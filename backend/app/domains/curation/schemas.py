"""Pydantic v2 schemas for the curation domain.

``CurationCardPublic`` is the wire representation returned to clients.
``CreateCurationCardRequest`` is the admin creation payload.
Both enforce the card_type literal so invalid values fail at the 422 boundary
before reaching the service.
"""

from __future__ import annotations

import uuid
from typing import Literal

from pydantic import BaseModel, ConfigDict, Field

CardType = Literal["intro", "guide", "context", "quote"]
FeedbackAction = Literal["helpful", "skip", "dismiss"]


class CurationCardPublic(BaseModel):
    """Wire shape returned to API clients."""

    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    book_id: uuid.UUID
    card_type: CardType
    title: str
    body: str
    order_index: int


class CreateCurationCardRequest(BaseModel):
    """Admin payload for creating a new curation card."""

    card_type: CardType
    title: str = Field(..., max_length=100)
    body: str = Field(..., min_length=1)
    order_index: int = 0


class CurationFeedbackRequest(BaseModel):
    """Reader reaction payload for ``POST /me/curation-cards/{id}/feedback``."""

    action: FeedbackAction
