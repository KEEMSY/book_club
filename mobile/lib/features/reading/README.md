# reading feature

Maps 1:1 to the backend `reading` domain (timer sessions, heatmap, grade, goals). Populated at M3 — this is the core UX of the app.

Layers:

- `presentation/` — timer screen, heatmap widget, grade screen, goals UI.
- `application/` — Riverpod state machines for timer (Start/Pause/Resume/End), grade-aware theming glue.
- `domain/` — ReadingSession, DailyStat, UserGrade, Goal, Streak entities.
- `data/` — retrofit client for `/reading/*` endpoints.
