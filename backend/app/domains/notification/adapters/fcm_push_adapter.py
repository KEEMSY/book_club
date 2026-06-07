"""FCM HTTP v1 push adapter.

Real FCM integration uses Firebase service-account credentials
(``FIREBASE_CREDENTIALS_JSON`` env var) to obtain an OAuth2 Bearer token
and calls the FCM v1 ``projects/{id}/messages:send`` endpoint via httpx.
"""

from __future__ import annotations

import asyncio
import json
import logging
import time

import httpx
from google.auth.transport.requests import Request as GoogleRequest
from google.oauth2 import service_account

logger = logging.getLogger(__name__)

FCM_SCOPES = ["https://www.googleapis.com/auth/firebase.messaging"]
_TOKEN_TTL = 3600  # seconds — service-account tokens are valid for 1 hour
_TOKEN_REFRESH_MARGIN = 300  # refresh when fewer than 5 minutes remain
_BATCH_SIZE = 100  # max concurrent requests per asyncio.gather call


class FcmPushAdapter:
    """FCM HTTP v1 API adapter backed by a service-account credential.

    Token refresh happens synchronously (google-auth uses ``requests`` under
    the hood) but is cheap enough that it only occurs once per hour. All
    actual FCM calls are async via httpx.

    Sends up to ``_BATCH_SIZE`` requests concurrently using
    ``asyncio.gather`` so large recipient lists are dispatched in parallel
    instead of sequentially. FCM HTTP v1 does not expose a true multicast
    endpoint, so individual POSTs are unavoidable, but parallelising them
    keeps end-to-end latency proportional to the slowest single request
    rather than the sum of all requests.

    Args:
        credentials_json: JSON string of the Firebase service-account key file.
        project_id: Firebase project ID (e.g. ``my-app-12345``).
    """

    def __init__(self, credentials_json: str, project_id: str) -> None:
        self._project_id = project_id
        self._creds: service_account.Credentials = (
            service_account.Credentials.from_service_account_info(  # type: ignore[no-untyped-call]
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
            self._creds.refresh(GoogleRequest())  # type: ignore[no-untyped-call]
            self._token_expires_at = time.time() + _TOKEN_TTL
        token: str = self._creds.token or ""
        return token

    async def _send_one(
        self,
        client: httpx.AsyncClient,
        url: str,
        headers: dict[str, str],
        device_token: str,
        title: str,
        body: str,
        data: dict[str, str],
    ) -> bool:
        """POST a single FCM message; return True on success."""
        payload = {
            "message": {
                "token": device_token,
                "notification": {"title": title, "body": body},
                "data": data,
            }
        }
        try:
            resp = await client.post(url, json=payload, headers=headers)
        except Exception as exc:
            logger.warning("FCM send exception for token: %s", exc)
            return False
        if resp.status_code != 200:
            logger.warning(
                "FCM send failed for token (status=%d): %s",
                resp.status_code,
                resp.text[:200],
            )
            return False
        return True

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
        """Send a notification to each device token.

        Tokens are dispatched in batches of up to ``_BATCH_SIZE`` concurrent
        requests using ``asyncio.gather``. This keeps latency low for large
        recipient sets while avoiding unbounded connection fan-out.
        Failed sends are counted and logged; partial failures do not raise so
        the caller's transaction is not rolled back.
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
            # Process tokens in fixed-size batches to cap peak concurrency.
            for batch_start in range(0, len(tokens), _BATCH_SIZE):
                batch = tokens[batch_start : batch_start + _BATCH_SIZE]
                results = await asyncio.gather(
                    *(self._send_one(client, url, headers, t, title, body, data) for t in batch),
                    return_exceptions=True,
                )
                for result in results:
                    if result is True:
                        continue
                    failures += 1
                    if isinstance(result, BaseException):
                        logger.warning("FCM gather exception: %s", result)

        if failures:
            logger.warning("FCM: %d/%d sends failed", failures, len(tokens))
