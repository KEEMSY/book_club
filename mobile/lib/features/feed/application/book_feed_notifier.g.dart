// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_feed_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookFeedNotifierHash() => r'd7a4fc17f36fdfb0249348c51f9522461ced709a';

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

abstract class _$BookFeedNotifier
    extends BuildlessAutoDisposeNotifier<BookFeedState> {
  late final String bookId;

  BookFeedState build(
    String bookId,
  );
}

/// Notifier for the per-book feed list.
///
/// Cursor pagination on `created_at DESC`: the first page hits without
/// a cursor; subsequent pages pass the previous response's `next_cursor`.
/// `loadMore` is a no-op once the server returns `next_cursor: null`.
///
/// Copied from [BookFeedNotifier].
@ProviderFor(BookFeedNotifier)
const bookFeedNotifierProvider = BookFeedNotifierFamily();

/// Notifier for the per-book feed list.
///
/// Cursor pagination on `created_at DESC`: the first page hits without
/// a cursor; subsequent pages pass the previous response's `next_cursor`.
/// `loadMore` is a no-op once the server returns `next_cursor: null`.
///
/// Copied from [BookFeedNotifier].
class BookFeedNotifierFamily extends Family<BookFeedState> {
  /// Notifier for the per-book feed list.
  ///
  /// Cursor pagination on `created_at DESC`: the first page hits without
  /// a cursor; subsequent pages pass the previous response's `next_cursor`.
  /// `loadMore` is a no-op once the server returns `next_cursor: null`.
  ///
  /// Copied from [BookFeedNotifier].
  const BookFeedNotifierFamily();

  /// Notifier for the per-book feed list.
  ///
  /// Cursor pagination on `created_at DESC`: the first page hits without
  /// a cursor; subsequent pages pass the previous response's `next_cursor`.
  /// `loadMore` is a no-op once the server returns `next_cursor: null`.
  ///
  /// Copied from [BookFeedNotifier].
  BookFeedNotifierProvider call(
    String bookId,
  ) {
    return BookFeedNotifierProvider(
      bookId,
    );
  }

  @override
  BookFeedNotifierProvider getProviderOverride(
    covariant BookFeedNotifierProvider provider,
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
  String? get name => r'bookFeedNotifierProvider';
}

/// Notifier for the per-book feed list.
///
/// Cursor pagination on `created_at DESC`: the first page hits without
/// a cursor; subsequent pages pass the previous response's `next_cursor`.
/// `loadMore` is a no-op once the server returns `next_cursor: null`.
///
/// Copied from [BookFeedNotifier].
class BookFeedNotifierProvider
    extends AutoDisposeNotifierProviderImpl<BookFeedNotifier, BookFeedState> {
  /// Notifier for the per-book feed list.
  ///
  /// Cursor pagination on `created_at DESC`: the first page hits without
  /// a cursor; subsequent pages pass the previous response's `next_cursor`.
  /// `loadMore` is a no-op once the server returns `next_cursor: null`.
  ///
  /// Copied from [BookFeedNotifier].
  BookFeedNotifierProvider(
    String bookId,
  ) : this._internal(
          () => BookFeedNotifier()..bookId = bookId,
          from: bookFeedNotifierProvider,
          name: r'bookFeedNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookFeedNotifierHash,
          dependencies: BookFeedNotifierFamily._dependencies,
          allTransitiveDependencies:
              BookFeedNotifierFamily._allTransitiveDependencies,
          bookId: bookId,
        );

  BookFeedNotifierProvider._internal(
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
  BookFeedState runNotifierBuild(
    covariant BookFeedNotifier notifier,
  ) {
    return notifier.build(
      bookId,
    );
  }

  @override
  Override overrideWith(BookFeedNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: BookFeedNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<BookFeedNotifier, BookFeedState>
      createElement() {
    return _BookFeedNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookFeedNotifierProvider && other.bookId == bookId;
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
mixin BookFeedNotifierRef on AutoDisposeNotifierProviderRef<BookFeedState> {
  /// The parameter `bookId` of this provider.
  String get bookId;
}

class _BookFeedNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<BookFeedNotifier, BookFeedState>
    with BookFeedNotifierRef {
  _BookFeedNotifierProviderElement(super.provider);

  @override
  String get bookId => (origin as BookFeedNotifierProvider).bookId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
