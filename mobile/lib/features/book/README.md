# book feature

Maps 1:1 to the backend `book` domain (catalog, search, user library). Populated at M2.

Layers:

- `presentation/` — search screen, book detail, library tab UI.
- `application/` — Riverpod notifiers for search debounce, pagination, library state.
- `domain/` — Book, UserBook entities and status enums.
- `data/` — retrofit client for `/books/*` and `/me/library`, DTO <-> entity mappers.
