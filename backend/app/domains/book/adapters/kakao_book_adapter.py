"""Kakao 책 검색 API adapter.

Calls ``GET https://dapi.kakao.com/v3/search/book`` with
``Authorization: KakaoAK {KAKAO_REST_API_KEY}``. Mirrors the Naver adapter's
filtering rules — any document missing a 13-digit ISBN is dropped.

Known provider quirks we handle here:
- ``isbn`` is a string like ``"8937460777 9788937460777"`` (10 + 13) or
  just ``"9788937460777"``. We always extract the 13-digit form.
- ``authors`` is already a list[str], which we join with ``" · "``.
- ``meta.total_count`` is the total; ``documents`` holds the page items.
"""

from __future__ import annotations

import logging
from typing import Any

from app.core.config import get_settings
from app.core.exceptions import KakaoBookError
from app.core.http.base_client import AsyncHttpClient
from app.domains.book.adapters.naver_book_adapter import _extract_isbn13
from app.domains.book.models import BookSource
from app.domains.book.ports import BookSearchResult, ExternalBook

logger = logging.getLogger(__name__)


class KakaoBookAdapter:
    """Implements :class:`app.domains.book.ports.BookSearchPort` for Kakao."""

    def __init__(self, http_client: AsyncHttpClient | None = None) -> None:
        self._http = http_client or AsyncHttpClient(timeout=5.0, max_retries=2)
        self._owns_client = http_client is None

    async def aclose(self) -> None:
        if self._owns_client:
            await self._http.aclose()

    async def search(self, query: str, *, page: int = 1, size: int = 20) -> BookSearchResult:
        settings = get_settings()
        params = {
            "query": query,
            "page": page,
            "size": size,
        }
        headers = {
            "Authorization": f"KakaoAK {settings.kakao_rest_api_key}",
        }

        response = await self._http.get(
            settings.kakao_book_api_url,
            params=params,
            headers=headers,
        )
        if response.status_code in (401, 403):
            raise KakaoBookError(
                f"kakao search rejected auth: {response.status_code}",
                code="KAKAO_BOOK_AUTH_FAILED",
            )
        if response.status_code >= 400:
            raise KakaoBookError(
                f"kakao search failed: {response.status_code}",
                code="KAKAO_BOOK_REQUEST_FAILED",
            )

        body: dict[str, Any] = response.json()
        meta: dict[str, Any] = body.get("meta") or {}
        raw_docs: list[dict[str, Any]] = body.get("documents") or []
        total = int(meta.get("total_count") or 0)

        items: list[ExternalBook] = []
        dropped = 0
        for raw in raw_docs:
            isbn13 = _extract_isbn13(raw.get("isbn"))
            if isbn13 is None:
                dropped += 1
                continue

            title_raw = raw.get("title")
            title = title_raw.strip() if isinstance(title_raw, str) else ""

            authors_raw = raw.get("authors")
            if isinstance(authors_raw, list) and authors_raw:
                author = " · ".join(str(a).strip() for a in authors_raw if str(a).strip())
            else:
                author = "알 수 없음"

            publisher_raw = raw.get("publisher")
            publisher = (
                publisher_raw.strip() if isinstance(publisher_raw, str) and publisher_raw else None
            )

            thumbnail_raw = raw.get("thumbnail")
            cover_url = thumbnail_raw if isinstance(thumbnail_raw, str) and thumbnail_raw else None

            contents_raw = raw.get("contents")
            description = (
                contents_raw.strip()
                if isinstance(contents_raw, str) and contents_raw.strip()
                else None
            )

            items.append(
                ExternalBook(
                    isbn13=isbn13,
                    title=title,
                    author=author,
                    publisher=publisher,
                    cover_url=cover_url,
                    description=description,
                    source=BookSource.KAKAO,
                )
            )

        if dropped:
            logger.info(
                "kakao_search dropped_items=%d reason=missing_isbn13 query=%s",
                dropped,
                query,
            )

        return BookSearchResult(items=items, total=total, page=page, size=size)
