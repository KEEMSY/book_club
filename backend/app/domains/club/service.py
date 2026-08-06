from __future__ import annotations

import json
import logging
import math
from dataclasses import dataclass, field
from datetime import date, datetime
from typing import Literal, Protocol
from uuid import UUID

import redis.asyncio as aioredis

from app.core.exceptions import (
    ConflictError,
    NotConfiguredError,
    NotFoundError,
    PermissionDeniedError,
)
from app.core.ws_manager import ws_manager
from app.domains.club.models import (
    AgendaStatus,
    AgendaTopic,
    ClubMember,
    ClubReadingPlan,
    ClubRole,
    ClubSession,
    ReadingClub,
    SessionAgenda,
    SessionStatus,
    TopicComment,
)
from app.domains.club.repository import ClubRepository
from app.domains.club.schemas import (
    AgendaTopicCreate,
    AgendaTopicPublic,
    AgendaTopicUpdate,
    AttendeeCount,
    AttendeeListResponse,
    ClubEventCreate,
    ClubEventPublic,
    ClubEventUpdate,
    ClubMessagePublic,
    ClubProgressResponse,
    ClubRoomCreate,
    ClubRoomListResponse,
    ClubRoomPublic,
    ClubSessionCreate,
    ClubSessionPublic,
    CreateClubRequest,
    MemberProgressItem,
    MessageListResponse,
    ReadingPlanResponse,
    SessionAgendaCreate,
    SessionAgendaPublic,
    SessionAgendaUpdate,
    TopicCommentCreate,
    TopicCommentPublic,
    TopicCommentThreadPublic,
    TopicCommentUpdate,
)

# Fallback page count when the catalog row carries no page total — keeps plan
# generation deterministic for books that predate page-count ingestion.
_DEFAULT_PAGE_COUNT = 200

# Forward-only lifecycle (design §5) — a transition is valid only when it moves
# exactly one step ahead in this order; skips and reversals are rejected.
_SESSION_STATUS_ORDER = (SessionStatus.DRAFT, SessionStatus.OPEN, SessionStatus.CLOSED)

logger = logging.getLogger(__name__)


class FeedClubPort(Protocol):
    """Minimal cross-domain interface consumed by ClubService.

    Defined here (rather than importing FeedService) so the club service
    depends only on this narrow contract per CLAUDE.md §3.2.
    """

    async def record_club_joined(self, *, user_id: UUID, club_id: UUID) -> None: ...

    async def record_session_opened(
        self, *, user_id: UUID, club_id: UUID, session_id: UUID, book_id: UUID
    ) -> None: ...

    async def record_agenda_published(
        self, *, user_id: UUID, club_id: UUID, session_id: UUID, agenda_id: UUID
    ) -> None: ...

    async def record_discussion_commented(
        self,
        *,
        user_id: UUID,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        topic_id: UUID,
        comment_id: UUID,
        parent_comment_id: UUID | None,
    ) -> None: ...


class NotificationClubPort(Protocol):
    """Minimal cross-domain interface consumed by ClubService (BC-48, design §6.2).

    Mirrors ``FeedClubPort`` above — defined here rather than importing
    NotificationService so the club service depends only on this narrow
    contract per CLAUDE.md §3.2. ClubService computes the deduplicated,
    self-excluded recipient list (member roster / agenda author / parent
    comment author) before calling either method; the port implementation is
    only responsible for delivering the push.
    """

    async def notify_agenda_published(
        self,
        *,
        actor_id: UUID,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        recipient_ids: list[UUID],
    ) -> None: ...

    async def notify_topic_comment_added(
        self,
        *,
        actor_id: UUID,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        topic_id: UUID,
        comment_id: UUID,
        recipient_ids: list[UUID],
    ) -> None: ...


class AgendaTopicAiPort(Protocol):
    """AI 논제 초안 추천 포트 (BC-53).

    ai_assistant 도메인(M63)의 논제 생성 자산을 재사용하기 위한 좁은 계약.
    ``FeedClubPort``/``NotificationClubPort``와 같은 이유로 여기 정의한다:
    club service는 이 Protocol에만 의존하고 구체 ``AIAssistantPort``/
    ``AIAssistantService``는 절대 import하지 않는다(CLAUDE.md §3.2).
    providers.py의 어댑터가 book 조회·Claude 호출·사용량 로깅까지 위임하고,
    여기서는 문자열 후보 목록만 돌려받는다 — 추천만 반환하며 DB에는 저장하지
    않는다(실제 논제 추가는 기존 add_topic 사용).
    """

    async def generate_topic_drafts(
        self, *, user_id: UUID, book_id: UUID, scope: str
    ) -> list[str]: ...


