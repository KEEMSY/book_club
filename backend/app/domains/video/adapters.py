"""External-provider adapters for the video domain (M68, M71).

Two implementations of ``AgoraTokenPort`` (CLAUDE.md §3.2):

- ``StubAgoraTokenAdapter`` — deterministic placeholder, no network/crypto. Used
  in dev/test and whenever the Agora credentials are unset.
- ``AgoraRtcTokenAdapter`` — signs an HMAC-SHA256 join token from the App ID and
  App Certificate (Fly.io secrets ``AGORA_APP_ID`` / ``AGORA_APP_CERTIFICATE``).
  Falls back to the stub format when either credential is missing so a
  half-configured environment degrades predictably rather than crashing.
"""

from __future__ import annotations

import base64
import hashlib
import hmac
import time
from dataclasses import dataclass


@dataclass(slots=True)
class StubAgoraTokenAdapter:
    """Returns a deterministic placeholder token, no network calls."""

    def generate_token(self, *, channel: str, uid: int, expiry_secs: int = 3600) -> str:
        return f"stub_token_{channel}_{uid}"


@dataclass(slots=True)
class AgoraRtcTokenAdapter:
    """Signs a join token from the Agora App ID + App Certificate.

    This is an HMAC-based token rather than the full AccessToken2 binary layout;
    it carries the channel, uid, and expiry under a certificate-keyed signature,
    which is enough for the backend to vouch for a join request without pulling
    in the Agora SDK. Swap for ``agora-token-builder`` if Agora's exact wire
    format becomes required.
    """

    app_id: str
    app_certificate: str

    def generate_token(self, *, channel: str, uid: int, expiry_secs: int = 3600) -> str:
        if not self.app_id or not self.app_certificate:
            return f"stub_token_{channel}_{uid}"
        expire_at = int(time.time()) + expiry_secs
        content = f"{self.app_id}:{channel}:{uid}:{expire_at}"
        sig = hmac.new(self.app_certificate.encode(), content.encode(), hashlib.sha256).hexdigest()
        return base64.b64encode(f"{self.app_id}:{sig}:{expire_at}".encode()).decode()
