"""HTTP surface for the curation domain.

Public endpoints (optional auth):
  GET  /books/{book_id}/curation-cards          — full card list for a book
  GET  /books/{book_id}/curation-cards/first    — first card (timer start UX),
                                                   personalized when authenticated

User endpoints (requires access token):
  POST /me/curation-cards/{card_id}/feedback    — record helpful/skip/dismiss

Admin endpoints (requires admin token):
  POST   /admin/books/{book_id}/curation-cards  — create a card
  DELETE /admin/curation-cards/{card_id}        — delete a card

Thin DTO ↔ service ↔ DTO layer per CLAUDE.md §3.1. Domain exceptions bubble
up to the global handler registered in ``core/exceptions.py``.
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Response, status

from app.core.deps import get_current_admin_id, get_current_user_id, get_current_user_id_optional
from app.domains.curation.providers import get_curation_service
from app.domains.curation.schemas import (
    CreateCurationCardRequest,
    CurationCardPublic,
    CurationFeedbackRequest,
)
from app.domains.curation.service import CurationService

router = APIRouter(tags=["curation"])


# ---------------------------------------------------------------------------
# Public endpoints
# ---------------------------------------------------------------------------


@router.get("/books/{book_id}/curation-cards", response_model=list[CurationCardPublic])
async def list_curation_cards(
    book_id: UUID,
    service: Annotated[CurationService, Depends(get_curation_service)],
) -> list[CurationCardPublic]:
    """Return all curation cards for *book_id* in display order.

    No authentication required — cards are editorial content visible to all.
    """
    return await service.list_cards(book_id)


@router.get(
    "/books/{book_id}/curation-cards/first",
    response_model=CurationCardPublic,
    responses={204: {"description": "No curation cards for this book"}},
)
async def get_first_curation_card(
    book_id: UUID,
    service: Annotated[CurationService, Depends(get_curation_service)],
    user_id: Annotated[str | None, Depends(get_current_user_id_optional)],
) -> Response | CurationCardPublic:
    """Return the first curation card for *book_id*.

    Used by the reading timer start screen to surface an intro card. When the
    request carries a valid token the result is personalized — card types the
    reader keeps skipping/dismissing are deprioritized (M67). Anonymous
    requests get the default ``order_index`` order.

    Returns HTTP 204 when no cards exist so the mobile client can skip
    the card overlay without treating the absence as an error.
    """
    card = await service.get_first_card(
        book_id, user_id=UUID(user_id) if user_id is not None else None
    )
    if card is None:
        return Response(status_code=status.HTTP_204_NO_CONTENT)
    return card


@router.post(
    "/me/curation-cards/{card_id}/feedback",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def submit_curation_feedback(
    card_id: UUID,
    body: CurationFeedbackRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[CurationService, Depends(get_curation_service)],
) -> Response:
    """Record the reader's reaction (helpful / skip / dismiss) to a card.

    Returns 404 when the card does not exist. Re-submitting flips the stored
    action rather than stacking rows.
    """
    await service.record_feedback(
        user_id=UUID(user_id), card_id=card_id, action=body.action
    )
    return Response(status_code=status.HTTP_204_NO_CONTENT)


# ---------------------------------------------------------------------------
# Admin endpoints
# ---------------------------------------------------------------------------


@router.post(
    "/admin/books/{book_id}/curation-cards",
    response_model=CurationCardPublic,
    status_code=status.HTTP_201_CREATED,
)
async def create_curation_card(
    book_id: UUID,
    body: CreateCurationCardRequest,
    _: Annotated[str, Depends(get_current_admin_id)],
    service: Annotated[CurationService, Depends(get_curation_service)],
) -> CurationCardPublic:
    """Create a new curation card for *book_id*.

    Returns 409 when the book already has 5 cards.
    """
    return await service.create_card(book_id=book_id, req=body)


@router.delete(
    "/admin/curation-cards/{card_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_curation_card(
    card_id: UUID,
    _: Annotated[str, Depends(get_current_admin_id)],
    service: Annotated[CurationService, Depends(get_curation_service)],
) -> Response:
    """Delete a curation card by its ID.

    Returns 404 when the card does not exist.
    """
    await service.delete_card(card_id)
    return Response(status_code=status.HTTP_204_NO_CONTENT)
