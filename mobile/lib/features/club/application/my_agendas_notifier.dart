import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/club_repository.dart';
import '../domain/club.dart';
import 'club_providers.dart';

/// Offset-paginated state for the "내 활동 > 내 발제문 더보기" screen
/// (BC-83 — `GET /clubs/me/agendas`).
class MyAgendasState {
  const MyAgendasState({
    required this.items,
    required this.total,
    required this.hasMore,
    required this.isLoading,
    required this.error,
  });

  const MyAgendasState.initial()
      : items = const <MyAgendaItem>[],
        total = 0,
        hasMore = false,
        isLoading = false,
        error = null;

  final List<MyAgendaItem> items;
  final int total;
  final bool hasMore;
  final bool isLoading;
  final Object? error;

  MyAgendasState copyWith({
    List<MyAgendaItem>? items,
    int? total,
    bool? hasMore,
    bool? isLoading,
    Object? error,
    bool clearError = false,
  }) {
    return MyAgendasState(
      items: items ?? this.items,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Not generated via @riverpod (mirrors [BookSearchNotifier]'s hand-written
/// style) — explicit `fetchFirst`/`fetchMore` over an offset cursor.
class MyAgendasNotifier extends StateNotifier<MyAgendasState> {
  MyAgendasNotifier(this._repository) : super(const MyAgendasState.initial());

  final ClubRepository _repository;

  static const int _pageSize = 20;

  Future<void> fetchFirst() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final MyAgendaPage page =
          await _repository.listMyAgendas(limit: _pageSize, offset: 0);
      state = MyAgendasState(
        items: page.items,
        total: page.total,
        hasMore: page.hasMore,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> fetchMore() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final MyAgendaPage page = await _repository.listMyAgendas(
        limit: _pageSize,
        offset: state.items.length,
      );
      state = state.copyWith(
        items: <MyAgendaItem>[...state.items, ...page.items],
        total: page.total,
        hasMore: page.hasMore,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}

final myAgendasNotifierProvider =
    StateNotifierProvider.autoDispose<MyAgendasNotifier, MyAgendasState>(
  (ref) => MyAgendasNotifier(ref.watch(clubRepositoryProvider)),
);
