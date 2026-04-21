"""S3-compatible client targeting Cloudflare R2 (or local MinIO).

Exposes the minimal surface needed by the Feed and Auth domains:
- put_object            → direct server-side upload
- presign_put / presign_get → client-side upload or download URLs
- delete                → cleanup

boto3 is synchronous; call these from a thread executor if needed from async
code paths. We keep the wrapper intentionally thin to stay testable with
`moto` or LocalStack in later milestones.
"""

from __future__ import annotations

from typing import Any

import boto3
from botocore.client import Config

from app.core.config import Settings, get_settings


class R2Client:
    """Lightweight wrapper over boto3's S3 client with an R2 endpoint."""

    def __init__(self, settings: Settings | None = None) -> None:
        self._settings = settings or get_settings()
        self._client = boto3.client(
            "s3",
            endpoint_url=self._settings.s3_endpoint_url,
            aws_access_key_id=self._settings.s3_access_key,
            aws_secret_access_key=self._settings.s3_secret_key,
            region_name=self._settings.s3_region,
            # R2 / MinIO require signature v4; addressing_style=path works for both.
            config=Config(signature_version="s3v4", s3={"addressing_style": "path"}),
        )
        self._bucket = self._settings.s3_bucket

    def put_object(self, key: str, body: bytes, content_type: str) -> None:
        self._client.put_object(
            Bucket=self._bucket,
            Key=key,
            Body=body,
            ContentType=content_type,
        )

    def presign_put(self, key: str, expires_in: int = 300, content_type: str | None = None) -> str:
        params: dict[str, Any] = {"Bucket": self._bucket, "Key": key}
        if content_type is not None:
            params["ContentType"] = content_type
        url = self._client.generate_presigned_url(
            "put_object",
            Params=params,
            ExpiresIn=expires_in,
        )
        return str(url)

    def presign_get(self, key: str, expires_in: int = 300) -> str:
        url = self._client.generate_presigned_url(
            "get_object",
            Params={"Bucket": self._bucket, "Key": key},
            ExpiresIn=expires_in,
        )
        return str(url)

    def delete(self, key: str) -> None:
        self._client.delete_object(Bucket=self._bucket, Key=key)
