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
