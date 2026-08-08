import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/admin_repository.dart';
import '../domain/admin_user.dart';
import 'admin_providers.dart';
import 'admin_users_state.dart';

/// Debounce window for the user-search field. Kept as a top-level constant
/// (same pattern as `kSearchDebounce` in the book feature) so tests can
/// override it with a near-zero duration.
const Duration kAdminUserSearchDebounce = Duration(milliseconds: 300);

/// Orchestrates the admin console's user-management list: debounced search,
/// page-number pagination, and the is_active/is_admin PATCH toggle.
///
/// Not generated via `@riverpod` — same rationale as `BookSearchNotifier`:
/// we want an explicit `searchChanged`/`loadMore`/`togglePatch` surface and a
/// `Timer` field that must survive rebuilds.
class AdminUsersNotifier extends StateNotifier<AdminUsersState> {
  AdminUsersNotifier(
    this._repository, {
    Duration? debounce,
    int pageSize = 20,
  })  : _debounce = debounce ?? kAdminUserSearchDebounce,
        _pageSize = pageSize,
        super(const AdminUsersState.loading()) {
    unawaited(_fetchFirstPage(''));
  }

  final AdminRepository _repository;
  final Duration _debounce;
  final int _pageSize;

  Timer? _debouncer;
  String _currentSearch = '';
  int _requestSeq = 0;

  /// Called on every keystroke of the search field. Resets to the first
  /// page once the debounce window elapses; an empty query re-fetches the
  /// unfiltered list rather than clearing it (unlike book search's idle
  /// state — the admin list always has something to show).
  void searchChanged(String raw) {
    final String trimmed = raw.trim();
    _debouncer?.cancel();
    if (trimmed == _currentSearch) {
      return;
    }
    _debouncer = Timer(_debounce, () => _fetchFirstPage(trimmed));
  }

  /// Re-fetches the current search's first page. Used by the error state's
  /// "다시 시도" CTA.
  Future<void> retry() async {
    _debouncer?.cancel();
    await _fetchFirstPage(_currentSearch);
  }

  /// Triggered when the list scrolls to its last visible item. No-op unless
  /// currently [AdminUsersLoaded] with more pages left.
  Future<void> loadMore() async {
    final AdminUsersState snapshot = state;
    if (snapshot is! AdminUsersLoaded) {
      return;
    }
    if (!snapshot.hasMore || snapshot.isLoadingMore) {
      return;
    }
    state = snapshot.copyWith(isLoadingMore: true);
    final int nextPage = snapshot.page + 1;
    final int seq = ++_requestSeq;
    try {
      final AdminUserPage result = await _repository.listUsers(
        page: nextPage,
        pageSize: _pageSize,
        search: snapshot.search,
      );
      if (seq != _requestSeq) {
        return; // superseded by a newer search/retry
      }
      state = AdminUsersState.loaded(
        search: snapshot.search,
        items: <AdminUser>[...snapshot.items, ...result.items],
        page: result.page,
        total: result.total,
      );
    } on AdminRepositoryException {
      if (seq != _requestSeq) {
        return;
      }
      // Keep already-visible rows; drop the footer spinner. The user can
      // scroll again (or the search box's retry) to re-trigger.
      state = snapshot.copyWith(isLoadingMore: false);
    }
  }

  /// Applies an `is_active`/`is_admin` PATCH and swaps the affected row in
  /// place on success. Rethrows [AdminRepositoryException] so the screen can
  /// show a snackbar — unlike search/pagination failures, a toggle failure
  /// must not look like it silently succeeded.
  Future<void> togglePatch(
    String userId, {
    bool? isActive,
    bool? isAdmin,
  }) async {
    final AdminUser updated = await _repository.patchUser(
      userId,
      isActive: isActive,
      isAdmin: isAdmin,
    );
    final AdminUsersState snapshot = state;
    if (snapshot is AdminUsersLoaded) {
      state = snapshot.copyWith(
        items: <AdminUser>[
          for (final AdminUser u in snapshot.items)
            if (u.id == userId) updated else u,
        ],
      );
    }
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    super.dispose();
  }

  Future<void> _fetchFirstPage(String search) async {
    _currentSearch = search;
    state = const AdminUsersState.loading();
    final int seq = ++_requestSeq;
    try {
      final AdminUserPage result = await _repository.listUsers(
        page: 1,
        pageSize: _pageSize,
        search: search,
      );
      if (seq != _requestSeq) {
        return;
      }
      state = AdminUsersState.loaded(
        search: search,
        items: result.items,
        page: result.page,
        total: result.total,
      );
    } on AdminRepositoryException catch (e) {
      if (seq != _requestSeq) {
        return;
      }
      state = AdminUsersState.error(code: e.code, message: e.message);
    }
  }
}

final adminUsersNotifierProvider =
    StateNotifierProvider.autoDispose<AdminUsersNotifier, AdminUsersState>(
  (ref) => AdminUsersNotifier(ref.watch(adminRepositoryProvider)),
);
