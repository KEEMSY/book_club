"""R2 / MinIO image storage adapter — implements ``ImageStoragePort``.

Service consumes the port; this file is the only place ``R2Client`` is
imported within the feed domain (CLAUDE.md §3.2).

Two design choices worth documenting:
- ``presign_upload`` requires the client to echo Content-Type on PUT.
  We bind the presigned URL to the content type the service validated
  (one of image/jpeg, image/png, image/webp) so a malicious client
  cannot upload an arbitrary blob to the same key.
- ``public_url`` returns a short-lived signed GET (presign_get) rather
  than a CDN URL. Reasoning: M4 starts on MinIO/local and Cloudflare R2
  buckets default to private. Public hosting is a deploy-time concern
  (custom domain + public access policy) that we do not pin in code.
  Mobile re-fetches the URL on each list, refresh comes for free.
"""

from __future__ import annotations

import asyncio

from app.core.storage import R2Client
from app.domains.feed.ports import PresignedUpload


class R2ImageStorageAdapter:
    """Implements ``ImageStoragePort`` over the project's R2Client."""

    # boto3's generate_presigned_url is sync; we offload to a thread so the
    # async router/service stays cooperative under load.
    def __init__(self, client: R2Client | None = None) -> None:
        self._client = client or R2Client()

    async def presign_upload(
        self,
        key: str,
        *,
        content_type: str,
        expires_in: int = 600,
    ) -> PresignedUpload:
        url = await asyncio.to_thread(
            self._client.presign_put,
            key,
            expires_in,
            content_type,
        )
        return PresignedUpload(
            url=url,
            key=key,
            headers={"Content-Type": content_type},
            expires_in=expires_in,
        )

    async def public_url(self, key: str) -> str:
        # Short-lived signed GET — see module docstring for rationale.
        return await asyncio.to_thread(self._client.presign_get, key, 600)
