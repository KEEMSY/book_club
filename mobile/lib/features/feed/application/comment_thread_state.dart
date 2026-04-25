import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/comment.dart';

part 'comment_thread_state.freezed.dart';

/// Sealed state for the comments sheet.
@freezed
sealed class CommentThreadState with _$CommentThreadState {
  const factory CommentThreadState.initial() = CommentThreadInitial;
  const factory CommentThreadState.loading() = CommentThreadLoading;
  const factory CommentThreadState.loaded({
    required List<Comment> items,
    String? nextCursor,
    @Default(false) bool isLoadingMore,
    @Default(false) bool isPosting,
    String? postError,
  }) = CommentThreadLoaded;
  const factory CommentThreadState.error({
    required String code,
    required String message,
  }) = CommentThreadError;
}
