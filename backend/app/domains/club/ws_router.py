"""WebSocket endpoints for the club domain.

Two streams are provided:

- ``/ws/clubs/{club_id}`` — real-time chat stream for a reading club.
  Any member of the club may connect; non-members receive a 4003 close.
- ``/ws/me`` — personal notification stream for the authenticated user.

Authentication is via a ``token`` query parameter (JWT access token) because
the browser WebSocket API does not support custom headers.  The same
``decode_token`` helper used by HTTP routes is reused here so token
validation logic stays consistent.

A 30-second ping/pong heartbeat keeps connections alive through NAT and
load-balancer idle timeouts.

Notification fan-out rules
--------------------------
- Club chat message: after broadcasting to connected club subscribers, each
  club member who is *not* currently in the chat room (i.e. has no active
  ``ws:club:{id}`` socket but may have a ``ws:user:{id}`` socket) receives a
  ``chat.new_message`` push via their personal stream.  This lets the mobile
  app show an unread badge even when the chat screen is closed.
- Follow event: when a user is followed (FollowReceived), the followee
  receives a ``notification.follow_received`` push on their personal stream so
  the Flutter app can update counts in real time without polling.
"""

from __future__ import annotations

import asyncio
import json
import logging
import uuid
from typing import Any

from fastapi import APIRouter, Depends, Query, WebSocket, WebSocketDisconnect
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.core.exceptions import AuthError, PermissionDeniedError
from app.core.security import decode_token
from app.core.ws_manager import ws_manager
from app.domains.club.repository import ClubRepository
from app.domains.club.service import ClubService

logger = logging.getLogger(__name__)

router = APIRouter(tags=["websocket"])

_PING_INTERVAL_SEC = 30


def _authenticate_ws(token: str) -> str:
    """Validate *token* and return the user_id string.

    Raises :class:`AuthError` for any invalid or non-access token so the
    caller can close the WebSocket with an appropriate code.
    """
    payload = decode_token(token)
    if payload.get("type") != "access":
        raise AuthError("expected an access token", code="TOKEN_TYPE_MISMATCH")
    sub = payload.get("sub")
    if not isinstance(sub, str) or not sub:
        raise AuthError("token missing sub", code="TOKEN_INVALID")
    return sub


async def _heartbeat(websocket: WebSocket) -> None:
    """Send a ping frame every 30 seconds until the connection closes."""
    while True:
        await asyncio.sleep(_PING_INTERVAL_SEC)
        try:
            await websocket.send_text(json.dumps({"type": "ping"}))
        except Exception:
            return


async def _notify_offline_club_members(
    club_id: uuid.UUID,
    sender_user_id: str,
    message: dict[str, Any],
    session: AsyncSession,
) -> None:
    """Push a chat.new_message notification to club members not in the chat room.

    Members who already have an active ``/ws/clubs/{club_id}`` connection
    receive the message via the normal club broadcast.  Those who are absent
    from the club socket pool but connected via ``/ws/me`` are notified here
    so they get a real-time unread badge update.

    Members with no WebSocket connection at all are not targeted here — they
    will receive an FCM push via the notification service event pipeline.
    """
    from sqlalchemy import select

    from app.domains.club.models import ClubMember

    stmt = select(ClubMember.user_id).where(ClubMember.club_id == club_id)
    result = await session.execute(stmt)
    all_member_ids = {str(row) for row in result.scalars().all()}

    # Members currently in the club chat room — they already got the message.
    club_key = str(club_id)
    in_room: set[str] = set()
    for uid, sockets in ws_manager._user_sockets.items():
        if uid in all_member_ids and ws_manager._club_sockets.get(club_key, set()) & sockets:
            in_room.add(uid)

    notification_payload: dict[str, Any] = {
        "type": "chat.new_message",
        "club_id": str(club_id),
        "sender_id": sender_user_id,
        "preview": str(message.get("content", ""))[:100],
    }

    offline_members = all_member_ids - in_room - {sender_user_id}
    await asyncio.gather(
        *(ws_manager.send_user(uid, notification_payload) for uid in offline_members),
        return_exceptions=True,
    )


@router.websocket("/ws/clubs/{club_id}/chat")
async def club_chat_stream(
    websocket: WebSocket,
    club_id: uuid.UUID,
    token: str = Query(...),
    session: AsyncSession = Depends(get_session),
) -> None:
    """Real-time chat stream for a reading club.

    The client must supply a valid JWT access token via ``?token=``.
    Messages received from the client are broadcast to all club members
    currently connected to any process (via Redis fan-out when available).
    Members not in the chat room receive a personal-stream notification.

    Close codes:
    - 4001: missing or invalid token
    - 4003: token valid but user is not a member of this club (reserved for
            future membership check — currently accepts any authenticated user)
    """
    try:
        user_id = _authenticate_ws(token)
    except AuthError as exc:
        await websocket.close(code=4001, reason=str(exc))
        return

    await websocket.accept()
    ws_manager.connect_club(club_id, websocket)
    ws_manager.connect_user(user_id, websocket)

    heartbeat_task = asyncio.create_task(_heartbeat(websocket))

    try:
        while True:
            raw = await websocket.receive_text()
            try:
                data: dict[str, Any] = json.loads(raw)
            except json.JSONDecodeError:
                await websocket.send_text(json.dumps({"type": "error", "detail": "invalid JSON"}))
                continue

            msg_type = data.get("type", "")
            if msg_type == "ping":
                await websocket.send_text(json.dumps({"type": "pong"}))
                continue

            service = ClubService(ClubRepository(session))
            try:
                msg = await service.send_message(
                    club_id=club_id,
                    user_id=uuid.UUID(user_id),
                    content=data.get("content", ""),
                    media_url=data.get("media_url"),
                )
            except PermissionDeniedError:
                await websocket.send_text(
                    json.dumps({"type": "error", "detail": "not a club member"})
                )
                continue

            outbound: dict[str, Any] = {
                "type": "chat.message",
                "data": msg.model_dump(mode="json"),
            }

            await ws_manager.broadcast_club(club_id, outbound)

            # Notify members who are not currently in the chat room so they
            # can update their unread badge via the personal stream.
            await _notify_offline_club_members(
                club_id, user_id, msg.model_dump(mode="json"), session
            )
    except WebSocketDisconnect:
        pass
    except Exception:
        logger.exception(
            "Unexpected error in club_chat_stream for club=%s user=%s", club_id, user_id
        )
    finally:
        heartbeat_task.cancel()
        ws_manager.disconnect_club(club_id, websocket)
        ws_manager.disconnect_user(user_id, websocket)


