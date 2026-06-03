"""FCM HTTP v1 push adapter.

Real FCM integration uses Firebase service-account credentials
(``FIREBASE_CREDENTIALS_JSON`` env var) to obtain an OAuth2 Bearer token
and calls the FCM v1 ``projects/{id}/messages:send`` endpoint via httpx.
"""

from __future__ import annotations

import json
import logging
import time

import httpx
from google.auth.transport.requests import Request as GoogleRequest  # type: ignore[import-not-found]
from google.oauth2 import service_account  # type: ignore[import-not-found]

logger = logging.getLogger(__name__)

FCM_SCOPES = ["https://www.googleapis.com/auth/firebase.messaging"]
_TOKEN_TTL = 3600  # seconds — service-account tokens are valid for 1 hour
_TOKEN_REFRESH_MARGIN = 300  # refresh when fewer than 5 minutes remain


class FcmPushAdapter:
    """FCM HTTP v1 API adapter backed by a service-account credential.

    Token refresh happens synchronously (google-auth uses ``requests`` under
    the hood) but is cheap enough that it only occurs once per hour. All
    actual FCM calls are async via httpx.

    Args:
        credentials_json: JSON string of the Firebase service-account key file.
        project_id: Firebase project ID (e.g. ``my-app-12345``).
    """

    def __init__(self, credentials_json: str, project_id: str) -> None:
        self._project_id = project_id
        self._creds: service_account.Credentials = (
            service_account.Credentials.from_service_account_info(
                json.loads(credentials_json), scopes=FCM_SCOPES
            )
        )
        self._token_expires_at: float = 0.0

    # ------------------------------------------------------------------
    # Internal helpers
    # ------------------------------------------------------------------

    def _get_token(self) -> str:
        """Return a valid Bearer token, refreshing if close to expiry."""
        if time.time() >= self._token_expires_at - _TOKEN_REFRESH_MARGIN:
            self._creds.refresh(GoogleRequest())
            self._token_expires_at = time.time() + _TOKEN_TTL
        return self._creds.token  # type: ignore[no-any-return]

    # ------------------------------------------------------------------
    # Public interface
    # ------------------------------------------------------------------

    async def send_to_tokens(
        self,
        tokens: list[str],
        title: str,
        body: str,
        data: dict[str, str],
    ) -> None:
        """Send a notification to each device token individually.

        FCM HTTP v1 does not support true multicast; each token gets a
        separate POST. Failed sends are counted and logged as warnings so
        callers do not need to handle partial failures themselves.
        """
        if not tokens:
            return

        bearer = self._get_token()
        url = f"https://fcm.googleapis.com/v1/projects/{self._project_id}/messages:send"
        headers = {
            "Authorization": f"Bearer {bearer}",
            "Content-Type": "application/json",
        }
        failures = 0

        async with httpx.AsyncClient(timeout=10) as client:
            for device_token in tokens:
                payload = {
                    "message": {
                        "token": device_token,
                        "notification": {"title": title, "body": body},
                        "data": data,
                    }
                }
                resp = await client.post(url, json=payload, headers=headers)
                if resp.status_code != 200:
                    failures += 1
                    logger.warning(
                        "FCM send failed for token (status=%d): %s",
                        resp.status_code,
                        resp.text[:200],
                    )

        if failures:
            logger.warning("FCM: %d/%d sends failed", failures, len(tokens))
