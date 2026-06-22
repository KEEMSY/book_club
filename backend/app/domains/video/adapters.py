"""External-provider adapters for the video domain (M68).

The MVP ships a stub Agora token builder. When the real Agora integration
lands, a builder that signs a proper RTC token replaces ``StubAgoraTokenAdapter``
behind ``AgoraTokenPort`` with no service change (CLAUDE.md §3.2).

TODO(video): replace with agora-token-builder once the Agora app cert is
provisioned in Fly.io secrets. — owner: backend
"""

from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID


@dataclass(slots=True)
class StubAgoraTokenAdapter:
    """Returns a deterministic placeholder token, no network calls."""

    def issue_token(self, *, club_id: UUID, session_id: UUID, channel: str) -> str:
        return f"STUB_{club_id}_{session_id}"
