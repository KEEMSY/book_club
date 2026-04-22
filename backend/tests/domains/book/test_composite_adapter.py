"""Unit tests for CompositeBookSearchAdapter (naver-first, kakao-fallback).

No HTTP calls — the two inner ``BookSearchPort`` implementations are
replaced by in-memory stubs so we can drive every fallback branch
deterministically:

1. Naver success with items → Kakao never called.
2. Naver raises ExternalServiceError → Kakao is called and returned.
3. Naver returns empty items → Kakao is called and returned.
4. Naver fails AND Kakao fails → second exception bubbles.
"""

from __future__ import annotations

from dataclasses import dataclass, field

import pytest
from app.core.exceptions import ExternalServiceError, KakaoBookError, NaverBookError
from app.domains.book.adapters.composite_book_search_adapter import (
    CompositeBookSearchAdapter,
)
from app.domains.book.models import BookSource
from app.domains.book.ports import BookSearchResult, ExternalBook


@dataclass
class StubSearch:
    """Either returns a prebuilt result or raises a prebuilt error."""

    result: BookSearchResult | None = None
    error: Exception | None = None
    calls: list[tuple[str, int, int]] = field(default_factory=list)

    async def search(self, query: str, *, page: int = 1, size: int = 20) -> BookSearchResult:
        self.calls.append((query, page, size))
        if self.error is not None:
            raise self.error
        assert self.result is not None
        return self.result


def _sample_result(*, source: BookSource, isbn13: str) -> BookSearchResult:
    return BookSearchResult(
        items=[
            ExternalBook(
                isbn13=isbn13,
                title="t",
                author="a",
                publisher=None,
                cover_url=None,
                description=None,
                source=source,
            )
        ],
        total=1,
        page=1,
        size=20,
    )


@pytest.mark.asyncio
async def test_naver_success_kakao_not_called() -> None:
    naver = StubSearch(result=_sample_result(source=BookSource.NAVER, isbn13="9788937460777"))
    kakao = StubSearch(result=_sample_result(source=BookSource.KAKAO, isbn13="0000000000000"))
    composite = CompositeBookSearchAdapter(primary=naver, fallback=kakao)

    result = await composite.search("query")

    assert result.items[0].source is BookSource.NAVER
    assert result.items[0].isbn13 == "9788937460777"
    assert naver.calls == [("query", 1, 20)]
    assert kakao.calls == []


@pytest.mark.asyncio
async def test_naver_external_error_falls_back_to_kakao() -> None:
    naver = StubSearch(error=NaverBookError("naver 500", code="NAVER_BOOK_REQUEST_FAILED"))
    kakao = StubSearch(result=_sample_result(source=BookSource.KAKAO, isbn13="9788937460555"))
    composite = CompositeBookSearchAdapter(primary=naver, fallback=kakao)

    result = await composite.search("query", page=2, size=10)

    assert result.items[0].source is BookSource.KAKAO
    assert kakao.calls == [("query", 2, 10)]


@pytest.mark.asyncio
async def test_naver_empty_falls_back_to_kakao() -> None:
    empty = BookSearchResult(items=[], total=0, page=1, size=20)
    naver = StubSearch(result=empty)
    kakao = StubSearch(result=_sample_result(source=BookSource.KAKAO, isbn13="9788937460555"))
    composite = CompositeBookSearchAdapter(primary=naver, fallback=kakao)

    result = await composite.search("희귀한검색어")

    assert len(result.items) == 1
    assert result.items[0].source is BookSource.KAKAO
    assert kakao.calls == [("희귀한검색어", 1, 20)]


@pytest.mark.asyncio
async def test_both_providers_fail_raises_fallback_error() -> None:
    naver = StubSearch(error=NaverBookError("n fail", code="NAVER_BOOK_REQUEST_FAILED"))
    kakao = StubSearch(error=KakaoBookError("k fail", code="KAKAO_BOOK_REQUEST_FAILED"))
    composite = CompositeBookSearchAdapter(primary=naver, fallback=kakao)

    with pytest.raises(ExternalServiceError) as exc_info:
        await composite.search("query")

    assert exc_info.value.code == "KAKAO_BOOK_REQUEST_FAILED"
