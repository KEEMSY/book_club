# feed feature

Maps 1:1 to the backend `feed` domain (per-book posts, reactions, comments). Populated at M4.

Layers:

- `presentation/` — feed list under book detail, post composer, reaction bar, comment screen.
- `application/` — Riverpod notifiers for cursor pagination, optimistic reactions.
- `domain/` — Post, Reaction, Comment entities with post-type enum.
- `data/` — retrofit client for `/books/{id}/posts`, `/posts/{id}/*`, presigned upload for attached images.
