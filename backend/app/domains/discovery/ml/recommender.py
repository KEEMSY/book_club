"""Item-based collaborative filtering recommender.

Algorithm
---------
1. Build a user x book rating matrix from ``user_books``:
   - COMPLETED  -> 5
   - READING    -> 3
   - WISHLIST   -> 1
   - PAUSED / DROPPED -> excluded (signal too noisy)
2. Compute item-item cosine similarity via scipy.
3. For the target user, aggregate similarity scores weighted by that
   user's existing ratings to surface the top-k unseen books.
4. Serialise (model state, book metadata) with pickle into Redis with a
   7-day TTL so restarts don't lose a freshly trained model.

Cold-start handling is delegated to DiscoveryService: this class returns
an empty list when no cached model exists or the user has no rated items.
"""

from __future__ import annotations

import logging
import pickle
from dataclasses import dataclass, field
from typing import TYPE_CHECKING, Any
from uuid import UUID

import numpy as np
from scipy.sparse import csr_matrix  # type: ignore[import-untyped]
from sklearn.preprocessing import normalize  # type: ignore[import-untyped]

from app.domains.book.models import UserBookStatus
from app.domains.discovery.service import RecommendedBookItem

if TYPE_CHECKING:
    from redis.asyncio import Redis
    from sqlalchemy.ext.asyncio import AsyncSession

logger = logging.getLogger(__name__)

_REDIS_KEY = "discovery:cf_model"
# 7 days in seconds
_CACHE_TTL = 7 * 24 * 60 * 60

# Rating values for each interaction type.
_STATUS_RATING: dict[str, int] = {
    UserBookStatus.COMPLETED: 5,
    UserBookStatus.READING: 3,
    UserBookStatus.WISHLIST: 1,
}

# Minimum interactions a book must have to be included in the model.
_MIN_BOOK_INTERACTIONS = 2


@dataclass(slots=True)
class _ModelState:
    """Serialisable snapshot of the trained item-item CF model."""

    # Normalised item-item cosine similarity matrix (n_books x n_books).
    item_sim: np.ndarray  # shape (n_books, n_books)

    # Ordered list of book_ids matching the column/row indices of item_sim.
    book_ids: list[str]

    # Mapping book_id -> index for O(1) lookup.
    book_index: dict[str, int]

    # Lightweight book metadata for building RecommendedBookItem without a DB
    # round-trip at recommendation time.
    book_meta: dict[str, dict[str, Any]]  # book_id -> {title, author, cover_url}

    # user_id -> {book_id: rating} for users in the training set.
    user_ratings: dict[str, dict[str, int]]