@router.websocket("/ws/clubs/{club_id}/rooms/{room_id}/chat")
async def room_chat_stream(
    websocket: WebSocket,
    club_id: uuid.UUID,
    room_id: uuid.UUID,
    token: str = Query(...),
    session: AsyncSession = Depends(get_session),
) -> None:
    """Real-time chat stream for a progress-gated club room.

    The client must supply a valid JWT access token via ``?token=``.
    On connect the user's reading progress is checked against the room's
    ``progress_gate``; insufficient progress results in a 4003 close.

    Close codes:
    - 4001: missing or invalid token
    - 4003: progress below progress_gate (or user is not a club member)
    """
    try:
        user_id = _authenticate_ws(token)
    except AuthError as exc:
        await websocket.close(code=4001, reason=str(exc))
        return

    # Verify progress gate before accepting the connection.
    from sqlalchemy import select

    from app.domains.book.models import UserBook
    from app.domains.club.models import ClubMember, ClubRoom, ReadingClub

    # Check club membership.
    member_stmt = select(ClubMember.club_id).where(
        ClubMember.club_id == club_id,
        ClubMember.user_id == uuid.UUID(user_id),
    )
    member_result = await session.execute(member_stmt)
    if member_result.scalar_one_or_none() is None:
        await websocket.close(code=4003, reason="not a club member")
        return

    # Fetch the room.
    room = await session.get(ClubRoom, room_id)
    if room is None or room.club_id != club_id:
        await websocket.close(code=4003, reason="room not found")
        return

    if room.progress_gate > 0:
        # Resolve the club's book and compare the caller's chapter against the gate.
        club = await session.get(ReadingClub, club_id)
        caller_chapter = 0
        if club is not None and club.book_id is not None:
            chapter_stmt = select(UserBook.current_chapter).where(
                UserBook.user_id == uuid.UUID(user_id),
                UserBook.book_id == club.book_id,
            )
            chapter_result = await session.execute(chapter_stmt)
            chapter_val: int | None = chapter_result.scalar_one_or_none()
            caller_chapter = chapter_val if chapter_val is not None else 0

        if caller_chapter < room.progress_gate:
            await websocket.close(
                code=4003,
                reason=f"chapter {caller_chapter} below gate {room.progress_gate}",
            )
            return

    await websocket.accept()
    ws_manager.connect_room(room_id, websocket)
    ws_manager.connect_user(user_id, websocket)

    heartbeat_task = asyncio.create_task(_heartbeat(websocket))

    try:
        while True:
            raw = await websocket.receive_text()
            try:
                data: dict[str, Any] = json.loads(raw)
            except json.JSONDecodeError:
                await websocket.send_text(json.dumps({"type": "error", "detail": "invalid JSON"}))
                continue

            msg_type = data.get("type", "")
            if msg_type == "ping":
                await websocket.send_text(json.dumps({"type": "pong"}))
                continue

            service = ClubService(ClubRepository(session))
            try:
                msg = await service.send_message(
                    club_id=club_id,
                    user_id=uuid.UUID(user_id),
                    content=data.get("content", ""),
                    media_url=data.get("media_url"),
                )
            except PermissionDeniedError:
                await websocket.send_text(
                    json.dumps({"type": "error", "detail": "not a club member"})
                )
                continue

            outbound: dict[str, Any] = {
                "type": "chat.message",
                "data": msg.model_dump(mode="json"),
            }

            await ws_manager.broadcast_room(room_id, outbound)
    except WebSocketDisconnect:
        pass
    except Exception:
        logger.exception(
            "Unexpected error in room_chat_stream for room=%s user=%s", room_id, user_id
        )
    finally:
        heartbeat_task.cancel()
        ws_manager.disconnect_room(room_id, websocket)
        ws_manager.disconnect_user(user_id, websocket)


@router.websocket("/ws/me")
async def personal_notification_stream(
    websocket: WebSocket,
    token: str = Query(...),
) -> None:
    """Personal notification stream for the authenticated user.

    Used to deliver server-push events (new follower, badge earned, chat
    unread badge, etc.) without polling.  The client should treat this as
    read-only; any text sent by the client is silently discarded so the
    contract stays simple.

    Close codes:
    - 4001: missing or invalid token
    """
    try:
        user_id = _authenticate_ws(token)
    except AuthError as exc:
        await websocket.close(code=4001, reason=str(exc))
        return

    await websocket.accept()
    ws_manager.connect_user(user_id, websocket)

    heartbeat_task = asyncio.create_task(_heartbeat(websocket))

    try:
        while True:
            # Keep the coroutine alive; discard any client-sent text.
            await websocket.receive_text()
    except WebSocketDisconnect:
        pass
    except Exception:
        logger.exception("Unexpected error in personal_notification_stream for user=%s", user_id)
    finally:
        heartbeat_task.cancel()
        ws_manager.disconnect_user(user_id, websocket)
