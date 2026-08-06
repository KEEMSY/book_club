from __future__ import annotations

from datetime import datetime
from typing import Annotated, Literal
from uuid import UUID

from fastapi import APIRouter, Depends, Query, status

from app.core.deps import get_current_user_id
from app.domains.club.models import ClubReadingPlan, ReadingClub
from app.domains.club.providers import get_club_service
from app.domains.club.repository import ClubRepository
from app.domains.club.schemas import (
    AgendaTopicCreate,
    AgendaTopicListResponse,
    AgendaTopicPublic,
    AgendaTopicRecommendationRequest,
    AgendaTopicRecommendationResponse,
    AgendaTopicUpdate,
    AttendeeListResponse,
    ClubEventCreate,
    ClubEventListResponse,
    ClubEventPublic,
    ClubEventUpdate,
    ClubListResponse,
    ClubMessagePublic,
    ClubProgressResponse,
    ClubPublic,
    ClubRoomCreate,
    ClubRoomListResponse,
    ClubRoomPublic,
    ClubSessionCreate,
    ClubSessionListResponse,
    ClubSessionPublic,
    CreateClubRequest,
    CreateReadingPlanRequest,
    EditMessageRequest,
    MessageListResponse,
    PublicClubListResponse,
    ReadingPlanResponse,
    ReorderTopicsRequest,
    RsvpRequest,
    SendMessageRequest,
    SessionAgendaCreate,
    SessionAgendaListResponse,
    SessionAgendaPublic,
    SessionAgendaUpdate,
    SetClubBookRequest,
    SetSessionPresenterRequest,
    TopicCommentCreate,
    TopicCommentPublic,
    TopicCommentThreadListResponse,
    TopicCommentUpdate,
    UpdateProgressRequest,
    UpdateSessionStatusRequest,
)
from app.domains.club.service import ClubService

router = APIRouter(prefix="/clubs", tags=["clubs"])


async def _to_public(club: ReadingClub, repo: ClubRepository) -> ClubPublic:
    count = await repo.member_count(club.id)
    tags = await repo.get_club_tags(club.id)
    return ClubPublic(
        id=club.id,
        name=club.name,
        description=club.description,
        owner_id=club.owner_id,
        book_id=club.book_id,
        book_title=None,
        invite_code=club.invite_code,
        max_members=club.max_members,
        member_count=count,
        is_public=club.is_public,
        category=club.category,
        tags=tags,
        created_at=club.created_at,
    )


