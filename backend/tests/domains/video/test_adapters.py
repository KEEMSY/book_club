"""Contract tests for the Agora token adapters (CLAUDE.md §5).

The stub returns a deterministic placeholder; the real adapter signs an
HMAC token but degrades to the stub format when credentials are missing.
"""

from __future__ import annotations

import base64

from app.domains.video.adapters import AgoraRtcTokenAdapter, StubAgoraTokenAdapter


def test_stub_token_is_deterministic() -> None:
    adapter = StubAgoraTokenAdapter()
    token = adapter.generate_token(channel="club-abc", uid=42)
    assert token == "stub_token_club-abc_42"


def test_real_adapter_without_credentials_falls_back_to_stub() -> None:
    adapter = AgoraRtcTokenAdapter(app_id="", app_certificate="")
    assert adapter.generate_token(channel="club-abc", uid=42) == "stub_token_club-abc_42"


def test_real_adapter_signs_token_when_configured() -> None:
    adapter = AgoraRtcTokenAdapter(app_id="app123", app_certificate="cert-secret")
    token = adapter.generate_token(channel="club-abc", uid=42, expiry_secs=600)

    # Decodes to "<app_id>:<sig>:<expiry>" and is not the stub placeholder.
    decoded = base64.b64decode(token).decode()
    app_id, sig, expiry = decoded.split(":")
    assert app_id == "app123"
    assert len(sig) == 64  # hex SHA256
    assert int(expiry) > 0
