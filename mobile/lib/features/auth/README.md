# auth feature

Maps 1:1 to the backend `auth` domain. Will be populated starting at M1.

Layers:

- `presentation/` — widgets and screens (login screen, loading state).
- `application/` — Riverpod notifiers/providers that orchestrate use cases.
- `domain/` — domain entities (User, AuthSession) and value objects.
- `data/` — retrofit clients, DTOs, and repository implementations that call the backend.
