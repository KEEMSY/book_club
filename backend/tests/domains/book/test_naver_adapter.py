"""Contract tests for the Naver book search adapter.

Uses ``respx`` to stub the Naver book endpoint with fixtures under
``tests/fixtures/naver/``. Verifies the normalisation rules:
- strip ``<b>…</b>`` tags from titles/descriptions
- join pipe-delimited authors with ``" · "``
- filter out items lacking a 13-digit ISBN
- map 401 to ``NaverBookError(NAVER_BOOK_AUTH_FAILED)``
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
from app.core.exceptions import NaverBookError
from app.core.http.base_client import AsyncHttpClient
from app.domains.book.adapters.naver_book_adapter import NaverBookAdapter
from app.domains.book.models import BookSource

FIXTURES = Path(__file__).resolve().parent.parent.parent / "fixtures"
_NAVER_URL = "https://openapi.naver.com/v1/search/book.json"


def _load(path: str) -> dict[str, Any]:
    return json.loads((FIXTURES / path).read_text())


@pytest_asyncio.fixture
async def naver_adapter() -> AsyncIterator[NaverBookAdapter]:
    client = AsyncHttpClient(timeout=2.0, max_retries=0)
    adapter = NaverBookAdapter(http_client=client)
    try:
        yield adapter
    finally:
        await client.aclose()


@pytest.mark.asyncio
async def test_naver_happy_path_returns_normalized_items(
    naver_adapter: NaverBookAdapter,
) -> None:
    payload = _load("naver/search_success.json")

    with respx.mock(assert_all_called=True) as mock:
        mock.get(_NAVER_URL).mock(return_value=httpx.Response(200, json=payload))
        result = await naver_adapter.search("검색어", page=1, size=20)

    assert result.total == 3
    assert result.page == 1
    assert result.size == 20
    assert len(result.items) == 3

    first = result.items[0]
    assert first.isbn13 == "9788937460777"
    assert first.title == "오만과 편견"
    # Pipe-delimited author normalised with " · " separator.
    assert first.author == "제인 오스틴 · 윤지관"
    assert first.publisher == "민음사"
    assert first.source is BookSource.NAVER
    assert first.cover_url is not None
    assert first.description is not None


@pytest.mark.asyncio
async def test_naver_strips_bold_tags(naver_adapter: NaverBookAdapter) -> None:
    payload = _load("naver/search_with_bold_tags.json")

    with respx.mock(assert_all_called=True) as mock:
        mock.get(_NAVER_URL).mock(return_value=httpx.Response(200, json=payload))
        result = await naver_adapter.search("오만과 편견")

    assert len(result.items) == 1
    item = result.items[0]
    # <b> and </b> removed from title and description.
    assert "<b>" not in item.title and "</b>" not in item.title
    assert item.title == "오만과 편견: 완역본"
    assert item.description is not None
    assert "<b>" not in item.description


@pytest.mark.asyncio
async def test_naver_filters_items_without_isbn13(
    naver_adapter: NaverBookAdapter,
) -> None:
    payload = _load("naver/search_missing_isbn13.json")

    with respx.mock(assert_all_called=True) as mock:
        mock.get(_NAVER_URL).mock(return_value=httpx.Response(200, json=payload))
        result = await naver_adapter.search("query")

    # Item with only a 10-digit ISBN is dropped. Total remains 2 (Naver
    # told us 2 matched the query) but the caller only receives 1 usable row.
    assert result.total == 2
    assert len(result.items) == 1
    assert result.items[0].isbn13 == "9788937460111"


@pytest.mark.asyncio
async def test_naver_empty_result(naver_adapter: NaverBookAdapter) -> None:
    payload = _load("naver/search_empty.json")

    with respx.mock(assert_all_called=True) as mock:
        mock.get(_NAVER_URL).mock(return_value=httpx.Response(200, json=payload))
        result = await naver_adapter.search("없는검색어")

    assert result.total == 0
    assert result.items == []


@pytest.mark.asyncio
async def test_naver_auth_error_maps_to_naver_book_error(
    naver_adapter: NaverBookAdapter,
) -> None:
    payload = _load("naver/error_401.json")

    with respx.mock(assert_all_called=True) as mock:
        mock.get(_NAVER_URL).mock(return_value=httpx.Response(401, json=payload))

        with pytest.raises(NaverBookError) as exc_info:
            await naver_adapter.search("query")

    assert exc_info.value.code == "NAVER_BOOK_AUTH_FAILED"


@pytest.mark.asyncio
async def test_naver_http_image_url_upgraded_to_https(
    naver_adapter: NaverBookAdapter,
) -> None:
    payload = _load("naver/search_success.json")
    # Inject an http:// image URL to verify the adapter upgrades it.
    payload["items"][0]["image"] = "http://bookthumb-phinf.pstatic.net/cover/001/001/cover1.jpg"

    with respx.mock(assert_all_called=True) as mock:
        mock.get(_NAVER_URL).mock(return_value=httpx.Response(200, json=payload))
        result = await naver_adapter.search("query")

    assert result.items[0].cover_url == "https://bookthumb-phinf.pstatic.net/cover/001/001/cover1.jpg"


@pytest.mark.asyncio
async def test_naver_pagination_uses_1_based_start(
    naver_adapter: NaverBookAdapter,
) -> None:
    payload = _load("naver/search_empty.json")

    with respx.mock(assert_all_called=True) as mock:
        route = mock.get(_NAVER_URL).mock(return_value=httpx.Response(200, json=payload))
        await naver_adapter.search("query", page=3, size=10)

    # page=3, size=10 -> start=21 in Naver's 1-based scheme.
    assert route.called
    request = route.calls[0].request
    assert request.url.params.get("start") == "21"
    assert request.url.params.get("display") == "10"
