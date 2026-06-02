import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/feed_repository.dart';
import '../domain/highlight.dart';
import 'feed_providers.dart';
import 'highlight_state.dart';

/// Manages the list of private highlights for a single [UserBook].
class HighlightNotifier extends StateNotifier<HighlightState> {
  HighlightNotifier(this._repo, this.userBookId)
      : super(const HighlightState.initial());

  final FeedRepository _repo;
  final String userBookId;

  Future<void> load() async {
    state = const HighlightState.loading();
    try {
      final page = await _repo.listHighlights(userBookId: userBookId);
      state = HighlightState.loaded(
        items: page.items,
        nextCursor: page.nextCursor,
      );
    } on FeedRepositoryException catch (e) {
      state = HighlightState.error(code: e.code, message: e.message);
    }
  }

  /// Adds a highlight optimistically — prepends on success, stays put on error.
  Future<Highlight?> add({
    required String quoteText,
    int? pageNumber,
    String? noteText,
  }) async {
    try {
      final Highlight h = await _repo.createHighlight(
        userBookId: userBookId,
        quoteText: quoteText,
        pageNumber: pageNumber,
        noteText: noteText,
      );
      // Guard against autoDispose: the provider may have been collected while
      // the HTTP call was in flight (e.g. opened from library sheet with no
      // watcher). Skip the optimistic state update rather than throwing.
      if (mounted) {
        if (state
            case HighlightLoaded(
              :final List<Highlight> items,
              :final nextCursor
            )) {
          state = HighlightState.loaded(
            items: <Highlight>[h, ...items],
            nextCursor: nextCursor,
          );
        }
      }
      return h;
    } on FeedRepositoryException {
      return null;
    }
  }

  /// Updates an existing highlight and replaces it in state on success.
  Future<Highlight?> update({
    required String highlightId,
    required String quoteText,
    int? pageNumber,
    String? noteText,
  }) async {
    try {
      final Highlight updated = await _repo.updateHighlight(
        userBookId: userBookId,
        highlightId: highlightId,
        quoteText: quoteText,
        pageNumber: pageNumber,
        noteText: noteText,
      );
      if (mounted) {
        if (state
            case HighlightLoaded(
              :final List<Highlight> items,
              :final nextCursor
            )) {
          state = HighlightState.loaded(
            items: items
                .map((Highlight h) => h.id == highlightId ? updated : h)
                .toList(),
            nextCursor: nextCursor,
          );
        }
      }
      return updated;
    } on FeedRepositoryException {
      return null;
    }
  }

  Future<void> delete(String highlightId) async {
    if (state
        case HighlightLoaded(:final List<Highlight> items, :final nextCursor)) {
      await _repo.deleteHighlight(
        userBookId: userBookId,
        highlightId: highlightId,
      );
      state = HighlightState.loaded(
        items: items.where((Highlight h) => h.id != highlightId).toList(),
        nextCursor: nextCursor,
      );
    }
  }
}

final highlightNotifierProvider = StateNotifierProvider.autoDispose
    .family<HighlightNotifier, HighlightState, String>((ref, userBookId) {
  return HighlightNotifier(ref.watch(feedRepositoryProvider), userBookId);
});
