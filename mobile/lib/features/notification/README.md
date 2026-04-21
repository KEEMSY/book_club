# notification feature

Maps 1:1 to the backend `notification` domain (in-app notifications, FCM push, weekly reports). Populated at M5.

Layers:

- `presentation/` — notification center screen, weekly report screen.
- `application/` — Riverpod notifiers for unread counts and FCM token lifecycle.
- `domain/` — Notification, WeeklyReport entities.
- `data/` — retrofit client for `/notifications/*`, FCM token registration.
