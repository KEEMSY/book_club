"""SQLAlchemy async implementations of the feed repository ports.

The repository layer only knows SQLAlchemy / Postgres; it never raises
raw ``IntegrityError`` past its boundary — conflicts and bad data are
mapped to domain semantics (idempotent toggle for duplicate reactions,
``NotFoundError`` for missing rows) so the service layer stays
transport-agnostic (CLAUDE.md §3.1).

Key design choices:
- ``PostRepository.list_by_book`` paginates by ``(created_at DESC, id DESC)``
  and excludes ``deleted_at IS NOT NULL`` so soft-deleted rows disappear
  from the timeline without a hard cascade.
- ``ReactionRepository.add`` catches the UNIQUE-violation IntegrityError
  and returns the existing row so toggle-on is idempotent — two clicks
  in quick succession converge on a single row instead of 500ing.
- ``ReactionRepository.aggregate_for_post`` issues a single GROUP BY
  query so a feed page with N posts performs N+1-avoiding aggregates via
  ``aggregates_for_posts``.
- ``CommentRepository.create`` does not enforce parent depth — that
  belongs to the service layer because the rule is "parent.parent_id IS
  NULL", which is awkward to express in pure SQL on a self-referencing
  table.
"""

from __future__ import annotations

from collections import defaultdict
from datetime import datetime
from uuid import UUID

from sqlalchemy import and_, delete, func, select
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.feed.models import Comment, Post, PostHighlight, Reaction, ReactionType
from app.domains.feed.ports import HighlightWithBookId


class PostRepository:
    """Persistence adapter for :class:`Post`. Implements ``PostRepositoryPort``."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def create(
        self,
        *,
        user_id: UUID,
        book_id: UUID,
        post_type: object,
        content: str,
        image_keys: list[str],
    ) -> Post:
        row = Post(
            user_id=user_id,
            book_id=book_id,
            post_type=post_type,
            content=content,
            image_keys=list(image_keys),
        )
        self._session.add(row)
        await self._session.flush()
        await self._session.refresh(row)
        return row

    async def get_by_id(self, post_id: UUID) -> Post | None:
        row = await self._session.get(Post, post_id)
        if row is None or row.deleted_at is not None:
            return None
        return row

    async def list_by_book(
        self,
        book_id: UUID,
        *,
        cursor: datetime | None,
        limit: int,
    ) -> list[Post]:
        conditions = [Post.book_id == book_id, Post.deleted_at.is_(None)]
        if cursor is not None:
            # Strict less-than so the row whose created_at == cursor isn't
            # repeated across pages; id tiebreak handles exact-match edges.
            conditions.append(Post.created_at < cursor)
        stmt = (
            select(Post)
            .where(and_(*conditions))
            .order_by(Post.created_at.desc(), Post.id.desc())
            .limit(limit)
        )
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def soft_delete(self, post_id: UUID, at: datetime) -> None:
        row = await self._session.get(Post, post_id)
        if row is None:
            return
        row.deleted_at = at
        await self._session.flush()

    async def comment_counts_for(self, post_ids: list[UUID]) -> dict[UUID, int]:
        if not post_ids:
            return {}
        stmt = (
            select(Comment.post_id, func.count(Comment.id))
            .where(
                Comment.post_id.in_(post_ids),
                Comment.deleted_at.is_(None),
            )
            .group_by(Comment.post_id)
        )
        result = await self._session.execute(stmt)
        counts = {pid: count for pid, count in result.all()}
        return {pid: counts.get(pid, 0) for pid in post_ids}


class ReactionRepository:
    """Persistence adapter for :class:`Reaction`. Implements ``ReactionRepositoryPort``."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def add(
        self,
        *,
        post_id: UUID,
        user_id: UUID,
        reaction_type: ReactionType,
    ) -> Reaction:
        # INSERT ... ON CONFLICT DO NOTHING avoids touching the outer
        # transaction state on duplicate triples — toggle-on stays
        # idempotent without forcing a rollback that would lose unrelated
        # pending writes in the same session.
        stmt = (
            pg_insert(Reaction)
            .values(post_id=post_id, user_id=user_id, reaction_type=reaction_type)
            .on_conflict_do_nothing(
                constraint="uq_reactions_triple",
            )
        )
        await self._session.execute(stmt)
        await self._session.flush()
        select_stmt = select(Reaction).where(
            Reaction.post_id == post_id,
            Reaction.user_id == user_id,
            Reaction.reaction_type == reaction_type,
        )
        existing = (await self._session.execute(select_stmt)).scalar_one_or_none()
        if existing is None:
            # Unreachable — either the INSERT succeeded or the row already exists.
            raise RuntimeError("reaction add upsert vanished")
        return existing

    async def remove(
        self,
        *,
        post_id: UUID,
        user_id: UUID,
        reaction_type: ReactionType,
    ) -> int:
        # SELECT-then-DELETE so we can return a clean rowcount even on async
        # backends where Result.rowcount is unreliable; cardinality is bounded
        # by the UNIQUE triple so this is at most one row.
        existing_stmt = select(Reaction).where(
            Reaction.post_id == post_id,
            Reaction.user_id == user_id,
            Reaction.reaction_type == reaction_type,
        )
        existing = (await self._session.execute(existing_stmt)).scalar_one_or_none()
        if existing is None:
            return 0
        await self._session.execute(
            delete(Reaction).where(Reaction.id == existing.id),
        )
        await self._session.flush()
        return 1

    async def aggregate_for_post(self, post_id: UUID) -> dict[ReactionType, int]:
        stmt = (
            select(Reaction.reaction_type, func.count(Reaction.id))
            .where(Reaction.post_id == post_id)
            .group_by(Reaction.reaction_type)
        )
        result = await self._session.execute(stmt)
        return {ReactionType(row_type): count for row_type, count in result.all()}

    async def reactions_by_user(self, post_id: UUID, user_id: UUID) -> set[ReactionType]:
        stmt = select(Reaction.reaction_type).where(
            Reaction.post_id == post_id,
            Reaction.user_id == user_id,
        )
        result = await self._session.execute(stmt)
        return {ReactionType(rt) for rt in result.scalars().all()}

    async def aggregates_for_posts(
        self, post_ids: list[UUID]
    ) -> dict[UUID, dict[ReactionType, int]]:
        if not post_ids:
            return {}
        stmt = (
            select(Reaction.post_id, Reaction.reaction_type, func.count(Reaction.id))
            .where(Reaction.post_id.in_(post_ids))
            .group_by(Reaction.post_id, Reaction.reaction_type)
        )
        result = await self._session.execute(stmt)
        bucket: dict[UUID, dict[ReactionType, int]] = defaultdict(dict)
        for pid, rt, count in result.all():
            bucket[pid][ReactionType(rt)] = count
        return {pid: bucket.get(pid, {}) for pid in post_ids}

    async def my_reactions_for_posts(
        self, post_ids: list[UUID], user_id: UUID
    ) -> dict[UUID, set[ReactionType]]:
        if not post_ids:
            return {}
        stmt = select(Reaction.post_id, Reaction.reaction_type).where(
            Reaction.post_id.in_(post_ids),
            Reaction.user_id == user_id,
        )
        result = await self._session.execute(stmt)
        bucket: dict[UUID, set[ReactionType]] = defaultdict(set)
        for pid, rt in result.all():
            bucket[pid].add(ReactionType(rt))
        return {pid: bucket.get(pid, set()) for pid in post_ids}


