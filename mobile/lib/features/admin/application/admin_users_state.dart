import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/admin_user.dart';

part 'admin_users_state.freezed.dart';

/// Sealed state union consumed by the admin console's user-management
/// section. Mirrors `BookSearchState` (book feature) — same
/// loading/loaded/error shape, plus pagination bookkeeping.
///
/// Transitions:
///   - [loading] — first page fetch in flight (initial load or a new,
///     debounced search term).
///   - [loaded]  — current page(s) for [search], plus [hasMore]/[total] so
///     the list can show a footer spinner and stop requesting once
///     `items.length == total`.
///   - [error]   — backend/network failure; screen shows a retry CTA.
@freezed
sealed class AdminUsersState with _$AdminUsersState {
  const factory AdminUsersState.loading() = AdminUsersLoading;
  const factory AdminUsersState.loaded({
    required String search,
    required List<AdminUser> items,
    required int page,
    required int total,
    @Default(false) bool isLoadingMore,
  }) = AdminUsersLoaded;
  const factory AdminUsersState.error({
    required String code,
    required String message,
  }) = AdminUsersError;
}

/// Whether another page can be requested — computed rather than stored so it
/// can never drift from [AdminUsersLoaded.items]/[AdminUsersLoaded.total].
extension AdminUsersLoadedX on AdminUsersLoaded {
  bool get hasMore => items.length < total;
}
