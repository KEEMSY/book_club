// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookDetailNotifierHash() =>
    r'8e7cf361a9d1d1377973668a74b2fbf52614950d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$BookDetailNotifier
    extends BuildlessAutoDisposeNotifier<BookDetailState> {
  late final String bookId;

  BookDetailState build(
    String bookId,
  );
}

/// Detail screen notifier:
///   * loads a book by id,
///   * tracks the add-to-library CTA state,
///   * translates 409 BOOK_ALREADY_IN_LIBRARY into a LibraryCtaDuplicate
///     so the screen can render the "서재에서 보기" affordance.
///
/// Keyed by book id so each detail screen owns its own state. `autoDispose`
/// so leaving the screen resets CTA state for the next visit.
///
/// Copied from [BookDetailNotifier].
@ProviderFor(BookDetailNotifier)
const bookDetailNotifierProvider = BookDetailNotifierFamily();

/// Detail screen notifier:
///   * loads a book by id,
///   * tracks the add-to-library CTA state,
///   * translates 409 BOOK_ALREADY_IN_LIBRARY into a LibraryCtaDuplicate
///     so the screen can render the "서재에서 보기" affordance.
///
/// Keyed by book id so each detail screen owns its own state. `autoDispose`
/// so leaving the screen resets CTA state for the next visit.
///
/// Copied from [BookDetailNotifier].
class BookDetailNotifierFamily extends Family<BookDetailState> {
  /// Detail screen notifier:
  ///   * loads a book by id,
  ///   * tracks the add-to-library CTA state,
  ///   * translates 409 BOOK_ALREADY_IN_LIBRARY into a LibraryCtaDuplicate
  ///     so the screen can render the "서재에서 보기" affordance.
  ///
  /// Keyed by book id so each detail screen owns its own state. `autoDispose`
  /// so leaving the screen resets CTA state for the next visit.
  ///
  /// Copied from [BookDetailNotifier].
  const BookDetailNotifierFamily();

  /// Detail screen notifier:
  ///   * loads a book by id,
  ///   * tracks the add-to-library CTA state,
  ///   * translates 409 BOOK_ALREADY_IN_LIBRARY into a LibraryCtaDuplicate
  ///     so the screen can render the "서재에서 보기" affordance.
  ///
  /// Keyed by book id so each detail screen owns its own state. `autoDispose`
  /// so leaving the screen resets CTA state for the next visit.
  ///
  /// Copied from [BookDetailNotifier].
  BookDetailNotifierProvider call(
    String bookId,
  ) {
    return BookDetailNotifierProvider(
      bookId,
    );
  }

  @override
  BookDetailNotifierProvider getProviderOverride(
    covariant BookDetailNotifierProvider provider,
  ) {
    return call(
      provider.bookId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bookDetailNotifierProvider';
}

/// Detail screen notifier:
///   * loads a book by id,
///   * tracks the add-to-library CTA state,
///   * translates 409 BOOK_ALREADY_IN_LIBRARY into a LibraryCtaDuplicate
///     so the screen can render the "서재에서 보기" affordance.
///
/// Keyed by book id so each detail screen owns its own state. `autoDispose`
/// so leaving the screen resets CTA state for the next visit.
///
/// Copied from [BookDetailNotifier].
class BookDetailNotifierProvider extends AutoDisposeNotifierProviderImpl<
    BookDetailNotifier, BookDetailState> {
  /// Detail screen notifier:
  ///   * loads a book by id,
  ///   * tracks the add-to-library CTA state,
  ///   * translates 409 BOOK_ALREADY_IN_LIBRARY into a LibraryCtaDuplicate
  ///     so the screen can render the "서재에서 보기" affordance.
  ///
  /// Keyed by book id so each detail screen owns its own state. `autoDispose`
  /// so leaving the screen resets CTA state for the next visit.
  ///
  /// Copied from [BookDetailNotifier].
  BookDetailNotifierProvider(
    String bookId,
  ) : this._internal(
          () => BookDetailNotifier()..bookId = bookId,
          from: bookDetailNotifierProvider,
          name: r'bookDetailNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookDetailNotifierHash,
          dependencies: BookDetailNotifierFamily._dependencies,
          allTransitiveDependencies:
              BookDetailNotifierFamily._allTransitiveDependencies,
          bookId: bookId,
        );

  BookDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookId,
  }) : super.internal();

  final String bookId;

  @override
  BookDetailState runNotifierBuild(
    covariant BookDetailNotifier notifier,
  ) {
    return notifier.build(
      bookId,
    );
  }

  @override
  Override overrideWith(BookDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: BookDetailNotifierProvider._internal(
        () => create()..bookId = bookId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookId: bookId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<BookDetailNotifier, BookDetailState>
      createElement() {
    return _BookDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookDetailNotifierProvider && other.bookId == bookId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BookDetailNotifierRef on AutoDisposeNotifierProviderRef<BookDetailState> {
  /// The parameter `bookId` of this provider.
  String get bookId;
}

class _BookDetailNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<BookDetailNotifier,
        BookDetailState> with BookDetailNotifierRef {
  _BookDetailNotifierProviderElement(super.provider);

  @override
  String get bookId => (origin as BookDetailNotifierProvider).bookId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
