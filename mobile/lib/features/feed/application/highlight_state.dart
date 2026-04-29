import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/highlight.dart';

part 'highlight_state.freezed.dart';

@freezed
sealed class HighlightState with _$HighlightState {
  const factory HighlightState.initial() = HighlightInitial;
  const factory HighlightState.loading() = HighlightLoading;
  const factory HighlightState.loaded({
    required List<Highlight> items,
    String? nextCursor,
  }) = HighlightLoaded;
  const factory HighlightState.error({
    required String code,
    required String message,
  }) = HighlightError;
}
