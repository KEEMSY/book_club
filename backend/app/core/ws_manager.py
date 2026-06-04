"""Process-wide WebSocket connection manager with optional Redis fan-out.

Architecture:
- Local state: ``_club_sockets`` and ``_user_sockets`` hold live WebSocket
  objects for connections handled by *this* process.
- Redis pub/sub: when Redis is available, ``broadcast_club`` also publishes to
  a per-club channel so that horizontally-scaled processes relay the message
  to their own local subscribers.  The background listener task is started
  lazily on first publish attempt.

Usage::

    from app.core.ws_manager import ws_manager

    await ws_manager.broadcast_club(club_id, {"type": "message", ...})
    await ws_manager.send_user(user_id, {"type": "notification", ...})
"""

from __future__ import annotations

import asyncio
import json
import logging
from collections import defaultdict
from typing import Any
from uuid import UUID

from fastapi import WebSocket

logger = logging.getLogger(__name__)

# Redis channel prefixes — keep in sync with any consumer scripts.
_CLUB_CHANNEL_PREFIX = "ws:club:"
_USER_CHANNEL_PREFIX = "ws:user:"


class ConnectionManager:
    """Manages active WebSocket connections and cross-process fan-out.

    Two indexes are maintained simultaneously so a single WebSocket
    can be looked up by either club or user without scanning the other
    structure.
    """

    def __init__(self) -> None:
        # club_id (str) → set of active WebSocket connections in this process.
        self._club_sockets: dict[str, set[WebSocket]] = defaultdict(set)
        # user_id (str) → set of active WebSocket connections in this process.
        self._user_sockets: dict[str, set[WebSocket]] = defaultdict(set)
        # Background task handle for the Redis pub/sub relay loop.
        self._relay_task: asyncio.Task[None] | None = None

    # ------------------------------------------------------------------
    # Connection lifecycle
    # ------------------------------------------------------------------

    def connect_club(self, club_id: UUID | str, websocket: WebSocket) -> None:
        """Register *websocket* as a subscriber for *club_id*."""
        self._club_sockets[str(club_id)].add(websocket)

    def connect_user(self, user_id: UUID | str, websocket: WebSocket) -> None:
        """Register *websocket* as the personal stream for *user_id*."""
        self._user_sockets[str(user_id)].add(websocket)

    def disconnect_club(self, club_id: UUID | str, websocket: WebSocket) -> None:
        """Remove *websocket* from the *club_id* subscriber set."""
        key = str(club_id)
        self._club_sockets[key].discard(websocket)
        if not self._club_sockets[key]:
            del self._club_sockets[key]

    def disconnect_user(self, user_id: UUID | str, websocket: WebSocket) -> None:
        """Remove *websocket* from the *user_id* personal stream set."""
        key = str(user_id)
        self._user_sockets[key].discard(websocket)
        if not self._user_sockets[key]:
            del self._user_sockets[key]

    # ------------------------------------------------------------------
    # Fan-out helpers
    # ------------------------------------------------------------------

    async def broadcast_club(
        self,
        club_id: UUID | str,
        message: dict[str, Any],
    ) -> None:
        """Send *message* to all club members connected in this process.

        Also publishes to the Redis channel so peer processes relay the
        message to their own local subscribers.
        """
        payload = json.dumps(message, default=str)
        await self._broadcast_local_club(str(club_id), payload)
        await self._redis_publish(_CLUB_CHANNEL_PREFIX + str(club_id), payload)

    async def send_user(
        self,
        user_id: UUID | str,
        message: dict[str, Any],
    ) -> None:
        """Push *message* to all personal-stream connections for *user_id*.

        Also publishes to Redis so peer processes reach users connected
        to other workers.
        """
        payload = json.dumps(message, default=str)
        await self._send_local_user(str(user_id), payload)
        await self._redis_publish(_USER_CHANNEL_PREFIX + str(user_id), payload)

    # ------------------------------------------------------------------
    # Local delivery
    # ------------------------------------------------------------------

    async def _broadcast_local_club(self, club_id: str, payload: str) -> None:
        sockets = list(self._club_sockets.get(club_id, set()))
        dead: list[WebSocket] = []
        for ws in sockets:
            try:
                await ws.send_text(payload)
            except Exception:
                dead.append(ws)
        for ws in dead:
            self._club_sockets[club_id].discard(ws)

    async def _send_local_user(self, user_id: str, payload: str) -> None:
        sockets = list(self._user_sockets.get(user_id, set()))
        dead: list[WebSocket] = []
        for ws in sockets:
            try:
                await ws.send_text(payload)
            except Exception:
                dead.append(ws)
        for ws in dead:
            self._user_sockets[user_id].discard(ws)

    # ------------------------------------------------------------------
    # Redis pub/sub relay
    # ------------------------------------------------------------------

    async def _redis_publish(self, channel: str, payload: str) -> None:
        """Publish *payload* to *channel*; silently skip if Redis unavailable."""
        try:
            from app.core.cache import get_redis  # local import avoids circular deps

            redis = get_redis()
            await redis.publish(channel, payload)
            # Start relay listener on first successful publish.
            if self._relay_task is None or self._relay_task.done():
                self._relay_task = asyncio.create_task(self._redis_relay_loop())
        except Exception as exc:
            # Redis unavailability must not crash the WS handler — single-node
            # deployments run without Redis and rely on local fan-out alone.
            logger.debug("Redis publish skipped: %s", exc)

    async def _redis_relay_loop(self) -> None:
        """Subscribe to all club/user channels and relay inbound messages.

        This loop runs for the lifetime of the process.  Messages published
        by *other* processes are relayed to local WebSocket subscribers so
        every connected client sees them regardless of which worker owns the
        connection.
        """
        try:
            from app.core.cache import get_redis

            redis = get_redis()
            pubsub = redis.pubsub()
            await pubsub.psubscribe(
                _CLUB_CHANNEL_PREFIX + "*",
                _USER_CHANNEL_PREFIX + "*",
            )
            async for raw in pubsub.listen():
                if raw["type"] != "pmessage":
                    continue
                channel: str = raw["channel"]
                data: str = raw["data"]
                if channel.startswith(_CLUB_CHANNEL_PREFIX):
                    club_id = channel[len(_CLUB_CHANNEL_PREFIX):]
                    await self._broadcast_local_club(club_id, data)
                elif channel.startswith(_USER_CHANNEL_PREFIX):
                    user_id = channel[len(_USER_CHANNEL_PREFIX):]
                    await self._send_local_user(user_id, data)
        except Exception as exc:
            logger.warning("Redis relay loop terminated: %s", exc)


# Process-wide singleton — import this directly in routers and services.
ws_manager = ConnectionManager()
