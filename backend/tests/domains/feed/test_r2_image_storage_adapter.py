"""Contract tests for the R2 image storage adapter.

We stub the underlying ``R2Client`` so this test never touches the
network. Verifies:
- presign_upload forwards the key, expires_in, and content_type to
  R2Client.presign_put and returns a PresignedUpload with the
  Content-Type header set to the validated MIME.
- public_url uses presign_get under the hood.
"""

from __future__ import annotations

import pytest
from app.domains.feed.adapters.r2_image_storage_adapter import R2ImageStorageAdapter


class StubR2Client:
    def __init__(self) -> None:
        self.put_calls: list[tuple[str, int, str | None]] = []
        self.get_calls: list[tuple[str, int]] = []

    def presign_put(self, key: str, expires_in: int = 300, content_type: str | None = None) -> str:
        self.put_calls.append((key, expires_in, content_type))
        return f"https://r2.example.com/PUT/{key}?ct={content_type}"

    def presign_get(self, key: str, expires_in: int = 300) -> str:
        self.get_calls.append((key, expires_in))
        return f"https://r2.example.com/GET/{key}"


@pytest.mark.asyncio
async def test_presign_upload_forwards_args_and_attaches_content_type_header() -> None:
    stub = StubR2Client()
    # Stub presents only the surface the adapter touches; mypy can't prove it
    # is structurally compatible with the concrete R2Client.
    adapter = R2ImageStorageAdapter(client=stub)  # type: ignore[arg-type]

    presigned = await adapter.presign_upload(
        "feed/abc/x.jpg",
        content_type="image/jpeg",
        expires_in=900,
    )

    assert stub.put_calls == [("feed/abc/x.jpg", 900, "image/jpeg")]
    assert presigned.key == "feed/abc/x.jpg"
    assert presigned.url.startswith("https://r2.example.com/PUT/feed/abc/x.jpg")
    assert presigned.headers == {"Content-Type": "image/jpeg"}
    assert presigned.expires_in == 900


@pytest.mark.asyncio
async def test_public_url_uses_presign_get() -> None:
    stub = StubR2Client()
    adapter = R2ImageStorageAdapter(client=stub)  # type: ignore[arg-type]

    url = await adapter.public_url("feed/abc/x.jpg")

    assert url == "https://r2.example.com/GET/feed/abc/x.jpg"
    assert stub.get_calls == [("feed/abc/x.jpg", 600)]


@pytest.mark.asyncio
async def test_presign_upload_default_expires_in_is_600() -> None:
    stub = StubR2Client()
    adapter = R2ImageStorageAdapter(client=stub)  # type: ignore[arg-type]

    presigned = await adapter.presign_upload(
        "feed/abc/x.png",
        content_type="image/png",
    )

    assert presigned.expires_in == 600
    assert stub.put_calls[0][1] == 600
