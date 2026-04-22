import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/book.dart';
import '../domain/user_book.dart';

part 'book_detail_state.freezed.dart';

/// Sealed state union for a single book detail screen.
///
/// Separate nested state (`libraryState`) captures the "담기" CTA machine so
/// the screen can show a spinner / success pill without losing the book
/// payload. [duplicateUserBookId] is populated after a 409 when the backend
/// knows which UserBook the user already owns (currently unavailable — the
/// backend returns only the error code, so the field stays nullable and the
/// CTA degrades to a disabled "이미 서재에 있어요" chip).
@freezed
sealed class BookDetailState with _$BookDetailState {
  const factory BookDetailState.loading() = BookDetailLoading;
  const factory BookDetailState.loaded({
    required Book book,
    @Default(LibraryCtaIdle()) LibraryCtaState libraryState,
  }) = BookDetailLoaded;
  const factory BookDetailState.error({
    required String code,
    required String message,
  }) = BookDetailError;
}

/// Drives the "내 서재에 담기" CTA. Separated from the outer sealed state so
/// switching into / out of adding doesn't rebuild the whole detail view.
@freezed
sealed class LibraryCtaState with _$LibraryCtaState {
  const factory LibraryCtaState.idle() = LibraryCtaIdle;
  const factory LibraryCtaState.adding() = LibraryCtaAdding;
  const factory LibraryCtaState.added({
    required UserBook userBook,
  }) = LibraryCtaAdded;

  /// The backend already has a UserBook for this (user, book) pair.
  /// `duplicateUserBookId` is the known id when the server surfaces it; null
  /// when the contract only returns the error code.
  const factory LibraryCtaState.duplicate({String? duplicateUserBookId}) =
      LibraryCtaDuplicate;
  const factory LibraryCtaState.error({
    required String code,
    required String message,
  }) = LibraryCtaError;
}