@dataclass(slots=True)
class ClubService:
    repo: ClubRepository
    # Optional — existing callers that do not wire the feed service continue to
    # work; CLUB_JOINED events are silently skipped when absent.
    feed_service: FeedClubPort | None = field(default=None)
    # Optional — existing callers that do not wire the notification service
    # continue to work; agenda/discussion pushes are silently skipped when
    # absent (BC-48, mirrors feed_service above).
    notification_service: NotificationClubPort | None = field(default=None)
    # Optional Redis client for recommendation caching; skipped when absent.
    redis: aioredis.Redis | None = field(default=None)
    # Optional AI 논제 추천 포트 (BC-53) — 실제 HTTP 요청 경로에서는 providers.py가
    # 항상 wiring하지만, 다른 cross-domain 포트들과 동일하게 옵션으로 두어 기존
    # 생성 호출부(단위 테스트 등)를 깨지 않는다. 미설정 상태에서 추천을 요청하면
    # NotConfiguredError(503)를 던진다.
    agenda_ai: AgendaTopicAiPort | None = field(default=None)

    async def create_club(self, *, user_id: UUID, req: CreateClubRequest) -> ReadingClub:
        return await self.repo.create(
            owner_id=user_id,
            name=req.name,
            description=req.description,
            book_id=req.book_id,
            max_members=req.max_members,
            is_public=req.is_public,
            category=req.category,
            tags=req.tags,
        )

    async def get_club(self, club_id: UUID) -> ReadingClub:
        club = await self.repo.get_by_id(club_id)
        if not club:
            raise NotFoundError("club not found", code="CLUB_NOT_FOUND")
        return club

    async def list_my_clubs(self, user_id: UUID) -> list[ReadingClub]:
        return await self.repo.list_by_user(user_id)

    async def join_by_code(self, *, user_id: UUID, invite_code: str) -> ReadingClub:
        club = await self.repo.get_by_invite_code(invite_code.upper())
        if not club:
            raise NotFoundError("invalid invite code", code="CLUB_NOT_FOUND")
        count = await self.repo.member_count(club.id)
        if count >= club.max_members:
            raise ConflictError("club is full", code="CLUB_FULL")
        if not await self.repo.is_member(club.id, user_id):
            await self.repo.join(club.id, user_id)
        return club

    async def list_public_clubs(
        self,
        *,
        search: str | None = None,
        sort: Literal["popular", "newest"] = "newest",
        cursor: datetime | None = None,
        limit: int = 20,
        category: str | None = None,
        tag: str | None = None,
    ) -> list[ReadingClub]:
        # When category/tag filters are present use the richer repository method.
        if category is not None or tag is not None:
            cursor_str = cursor.isoformat() if cursor is not None else None
            return await self.repo.list_public_clubs(
                category=category,
                tag=tag,
                sort=sort,
                limit=limit,
                cursor=cursor_str,
            )
        return await self.repo.list_public(
            search=search,
            sort=sort,
            cursor=cursor,
            limit=limit,
        )

    async def get_recommended_clubs(self, user_id: UUID, limit: int = 6) -> list[ReadingClub]:
        """Return clubs recommended for the user based on their taste profile.

        Caches the resolved club-ID list in Redis under
        'club_recommendations:{user_id}' for 1 hour, then re-fetches the
        ReadingClub rows by ID on a cache hit.  Falls back to a fresh DB query
        when Redis is unavailable or the key has expired.
        """
        cache_key = f"club_recommendations:{user_id}"

        if self.redis is not None:
            try:
                cached = await self.redis.get(cache_key)
                if cached:
                    club_id_strs: list[str] = json.loads(cached)
                    club_ids = [UUID(cid) for cid in club_id_strs]
                    clubs: list[ReadingClub] = []
                    for cid in club_ids:
                        club = await self.repo.get_by_id(cid)
                        if club is not None:
                            clubs.append(club)
                    return clubs
            except Exception:
                logger.warning("Redis get failed for %s", cache_key, exc_info=True)

        clubs = await self.repo.recommended_clubs(user_id=user_id, limit=limit)

        if self.redis is not None:
            try:
                payload = [str(c.id) for c in clubs]
                await self.redis.set(cache_key, json.dumps(payload), ex=3600)
            except Exception:
                logger.warning("Redis set failed for %s", cache_key, exc_info=True)

        return clubs

    async def join_public(self, *, club_id: UUID, user_id: UUID) -> ReadingClub:
        club = await self.repo.get_by_id(club_id)
        if not club:
            raise NotFoundError("club not found", code="CLUB_NOT_FOUND")
        if not club.is_public:
            raise PermissionDeniedError("club is not public", code="CLUB_NOT_PUBLIC")
        count = await self.repo.member_count(club_id)
        if count >= club.max_members:
            raise ConflictError("club is full", code="CLUB_FULL")
        if not await self.repo.is_member(club_id, user_id):
            await self.repo.join(club_id, user_id)
            if self.feed_service is not None:
                await self.feed_service.record_club_joined(user_id=user_id, club_id=club_id)
        return club

    async def leave_club(self, *, user_id: UUID, club_id: UUID) -> None:
        club = await self.repo.get_by_id(club_id)
        if not club:
            raise NotFoundError("club not found", code="CLUB_NOT_FOUND")
        if club.owner_id == user_id:
            raise ConflictError(
                "owner cannot leave; delete the club instead",
                code="OWNER_CANNOT_LEAVE",
            )
        await self.repo.leave(club_id, user_id)

    async def set_book(self, *, club_id: UUID, user_id: UUID, book_id: UUID | None) -> ReadingClub:
        club = await self.repo.get_by_id(club_id)
        if not club:
            raise NotFoundError("club not found", code="CLUB_NOT_FOUND")
        if club.owner_id != user_id:
            raise PermissionDeniedError(
                "only the owner can set the club book", code="PERMISSION_DENIED"
            )
        return await self.repo.set_book(club_id, book_id)

    async def _is_owner_or_manager(self, club_id: UUID, user_id: UUID) -> bool:
        """Return True when the user is the club owner or has manager role."""
        club = await self.repo.get_by_id(club_id)
        if not club:
            return False
        if club.owner_id == user_id:
            return True
        role = await self.repo.get_member_role(club_id, user_id)
        return role in (ClubRole.OWNER, "manager")

    async def create_event(
        self, *, user_id: UUID, club_id: UUID, data: ClubEventCreate
    ) -> ClubEventPublic:
        if not await self._is_owner_or_manager(club_id, user_id):
            raise PermissionDeniedError(
                "only owner or manager can create events", code="PERMISSION_DENIED"
            )
        event = await self.repo.create_event(
            club_id=club_id,
            created_by=user_id,
            title=data.title,
            description=data.description,
            event_at=data.event_at,
            location=data.location,
            max_attendees=data.max_attendees,
        )
        return ClubEventPublic(
            id=event.id,
            club_id=event.club_id,
            title=event.title,
            description=event.description,
            event_at=event.event_at,
            location=event.location,
            max_attendees=event.max_attendees,
            created_by=event.created_by,
            created_at=event.created_at,
            attendee_counts=AttendeeCount(going=0, maybe=0, not_going=0),
            my_status=None,
        )

    async def list_events(
        self, *, club_id: UUID, caller_user_id: UUID, upcoming_only: bool = True
    ) -> list[ClubEventPublic]:
        if not await self.repo.is_member(club_id, caller_user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        events = await self.repo.get_events(club_id, upcoming_only=upcoming_only)
        result: list[ClubEventPublic] = []
        for event in events:
            counts = await self.repo.get_attendee_counts(event.id)
            my_status = await self.repo.get_my_rsvp_status(event.id, caller_user_id)
            result.append(
                ClubEventPublic(
                    id=event.id,
                    club_id=event.club_id,
                    title=event.title,
                    description=event.description,
                    event_at=event.event_at,
                    location=event.location,
                    max_attendees=event.max_attendees,
                    created_by=event.created_by,
                    created_at=event.created_at,
                    attendee_counts=counts,
                    my_status=my_status,
                )
            )
        return result

    async def get_event(self, *, event_id: UUID, caller_user_id: UUID) -> ClubEventPublic:
        event = await self.repo.get_event(event_id)
        if not event:
            raise NotFoundError("event not found", code="EVENT_NOT_FOUND")
        if not await self.repo.is_member(event.club_id, caller_user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        counts = await self.repo.get_attendee_counts(event.id)
        my_status = await self.repo.get_my_rsvp_status(event.id, caller_user_id)
        return ClubEventPublic(
            id=event.id,
            club_id=event.club_id,
            title=event.title,
            description=event.description,
            event_at=event.event_at,
            location=event.location,
            max_attendees=event.max_attendees,
            created_by=event.created_by,
            created_at=event.created_at,
            attendee_counts=counts,
            my_status=my_status,
        )

    async def update_event(
        self, *, event_id: UUID, user_id: UUID, data: ClubEventUpdate
    ) -> ClubEventPublic:
        event = await self.repo.get_event(event_id)
        if not event:
            raise NotFoundError("event not found", code="EVENT_NOT_FOUND")
        if not await self._is_owner_or_manager(event.club_id, user_id):
            raise PermissionDeniedError(
                "only owner or manager can update events", code="PERMISSION_DENIED"
            )
        updated = await self.repo.update_event(
            event_id,
            title=data.title,
            description=data.description,
            event_at=data.event_at,
            location=data.location,
            max_attendees=data.max_attendees,
        )
        if not updated:
            raise NotFoundError("event not found", code="EVENT_NOT_FOUND")
        counts = await self.repo.get_attendee_counts(event_id)
        my_status = await self.repo.get_my_rsvp_status(event_id, user_id)
        return ClubEventPublic(
            id=updated.id,
            club_id=updated.club_id,
            title=updated.title,
            description=updated.description,
            event_at=updated.event_at,
            location=updated.location,
            max_attendees=updated.max_attendees,
            created_by=updated.created_by,
            created_at=updated.created_at,
            attendee_counts=counts,
            my_status=my_status,
        )

    async def delete_event(self, *, event_id: UUID, user_id: UUID) -> None:
        event = await self.repo.get_event(event_id)
        if not event:
            raise NotFoundError("event not found", code="EVENT_NOT_FOUND")
        if not await self._is_owner_or_manager(event.club_id, user_id):
            raise PermissionDeniedError(
                "only owner or manager can delete events", code="PERMISSION_DENIED"
            )
        await self.repo.delete_event(event_id)

    async def rsvp(self, *, user_id: UUID, event_id: UUID, status: str) -> None:
        event = await self.repo.get_event(event_id)
        if not event:
            raise NotFoundError("event not found", code="EVENT_NOT_FOUND")
        if not await self.repo.is_member(event.club_id, user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        await self.repo.upsert_rsvp(event_id=event_id, user_id=user_id, status=status)

    async def get_attendees(self, *, event_id: UUID, caller_user_id: UUID) -> AttendeeListResponse:
        event = await self.repo.get_event(event_id)
        if not event:
            raise NotFoundError("event not found", code="EVENT_NOT_FOUND")
        if not await self.repo.is_member(event.club_id, caller_user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        attendees = await self.repo.get_attendees(event_id)
        return AttendeeListResponse(items=attendees)

    # --- chat messages ---

    async def send_message(
        self,
        *,
        club_id: UUID,
        user_id: UUID,
        content: str,
        media_url: str | None,
    ) -> ClubMessagePublic:
        if not await self.repo.is_member(club_id, user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        msg = await self.repo.create_message(
            club_id=club_id,
            user_id=user_id,
            content=content,
            media_url=media_url,
        )
        # Fetch author nickname via a single-row message list query.
        rows = await self.repo.list_messages(club_id, cursor=None, limit=1)
        author_nickname = rows[0][1] if rows else ""
        return ClubMessagePublic(
            id=msg.id,
            club_id=msg.club_id,
            user_id=msg.user_id,
            author_nickname=author_nickname,
            content=msg.content,
            media_url=msg.media_url,
            created_at=msg.created_at,
            read_count=0,
        )

    async def list_messages(
        self,
        *,
        club_id: UUID,
        user_id: UUID,
        cursor: datetime | None,
        limit: int = 50,
    ) -> MessageListResponse:
        if not await self.repo.is_member(club_id, user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        # Fetch one extra row to detect whether a next page exists.
        rows = await self.repo.list_messages(club_id, cursor=cursor, limit=limit + 1)
        has_more = len(rows) > limit
        page = rows[:limit]
        items = [
            ClubMessagePublic(
                id=msg.id,
                club_id=msg.club_id,
                user_id=msg.user_id,
                author_nickname=nickname,
                content=msg.content,
                media_url=msg.media_url,
                created_at=msg.created_at,
                read_count=read_count,
            )
            for msg, nickname, read_count in page
        ]
        next_cursor = page[-1][0].created_at.isoformat() if has_more else None
        return MessageListResponse(items=items, next_cursor=next_cursor)

    async def mark_read(
        self,
        *,
        club_id: UUID,
        user_id: UUID,
        message_id: UUID,
    ) -> None:
        msg = await self.repo.get_message(message_id)
        if not msg:
            raise NotFoundError("message not found", code="MESSAGE_NOT_FOUND")
        if msg.club_id != club_id:
            raise NotFoundError("message not found", code="MESSAGE_NOT_FOUND")
        if not await self.repo.is_member(club_id, user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        await self.repo.upsert_message_read(message_id=message_id, user_id=user_id)

    async def edit_message(
        self,
        *,
        club_id: UUID,
        user_id: UUID,
        message_id: UUID,
        content: str,
    ) -> None:
        msg = await self.repo.get_message(message_id)
        if not msg or msg.club_id != club_id or msg.deleted_at is not None:
            raise NotFoundError("message not found", code="MESSAGE_NOT_FOUND")
        if msg.user_id != user_id:
            raise PermissionDeniedError("not the message author", code="PERMISSION_DENIED")
        edited_at = datetime.now()
        await self.repo.update_message_content(
            message_id=message_id, content=content, edited_at=edited_at
        )
        await ws_manager.broadcast_club(
            club_id,
            {
                "type": "chat.message_edited",
                "club_id": str(club_id),
                "message_id": str(message_id),
                "content": content,
                "edited_at": edited_at.isoformat(),
            },
        )

    async def delete_message(
        self,
        *,
        club_id: UUID,
        user_id: UUID,
        message_id: UUID,
    ) -> None:
        msg = await self.repo.get_message(message_id)
        if not msg or msg.club_id != club_id or msg.deleted_at is not None:
            raise NotFoundError("message not found", code="MESSAGE_NOT_FOUND")
        if msg.user_id != user_id:
            raise PermissionDeniedError("not the message author", code="PERMISSION_DENIED")
        deleted_at = datetime.now()
        await self.repo.soft_delete_message(message_id=message_id, deleted_at=deleted_at)
        await ws_manager.broadcast_club(
            club_id,
            {
                "type": "chat.message_deleted",
                "club_id": str(club_id),
                "message_id": str(message_id),
                "deleted_at": deleted_at.isoformat(),
            },
        )

    # --- club rooms ---

    async def create_room(
        self,
        *,
        club_id: UUID,
        user_id: UUID,
        req: ClubRoomCreate,
    ) -> ClubRoomPublic:
        if not await self._is_owner_or_manager(club_id, user_id):
            raise PermissionDeniedError(
                "only owner or manager can create rooms", code="PERMISSION_DENIED"
            )
        room = await self.repo.create_room(
            club_id=club_id,
            name=req.name,
            progress_gate=req.progress_gate,
            created_by=user_id,
        )
        caller_chapter = await self.repo.get_user_chapter_for_club(user_id, club_id)
        return ClubRoomPublic(
            id=room.id,
            club_id=room.club_id,
            name=room.name,
            progress_gate=room.progress_gate,
            created_at=room.created_at,
            can_enter=caller_chapter >= room.progress_gate,
        )

    async def list_rooms(
        self,
        *,
        club_id: UUID,
        caller_user_id: UUID,
    ) -> ClubRoomListResponse:
        if not await self.repo.is_member(club_id, caller_user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        rooms = await self.repo.get_rooms(club_id)
        caller_chapter = await self.repo.get_user_chapter_for_club(caller_user_id, club_id)
        return ClubRoomListResponse(
            rooms=[
                ClubRoomPublic(
                    id=room.id,
                    club_id=room.club_id,
                    name=room.name,
                    progress_gate=room.progress_gate,
                    created_at=room.created_at,
                    can_enter=caller_chapter >= room.progress_gate,
                )
                for room in rooms
            ]
        )

    async def delete_room(
        self,
        *,
        club_id: UUID,
        room_id: UUID,
        user_id: UUID,
    ) -> None:
        room = await self.repo.get_room(room_id)
        if not room or room.club_id != club_id:
            raise NotFoundError("room not found", code="ROOM_NOT_FOUND")
        if not await self._is_owner_or_manager(club_id, user_id):
            raise PermissionDeniedError(
                "only owner or manager can delete rooms", code="PERMISSION_DENIED"
            )
        await self.repo.delete_room(room_id)

    # --- reading plans (M52) ---

    async def create_reading_plan(
        self,
        *,
        club_id: UUID,
        created_by: UUID,
        book_id: UUID,
        start_date: date,
        end_date: date,
    ) -> ClubReadingPlan:
        club = await self.repo.get_by_id(club_id)
        if club is None:
            raise NotFoundError("club not found", code="CLUB_NOT_FOUND")
        if club.owner_id != created_by:
            raise PermissionDeniedError(
                "only the club owner can create a reading plan", code="PERMISSION_DENIED"
            )
        if not await self.repo.get_user_is_pro(created_by):
            raise ConflictError("Pro subscription required", code="PRO_REQUIRED")

        total_pages = await self.repo.get_book_page_count(book_id) or _DEFAULT_PAGE_COUNT
        weeks = self._plan_weeks(start_date, end_date)
        weekly_pages = math.ceil(total_pages / weeks)

        plan = await self.repo.create_reading_plan(
            club_id=club_id,
            book_id=book_id,
            start_date=start_date,
            end_date=end_date,
            weekly_pages=weekly_pages,
            created_by=created_by,
        )
        await self._push_plan_created(club_id=club_id, exclude_user_id=created_by)
        return plan

    async def update_member_progress(
        self, *, club_id: UUID, user_id: UUID, current_page: int
    ) -> ClubMember:
        member = await self.repo.update_member_progress(
            club_id=club_id, user_id=user_id, current_page=current_page
        )
        if member is None:
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        return member

    async def get_club_progress(self, *, club_id: UUID, requester_id: UUID) -> ClubProgressResponse:
        if not await self.repo.is_member(club_id, requester_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")

        plan = await self.repo.get_active_reading_plan(club_id)
        members = await self.repo.get_members_with_progress(club_id)

        elapsed_weeks = self._elapsed_weeks(plan) if plan is not None else 0
        plan_resp = self._to_plan_response(plan) if plan is not None else None

        items = [
            MemberProgressItem(
                user_id=member.user_id,
                nickname=nickname,
                current_page=member.current_page,
                last_page_updated_at=member.last_page_updated_at,
                progress_pct=(
                    self._progress_pct(member.current_page, plan.weekly_pages, elapsed_weeks)
                    if plan is not None
                    else 0.0
                ),
            )
            for member, nickname in members
        ]
        return ClubProgressResponse(plan=plan_resp, members=items)

    @staticmethod
    def _plan_weeks(start_date: date, end_date: date) -> int:
        """Number of whole weeks the plan spans, at least one."""
        days = (end_date - start_date).days
        return max(1, math.ceil((days + 1) / 7))

    @staticmethod
    def _elapsed_weeks(plan: ClubReadingPlan) -> int:
        """Weeks elapsed since the plan start, clamped to [1, plan span]."""
        total_weeks = ClubService._plan_weeks(plan.start_date, plan.end_date)
        elapsed_days = (date.today() - plan.start_date).days
        elapsed = max(1, math.ceil((elapsed_days + 1) / 7))
        return min(elapsed, total_weeks)

    @staticmethod
    def _progress_pct(current_page: int, weekly_pages: int, elapsed_weeks: int) -> float:
        expected = weekly_pages * elapsed_weeks
        if expected <= 0:
            return 0.0
        pct = current_page / expected * 100
        return max(0.0, min(100.0, pct))

    @staticmethod
    def _to_plan_response(plan: ClubReadingPlan) -> ReadingPlanResponse:
        return ReadingPlanResponse(
            id=plan.id,
            club_id=plan.club_id,
            book_id=plan.book_id,
            start_date=plan.start_date,
            end_date=plan.end_date,
            weekly_pages=plan.weekly_pages,
            created_at=plan.created_at,
        )

    async def _push_plan_created(self, *, club_id: UUID, exclude_user_id: UUID) -> None:
        """Notify members that a reading plan was created — failures are swallowed."""
        try:
            member_ids = await self.repo.get_member_ids(club_id)
            targets = [uid for uid in member_ids if uid != exclude_user_id]
            if not targets:
                return
            from app.domains.notification.providers import get_notification_service

            svc = get_notification_service()
            for uid in targets:
                tokens = await svc.device_tokens.get_active_tokens(uid)
                if tokens:
                    await svc.push.send_to_tokens(
                        tokens=tokens,
                        title="독서 계획이 생성됐어요!",
                        body="클럽의 새 독서 계획을 확인해보세요.",
                        data={"type": "club_reading_plan", "club_id": str(club_id)},
                    )
        except Exception:
            pass  # fire-and-forget: push failure must not affect the main flow

    # --- sessions (BC-44) ---

    async def create_session(
        self, *, club_id: UUID, user_id: UUID, req: ClubSessionCreate
    ) -> ClubSessionPublic:
        await self._assert_host(club_id, user_id)
        await self._assert_presenter_is_member(club_id, req.presenter_id)
        session_row = await self.repo.create_session(
            club_id=club_id,
            book_id=req.book_id,
            title=req.title,
            scope=req.scope,
            presenter_id=req.presenter_id,
            scheduled_at=req.scheduled_at,
            created_by=user_id,
        )
        return self._to_session_public(session_row)

    async def list_sessions(
        self,
        *,
        club_id: UUID,
        caller_user_id: UUID,
        book_id: UUID | None = None,
    ) -> list[ClubSessionPublic]:
        await self._assert_can_view_club(club_id, caller_user_id)
        sessions = await self.repo.list_sessions(club_id, book_id=book_id)
        return [self._to_session_public(s) for s in sessions]

    async def get_session(
        self, *, club_id: UUID, session_id: UUID, caller_user_id: UUID
    ) -> ClubSessionPublic:
        await self._assert_can_view_club(club_id, caller_user_id)
        session_row = await self._get_session_in_club(club_id, session_id)
        return self._to_session_public(session_row)

    async def set_session_presenter(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        user_id: UUID,
        presenter_id: UUID | None,
    ) -> ClubSessionPublic:
        await self._assert_host(club_id, user_id)
        await self._get_session_in_club(club_id, session_id)
        await self._assert_presenter_is_member(club_id, presenter_id)
        updated = await self.repo.update_session_presenter(session_id, presenter_id)
        if updated is None:
            raise NotFoundError("session not found", code="SESSION_NOT_FOUND")
        return self._to_session_public(updated)

    async def transition_session_status(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        user_id: UUID,
        status: str,
    ) -> ClubSessionPublic:
        await self._assert_host(club_id, user_id)
        session_row = await self._get_session_in_club(club_id, session_id)
        self._validate_status_transition(session_row.status, status)
        updated = await self.repo.update_session_status(session_id, status)
        if updated is None:
            raise NotFoundError("session not found", code="SESSION_NOT_FOUND")
        if status == SessionStatus.OPEN and self.feed_service is not None:
            await self.feed_service.record_session_opened(
                user_id=user_id,
                club_id=club_id,
                session_id=session_id,
                book_id=updated.book_id,
            )
        return self._to_session_public(updated)

    async def _assert_host(self, club_id: UUID, user_id: UUID) -> ReadingClub:
        """Only the club owner (host) may manage sessions (design §5)."""
        club = await self.repo.get_by_id(club_id)
        if club is None:
            raise NotFoundError("club not found", code="CLUB_NOT_FOUND")
        role = await self.repo.get_member_role(club_id, user_id)
        if role != ClubRole.OWNER:
            raise PermissionDeniedError(
                "호스트만 회차를 관리할 수 있습니다", code="PERMISSION_DENIED"
            )
        return club

    async def _assert_can_view_club(self, club_id: UUID, user_id: UUID) -> ReadingClub:
        """Members can always view; non-members only when the club is public."""
        club = await self.repo.get_by_id(club_id)
        if club is None:
            raise NotFoundError("club not found", code="CLUB_NOT_FOUND")
        if club.is_public:
            return club
        if not await self.repo.is_member(club_id, user_id):
            raise PermissionDeniedError("클럽 멤버만 조회할 수 있습니다", code="NOT_MEMBER")
        return club

    async def _assert_presenter_is_member(self, club_id: UUID, presenter_id: UUID | None) -> None:
        if presenter_id is None:
            return
        if not await self.repo.is_member(club_id, presenter_id):
            raise ConflictError("발제자는 클럽 멤버여야 합니다", code="PRESENTER_NOT_MEMBER")

    async def _get_session_in_club(self, club_id: UUID, session_id: UUID) -> ClubSession:
        session_row = await self.repo.get_session(session_id)
        if session_row is None or session_row.club_id != club_id:
            raise NotFoundError("session not found", code="SESSION_NOT_FOUND")
        return session_row

    @staticmethod
    def _validate_status_transition(current: str, target: str) -> None:
        """Reject anything but the next step in draft→open→closed (design §5)."""
        try:
            cur_idx = _SESSION_STATUS_ORDER.index(current)
            tgt_idx = _SESSION_STATUS_ORDER.index(target)
        except ValueError as exc:
            raise ConflictError("유효하지 않은 상태입니다", code="INVALID_SESSION_STATUS") from exc
        if tgt_idx != cur_idx + 1:
            raise ConflictError(
                f"{current}에서 {target}로 전이할 수 없습니다",
                code="INVALID_STATUS_TRANSITION",
            )

    @staticmethod
    def _to_session_public(session_row: ClubSession) -> ClubSessionPublic:
        return ClubSessionPublic(
            id=session_row.id,
            club_id=session_row.club_id,
            book_id=session_row.book_id,
            title=session_row.title,
            scope=session_row.scope,
            presenter_id=session_row.presenter_id,
            scheduled_at=session_row.scheduled_at,
            status=session_row.status,
            created_by=session_row.created_by,
            created_at=session_row.created_at,
        )

    # --- agendas (BC-45) ---

    async def create_agenda(
        self, *, club_id: UUID, session_id: UUID, user_id: UUID, req: SessionAgendaCreate
    ) -> SessionAgendaPublic:
        await self._assert_host_or_presenter(
            club_id=club_id, session_id=session_id, user_id=user_id
        )
        agenda = await self.repo.create_agenda(
            session_id=session_id, author_id=user_id, body=req.body
        )
        return self._to_agenda_public(agenda, [])

    async def update_agenda(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        user_id: UUID,
        req: SessionAgendaUpdate,
    ) -> SessionAgendaPublic:
        # Design §5 확정: 발제문 작성/수정은 회차 status(draft/open/closed)와 무관하게
        # 허용한다 — 여기서 세션 상태를 게이팅하지 않는다.
        await self._assert_host_or_presenter(
            club_id=club_id, session_id=session_id, user_id=user_id
        )
        agenda = await self._get_agenda_in_session(session_id, agenda_id)
        updated = await self.repo.update_agenda_body(agenda.id, req.body)
        if updated is None:
            raise NotFoundError("agenda not found", code="AGENDA_NOT_FOUND")
        topics = await self.repo.list_topics_by_agenda(updated.id)
        return self._to_agenda_public(updated, topics)

    async def publish_agenda(
        self, *, club_id: UUID, session_id: UUID, agenda_id: UUID, user_id: UUID
    ) -> SessionAgendaPublic:
        await self._assert_host_or_presenter(
            club_id=club_id, session_id=session_id, user_id=user_id
        )
        agenda = await self._get_agenda_in_session(session_id, agenda_id)
        if agenda.status == AgendaStatus.PUBLISHED:
            raise ConflictError("이미 게시된 발제문입니다", code="ALREADY_PUBLISHED")
        updated = await self.repo.publish_agenda(agenda.id, published_at=datetime.now())
        if updated is None:
            raise NotFoundError("agenda not found", code="AGENDA_NOT_FOUND")
        if self.feed_service is not None:
            await self.feed_service.record_agenda_published(
                user_id=user_id,
                club_id=club_id,
                session_id=session_id,
                agenda_id=agenda_id,
            )
        if self.notification_service is not None:
            member_ids = await self.repo.get_member_ids(club_id)
            recipient_ids = [uid for uid in member_ids if uid != user_id]
            if recipient_ids:
                await self.notification_service.notify_agenda_published(
                    actor_id=user_id,
                    club_id=club_id,
                    session_id=session_id,
                    agenda_id=agenda_id,
                    recipient_ids=recipient_ids,
                )
        topics = await self.repo.list_topics_by_agenda(updated.id)
        return self._to_agenda_public(updated, topics)

    async def list_agendas(
        self, *, club_id: UUID, session_id: UUID, caller_user_id: UUID
    ) -> list[SessionAgendaPublic]:
        await self._assert_can_view_club(club_id, caller_user_id)
        await self._get_session_in_club(club_id, session_id)
        agendas = await self.repo.list_agendas_by_session(session_id)
        return [self._to_agenda_public(a, a.topics) for a in agendas]

    async def get_agenda(
        self, *, club_id: UUID, session_id: UUID, agenda_id: UUID, caller_user_id: UUID
    ) -> SessionAgendaPublic:
        await self._assert_can_view_club(club_id, caller_user_id)
        await self._get_session_in_club(club_id, session_id)
        agenda = await self._get_agenda_with_topics_in_session(session_id, agenda_id)
        return self._to_agenda_public(agenda, agenda.topics)

    # --- topics (BC-45) ---

    async def add_topic(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        user_id: UUID,
        req: AgendaTopicCreate,
    ) -> AgendaTopicPublic:
        await self._get_session_in_club(club_id, session_id)
        agenda = await self._get_agenda_in_session(session_id, agenda_id)
        self._assert_agenda_author(agenda, user_id)
        position = await self.repo.get_next_topic_position(agenda.id)
        topic = await self.repo.create_topic(
            agenda_id=agenda.id, position=position, prompt=req.prompt
        )
        return self._to_topic_public(topic)

    async def update_topic(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        topic_id: UUID,
        user_id: UUID,
        req: AgendaTopicUpdate,
    ) -> AgendaTopicPublic:
        await self._get_session_in_club(club_id, session_id)
        agenda = await self._get_agenda_in_session(session_id, agenda_id)
        self._assert_agenda_author(agenda, user_id)
        await self._get_topic_in_agenda(agenda.id, topic_id)
        updated = await self.repo.update_topic_prompt(topic_id, req.prompt)
        if updated is None:
            raise NotFoundError("topic not found", code="TOPIC_NOT_FOUND")
        return self._to_topic_public(updated)

    async def delete_topic(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        topic_id: UUID,
        user_id: UUID,
    ) -> None:
        await self._get_session_in_club(club_id, session_id)
        agenda = await self._get_agenda_in_session(session_id, agenda_id)
        self._assert_agenda_author(agenda, user_id)
        await self._get_topic_in_agenda(agenda.id, topic_id)
        await self.repo.delete_topic(topic_id)

    async def reorder_topics(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        user_id: UUID,
        topic_ids: list[UUID],
    ) -> list[AgendaTopicPublic]:
        await self._get_session_in_club(club_id, session_id)
        agenda = await self._get_agenda_in_session(session_id, agenda_id)
        self._assert_agenda_author(agenda, user_id)
        existing = await self.repo.list_topics_by_agenda(agenda.id)
        existing_ids = {t.id for t in existing}
        if set(topic_ids) != existing_ids:
            raise ConflictError("논제 목록이 일치하지 않습니다", code="INVALID_TOPIC_SET")
        reordered = await self.repo.reorder_topics(agenda.id, topic_ids)
        return [self._to_topic_public(t) for t in reordered]

    # --- AI 논제 초안 추천 (BC-53) ---

    async def recommend_topic_drafts(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        user_id: UUID,
        book_id: UUID,
        scope: str,
    ) -> list[str]:
        """발제문 author용 AI 논제 초안 3~5개 추천 (BC-53, design §6.3).

        권한은 논제 추가·수정·삭제와 동일하게 "이 발제문의 author"로 게이팅한다
        (``_assert_agenda_author`` 재사용) — 세션의 host/presenter 전반이 아니라
        실제로 이 발제문을 쓴 사람만 추천을 받는다. 추천 결과는 그대로 반환할
        뿐 DB에 저장하지 않는다: 발제자가 마음에 드는 문구를 골라 기존
        ``add_topic``으로 직접 추가해야 한다. 무료 MVP 범위라 Pro 게이팅은 두지
        않는다(design §6.3, 명시적 결정).
        """
        await self._get_session_in_club(club_id, session_id)
        agenda = await self._get_agenda_in_session(session_id, agenda_id)
        self._assert_agenda_author(agenda, user_id)
        if self.agenda_ai is None:
            raise NotConfiguredError(
                "AI 논제 추천 기능을 사용할 수 없습니다", code="AGENDA_AI_UNAVAILABLE"
            )
        return await self.agenda_ai.generate_topic_drafts(
            user_id=user_id, book_id=book_id, scope=scope
        )

    async def _assert_host_or_presenter(
        self, *, club_id: UUID, session_id: UUID, user_id: UUID
    ) -> ClubSession:
        """발제문 작성·수정·게시 권한 = 해당 회차의 host 또는 presenter (design §5)."""
        club = await self.repo.get_by_id(club_id)
        if club is None:
            raise NotFoundError("club not found", code="CLUB_NOT_FOUND")
        session_row = await self._get_session_in_club(club_id, session_id)
        is_host = club.owner_id == user_id
        is_presenter = session_row.presenter_id is not None and session_row.presenter_id == user_id
        if not (is_host or is_presenter):
            raise PermissionDeniedError(
                "호스트 또는 발제자만 발제문을 작성할 수 있습니다", code="PERMISSION_DENIED"
            )
        return session_row

    async def _get_agenda_in_session(self, session_id: UUID, agenda_id: UUID) -> SessionAgenda:
        agenda = await self.repo.get_agenda(agenda_id)
        if agenda is None or agenda.session_id != session_id:
            raise NotFoundError("agenda not found", code="AGENDA_NOT_FOUND")
        return agenda

    async def _get_agenda_with_topics_in_session(
        self, session_id: UUID, agenda_id: UUID
    ) -> SessionAgenda:
        agenda = await self.repo.get_agenda_with_topics(agenda_id)
        if agenda is None or agenda.session_id != session_id:
            raise NotFoundError("agenda not found", code="AGENDA_NOT_FOUND")
        return agenda

    async def _get_topic_in_agenda(self, agenda_id: UUID, topic_id: UUID) -> AgendaTopic:
        topic = await self.repo.get_topic(topic_id)
        if topic is None or topic.agenda_id != agenda_id:
            raise NotFoundError("topic not found", code="TOPIC_NOT_FOUND")
        return topic

    @staticmethod
    def _assert_agenda_author(agenda: SessionAgenda, user_id: UUID) -> None:
        """논제 추가·수정·삭제·순서 변경 권한 = 발제문 author (design §5)."""
        if agenda.author_id != user_id:
            raise PermissionDeniedError(
                "발제문 작성자만 논제를 관리할 수 있습니다", code="PERMISSION_DENIED"
            )

    @staticmethod
    def _to_agenda_public(agenda: SessionAgenda, topics: list[AgendaTopic]) -> SessionAgendaPublic:
        return SessionAgendaPublic(
            id=agenda.id,
            session_id=agenda.session_id,
            author_id=agenda.author_id,
            body=agenda.body,
            status=agenda.status,
            published_at=agenda.published_at,
            created_at=agenda.created_at,
            topics=[ClubService._to_topic_public(t) for t in topics],
        )

    @staticmethod
    def _to_topic_public(topic: AgendaTopic) -> AgendaTopicPublic:
        return AgendaTopicPublic(
            id=topic.id,
            agenda_id=topic.agenda_id,
            position=topic.position,
            prompt=topic.prompt,
            created_at=topic.created_at,
        )

    # --- topic comments (BC-46) ---

    async def add_comment(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        topic_id: UUID,
        user_id: UUID,
        req: TopicCommentCreate,
    ) -> TopicCommentPublic:
        await self._get_club_or_404(club_id)
        await self._get_session_in_club(club_id, session_id)
        agenda = await self._get_agenda_in_session(session_id, agenda_id)
        topic = await self._get_topic_in_agenda(agenda.id, topic_id)
        # 답글 작성 = club 멤버 (design §5) — 공개 클럽 열람자라도 작성은 멤버만
        # 허용해야 하므로 _assert_can_view_club이 아닌 멤버십을 직접 확인한다.
        await self._assert_club_member(club_id, user_id)

        parent_id = req.parent_comment_id
        parent_author_id: UUID | None = None
        if parent_id is not None:
            parent = await self._get_comment_in_topic(topic.id, parent_id)
            if parent.parent_comment_id is not None:
                # 1단계 대댓글까지만 허용(design §2 비목표) — 부모 자신이 이미
                # 대댓글이면 그 밑에 또 답글을 다는 2단계 트리를 거부한다.
                raise ConflictError(
                    "대댓글에는 답글을 달 수 없습니다", code="MAX_REPLY_DEPTH_EXCEEDED"
                )
            parent_author_id = parent.author_id

        comment = await self.repo.create_comment(
            topic_id=topic.id,
            author_id=user_id,
            parent_comment_id=parent_id,
            body=req.body,
        )
        if self.feed_service is not None:
            await self.feed_service.record_discussion_commented(
                user_id=user_id,
                club_id=club_id,
                session_id=session_id,
                agenda_id=agenda_id,
                topic_id=topic.id,
                comment_id=comment.id,
                parent_comment_id=parent_id,
            )
        if self.notification_service is not None:
            # 발제문 author + (대댓글이면) 부모 댓글 author, 본인 제외·중복 제거
            # (design §6.2). agenda/parent는 위에서 이미 조회했으므로 추가 쿼리 없음.
            recipient_ids = {
                uid
                for uid in (agenda.author_id, parent_author_id)
                if uid is not None and uid != user_id
            }
            if recipient_ids:
                await self.notification_service.notify_topic_comment_added(
                    actor_id=user_id,
                    club_id=club_id,
                    session_id=session_id,
                    agenda_id=agenda_id,
                    topic_id=topic.id,
                    comment_id=comment.id,
                    recipient_ids=list(recipient_ids),
                )
        return self._to_comment_public(comment)

    async def update_comment(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        topic_id: UUID,
        comment_id: UUID,
        user_id: UUID,
        req: TopicCommentUpdate,
    ) -> TopicCommentPublic:
        club = await self._get_club_or_404(club_id)
        await self._get_session_in_club(club_id, session_id)
        agenda = await self._get_agenda_in_session(session_id, agenda_id)
        topic = await self._get_topic_in_agenda(agenda.id, topic_id)
        comment = await self._get_comment_in_topic(topic.id, comment_id)
        self._assert_comment_author_or_host(club, comment, user_id)

        updated = await self.repo.update_comment_body(
            comment.id, req.body, edited_at=datetime.now()
        )
        if updated is None:
            raise NotFoundError("comment not found", code="COMMENT_NOT_FOUND")
        return self._to_comment_public(updated)

    async def delete_comment(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        topic_id: UUID,
        comment_id: UUID,
        user_id: UUID,
    ) -> None:
        club = await self._get_club_or_404(club_id)
        await self._get_session_in_club(club_id, session_id)
        agenda = await self._get_agenda_in_session(session_id, agenda_id)
        topic = await self._get_topic_in_agenda(agenda.id, topic_id)
        comment = await self._get_comment_in_topic(topic.id, comment_id)
        self._assert_comment_author_or_host(club, comment, user_id)
        # design §4 모델 주석: parent_comment_id는 ON DELETE CASCADE이므로 최상위
        # 댓글을 지우면 그 아래 대댓글도 DB가 함께 정리한다 — 여기서 자식을 따로
        # 조회·삭제할 필요는 없다.
        await self.repo.delete_comment(comment.id)

    async def list_comments(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        topic_id: UUID,
        caller_user_id: UUID,
    ) -> list[TopicCommentThreadPublic]:
        await self._assert_can_view_club(club_id, caller_user_id)
        await self._get_session_in_club(club_id, session_id)
        agenda = await self._get_agenda_in_session(session_id, agenda_id)
        topic = await self._get_topic_in_agenda(agenda.id, topic_id)
        comments = await self.repo.list_comments_by_topic(topic.id)
        return self._build_comment_threads(comments)

    async def _get_club_or_404(self, club_id: UUID) -> ReadingClub:
        club = await self.repo.get_by_id(club_id)
        if club is None:
            raise NotFoundError("club not found", code="CLUB_NOT_FOUND")
        return club

    async def _assert_club_member(self, club_id: UUID, user_id: UUID) -> None:
        """답글 작성 권한 = club 멤버 (design §5) — 발제자·호스트 제한 없음."""
        if not await self.repo.is_member(club_id, user_id):
            raise PermissionDeniedError("클럽 멤버만 답글을 작성할 수 있습니다", code="NOT_MEMBER")

    async def _get_comment_in_topic(self, topic_id: UUID, comment_id: UUID) -> TopicComment:
        comment = await self.repo.get_comment(comment_id)
        if comment is None or comment.topic_id != topic_id:
            raise NotFoundError("comment not found", code="COMMENT_NOT_FOUND")
        return comment

    @staticmethod
    def _assert_comment_author_or_host(
        club: ReadingClub, comment: TopicComment, user_id: UUID
    ) -> None:
        """답글 수정·삭제 권한 = 본인 또는 host (design §5)."""
        is_author = comment.author_id == user_id
        is_host = club.owner_id == user_id
        if not (is_author or is_host):
            raise PermissionDeniedError(
                "본인 또는 호스트만 답글을 수정·삭제할 수 있습니다",
                code="PERMISSION_DENIED",
            )

    @staticmethod
    def _build_comment_threads(comments: list[TopicComment]) -> list[TopicCommentThreadPublic]:
        """Group a topic's flat, oldest-first comments into top-level threads.

        Replies are single-level by construction (design §2 비목표) — every
        reply's parent is itself a top-level comment — so grouping by
        parent_comment_id in one pass is sufficient; no recursive tree walk
        is needed.
        """
        replies_by_parent: dict[UUID, list[TopicCommentPublic]] = {}
        roots: list[TopicComment] = []
        for comment in comments:
            if comment.parent_comment_id is None:
                roots.append(comment)
            else:
                replies_by_parent.setdefault(comment.parent_comment_id, []).append(
                    ClubService._to_comment_public(comment)
                )
        return [
            TopicCommentThreadPublic(
                id=root.id,
                topic_id=root.topic_id,
                author_id=root.author_id,
                body=root.body,
                created_at=root.created_at,
                edited_at=root.edited_at,
                replies=replies_by_parent.get(root.id, []),
            )
            for root in roots
        ]

    @staticmethod
    def _to_comment_public(comment: TopicComment) -> TopicCommentPublic:
        return TopicCommentPublic(
            id=comment.id,
            topic_id=comment.topic_id,
            author_id=comment.author_id,
            parent_comment_id=comment.parent_comment_id,
            body=comment.body,
            created_at=comment.created_at,
            edited_at=comment.edited_at,
        )
