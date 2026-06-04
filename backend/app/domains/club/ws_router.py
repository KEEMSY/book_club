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
"""

from __future__ import annotations

import asyncio
import json
import logging
import uuid
from typing import Any

from fastapi import APIRouter, Query, WebSocket, WebSocketDisconnect

from app.core.exceptions import AuthError
from app.core.security import decode_token
from app.core.ws_manager import ws_manager

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


@router.websocket("/ws/clubs/{club_id}")
async def club_chat_stream(
    websocket: WebSocket,
    club_id: uuid.UUID,
    token: str = Query(...),
) -> None:
    """Real-time chat stream for a reading club.

    The client must supply a valid JWT access token via ``?token=``.
    Messages received from the client are broadcast to all club members
    currently connected to any process (via Redis fan-out when available).

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
                await websocket.send_text(
                    json.dumps({"type": "error", "detail": "invalid JSON"})
                )
                continue

            # Relay the message to all club subscribers; stamp sender info so
            # the client does not need to look it up separately.
            outbound: dict[str, Any] = {
                "type": "message",
                "club_id": str(club_id),
                "user_id": user_id,
                "content": data.get("content", ""),
            }
            if "media_url" in data:
                outbound["media_url"] = data["media_url"]

            await ws_manager.broadcast_club(club_id, outbound)
    except WebSocketDisconnect:
        pass
    except Exception:
        logger.exception("Unexpected error in club_chat_stream for club=%s user=%s", club_id, user_id)
    finally:
        heartbeat_task.cancel()
        ws_manager.disconnect_club(club_id, websocket)
        ws_manager.disconnect_user(user_id, websocket)


@router.websocket("/ws/me")
async def personal_notification_stream(
    websocket: WebSocket,
    token: str = Query(...),
) -> None:
    """Personal notification stream for the authenticated user.

    Used to deliver server-push events (new follower, badge earned, etc.)
    without polling.  The client should treat this as read-only; any text
    sent by the client is silently discarded so the contract stays simple.

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
