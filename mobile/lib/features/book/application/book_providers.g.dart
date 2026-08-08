// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookApiHash() => r'967d7c8cef5eed229883dff5d6a1f27d2a187c74';

/// retrofit client for `/books/*` and `/me/library` — built once per Dio.
///
/// Copied from [bookApi].
@ProviderFor(bookApi)
final bookApiProvider = AutoDisposeProvider<BookApi>.internal(
  bookApi,
  name: r'bookApiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bookApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BookApiRef = AutoDisposeProviderRef<BookApi>;
String _$bookRepositoryHash() => r'7f810233b5553e0ba379aa9d5a82025d9a99098f';

/// Thin wrapper that translates the retrofit client into a domain-shaped
/// repository. Notifiers (search, detail, library) consume this provider.
///
/// Copied from [bookRepository].
@ProviderFor(bookRepository)
final bookRepositoryProvider = AutoDisposeProvider<BookRepository>.internal(
  bookRepository,
  name: r'bookRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BookRepositoryRef = AutoDisposeProviderRef<BookRepository>;
String _$discoverBooksHash() => r'7c7d5010f15e3b0a43c3f160ae33f74197e1d624';

/// See also [discoverBooks].
@ProviderFor(discoverBooks)
final discoverBooksProvider =
    AutoDisposeFutureProvider<DiscoverResponseDto>.internal(
  discoverBooks,
  name: r'discoverBooksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$discoverBooksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DiscoverBooksRef = AutoDisposeFutureProviderRef<DiscoverResponseDto>;
String _$featuredBookHash() => r'47f96ff3833d1cc23708afce172ca7c66a8d09ea';

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

/// Fetches a single book by id — used by the profile header (BC-84) to
/// resolve a user's `featuredBookId` into title/cover for display.
/// `featuredBookId` is a bare id on `UserProfile`/`AuthUser`; this stays a
/// plain family provider (not baked into the profile fetch) so the profile
/// endpoint doesn't have to join book data server-side.
///
/// Copied from [featuredBook].
@ProviderFor(featuredBook)
const featuredBookProvider = FeaturedBookFamily();

/// Fetches a single book by id — used by the profile header (BC-84) to
/// resolve a user's `featuredBookId` into title/cover for display.
/// `featuredBookId` is a bare id on `UserProfile`/`AuthUser`; this stays a
/// plain family provider (not baked into the profile fetch) so the profile
/// endpoint doesn't have to join book data server-side.
///
/// Copied from [featuredBook].
class FeaturedBookFamily extends Family<AsyncValue<Book>> {
  /// Fetches a single book by id — used by the profile header (BC-84) to
  /// resolve a user's `featuredBookId` into title/cover for display.
  /// `featuredBookId` is a bare id on `UserProfile`/`AuthUser`; this stays a
  /// plain family provider (not baked into the profile fetch) so the profile
  /// endpoint doesn't have to join book data server-side.
  ///
  /// Copied from [featuredBook].
  const FeaturedBookFamily();

  /// Fetches a single book by id — used by the profile header (BC-84) to
  /// resolve a user's `featuredBookId` into title/cover for display.
  /// `featuredBookId` is a bare id on `UserProfile`/`AuthUser`; this stays a
  /// plain family provider (not baked into the profile fetch) so the profile
  /// endpoint doesn't have to join book data server-side.
  ///
  /// Copied from [featuredBook].
  FeaturedBookProvider call(
    String bookId,
  ) {
    return FeaturedBookProvider(
      bookId,
    );
  }

  @override
  FeaturedBookProvider getProviderOverride(
    covariant FeaturedBookProvider provider,
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
  String? get name => r'featuredBookProvider';
}

/// Fetches a single book by id — used by the profile header (BC-84) to
/// resolve a user's `featuredBookId` into title/cover for display.
/// `featuredBookId` is a bare id on `UserProfile`/`AuthUser`; this stays a
/// plain family provider (not baked into the profile fetch) so the profile
/// endpoint doesn't have to join book data server-side.
///
/// Copied from [featuredBook].
class FeaturedBookProvider extends AutoDisposeFutureProvider<Book> {
  /// Fetches a single book by id — used by the profile header (BC-84) to
  /// resolve a user's `featuredBookId` into title/cover for display.
  /// `featuredBookId` is a bare id on `UserProfile`/`AuthUser`; this stays a
  /// plain family provider (not baked into the profile fetch) so the profile
  /// endpoint doesn't have to join book data server-side.
  ///
  /// Copied from [featuredBook].
  FeaturedBookProvider(
    String bookId,
  ) : this._internal(
          (ref) => featuredBook(
            ref as FeaturedBookRef,
            bookId,
          ),
          from: featuredBookProvider,
          name: r'featuredBookProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$featuredBookHash,
          dependencies: FeaturedBookFamily._dependencies,
          allTransitiveDependencies:
              FeaturedBookFamily._allTransitiveDependencies,
          bookId: bookId,
        );

  FeaturedBookProvider._internal(
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
  Override overrideWith(
    FutureOr<Book> Function(FeaturedBookRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FeaturedBookProvider._internal(
        (ref) => create(ref as FeaturedBookRef),
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
  AutoDisposeFutureProviderElement<Book> createElement() {
    return _FeaturedBookProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeaturedBookProvider && other.bookId == bookId;
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
mixin FeaturedBookRef on AutoDisposeFutureProviderRef<Book> {
  /// The parameter `bookId` of this provider.
  String get bookId;
}

class _FeaturedBookProviderElement
    extends AutoDisposeFutureProviderElement<Book> with FeaturedBookRef {
  _FeaturedBookProviderElement(super.provider);

  @override
  String get bookId => (origin as FeaturedBookProvider).bookId;
}

String _$libraryPendingTabHash() => r'b8e23434821af4227cdfed77446536a843d7b788';

/// One-shot "jump to this tab" signal consumed by LibraryScreen.
/// Set before navigating to /library; the screen clears it after reading.
///
/// Copied from [LibraryPendingTab].
@ProviderFor(LibraryPendingTab)
final libraryPendingTabProvider =
    AutoDisposeNotifierProvider<LibraryPendingTab, BookStatus?>.internal(
  LibraryPendingTab.new,
  name: r'libraryPendingTabProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$libraryPendingTabHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LibraryPendingTab = AutoDisposeNotifier<BookStatus?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
