"""Thin httpx.AsyncClient wrapper: timeouts, retries, structured logging.

External adapters (Kakao / Naver / Apple / FCM) subclass or wrap this to share
a single retry + redaction policy. 5xx responses and network errors are
retried with exponential backoff (tenacity). 4xx is returned verbatim so the
adapter can map to a domain exception.
"""

from __future__ import annotations

import logging
from collections.abc import Mapping
from types import TracebackType
from typing import Any, Self

import httpx
from tenacity import (
    AsyncRetrying,
    retry_if_exception_type,
    stop_after_attempt,
    wait_exponential,
)

from app.core.exceptions import ExternalServiceError

logger = logging.getLogger(__name__)

_REDACTED_HEADERS = {"authorization", "x-naver-client-secret", "cookie", "set-cookie"}


def _redact_headers(headers: Mapping[str, str]) -> dict[str, str]:
    return {
        key: ("<redacted>" if key.lower() in _REDACTED_HEADERS else value)
        for key, value in headers.items()
    }


class _RetryableStatusError(Exception):
    """Internal marker to drive tenacity retry on 5xx responses."""

    def __init__(self, response: httpx.Response) -> None:
        super().__init__(f"retryable status {response.status_code}")
        self.response = response


class AsyncHttpClient:
    """httpx.AsyncClient wrapper with bounded retries and structured logging."""

    def __init__(
        self,
        *,
        base_url: str = "",
        timeout: float = 5.0,
        max_retries: int = 2,
        headers: Mapping[str, str] | None = None,
        transport: httpx.AsyncBaseTransport | None = None,
    ) -> None:
        self._max_retries = max_retries
        self._client = httpx.AsyncClient(
            base_url=base_url,
            timeout=timeout,
            headers=dict(headers) if headers else None,
            transport=transport,
        )

    async def __aenter__(self) -> Self:
        return self

    async def __aexit__(
        self,
        exc_type: type[BaseException] | None,
        exc: BaseException | None,
        tb: TracebackType | None,
    ) -> None:
        await self._client.aclose()

    async def aclose(self) -> None:
        await self._client.aclose()

    async def request(self, method: str, url: str, **kwargs: Any) -> httpx.Response:
        retryer = AsyncRetrying(
            stop=stop_after_attempt(self._max_retries + 1),
            wait=wait_exponential(multiplier=0.1, min=0.1, max=2.0),
            retry=retry_if_exception_type(
                (_RetryableStatusError, httpx.TransportError, httpx.TimeoutException)
            ),
            reraise=True,
        )

        try:
            async for attempt in retryer:
                with attempt:
                    response = await self._client.request(method, url, **kwargs)
                    logger.info(
                        "http_request method=%s url=%s status=%s headers=%s",
                        method,
                        url,
                        response.status_code,
                        _redact_headers(response.request.headers),
                    )
                    if 500 <= response.status_code < 600:
                        raise _RetryableStatusError(response)
                    return response
        except _RetryableStatusError as exc:
            logger.error(
                "http_retry_exhausted method=%s url=%s status=%s",
                method,
                url,
                exc.response.status_code,
            )
            raise ExternalServiceError(
                f"{method} {url} failed with status {exc.response.status_code}",
                code="UPSTREAM_5XX",
            ) from exc
        except httpx.TimeoutException as exc:
            logger.error("http_timeout method=%s url=%s", method, url)
            raise ExternalServiceError(
                f"{method} {url} timed out", code="UPSTREAM_TIMEOUT"
            ) from exc
        except httpx.TransportError as exc:
            logger.error("http_transport_error method=%s url=%s error=%s", method, url, exc)
            raise ExternalServiceError(
                f"{method} {url} transport error: {exc}", code="UPSTREAM_TRANSPORT"
            ) from exc

        # Unreachable: tenacity either returns via attempt or raises.
        raise ExternalServiceError(
            f"{method} {url} failed without a response", code="UPSTREAM_UNKNOWN"
        )

    async def get(self, url: str, **kwargs: Any) -> httpx.Response:
        return await self.request("GET", url, **kwargs)

    async def post(self, url: str, **kwargs: Any) -> httpx.Response:
        return await self.request("POST", url, **kwargs)