@router.post("", response_model=ClubPublic, status_code=status.HTTP_201_CREATED)
async def create_club(
    body: CreateClubRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubPublic:
    club = await service.create_club(user_id=UUID(user_id), req=body)
    return await _to_public(club, service.repo)


@router.get("/me", response_model=ClubListResponse)
async def list_my_clubs(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubListResponse:
    clubs = await service.list_my_clubs(UUID(user_id))
    items = [await _to_public(c, service.repo) for c in clubs]
    return ClubListResponse(items=items)


@router.post("/join", response_model=ClubPublic, status_code=status.HTTP_200_OK)
async def join_club(
    body: dict[str, str],
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubPublic:
    invite_code = body.get("invite_code", "")
    club = await service.join_by_code(user_id=UUID(user_id), invite_code=str(invite_code))
    return await _to_public(club, service.repo)


@router.get("/public", response_model=PublicClubListResponse)
async def list_public_clubs(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
    search: Annotated[str | None, Query(max_length=100)] = None,
    sort: Annotated[Literal["popular", "newest"], Query()] = "newest",
    cursor: Annotated[
        datetime | None,
        Query(description="ISO-8601 created_at of the last item on the previous page"),
    ] = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 20,
    category: Annotated[str | None, Query(max_length=32)] = None,
    tag: Annotated[str | None, Query(max_length=32)] = None,
) -> PublicClubListResponse:
    clubs = await service.list_public_clubs(
        search=search,
        sort=sort,
        cursor=cursor,
        limit=limit + 1,
        category=category,
        tag=tag,
    )
    has_more = len(clubs) > limit
    page = clubs[:limit]
    items = [await _to_public(c, service.repo) for c in page]
    next_cursor = page[-1].created_at.isoformat() if has_more else None
    return PublicClubListResponse(items=items, next_cursor=next_cursor)


@router.get("/recommended", response_model=PublicClubListResponse)
async def recommended_clubs(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
    limit: Annotated[int, Query(ge=1, le=20)] = 6,
) -> PublicClubListResponse:
    clubs = await service.get_recommended_clubs(UUID(user_id), limit=limit)
    items = [await _to_public(c, service.repo) for c in clubs]
    return PublicClubListResponse(items=items, next_cursor=None)


@router.post("/{club_id}/join-public", response_model=ClubPublic, status_code=status.HTTP_200_OK)
async def join_public_club(
    club_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubPublic:
    club = await service.join_public(club_id=club_id, user_id=UUID(user_id))
    return await _to_public(club, service.repo)


@router.get("/{club_id}", response_model=ClubPublic)
async def get_club(
    club_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubPublic:
    club = await service.get_club(club_id)
    return await _to_public(club, service.repo)


@router.delete("/{club_id}/leave", status_code=status.HTTP_204_NO_CONTENT)
async def leave_club(
    club_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> None:
    await service.leave_club(user_id=UUID(user_id), club_id=club_id)


@router.post(
    "/{club_id}/events",
    response_model=ClubEventPublic,
    status_code=status.HTTP_201_CREATED,
)
async def create_event(
    club_id: UUID,
    body: ClubEventCreate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubEventPublic:
    return await service.create_event(user_id=UUID(user_id), club_id=club_id, data=body)


@router.get("/{club_id}/events", response_model=ClubEventListResponse)
async def list_events(
    club_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
    upcoming_only: Annotated[bool, Query(description="Filter to future events only")] = True,
) -> ClubEventListResponse:
    items = await service.list_events(
        club_id=club_id, caller_user_id=UUID(user_id), upcoming_only=upcoming_only
    )
    return ClubEventListResponse(items=items)


@router.get("/{club_id}/events/{event_id}", response_model=ClubEventPublic)
async def get_event(
    club_id: UUID,
    event_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubEventPublic:
    return await service.get_event(event_id=event_id, caller_user_id=UUID(user_id))


@router.patch(
    "/{club_id}/events/{event_id}",
    response_model=ClubEventPublic,
)
async def update_event(
    club_id: UUID,
    event_id: UUID,
    body: ClubEventUpdate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubEventPublic:
    return await service.update_event(event_id=event_id, user_id=UUID(user_id), data=body)


@router.delete(
    "/{club_id}/events/{event_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_event(
    club_id: UUID,
    event_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> None:
    await service.delete_event(event_id=event_id, user_id=UUID(user_id))


@router.post(
    "/{club_id}/events/{event_id}/rsvp",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def rsvp_event(
    club_id: UUID,
    event_id: UUID,
    body: RsvpRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> None:
    await service.rsvp(user_id=UUID(user_id), event_id=event_id, status=body.status)


@router.get(
    "/{club_id}/events/{event_id}/attendees",
    response_model=AttendeeListResponse,
)
async def list_event_attendees(
    club_id: UUID,
    event_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> AttendeeListResponse:
    return await service.get_attendees(event_id=event_id, caller_user_id=UUID(user_id))


# --- chat messages ---


@router.post(
    "/{club_id}/messages",
    response_model=ClubMessagePublic,
    status_code=status.HTTP_201_CREATED,
)
async def send_message(
    club_id: UUID,
    body: SendMessageRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubMessagePublic:
    return await service.send_message(
        club_id=club_id,
        user_id=UUID(user_id),
        content=body.content,
        media_url=body.media_url,
    )


@router.get("/{club_id}/messages", response_model=MessageListResponse)
async def list_messages(
    club_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
    cursor: Annotated[
        datetime | None,
        Query(description="ISO-8601 created_at of the oldest item on the previous page"),
    ] = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 50,
) -> MessageListResponse:
    return await service.list_messages(
        club_id=club_id,
        user_id=UUID(user_id),
        cursor=cursor,
        limit=limit,
    )


@router.post(
    "/{club_id}/messages/{message_id}/read",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def mark_message_read(
    club_id: UUID,
    message_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> None:
    await service.mark_read(
        club_id=club_id,
        user_id=UUID(user_id),
        message_id=message_id,
    )


@router.patch(
    "/{club_id}/messages/{message_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def edit_message(
    club_id: UUID,
    message_id: UUID,
    body: EditMessageRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> None:
    await service.edit_message(
        club_id=club_id,
        user_id=UUID(user_id),
        message_id=message_id,
        content=body.content,
    )


@router.delete(
    "/{club_id}/messages/{message_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_message(
    club_id: UUID,
    message_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> None:
    await service.delete_message(
        club_id=club_id,
        user_id=UUID(user_id),
        message_id=message_id,
    )


# --- club rooms ---


@router.post(
    "/{club_id}/rooms",
    response_model=ClubRoomPublic,
    status_code=status.HTTP_201_CREATED,
)
async def create_room(
    club_id: UUID,
    body: ClubRoomCreate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubRoomPublic:
    return await service.create_room(
        club_id=club_id,
        user_id=UUID(user_id),
        req=body,
    )


@router.get("/{club_id}/rooms", response_model=ClubRoomListResponse)
async def list_rooms(
    club_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubRoomListResponse:
    return await service.list_rooms(
        club_id=club_id,
        caller_user_id=UUID(user_id),
    )


@router.delete(
    "/{club_id}/rooms/{room_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_room(
    club_id: UUID,
    room_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> None:
    await service.delete_room(
        club_id=club_id,
        room_id=room_id,
        user_id=UUID(user_id),
    )


# --- reading plans (M52) ---


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


@router.post(
    "/{club_id}/reading-plan",
    response_model=ReadingPlanResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_reading_plan(
    club_id: UUID,
    body: CreateReadingPlanRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ReadingPlanResponse:
    plan = await service.create_reading_plan(
        club_id=club_id,
        created_by=UUID(user_id),
        book_id=body.book_id,
        start_date=body.start_date,
        end_date=body.end_date,
    )
    return _to_plan_response(plan)


@router.get("/{club_id}/reading-plan", response_model=ReadingPlanResponse | None)
async def get_reading_plan(
    club_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ReadingPlanResponse | None:
    plan = await service.repo.get_active_reading_plan(club_id)
    return _to_plan_response(plan) if plan is not None else None


@router.patch("/{club_id}/members/me/progress", status_code=status.HTTP_204_NO_CONTENT)
async def update_my_progress(
    club_id: UUID,
    body: UpdateProgressRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> None:
    await service.update_member_progress(
        club_id=club_id,
        user_id=UUID(user_id),
        current_page=body.current_page,
    )


@router.get("/{club_id}/progress", response_model=ClubProgressResponse)
async def get_club_progress(
    club_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubProgressResponse:
    return await service.get_club_progress(club_id=club_id, requester_id=UUID(user_id))


@router.patch("/{club_id}/book", response_model=ClubPublic)
async def set_club_book(
    club_id: UUID,
    body: SetClubBookRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubPublic:
    club = await service.set_book(
        club_id=club_id,
        user_id=UUID(user_id),
        book_id=body.book_id,
    )
    return await _to_public(club, service.repo)


# --- sessions (BC-44) ---


@router.post(
    "/{club_id}/sessions",
    response_model=ClubSessionPublic,
    status_code=status.HTTP_201_CREATED,
)
async def create_session(
    club_id: UUID,
    body: ClubSessionCreate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubSessionPublic:
    return await service.create_session(club_id=club_id, user_id=UUID(user_id), req=body)


@router.get("/{club_id}/sessions", response_model=ClubSessionListResponse)
async def list_sessions(
    club_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
    book_id: Annotated[UUID | None, Query(description="특정 책의 회차만 조회")] = None,
) -> ClubSessionListResponse:
    items = await service.list_sessions(
        club_id=club_id, caller_user_id=UUID(user_id), book_id=book_id
    )
    return ClubSessionListResponse(items=items)


@router.get("/{club_id}/sessions/{session_id}", response_model=ClubSessionPublic)
async def get_session(
    club_id: UUID,
    session_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubSessionPublic:
    return await service.get_session(
        club_id=club_id, session_id=session_id, caller_user_id=UUID(user_id)
    )


@router.patch(
    "/{club_id}/sessions/{session_id}/presenter",
    response_model=ClubSessionPublic,
)
async def set_session_presenter(
    club_id: UUID,
    session_id: UUID,
    body: SetSessionPresenterRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubSessionPublic:
    return await service.set_session_presenter(
        club_id=club_id,
        session_id=session_id,
        user_id=UUID(user_id),
        presenter_id=body.presenter_id,
    )


@router.patch(
    "/{club_id}/sessions/{session_id}/status",
    response_model=ClubSessionPublic,
)
async def update_session_status(
    club_id: UUID,
    session_id: UUID,
    body: UpdateSessionStatusRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubSessionPublic:
    return await service.transition_session_status(
        club_id=club_id,
        session_id=session_id,
        user_id=UUID(user_id),
        status=body.status,
    )


# --- agendas (BC-45) ---


@router.post(
    "/{club_id}/sessions/{session_id}/agendas",
    response_model=SessionAgendaPublic,
    status_code=status.HTTP_201_CREATED,
)
async def create_agenda(
    club_id: UUID,
    session_id: UUID,
    body: SessionAgendaCreate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> SessionAgendaPublic:
    return await service.create_agenda(
        club_id=club_id, session_id=session_id, user_id=UUID(user_id), req=body
    )


@router.get(
    "/{club_id}/sessions/{session_id}/agendas",
    response_model=SessionAgendaListResponse,
)
async def list_agendas(
    club_id: UUID,
    session_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> SessionAgendaListResponse:
    items = await service.list_agendas(
        club_id=club_id, session_id=session_id, caller_user_id=UUID(user_id)
    )
    return SessionAgendaListResponse(items=items)


@router.get(
    "/{club_id}/sessions/{session_id}/agendas/{agenda_id}",
    response_model=SessionAgendaPublic,
)
async def get_agenda(
    club_id: UUID,
    session_id: UUID,
    agenda_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> SessionAgendaPublic:
    return await service.get_agenda(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        caller_user_id=UUID(user_id),
    )


@router.patch(
    "/{club_id}/sessions/{session_id}/agendas/{agenda_id}",
    response_model=SessionAgendaPublic,
)
async def update_agenda(
    club_id: UUID,
    session_id: UUID,
    agenda_id: UUID,
    body: SessionAgendaUpdate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> SessionAgendaPublic:
    return await service.update_agenda(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        user_id=UUID(user_id),
        req=body,
    )


@router.post(
    "/{club_id}/sessions/{session_id}/agendas/{agenda_id}/publish",
    response_model=SessionAgendaPublic,
)
async def publish_agenda(
    club_id: UUID,
    session_id: UUID,
    agenda_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> SessionAgendaPublic:
    return await service.publish_agenda(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        user_id=UUID(user_id),
    )


# --- topics (BC-45) ---


@router.post(
    "/{club_id}/sessions/{session_id}/agendas/{agenda_id}/topics",
    response_model=AgendaTopicPublic,
    status_code=status.HTTP_201_CREATED,
)
async def add_topic(
    club_id: UUID,
    session_id: UUID,
    agenda_id: UUID,
    body: AgendaTopicCreate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> AgendaTopicPublic:
    return await service.add_topic(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        user_id=UUID(user_id),
        req=body,
    )


# --- AI 논제 초안 추천 (BC-53, design §6.3) ---
#
# 추천만 반환하고 DB에 저장하지 않는다 — 발제자가 마음에 드는 문구를 골라
# 위 add_topic으로 직접 추가한다. 무료 MVP 범위라 Pro 게이팅은 없다.
@router.post(
    "/{club_id}/sessions/{session_id}/agendas/{agenda_id}/topics/recommendations",
    response_model=AgendaTopicRecommendationResponse,
)
async def recommend_topic_drafts(
    club_id: UUID,
    session_id: UUID,
    agenda_id: UUID,
    body: AgendaTopicRecommendationRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> AgendaTopicRecommendationResponse:
    topics = await service.recommend_topic_drafts(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        user_id=UUID(user_id),
        book_id=body.book_id,
        scope=body.scope,
    )
    return AgendaTopicRecommendationResponse(topics=topics)


# NOTE: the reorder route must be registered before the {topic_id} PATCH route
# below — both are single-segment PATCH paths under .../topics/, and FastAPI
# matches in registration order. Reversing this would make "reorder" attempt
# UUID conversion as a topic_id and fail with 422 instead of running reorder.
@router.patch(
    "/{club_id}/sessions/{session_id}/agendas/{agenda_id}/topics/reorder",
    response_model=AgendaTopicListResponse,
)
async def reorder_topics(
    club_id: UUID,
    session_id: UUID,
    agenda_id: UUID,
    body: ReorderTopicsRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> AgendaTopicListResponse:
    items = await service.reorder_topics(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        user_id=UUID(user_id),
        topic_ids=body.topic_ids,
    )
    return AgendaTopicListResponse(items=items)


@router.patch(
    "/{club_id}/sessions/{session_id}/agendas/{agenda_id}/topics/{topic_id}",
    response_model=AgendaTopicPublic,
)
async def update_topic(
    club_id: UUID,
    session_id: UUID,
    agenda_id: UUID,
    topic_id: UUID,
    body: AgendaTopicUpdate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> AgendaTopicPublic:
    return await service.update_topic(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic_id,
        user_id=UUID(user_id),
        req=body,
    )


@router.delete(
    "/{club_id}/sessions/{session_id}/agendas/{agenda_id}/topics/{topic_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_topic(
    club_id: UUID,
    session_id: UUID,
    agenda_id: UUID,
    topic_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> None:
    await service.delete_topic(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic_id,
        user_id=UUID(user_id),
    )


# --- topic comments (BC-46) ---


@router.post(
    "/{club_id}/sessions/{session_id}/agendas/{agenda_id}/topics/{topic_id}/comments",
    response_model=TopicCommentPublic,
    status_code=status.HTTP_201_CREATED,
)
async def add_comment(
    club_id: UUID,
    session_id: UUID,
    agenda_id: UUID,
    topic_id: UUID,
    body: TopicCommentCreate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> TopicCommentPublic:
    return await service.add_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic_id,
        user_id=UUID(user_id),
        req=body,
    )


@router.get(
    "/{club_id}/sessions/{session_id}/agendas/{agenda_id}/topics/{topic_id}/comments",
    response_model=TopicCommentThreadListResponse,
)
async def list_comments(
    club_id: UUID,
    session_id: UUID,
    agenda_id: UUID,
    topic_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> TopicCommentThreadListResponse:
    items = await service.list_comments(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic_id,
        caller_user_id=UUID(user_id),
    )
    return TopicCommentThreadListResponse(items=items)


@router.patch(
    "/{club_id}/sessions/{session_id}/agendas/{agenda_id}/topics/{topic_id}/comments/{comment_id}",
    response_model=TopicCommentPublic,
)
async def update_comment(
    club_id: UUID,
    session_id: UUID,
    agenda_id: UUID,
    topic_id: UUID,
    comment_id: UUID,
    body: TopicCommentUpdate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> TopicCommentPublic:
    return await service.update_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic_id,
        comment_id=comment_id,
        user_id=UUID(user_id),
        req=body,
    )


@router.delete(
    "/{club_id}/sessions/{session_id}/agendas/{agenda_id}/topics/{topic_id}/comments/{comment_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_comment(
    club_id: UUID,
    session_id: UUID,
    agenda_id: UUID,
    topic_id: UUID,
    comment_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> None:
    await service.delete_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic_id,
        comment_id=comment_id,
        user_id=UUID(user_id),
    )