@dataclass(slots=True)
class CollaborativeFilteringRecommender:
    """Item-based collaborative filtering recommender backed by Redis cache."""

    _redis: Redis[bytes]  # type: ignore[type-arg]
    _model: _ModelState | None = field(default=None, init=False)

    # ------------------------------------------------------------------
    # Training
    # ------------------------------------------------------------------

    async def retrain(self, conn: AsyncSession) -> None:
        """Rebuild the CF model from the live database and push to Redis.

        Fetches the full ``user_books`` table in a single query, constructs
        the rating matrix, computes item-item cosine similarity, and stores
        the result in Redis with a 7-day TTL.
        """
        from sqlalchemy import select

        from app.domains.book.models import Book, UserBook

        logger.info("cf_retrain_start")

        # Fetch all relevant interactions plus book metadata in one round-trip.
        stmt = (
            select(
                UserBook.user_id,
                UserBook.book_id,
                UserBook.status,
                Book.title,
                Book.author,
                Book.cover_url,
            )
            .join(Book, Book.id == UserBook.book_id)
            .where(
                UserBook.status.in_(list(_STATUS_RATING.keys()))
            )
        )
        result = await conn.execute(stmt)
        rows = result.all()

        if not rows:
            logger.warning("cf_retrain_no_data: skipping")
            return

        # Build rating dict and collect book metadata.
        # user_ratings: user_id_str -> {book_id_str: rating}
        user_ratings: dict[str, dict[str, int]] = {}
        book_meta: dict[str, dict[str, Any]] = {}
        book_interaction_counts: dict[str, int] = {}

        for row in rows:
            uid = str(row.user_id)
            bid = str(row.book_id)
            rating = _STATUS_RATING.get(str(row.status), 0)
            if rating == 0:
                continue

            user_ratings.setdefault(uid, {})[bid] = rating
            book_meta[bid] = {
                "title": row.title,
                "author": row.author,
                "cover_url": row.cover_url,
            }
            book_interaction_counts[bid] = book_interaction_counts.get(bid, 0) + 1

        # Filter to books with enough signal.
        qualifying_books = [
            bid
            for bid, cnt in book_interaction_counts.items()
            if cnt >= _MIN_BOOK_INTERACTIONS
        ]

        if len(qualifying_books) < 2:
            logger.warning(
                "cf_retrain_insufficient_books qualifying=%d: skipping",
                len(qualifying_books),
            )
            return

        book_ids = sorted(qualifying_books)
        book_index = {bid: i for i, bid in enumerate(book_ids)}
        n_books = len(book_ids)

        # Collect users that rated at least one qualifying book.
        users = [uid for uid, ratings in user_ratings.items() if any(b in book_index for b in ratings)]
        n_users = len(users)

        if n_users == 0:
            logger.warning("cf_retrain_no_qualifying_users: skipping")
            return

        user_index = {uid: i for i, uid in enumerate(users)}

        # Build sparse user x book matrix (CSR format for efficient column ops).
        row_indices: list[int] = []
        col_indices: list[int] = []
        data: list[int] = []

        for uid, ratings in user_ratings.items():
            if uid not in user_index:
                continue
            ui = user_index[uid]
            for bid, rating in ratings.items():
                if bid in book_index:
                    row_indices.append(ui)
                    col_indices.append(book_index[bid])
                    data.append(rating)

        user_book_matrix = csr_matrix(
            (data, (row_indices, col_indices)),
            shape=(n_users, n_books),
            dtype=np.float32,
        )

        # Normalise each item (column) vector to unit length for cosine sim.
        # Transpose -> item x user matrix, then row-normalise (each row = one item).
        item_matrix = user_book_matrix.T  # shape: (n_books, n_users)
        item_matrix_normalised = normalize(item_matrix, norm="l2", axis=1)

        # item_sim[i, j] = cosine similarity between book i and book j.
        item_sim: np.ndarray = (item_matrix_normalised @ item_matrix_normalised.T).toarray()

        state = _ModelState(
            item_sim=item_sim,
            book_ids=book_ids,
            book_index=book_index,
            book_meta=book_meta,
            user_ratings=user_ratings,
        )

        payload = pickle.dumps(state, protocol=pickle.HIGHEST_PROTOCOL)
        await self._redis.set(_REDIS_KEY, payload, ex=_CACHE_TTL)
        self._model = state

        logger.info(
            "cf_retrain_done n_books=%d n_users=%d",
            n_books,
            n_users,
        )

    # ------------------------------------------------------------------
    # Inference
    # ------------------------------------------------------------------

    async def recommend(
        self,
        user_id: UUID,
        limit: int = 10,
    ) -> list[RecommendedBookItem]:
        """Return up to *limit* item-CF recommendations for the given user.

        Returns an empty list on cold-start (user not in training set or
        model not yet trained), letting DiscoveryService fall back to the
        rule-based path.
        """
        model = await self._load_model()
        if model is None:
            return []

        uid = str(user_id)
        user_rated = model.user_ratings.get(uid)
        if not user_rated:
            # Cold-start: user has no interactions in the training set.
            return []

        # For each book the user has rated, add its similarity row weighted
        # by the user's rating, then zero out books the user already knows.
        n_books = len(model.book_ids)
        scores = np.zeros(n_books, dtype=np.float32)

        for bid, rating in user_rated.items():
            idx = model.book_index.get(bid)
            if idx is None:
                continue
            scores += model.item_sim[idx] * rating

        # Zero out books the user has already interacted with.
        for bid in user_rated:
            idx = model.book_index.get(bid)
            if idx is not None:
                scores[idx] = 0.0

        # Top-k by score (descending).
        top_indices = np.argpartition(scores, -min(limit, n_books))[-limit:]
        top_indices = top_indices[np.argsort(scores[top_indices])[::-1]]

        results: list[RecommendedBookItem] = []
        for idx in top_indices:
            if scores[idx] <= 0.0:
                break
            bid = model.book_ids[int(idx)]
            meta = model.book_meta.get(bid)
            if meta is None:
                continue
            results.append(
                RecommendedBookItem(
                    id=bid,
                    title=meta["title"],
                    author=meta["author"],
                    cover_url=meta.get("cover_url"),
                    reason="similar_readers",
                )
            )

        return results

    # ------------------------------------------------------------------
    # Internal helpers
    # ------------------------------------------------------------------

    async def _load_model(self) -> _ModelState | None:
        """Return the in-process model if fresh, otherwise hydrate from Redis."""
        if self._model is not None:
            return self._model

        raw = await self._redis.get(_REDIS_KEY)
        if raw is None:
            return None

        try:
            state: _ModelState = pickle.loads(raw)  # type: ignore[arg-type]
        except Exception:
            logger.exception("cf_model_deserialise_failed")
            return None

        self._model = state
        return state
