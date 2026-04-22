"""Naver 책 검색 API adapter.

Calls ``GET https://openapi.naver.com/v1/search/book.json`` with the
``X-Naver-Client-Id`` / ``X-Naver-Client-Secret`` headers from Settings.
Each item is normalized into :class:`ExternalBook` and items lacking a
13-digit ISBN are filtered out — the catalog row is keyed on isbn13.

Known provider quirks we handle here so the service layer stays clean:
- ``title`` may contain ``<b>…</b>`` emphasis tags around the matched
  query. We strip them with a small regex helper.
- ``author`` comes pipe-delimited (``"A|B|C"``). We join with ``" · "``
  so the UI renders naturally.
- ``isbn`` is either a single 13-digit string or a ``"10자리 13자리"``
  space-separated pair. We always extract the 13-digit form; if neither
  slot contains 13 digits the item is dropped.
- ``description`` also sometimes contains ``<b>`` tags; same stripping.
"""

from __future__ import annotations

import logging
import re
from typing import Any

from app.core.config import get_settings
from app.core.exceptions import NaverBookError
from app.core.http.base_client import AsyncHttpClient
from app.domains.book.models import BookSource
from app.domains.book.ports import BookSearchResult, ExternalBook

logger = logging.getLogger(__name__)

_BOLD_TAG_RE = re.compile(r"</?b>", re.IGNORECASE)
_ISBN13_RE = re.compile(r"\b\d{13}\b")


def _strip_bold(text: str) -> str:
    """Remove Naver's ``<b>…</b>`` emphasis tags from a string."""
    return _BOLD_TAG_RE.sub("", text)


def _normalize_authors(raw: str) -> str:
    """Turn Naver's pipe-delimited author list into a human-friendly join."""
    parts = [p.strip() for p in raw.split("|") if p.strip()]
    return " · ".join(parts) if parts else raw.strip()


def _extract_isbn13(raw: str | None) -> str | None:
    """Return the 13-digit ISBN from a Naver ``isbn`` field, or None."""
    if not raw:
        return None
    match = _ISBN13_RE.search(raw)
    return match.group(0) if match else None


class NaverBookAdapter:
    """Implements :class:`app.domains.book.ports.BookSearchPort` for Naver."""

    def __init__(self, http_client: AsyncHttpClient | None = None) -> None:
        self._http = http_client or AsyncHttpClient(timeout=5.0, max_retries=2)
        self._owns_client = http_client is None

    async def aclose(self) -> None:
        if self._owns_client:
            await self._http.aclose()

    async def search(self, query: str, *, page: int = 1, size: int = 20) -> BookSearchResult:
        settings = get_settings()
        # Naver uses a 1-based ``start`` index rather than a page number.
        start = (page - 1) * size + 1
        params = {
            "query": query,
            "display": size,
            "start": start,
        }
        headers = {
            "X-Naver-Client-Id": settings.naver_client_id,
            "X-Naver-Client-Secret": settings.naver_client_secret,
        }

        response = await self._http.get(
            settings.naver_book_api_url,
            params=params,
            headers=headers,
        )
        if response.status_code in (401, 403):
            raise NaverBookError(
                f"naver search rejected auth: {response.status_code}",
                code="NAVER_BOOK_AUTH_FAILED",
            )
        if response.status_code >= 400:
            raise NaverBookError(
                f"naver search failed: {response.status_code}",
                code="NAVER_BOOK_REQUEST_FAILED",
            )

        body: dict[str, Any] = response.json()
        raw_items: list[dict[str, Any]] = body.get("items") or []
        total = int(body.get("total") or 0)

        items: list[ExternalBook] = []
        dropped = 0
        for raw in raw_items:
            isbn13 = _extract_isbn13(raw.get("isbn"))
            if isbn13 is None:
                dropped += 1
                continue

            title_raw = raw.get("title") or ""
            description_raw = raw.get("description") or ""
            author_raw = raw.get("author") or ""
            publisher_raw = raw.get("publisher")
            image_raw = raw.get("image")

            title = _strip_bold(title_raw).strip()
            description = _strip_bold(description_raw).strip() or None
            author = _normalize_authors(author_raw) or "알 수 없음"
            publisher = publisher_raw.strip() if isinstance(publisher_raw, str) else None
            cover_url = image_raw if isinstance(image_raw, str) and image_raw else None

            items.append(
                ExternalBook(
                    isbn13=isbn13,
                    title=title,
                    author=author,
                    publisher=publisher or None,
                    cover_url=cover_url,
                    description=description,
                    source=BookSource.NAVER,
                )
            )

        if dropped:
            logger.info(
                "naver_search dropped_items=%d reason=missing_isbn13 query=%s",
                dropped,
                query,
            )

        return BookSearchResult(items=items, total=total, page=page, size=size)
