"""Composite book search adapter — Naver first, Kakao fallback.

Implements :class:`app.domains.book.ports.BookSearchPort`. This is the shape
the service layer actually depends on; the individual provider adapters stay
behind this facade.

Fallback contract:
- Primary: Naver. If it returns a populated result (``items != []``), that
  result is returned verbatim.
- Fallback triggers:
  1. Naver raises :class:`ExternalServiceError` (auth, quota, 5xx after
     retries, timeout) → Kakao is called.
  2. Naver returns an empty page (``items == []``) → Kakao is called.
  The empty-page case matters because a new book may only be indexed by
  one provider at any given moment.
- If Kakao also fails, the Kakao exception bubbles — the service layer sees
  an ExternalServiceError subclass and the router converts it to HTTP 502.
- The selected provider is logged structurally (``book_search_provider=<n>``)
  for post-hoc debugging of quota / latency incidents.
"""

from __future__ import annotations

import logging

from app.core.exceptions import ExternalServiceError
from app.domains.book.ports import BookSearchPort, BookSearchResult

logger = logging.getLogger(__name__)


class CompositeBookSearchAdapter:
    """Wraps two BookSearchPort implementations with naver-first fallback."""

    def __init__(self, primary: BookSearchPort, fallback: BookSearchPort) -> None:
        self._primary = primary
        self._fallback = fallback

    async def search(self, query: str, *, page: int = 1, size: int = 20) -> BookSearchResult:
        try:
            primary_result = await self._primary.search(query, page=page, size=size)
        except ExternalServiceError as exc:
            logger.warning(
                "book_search primary_failed fallback=kakao code=%s query=%s",
                exc.code,
                query,
            )
            fallback_result = await self._fallback.search(query, page=page, size=size)
            logger.info(
                "book_search provider=kakao_fallback items=%d total=%d",
                len(fallback_result.items),
                fallback_result.total,
            )
            return fallback_result

        if primary_result.items:
            logger.info(
                "book_search provider=naver items=%d total=%d",
                len(primary_result.items),
                primary_result.total,
            )
            return primary_result

        # Primary succeeded but produced no usable rows — try the fallback.
        # A Naver 200 with 0 items is common when the search term is niche or
        # newly published; Kakao occasionally has it.
        logger.info(
            "book_search primary_empty fallback=kakao query=%s",
            query,
        )
        fallback_result = await self._fallback.search(query, page=page, size=size)
        logger.info(
            "book_search provider=kakao_fallback items=%d total=%d",
            len(fallback_result.items),
            fallback_result.total,
        )
        return fallback_result
