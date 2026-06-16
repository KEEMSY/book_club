"""Unit tests for M47 FeedService social-feed methods.

Covers toggle_feed_reaction, add_feed_comment, get_feed_comments, and
delete_feed_comment using in-memory fakes — no DB, no HTTP required.

Fakes implement exactly the Port Protocol methods exercised by the service;
only those methods that the service calls are provided (Protocol does not
require 100% surface coverage for unit tests).
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError
from app.domains.feed.models import FeedComment, FeedEvent, FeedEventReaction
from app.domains.feed.service import FeedService


# ---------------------------------------------------------------------------
# Fakes
# ---------------------------------------------------------------------------


@dataclass
class FakeFeedEventRepo:
    """Minimal in-memory FeedEventRepositoryPort for M47 tests."""

    _events: dict[UUID, FeedEvent] = field(default_factory=dict)

    @staticmethod
    def _make_event(*, user_id: UUID, event_type: str) -> FeedEvent:
        # Use the ORM constructor so SQLAlchemy's instrumentation is
        # initialised — setting attributes via __new__ leaves the
        # InstrumentedAttribute impl as None and causes AttributeError.
        ev = FeedEvent(user_id=user_id, event_type=event_type)
        ev.id = uuid4()
        ev.created_at = datetime.now(tz=UTC)
        return ev

    def seed(self, *, user_id: UUID, event_type: str = "STREAK_MILESTONE") -> FeedEvent:
        """Helper to insert a pre-built event into the store."""
        ev = self._make_event(user_id=user_id, event_type=event_type)
        self._events[ev.id] = ev
        return ev

    async def create_event(
        self, *, user_id: UUID, event_type: str, metadata: dict | None
    ) -> object:
        ev = self._make_event(user_id=user_id, event_type=event_type)
        self._events[ev.id] = ev
        return ev

    async def get_by_id(self, event_id: UUID) -> FeedEvent | None:
        return self._events.get(event_id)

    async def list_global(self, *, cursor: str | None, limit: int) -> list[FeedEvent]:
        return list(self._events.values())[:limit]

    async def list_following(
        self, *, user_id: UUID, cursor: str | None, limit: int
    ) -> list[FeedEvent]:
        return list(self._events.values())[:limit]

    async def comment_counts_for_events(self, event_ids: list[UUID]) -> dict[UUID, int]:
        return {eid: 0 for eid in event_ids}


@dataclass
class FakeFeedReactionRepository:
    """In-memory FeedEventReactionRepositoryPort."""

    _reactions: list[dict] = field(default_factory=list)
    # records: {event_id: UUID, user_id: UUID, emoji: str}

    @staticmethod
    def _make_reaction(*, event_id: UUID, user_id: UUID, emoji: str) -> FeedEventReaction:
        r = FeedEventReaction(feed_event_id=event_id, user_id=user_id, emoji=emoji)
        r.id = uuid4()
        r.created_at = datetime.now(tz=UTC)
        return r

    async def add(self, *, event_id: UUID, user_id: UUID, emoji: str) -> FeedEventReaction:
        row = {"event_id": event_id, "user_id": user_id, "emoji": emoji}
        self._reactions.append(row)
        return self._make_reaction(event_id=event_id, user_id=user_id, emoji=emoji)

    async def remove(self, *, event_id: UUID, user_id: UUID, emoji: str) -> bool:
        before = len(self._reactions)
        self._reactions = [
            r
            for r in self._reactions
            if not (r["event_id"] == event_id and r["user_id"] == user_id and r["emoji"] == emoji)
        ]
        return len(self._reactions) < before

    async def get_for_event(self, event_id: UUID) -> list[FeedEventReaction]:
        return [
            self._make_reaction(
                event_id=r["event_id"], user_id=r["user_id"], emoji=r["emoji"]
            )
            for r in self._reactions
            if r["event_id"] == event_id
        ]

    async def get_for_events(
        self, event_ids: list[UUID]
    ) -> dict[UUID, list[FeedEventReaction]]:
        result: dict[UUID, list[FeedEventReaction]] = {eid: [] for eid in event_ids}
        for r in self._reactions:
            if r["event_id"] in result:
                result[r["event_id"]].append(
                    self._make_reaction(
                        event_id=r["event_id"], user_id=r["user_id"], emoji=r["emoji"]
                    )
                )
        return result

    async def has_reacted(self, *, event_id: UUID, user_id: UUID, emoji: str) -> bool:
        return any(
            r["event_id"] == event_id and r["user_id"] == user_id and r["emoji"] == emoji
            for r in self._reactions
        )


@dataclass
class FakeFeedCommentRepository:
    """In-memory FeedCommentRepositoryPort."""

    _comments: dict[UUID, FeedComment] = field(default_factory=dict)

    @staticmethod
    def _make_comment(
        *,
        event_id: UUID,
        user_id: UUID,
        parent_id: UUID | None,
        body: str,
        comment_id: UUID | None = None,
    ) -> FeedComment:
        c = FeedComment(
            feed_event_id=event_id,
            user_id=user_id,
            parent_id=parent_id,
            body=body,
        )
        c.id = comment_id if comment_id is not None else uuid4()
        now = datetime.now(tz=UTC)
        c.created_at = now
        c.updated_at = now
        return c

    async def create(
        self,
        *,
        event_id: UUID,
        user_id: UUID,
        parent_id: UUID | None,
        body: str,
    ) -> FeedComment:
        c = self._make_comment(
            event_id=event_id, user_id=user_id, parent_id=parent_id, body=body
        )
        self._comments[c.id] = c
        return c

    async def get_by_id(self, comment_id: UUID) -> FeedComment | None:
        return self._comments.get(comment_id)

    async def list_for_event(self, event_id: UUID) -> list[FeedComment]:
        return sorted(
            [c for c in self._comments.values() if c.feed_event_id == event_id],
            key=lambda c: c.created_at,
        )

    async def delete(self, *, comment_id: UUID, user_id: UUID) -> bool:
        comment = self._comments.get(comment_id)
        if comment is None or comment.user_id != user_id:
            return False
        del self._comments[comment_id]
        return True


# ---------------------------------------------------------------------------
# Helper: build a wired FeedService
# ---------------------------------------------------------------------------


def _make_svc(
    event_repo: FakeFeedEventRepo | None = None,
    reaction_repo: FakeFeedReactionRepository | None = None,
    comment_repo: FakeFeedCommentRepository | None = None,
) -> FeedService:
    return FeedService(  # type: ignore[call-arg]
        posts=None,  # type: ignore[arg-type]
        reactions=None,  # type: ignore[arg-type]
        comments=None,  # type: ignore[arg-type]
        image_storage=None,  # type: ignore[arg-type]
        book_query=None,  # type: ignore[arg-type]
        highlights=None,  # type: ignore[arg-type]
        feed_events=event_repo or FakeFeedEventRepo(),
        feed_event_reactions=reaction_repo or FakeFeedReactionRepository(),
        feed_comments_repo=comment_repo or FakeFeedCommentRepository(),
    )


# ---------------------------------------------------------------------------
# toggle_feed_reaction
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_toggle_reaction_add() -> None:
    """First toggle on a fresh event yields state='added'."""
    events = FakeFeedEventRepo()
    reactions = FakeFeedReactionRepository()
    svc = _make_svc(events, reactions)

    author_id = uuid4()
    ev = events.seed(user_id=author_id)
    user_id = uuid4()

    result = await svc.toggle_feed_reaction(event_id=ev.id, user_id=user_id, emoji="❤️")

    assert result.state == "added"
    assert any(r.emoji == "❤️" and r.user_id == user_id for r in result.reactions)


@pytest.mark.asyncio
async def test_toggle_reaction_remove() -> None:
    """Second toggle on the same emoji removes the reaction (state='removed')."""
    events = FakeFeedEventRepo()
    reactions = FakeFeedReactionRepository()
    svc = _make_svc(events, reactions)

    ev = events.seed(user_id=uuid4())
    user_id = uuid4()

    # First toggle — add
    await svc.toggle_feed_reaction(event_id=ev.id, user_id=user_id, emoji="🔥")
    # Second toggle — remove
    result = await svc.toggle_feed_reaction(event_id=ev.id, user_id=user_id, emoji="🔥")

    assert result.state == "removed"
    assert not any(r.user_id == user_id and r.emoji == "🔥" for r in result.reactions)


@pytest.mark.asyncio
async def test_toggle_different_emoji() -> None:
    """Different emojis on the same event are independent — both can coexist."""
    events = FakeFeedEventRepo()
    reactions = FakeFeedReactionRepository()
    svc = _make_svc(events, reactions)

    ev = events.seed(user_id=uuid4())
    user_id = uuid4()

    res1 = await svc.toggle_feed_reaction(event_id=ev.id, user_id=user_id, emoji="❤️")
    res2 = await svc.toggle_feed_reaction(event_id=ev.id, user_id=user_id, emoji="🔥")

    assert res1.state == "added"
    assert res2.state == "added"
    # Both emojis should appear in the latest snapshot
    emojis = {r.emoji for r in res2.reactions}
    assert "❤️" in emojis
    assert "🔥" in emojis


@pytest.mark.asyncio
async def test_invalid_emoji() -> None:
    """An emoji not in the allowed set raises ConflictError."""
    events = FakeFeedEventRepo()
    svc = _make_svc(events)
    ev = events.seed(user_id=uuid4())

    with pytest.raises(ConflictError) as exc_info:
        await svc.toggle_feed_reaction(event_id=ev.id, user_id=uuid4(), emoji="😈")

    assert exc_info.value.code == "UNSUPPORTED_EMOJI"


# ---------------------------------------------------------------------------
# add_feed_comment
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_add_root_comment() -> None:
    """Posting a root comment (parent_id=None) returns a FeedComment."""
    events = FakeFeedEventRepo()
    svc = _make_svc(events)
    ev = events.seed(user_id=uuid4())
    user_id = uuid4()

    comment = await svc.add_feed_comment(
        event_id=ev.id,
        user_id=user_id,
        parent_id=None,
        body="Nice milestone!",
    )

    assert comment.feed_event_id == ev.id
    assert comment.user_id == user_id
    assert comment.parent_id is None
    assert comment.body == "Nice milestone!"


@pytest.mark.asyncio
async def test_add_reply() -> None:
    """A reply referencing an existing root comment is stored with the correct parent_id."""
    events = FakeFeedEventRepo()
    comments = FakeFeedCommentRepository()
    svc = _make_svc(events, comment_repo=comments)
    ev = events.seed(user_id=uuid4())

    root = await svc.add_feed_comment(
        event_id=ev.id, user_id=uuid4(), parent_id=None, body="Root"
    )
    replier_id = uuid4()
    reply = await svc.add_feed_comment(
        event_id=ev.id, user_id=replier_id, parent_id=root.id, body="Reply!"
    )

    assert reply.parent_id == root.id
    assert reply.feed_event_id == ev.id


@pytest.mark.asyncio
async def test_comment_body_empty() -> None:
    """An empty body raises ConflictError with code BODY_EMPTY."""
    events = FakeFeedEventRepo()
    svc = _make_svc(events)
    ev = events.seed(user_id=uuid4())

    with pytest.raises(ConflictError) as exc_info:
        await svc.add_feed_comment(
            event_id=ev.id, user_id=uuid4(), parent_id=None, body=""
        )

    assert exc_info.value.code == "BODY_EMPTY"


# ---------------------------------------------------------------------------
# get_feed_comments
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_get_comments_tree_structure() -> None:
    """get_feed_comments returns a flat list; root and reply are both included."""
    events = FakeFeedEventRepo()
    comments = FakeFeedCommentRepository()
    svc = _make_svc(events, comment_repo=comments)
    ev = events.seed(user_id=uuid4())

    root = await svc.add_feed_comment(
        event_id=ev.id, user_id=uuid4(), parent_id=None, body="Root comment"
    )
    reply = await svc.add_feed_comment(
        event_id=ev.id, user_id=uuid4(), parent_id=root.id, body="Reply to root"
    )

    result = await svc.get_feed_comments(ev.id)

    ids = [c.id for c in result]
    assert root.id in ids
    assert reply.id in ids
    # Root comment should appear before its reply (ASC order)
    assert ids.index(root.id) < ids.index(reply.id)


# ---------------------------------------------------------------------------
# delete_feed_comment
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_delete_own_comment() -> None:
    """An author can delete their own comment without error."""
    events = FakeFeedEventRepo()
    comments = FakeFeedCommentRepository()
    svc = _make_svc(events, comment_repo=comments)
    ev = events.seed(user_id=uuid4())
    user_id = uuid4()

    comment = await svc.add_feed_comment(
        event_id=ev.id, user_id=user_id, parent_id=None, body="My comment"
    )
    # Should not raise
    await svc.delete_feed_comment(comment_id=comment.id, user_id=user_id)

    remaining = await svc.get_feed_comments(ev.id)
    assert all(c.id != comment.id for c in remaining)


@pytest.mark.asyncio
async def test_delete_others_comment_forbidden() -> None:
    """Deleting another user's comment raises NotFoundError (404, not 403)."""
    events = FakeFeedEventRepo()
    comments = FakeFeedCommentRepository()
    svc = _make_svc(events, comment_repo=comments)
    ev = events.seed(user_id=uuid4())
    owner_id = uuid4()
    intruder_id = uuid4()

    comment = await svc.add_feed_comment(
        event_id=ev.id, user_id=owner_id, parent_id=None, body="Owner's comment"
    )

    with pytest.raises(NotFoundError) as exc_info:
        await svc.delete_feed_comment(comment_id=comment.id, user_id=intruder_id)

    assert exc_info.value.code == "COMMENT_NOT_FOUND"
