"""Pydantic schemas for the search domain."""

from __future__ import annotations

from uuid import UUID

from pydantic import BaseModel


class BookSearchItem(BaseModel):
    id: UUID
    title: str
    author: str
    thumbnail_url: str | None


class UserSearchItem(BaseModel):
    id: UUID
    nickname: str
    avatar_url: str | None


class ClubSearchItem(BaseModel):
    id: UUID
    name: str
    member_count: int
    current_book_title: str | None


class SearchResult(BaseModel):
    books: list[BookSearchItem]
    users: list[UserSearchItem]
    clubs: list[ClubSearchItem]


class AutocompleteResult(BaseModel):
    suggestions: list[str]
