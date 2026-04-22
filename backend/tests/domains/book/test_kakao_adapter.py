"""Contract tests for the Kakao book search adapter.

Uses ``respx`` to stub the Kakao book endpoint with fixtures under
``tests/fixtures/kakao_book/``. Verifies:
- ``authors`` list flattened with ``" · "``
- items without a 13-digit ISBN are dropped
- 401 maps to ``KakaoBookError(KAKAO_BOOK_AUTH_FAILED)``
- pagination forwards ``page`` and ``size`` verbatim (Kakao is 1-based by page)
"""

from __future__ import annotations

import json
from collections.abc import AsyncIterator
from pathlib import Path
from typing import Any

import httpx
import pytest
import pytest_asyncio
import respx
from app.core.exceptions import KakaoBookError
from app.core.http.base_client import AsyncHttpClient
from app.domains.book.adapters.kakao_book_adapter import KakaoBookAdapter
from app.domains.book.models import BookSource

FIXTURES = Path(__file__).resolve().parent.parent.parent / "fixtures"
_KAKAO_URL = "https://dapi.kakao.com/v3/search/book"


def _load(path: str) -> dict[str, Any]:
    return json.loads((FIXTURES / path).read_text())


@pytest_asyncio.fixture
async def kakao_book_adapter() -> AsyncIterator[KakaoBookAdapter]:
    client = AsyncHttpClient(timeout=2.0, max_retries=0)
    adapter = KakaoBookAdapter(http_client=client)
    try:
        yield adapter
    finally:
        await client.aclose()


@pytest.mark.asyncio
async def test_kakao_happy_path_returns_normalized_items(
    kakao_book_adapter: KakaoBookAdapter,
) -> None:
    payload = _load("kakao_book/search_success.json")

    with respx.mock(assert_all_called=True) as mock:
        mock.get(_KAKAO_URL).mock(return_value=httpx.Response(200, json=payload))
        result = await kakao_book_adapter.search("검색어")

    assert result.total == 3
    assert len(result.items) == 3

    first = result.items[0]
    assert first.isbn13 == "9788937460777"
    assert first.title == "오만과 편견"
    assert first.author == "제인 오스틴 · 윤지관"
    assert first.publisher == "민음사"
    assert first.cover_url is not None
    assert first.source is BookSource.KAKAO


@pytest.mark.asyncio
async def test_kakao_filters_items_without_isbn13(
    kakao_book_adapter: KakaoBookAdapter,
) -> None:
    payload = _load("kakao_book/search_missing_isbn13.json")

    with respx.mock(assert_all_called=True) as mock:
        mock.get(_KAKAO_URL).mock(return_value=httpx.Response(200, json=payload))
        result = await kakao_book_adapter.search("query")

    assert result.total == 2
    assert len(result.items) == 1
    assert result.items[0].isbn13 == "9788937460111"


@pytest.mark.asyncio
async def test_kakao_empty_result(kakao_book_adapter: KakaoBookAdapter) -> None:
    payload = _load("kakao_book/search_empty.json")

    with respx.mock(assert_all_called=True) as mock:
        mock.get(_KAKAO_URL).mock(return_value=httpx.Response(200, json=payload))
        result = await kakao_book_adapter.search("없는검색어")

    assert result.total == 0
    assert result.items == []


@pytest.mark.asyncio
async def test_kakao_auth_error_maps_to_kakao_book_error(
    kakao_book_adapter: KakaoBookAdapter,
) -> None:
    payload = _load("kakao_book/error_401.json")

    with respx.mock(assert_all_called=True) as mock:
        mock.get(_KAKAO_URL).mock(return_value=httpx.Response(401, json=payload))

        with pytest.raises(KakaoBookError) as exc_info:
            await kakao_book_adapter.search("query")

    assert exc_info.value.code == "KAKAO_BOOK_AUTH_FAILED"


@pytest.mark.asyncio
async def test_kakao_pagination_forwards_page_and_size(
    kakao_book_adapter: KakaoBookAdapter,
) -> None:
    payload = _load("kakao_book/search_empty.json")

    with respx.mock(assert_all_called=True) as mock:
        route = mock.get(_KAKAO_URL).mock(return_value=httpx.Response(200, json=payload))
        await kakao_book_adapter.search("query", page=2, size=15)

    request = route.calls[0].request
    assert request.url.params.get("page") == "2"
    assert request.url.params.get("size") == "15"
    # Authorization header must be in KakaoAK {key} form.
    assert request.headers.get("Authorization", "").startswith("KakaoAK ")
