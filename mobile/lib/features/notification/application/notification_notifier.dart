import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/notification_repository.dart';
import 'notification_state.dart';

/// Manages the notification list with cursor-based pagination.
///
/// [load] always replaces the list with the first page so pull-to-refresh
/// and the initial mount both reset cleanly.
/// [loadMore] appends the next page only when [NotificationState.hasMore].
/// [markRead] optimistically patches the local item to avoid a full reload
/// that would scroll-jump the user.
class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier(this._repository) : super(const NotificationState());

  final NotificationRepository _repository;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final resp = await _repository.getNotifications(limit: 20);
      state = NotificationState(
        items: resp.items,
        nextCursor: resp.nextCursor,
        unreadCount: resp.unreadCount,
        hasMore: resp.nextCursor != null,
      );
    } on NotificationRepositoryException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) {
      return;
    }
    state = state.copyWith(isLoading: true);
    try {
      final resp = await _repository.getNotifications(
        cursor: state.nextCursor,
        limit: 20,
      );
      state = state.copyWith(
        items: [...state.items, ...resp.items],
        nextCursor: resp.nextCursor,
        unreadCount: resp.unreadCount,
        hasMore: resp.nextCursor != null,
        isLoading: false,
      );
    } on NotificationRepositoryException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  /// Marks a notification as read locally first (optimistic update), then
  /// syncs to the backend. On failure the item stays read locally — a
  /// subsequent [load] will reconcile from the server.
  Future<void> markRead(String id) async {
    final now = DateTime.now();
    state = state.copyWith(
      items: state.items.map((n) {
        if (n.id == id && n.readAt == null) {
          return n.copyWith(readAt: now);
        }
        return n;
      }).toList(),
      unreadCount:
          state.unreadCount > 0 ? state.unreadCount - 1 : 0,
    );
    try {
      await _repository.markRead(id);
    } on NotificationRepositoryException {
      // Silent — optimistic state is good enough for UX continuity.
    }
  }

  /// Refreshes only the unread count badge — called periodically from
  /// [NotificationBell] without triggering a full list reload.
  Future<void> refreshUnreadCount() async {
    try {
      final count = await _repository.getUnreadCount();
      state = state.copyWith(unreadCount: count);
    } on NotificationRepositoryException {
      // Badge failure is non-critical — keep the stale value shown.
    }
  }
}

final notificationNotifierProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier(ref.watch(notificationRepositoryProvider));
});
