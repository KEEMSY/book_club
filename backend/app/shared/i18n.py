"""Lightweight message catalog for localized API responses (M72).

The translation surface is intentionally small: only operator-facing error
messages that reach the client are localized here. UI copy lives in the Flutter
ARB files, not in the backend.

``LanguageMiddleware`` parses ``Accept-Language`` into ``request.state.lang``;
routers/services pass that code to :func:`t` to resolve a message. Korean is the
canonical fallback when a key or language is missing, mirroring the default the
middleware applies.
"""

from __future__ import annotations

from typing import Literal, get_args

LangCode = Literal["ko", "en", "ja"]

DEFAULT_LANG: LangCode = "ko"

# Single source of truth for the supported set — the middleware imports this so
# the parser and the catalog can never drift apart.
SUPPORTED_LANGS: frozenset[str] = frozenset(get_args(LangCode))

_MESSAGES: dict[str, dict[LangCode, str]] = {
    "not_found": {
        "ko": "찾을 수 없습니다",
        "en": "Not found",
        "ja": "見つかりません",
    },
    "unauthorized": {
        "ko": "인증이 필요합니다",
        "en": "Unauthorized",
        "ja": "認証が必要です",
    },
    "forbidden": {
        "ko": "권한이 없습니다",
        "en": "Forbidden",
        "ja": "権限がありません",
    },
    "pro_required": {
        "ko": "Pro 구독이 필요합니다",
        "en": "Pro subscription required",
        "ja": "Proサブスクリプションが必要です",
    },
    "validation_error": {
        "ko": "입력값을 확인해주세요",
        "en": "Please check your input",
        "ja": "入力を確認してください",
    },
}


def t(key: str, lang: str = DEFAULT_LANG) -> str:
    """Resolve ``key`` for ``lang``, falling back to Korean then the raw key.

    ``lang`` is typed as ``str`` (not ``LangCode``) so callers can pass
    ``request.state.lang`` directly without a cast; unknown languages degrade to
    the Korean entry rather than raising.
    """
    entry = _MESSAGES.get(key)
    if entry is None:
        return key
    if lang in SUPPORTED_LANGS:
        return entry[lang]  # type: ignore[index]
    return entry[DEFAULT_LANG]