class CommentRepository:
    """Persistence adapter for :class:`Comment`. Implements ``CommentRepositoryPort``."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def create(
        self,
        *,
        user_id: UUID,
        post_id: UUID,
        parent_id: UUID | None,
        content: str,
    ) -> Comment:
        row = Comment(
            user_id=user_id,
            post_id=post_id,
            parent_id=parent_id,
            content=content,
        )
        self._session.add(row)
        await self._session.flush()
        await self._session.refresh(row)
        return row

    async def get_by_id(self, comment_id: UUID) -> Comment | None:
        row = await self._session.get(Comment, comment_id)
        if row is None or row.deleted_at is not None:
            return None
        return row

    async def list_by_post(
        self,
        post_id: UUID,
        *,
        cursor: datetime | None,
        limit: int,
    ) -> list[Comment]:
        conditions = [Comment.post_id == post_id, Comment.deleted_at.is_(None)]
        if cursor is not None:
            # Comments paginate forward (created_at ASC) — the natural reading
            # order. Strict greater-than avoids repeating the cursor row.
            conditions.append(Comment.created_at > cursor)
        stmt = (
            select(Comment)
            .where(and_(*conditions))
            .order_by(Comment.created_at.asc(), Comment.id.asc())
            .limit(limit)
        )
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def soft_delete(self, comment_id: UUID, at: datetime) -> None:
        row = await self._session.get(Comment, comment_id)
        if row is None:
            return
        row.deleted_at = at
        await self._session.flush()


class HighlightRepository:
    """Persistence adapter for :class:`PostHighlight`. Implements ``HighlightRepositoryPort``."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def create(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
        quote_text: str,
        page_number: int | None,
    ) -> PostHighlight:
        row = PostHighlight(
            user_id=user_id,
            user_book_id=user_book_id,
            quote_text=quote_text,
            page_number=page_number,
        )
        self._session.add(row)
        await self._session.flush()
        await self._session.refresh(row)
        return row

    async def get_by_id(self, highlight_id: UUID) -> PostHighlight | None:
        return await self._session.get(PostHighlight, highlight_id)

    async def list_by_user_book(
        self,
        user_book_id: UUID,
        *,
        user_id: UUID,
        cursor: datetime | None,
        limit: int,
    ) -> list[PostHighlight]:
        conditions = [
            PostHighlight.user_book_id == user_book_id,
            PostHighlight.user_id == user_id,
        ]
        if cursor is not None:
            conditions.append(PostHighlight.created_at < cursor)
        stmt = (
            select(PostHighlight)
            .where(and_(*conditions))
            .order_by(PostHighlight.created_at.desc(), PostHighlight.id.desc())
            .limit(limit)
        )
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def delete(self, highlight_id: UUID) -> None:
        row = await self._session.get(PostHighlight, highlight_id)
        if row is None:
            return
        await self._session.delete(row)
        await self._session.flush()

    async def list_all_for_user(self, user_id: UUID) -> list[HighlightWithBookId]:
        """Return every highlight for a user, joined to ``user_books`` for ``book_id``.

        Ordered by ``(book_id, created_at DESC)`` so the service can group by
        ``user_book_id`` while preserving recency order within each group.
        Cross-domain import of ``UserBook`` is intentional per CLAUDE.md §3.3 —
        this is a same-DB JOIN, not a service-layer cross-domain call.
        """
        from app.domains.book.models import UserBook

        stmt = (
            select(PostHighlight, UserBook.book_id)
            .join(UserBook, UserBook.id == PostHighlight.user_book_id)
            .where(PostHighlight.user_id == user_id)
            .order_by(UserBook.book_id, PostHighlight.created_at.desc())
        )
        result = await self._session.execute(stmt)
        return [
            HighlightWithBookId(highlight=row.PostHighlight, book_id=row.book_id)
            for row in result.all()
        ]
