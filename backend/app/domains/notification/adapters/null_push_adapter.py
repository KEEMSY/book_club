"""No-op push adapter used in development and test environments.

Suppresses actual FCM calls so developers can run the full notification flow
locally without Firebase credentials. Debug logging confirms the call path
is exercised even though no network request is made.
"""

from __future__ import annotations

import logging

logger = logging.getLogger(__name__)


class NullPushAdapter:
    """Satisfies PushPort without sending real push notifications."""

    async def send_to_tokens(
        self,
        tokens: list[str],
        title: str,
        body: str,
        data: dict[str, str],
    ) -> None:
        logger.debug("push suppressed (dev) title=%s tokens=%d", title, len(tokens))
