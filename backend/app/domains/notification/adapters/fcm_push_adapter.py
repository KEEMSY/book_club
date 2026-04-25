"""FCM HTTP v1 push adapter.

Real FCM integration requires Firebase service-account credentials
(``FIREBASE_CREDENTIALS_JSON`` env var). M6 will wire the actual HTTP v1
call; for now the adapter is a skeleton that warns when invoked so the
missing credential surfaces clearly in logs rather than silently doing nothing.
"""

from __future__ import annotations

import logging

logger = logging.getLogger(__name__)


class FcmPushAdapter:
    """FCM v1 HTTP API adapter.

    Requires ``FIREBASE_CREDENTIALS_JSON`` and ``FIREBASE_PROJECT_ID`` env
    vars. M6 implements the actual ``projects/{id}/messages:send`` POST using
    an OAuth2 service-account token obtained via httpx.
    """

    def __init__(self, credentials_json: str, project_id: str) -> None:
        self._credentials_json = credentials_json
        self._project_id = project_id

    async def send_to_tokens(
        self,
        tokens: list[str],
        title: str,
        body: str,
        data: dict[str, str],
    ) -> None:
        # TODO(m6/push): implement FCM HTTP v1 multicast via httpx +
        # service-account OAuth2. Context: M5 scaffolds the adapter;
        # real credentials land in M6.
        logger.warning("FCM not yet implemented — would send to %d tokens", len(tokens))
