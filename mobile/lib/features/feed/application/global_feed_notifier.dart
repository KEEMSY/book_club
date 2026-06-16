import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/feed_event.dart';
import '../domain/feed_reaction.dart';
import 'feed_providers.dart';

part 'global_feed_notifier.g.dart';

/// Which of the two global feed timelines is active.
enum FeedTab { global, following }

/// State for the global event feed (all users or following-only).
class GlobalFeedState {
  const GlobalFeedState({
    required this.items,
    required this.nextCursor,
    required this.isLoading,
    required this.error,
  });

  const GlobalFeedState.initial()
      : items = const <FeedEvent>[],
        nextCursor = null,
        isLoading = false,
        error = null;

  final List<FeedEvent> items;
  final String? nextCursor;
  final bool isLoading;
  final Object? error;

  bool get hasMore => nextCursor != null;

  GlobalFeedState copyWith({
    List<FeedEvent>? items,
    String? nextCursor,
    bool clearCursor = false,
    bool? isLoading,
    Object? error,
    bool clearError = false,
  }) {
    return GlobalFeedState(
      items: items ?? this.items,
      nextCursor: clearCursor ? null : (nextCursor ?? this.nextCursor),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Notifier for [FeedTab.global] — `GET /feed`.
@riverpod
class GlobalFeedNotifier extends _$GlobalFeedNotifier {
  @override
  GlobalFeedState build() {
    Future.microtask(fetchFirst);
    return const GlobalFeedState.initial();
  }

  Future<void> fetchFirst() async {
    if (state.isLoading) return;
    state = state.copyWith(
      items: const <FeedEvent>[],
      clearCursor: true,
      isLoading: true,
      clearError: true,
    );
    try {
      final page = await ref.read(feedRepositoryProvider).getGlobalFeed();
      state = state.copyWith(
        items: page.items,
        nextCursor: page.cursor,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> fetchMore() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final page = await ref
          .read(feedRepositoryProvider)
          .getGlobalFeed(cursor: state.nextCursor);
      state = state.copyWith(
        items: [...state.items, ...page.items],
        nextCursor: page.cursor,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Optimistically updates reactions after a toggle response. The emoji list
  /// is rebuilt from the server-authoritative reaction count; callers pass the
  /// full updated reactions list from the event card.
  void applyReactionToggle({
    required String eventId,
    required String emoji,
    required bool added,
    required String currentUserId,
  }) {
    final List<FeedEvent> next = <FeedEvent>[
      for (final FeedEvent ev in state.items)
        if (ev.id == eventId)
          _applyToggle(
            ev,
            emoji: emoji,
            added: added,
            userId: currentUserId,
          )
        else
          ev,
    ];
    state = state.copyWith(items: next);
  }

  void incrementCommentCount(String eventId, [int delta = 1]) {
    final List<FeedEvent> next = <FeedEvent>[
      for (final FeedEvent ev in state.items)
        if (ev.id == eventId)
          ev.copyWith(
            commentCount: (ev.commentCount + delta).clamp(0, 1 << 31),
          )
        else
          ev,
    ];
    state = state.copyWith(items: next);
  }
}

/// Notifier for [FeedTab.following] — `GET /feed/following`.
@riverpod
class FollowingEventFeedNotifier extends _$FollowingEventFeedNotifier {
  @override
  GlobalFeedState build() {
    Future.microtask(fetchFirst);
    return const GlobalFeedState.initial();
  }

  Future<void> fetchFirst() async {
    if (state.isLoading) return;
    state = state.copyWith(
      items: const <FeedEvent>[],
      clearCursor: true,
      isLoading: true,
      clearError: true,
    );
    try {
      final page =
          await ref.read(feedRepositoryProvider).getFollowingEventFeed();
      state = state.copyWith(
        items: page.items,
        nextCursor: page.cursor,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> fetchMore() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final page = await ref
          .read(feedRepositoryProvider)
          .getFollowingEventFeed(cursor: state.nextCursor);
      state = state.copyWith(
        items: [...state.items, ...page.items],
        nextCursor: page.cursor,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  void applyReactionToggle({
    required String eventId,
    required String emoji,
    required bool added,
    required String currentUserId,
  }) {
    final List<FeedEvent> next = <FeedEvent>[
      for (final FeedEvent ev in state.items)
        if (ev.id == eventId)
          _applyToggle(
            ev,
            emoji: emoji,
            added: added,
            userId: currentUserId,
          )
        else
          ev,
    ];
    state = state.copyWith(items: next);
  }

  void incrementCommentCount(String eventId, [int delta = 1]) {
    final List<FeedEvent> next = <FeedEvent>[
      for (final FeedEvent ev in state.items)
        if (ev.id == eventId)
          ev.copyWith(
            commentCount: (ev.commentCount + delta).clamp(0, 1 << 31),
          )
        else
          ev,
    ];
    state = state.copyWith(items: next);
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

FeedEvent _applyToggle(
  FeedEvent ev, {
  required String emoji,
  required bool added,
  required String userId,
}) {
  List<FeedReaction> next;
  if (added) {
    // Append a synthetic reaction; canonical data reconciled on next fetch.
    next = <FeedReaction>[
      ...ev.reactions,
      FeedReaction(
        id: '${ev.id}_${emoji}_${userId.substring(0, 6)}',
        emoji: emoji,
        userId: userId,
        createdAt: DateTime.now(),
      ),
    ];
  } else {
    // Remove the first matching emoji from this user.
    bool removed = false;
    next = ev.reactions.where((FeedReaction r) {
      if (!removed && r.emoji == emoji && r.userId == userId) {
        removed = true;
        return false;
      }
      return true;
    }).toList(growable: false);
  }
  return ev.copyWith(reactions: next);
}
