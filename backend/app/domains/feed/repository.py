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

from sqlalchemy import ColumnElement, String, and_, cast, delete, func, select, update
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.feed.models import (
    Comment,
    FeedComment,
    FeedEvent,
    FeedEventReaction,
    FeedEventType,
    Post,
    PostHighlight,
    Reaction,
    ReactionType,
)
from app.domains.feed.ports import ExploreHighlightItem, HighlightWithBookId


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
        note_text: str | None,
    ) -> PostHighlight:
        row = PostHighlight(
            user_id=user_id,
            user_book_id=user_book_id,
            quote_text=quote_text,
            page_number=page_number,
            note_text=note_text,
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

    async def set_visibility(self, highlight_id: UUID, visibility: str) -> None:
        await self._session.execute(
            update(PostHighlight)
            .where(PostHighlight.id == highlight_id)
            .values(visibility=visibility)
        )
        await self._session.flush()

    async def mark_shared(self, highlight_id: UUID, *, shared_at: datetime) -> None:
        # Sharing always implies public visibility — set both atomically so the
        # explore feed and the share state never disagree.
        await self._session.execute(
            update(PostHighlight)
            .where(PostHighlight.id == highlight_id)
            .values(shared_at=shared_at, visibility="public")
        )
        await self._session.flush()

    async def list_public(self, *, limit: int, sort: str) -> list[ExploreHighlightItem]:
        """Public, non-deleted highlights enriched with book info and a reaction count.

        ``reaction_count`` is a correlated subquery over the highlight's
        HIGHLIGHT_SHARED feed event (matched by ``metadata->>'highlight_id'``),
        keeping the page free of per-row reaction queries. The ``books`` JOIN is
        an intentional same-DB cross-domain read per CLAUDE.md §3.3.
        """
        from app.domains.book.models import Book, UserBook

        reaction_count = (
            select(func.count(FeedEventReaction.id))
            .select_from(FeedEvent)
            .join(FeedEventReaction, FeedEventReaction.feed_event_id == FeedEvent.id)
            .where(
                FeedEvent.event_type == FeedEventType.HIGHLIGHT_SHARED.value,
                FeedEvent.event_metadata["highlight_id"].astext
                == cast(PostHighlight.id, String),
            )
            .correlate(PostHighlight)
            .scalar_subquery()
        )
        stmt = (
            select(
                PostHighlight,
                UserBook.book_id.label("book_id"),
                Book.title.label("book_title"),
                Book.cover_url.label("book_cover_url"),
                reaction_count.label("reaction_count"),
            )
            .join(UserBook, UserBook.id == PostHighlight.user_book_id)
            .join(Book, Book.id == UserBook.book_id)
            .where(
                PostHighlight.visibility == "public",
                PostHighlight.deleted_at.is_(None),
            )
        )
        if sort == "popular":
            stmt = stmt.order_by(reaction_count.desc(), PostHighlight.created_at.desc())
        else:
            stmt = stmt.order_by(PostHighlight.created_at.desc())
        stmt = stmt.limit(limit)

        result = await self._session.execute(stmt)
        return [
            ExploreHighlightItem(
                highlight=row.PostHighlight,
                book_id=row.book_id,
                book_title=row.book_title,
                book_cover_url=row.book_cover_url,
                reaction_count=row.reaction_count or 0,
            )
            for row in result.all()
        ]


class FeedEventRepository:
    """Persistence adapter for :class:`FeedEvent`.

    Append-only — rows are inserted but never updated or deleted through
    normal product flows.  The table is pruned via cascade when the user
    row is hard-deleted.
    """

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def create_event(
        self,
        *,
        user_id: UUID,
        event_type: str,
        metadata: dict[str, object] | None = None,
    ) -> FeedEvent:
        row = FeedEvent(user_id=user_id, event_type=event_type, event_metadata=metadata)
        self._session.add(row)
        await self._session.flush()
        await self._session.refresh(row)
        return row

    async def get_by_id(self, event_id: UUID) -> FeedEvent | None:
        return await self._session.get(FeedEvent, event_id)

    async def list_global(self, *, cursor: str | None, limit: int) -> list[FeedEvent]:
        """All events ordered newest-first, cursor-paged by created_at ISO string."""
        cursor_dt: datetime | None = None
        if cursor:
            try:
                cursor_dt = datetime.fromisoformat(cursor)
            except ValueError:
                cursor_dt = None
        conditions: list[ColumnElement[bool]] = []
        if cursor_dt is not None:
            conditions.append(FeedEvent.created_at < cursor_dt)
        stmt = select(FeedEvent).order_by(FeedEvent.created_at.desc(), FeedEvent.id.desc())
        if conditions:
            stmt = stmt.where(and_(*conditions))
        stmt = stmt.limit(limit)
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def list_following(
        self,
        *,
        user_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> list[FeedEvent]:
        """Events from users that ``user_id`` follows, newest-first, cursor-paged."""
        from app.domains.social.models import Follow

        cursor_dt: datetime | None = None
        if cursor:
            try:
                cursor_dt = datetime.fromisoformat(cursor)
            except ValueError:
                cursor_dt = None
        followees_subq = (
            select(Follow.followee_id).where(Follow.follower_id == user_id).scalar_subquery()
        )
        conditions: list[ColumnElement[bool]] = [FeedEvent.user_id.in_(followees_subq)]
        if cursor_dt is not None:
            conditions.append(FeedEvent.created_at < cursor_dt)
        stmt = (
            select(FeedEvent)
            .where(and_(*conditions))
            .order_by(FeedEvent.created_at.desc(), FeedEvent.id.desc())
            .limit(limit)
        )
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def comment_counts_for_events(self, event_ids: list[UUID]) -> dict[UUID, int]:
        """Batch comment count per feed_event_id."""
        if not event_ids:
            return {}
        stmt = (
            select(FeedComment.feed_event_id, func.count(FeedComment.id))
            .where(FeedComment.feed_event_id.in_(event_ids))
            .group_by(FeedComment.feed_event_id)
        )
        result = await self._session.execute(stmt)
        counts = {eid: cnt for eid, cnt in result.all()}
        return {eid: counts.get(eid, 0) for eid in event_ids}

    async def find_highlight_share(self, highlight_id: UUID) -> FeedEvent | None:
        """Return the HIGHLIGHT_SHARED event for a highlight, if one exists.

        Used to make a re-share idempotent — the highlight's ``highlight_id`` is
        stored in the event ``metadata``. Returns the earliest match so repeated
        shares always resolve to the original event.
        """
        stmt = (
            select(FeedEvent)
            .where(
                FeedEvent.event_type == FeedEventType.HIGHLIGHT_SHARED.value,
                FeedEvent.event_metadata["highlight_id"].astext == str(highlight_id),
            )
            .order_by(FeedEvent.created_at.asc())
            .limit(1)
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()


class FeedEventReactionRepository:
    """Persistence adapter for :class:`FeedEventReaction`."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def add(self, *, event_id: UUID, user_id: UUID, emoji: str) -> FeedEventReaction:
        """Insert reaction; return existing row if the triple already exists (idempotent)."""
        stmt = (
            pg_insert(FeedEventReaction)
            .values(feed_event_id=event_id, user_id=user_id, emoji=emoji)
            .on_conflict_do_nothing(constraint="uq_feed_event_reactions_triple")
        )
        await self._session.execute(stmt)
        await self._session.flush()
        select_stmt = select(FeedEventReaction).where(
            FeedEventReaction.feed_event_id == event_id,
            FeedEventReaction.user_id == user_id,
            FeedEventReaction.emoji == emoji,
        )
        existing = (await self._session.execute(select_stmt)).scalar_one_or_none()
        if existing is None:
            raise RuntimeError("feed_event_reaction upsert vanished")
        return existing

    async def remove(self, *, event_id: UUID, user_id: UUID, emoji: str) -> bool:
        """Delete a reaction triple; returns True if a row was deleted."""
        existing_stmt = select(FeedEventReaction).where(
            FeedEventReaction.feed_event_id == event_id,
            FeedEventReaction.user_id == user_id,
            FeedEventReaction.emoji == emoji,
        )
        existing = (await self._session.execute(existing_stmt)).scalar_one_or_none()
        if existing is None:
            return False
        await self._session.execute(
            delete(FeedEventReaction).where(FeedEventReaction.id == existing.id)
        )
        await self._session.flush()
        return True

    async def get_for_event(self, event_id: UUID) -> list[FeedEventReaction]:
        stmt = select(FeedEventReaction).where(FeedEventReaction.feed_event_id == event_id)
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def get_for_events(
        self, event_ids: list[UUID]
    ) -> dict[UUID, list[FeedEventReaction]]:
        """Batch-fetch reactions keyed by feed_event_id."""
        if not event_ids:
            return {}
        stmt = select(FeedEventReaction).where(FeedEventReaction.feed_event_id.in_(event_ids))
        result = await self._session.execute(stmt)
        bucket: dict[UUID, list[FeedEventReaction]] = {eid: [] for eid in event_ids}
        for row in result.scalars().all():
            bucket[row.feed_event_id].append(row)
        return bucket

    async def has_reacted(self, *, event_id: UUID, user_id: UUID, emoji: str) -> bool:
        stmt = select(FeedEventReaction.id).where(
            FeedEventReaction.feed_event_id == event_id,
            FeedEventReaction.user_id == user_id,
            FeedEventReaction.emoji == emoji,
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none() is not None


class FeedCommentRepository:
    """Persistence adapter for :class:`FeedComment`."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def create(
        self,
        *,
        event_id: UUID,
        user_id: UUID,
        parent_id: UUID | None,
        body: str,
    ) -> FeedComment:
        row = FeedComment(
            feed_event_id=event_id,
            user_id=user_id,
            parent_id=parent_id,
            body=body,
        )
        self._session.add(row)
        await self._session.flush()
        await self._session.refresh(row)
        return row

    async def get_by_id(self, comment_id: UUID) -> FeedComment | None:
        return await self._session.get(FeedComment, comment_id)

    async def list_for_event(self, event_id: UUID) -> list[FeedComment]:
        """All comments for an event ordered by (created_at ASC, id ASC).

        Returns both root comments and replies in a flat list; the caller
        assembles the tree. The service guarantees depth ≤ 2.
        """
        stmt = (
            select(FeedComment)
            .where(FeedComment.feed_event_id == event_id)
            .order_by(FeedComment.created_at.asc(), FeedComment.id.asc())
        )
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def delete(self, *, comment_id: UUID, user_id: UUID) -> bool:
        """Hard-delete comment if owned by ``user_id``; returns True on success."""
        row = await self._session.get(FeedComment, comment_id)
        if row is None or row.user_id != user_id:
            return False
        await self._session.execute(delete(FeedComment).where(FeedComment.id == comment_id))
        await self._session.flush()
        return True
