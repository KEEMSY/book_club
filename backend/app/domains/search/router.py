"""Search router — GET /search."""

from __future__ import annotations

from typing import Annotated, Literal

from fastapi import APIRouter, Depends, Query

from app.core.deps import get_current_user_id
from app.domains.search.providers import get_search_service
from app.domains.search.schemas import AutocompleteResult, SearchResult
from app.domains.search.service import SearchService

router = APIRouter(prefix="/search", tags=["search"])

SearchType = Literal["all", "book", "user", "club"]


@router.get("", response_model=SearchResult)
async def search(
    q: Annotated[str, Query(min_length=1, max_length=100, description="검색어")],
    type: Annotated[SearchType, Query(description="검색 대상: all | book | user | club")] = "all",
    limit: Annotated[int, Query(ge=1, le=50, description="엔티티 유형별 최대 결과 수")] = 10,
    _user_id: Annotated[str, Depends(get_current_user_id)] = "",
    service: Annotated[SearchService, Depends(get_search_service)] = ...,  # type: ignore[assignment]
) -> SearchResult:
    """통합 검색 — 책·사용자·클럽을 동시에 검색합니다."""
    include_books = type in ("all", "book")
    include_users = type in ("all", "user")
    include_clubs = type in ("all", "club")

    return await service.search(
        q,
        include_books=include_books,
        include_users=include_users,
        include_clubs=include_clubs,
        limit=limit,
    )


@router.get("/autocomplete", response_model=AutocompleteResult)
async def autocomplete(
    q: Annotated[str, Query(min_length=1, max_length=100, description="검색어 접두사")],
    limit: Annotated[int, Query(ge=1, le=10, description="최대 제안 수")] = 10,
    _user_id: Annotated[str, Depends(get_current_user_id)] = "",
    service: Annotated[SearchService, Depends(get_search_service)] = ...,  # type: ignore[assignment]
) -> AutocompleteResult:
    """책 제목·저자 자동완성 — pg_trgm 유사도 기반 제안."""
    return await service.autocomplete(q, limit=limit)
