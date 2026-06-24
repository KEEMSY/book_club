"""Unit tests for the i18n message catalog and the Accept-Language parser."""

from __future__ import annotations

import pytest
from app.core.middleware import LanguageMiddleware
from app.shared.i18n import DEFAULT_LANG, SUPPORTED_LANGS, t


class _FakeState:
    lang: str


class _FakeRequest:
    """Minimal Request stand-in exposing only ``headers`` and ``state``."""

    def __init__(self, accept_language: str | None) -> None:
        self.headers = {} if accept_language is None else {"Accept-Language": accept_language}
        self.state = _FakeState()


async def _resolve_lang(accept_language: str | None) -> str:
    """Drive LanguageMiddleware.dispatch and return the resolved state.lang."""
    middleware = LanguageMiddleware(app=lambda *a, **k: None)  # type: ignore[arg-type]
    request = _FakeRequest(accept_language)

    async def call_next(_req: object) -> str:
        return "response"

    await middleware.dispatch(request, call_next)  # type: ignore[arg-type]
    return request.state.lang


def test_t_returns_requested_language() -> None:
    assert t("not_found", "en") == "Not found"
    assert t("not_found", "ja") == "見つかりません"
    assert t("pro_required", "ko") == "Pro 구독이 필요합니다"


def test_t_falls_back_to_korean_for_unsupported_language() -> None:
    assert t("forbidden", "fr") == t("forbidden", "ko")


def test_t_returns_key_when_missing() -> None:
    assert t("no_such_key", "en") == "no_such_key"


def test_supported_langs_matches_catalog() -> None:
    assert {"ko", "en", "ja"} == SUPPORTED_LANGS
    assert DEFAULT_LANG == "ko"


@pytest.mark.asyncio
@pytest.mark.parametrize(
    ("header", "expected"),
    [
        ("en", "en"),
        ("ja-JP", "ja"),
        ("en-US,en;q=0.9", "en"),
        ("KO", "ko"),
        ("fr", "ko"),
        (None, "ko"),
        ("", "ko"),
    ],
)
async def test_language_middleware_parses_accept_language(
    header: str | None, expected: str
) -> None:
    assert await _resolve_lang(header) == expected
