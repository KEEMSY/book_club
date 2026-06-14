// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchRepositoryHash() => r'7a7b1f4e97c2108472b29b80e343d9909c987127';

/// See also [searchRepository].
@ProviderFor(searchRepository)
final searchRepositoryProvider = AutoDisposeProvider<SearchRepository>.internal(
  searchRepository,
  name: r'searchRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SearchRepositoryRef = AutoDisposeProviderRef<SearchRepository>;
String _$searchResultsHash() => r'c97c1e7f16c21b4aac53bdbf52a327fa06d8b2fa';

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

/// Returns the unified search result for [query].
///
/// Returns `null` when the query is blank so the screen can distinguish
/// "user has not typed anything yet" from "the search returned no results".
///
/// Copied from [searchResults].
@ProviderFor(searchResults)
const searchResultsProvider = SearchResultsFamily();

/// Returns the unified search result for [query].
///
/// Returns `null` when the query is blank so the screen can distinguish
/// "user has not typed anything yet" from "the search returned no results".
///
/// Copied from [searchResults].
class SearchResultsFamily extends Family<AsyncValue<SearchResult?>> {
  /// Returns the unified search result for [query].
  ///
  /// Returns `null` when the query is blank so the screen can distinguish
  /// "user has not typed anything yet" from "the search returned no results".
  ///
  /// Copied from [searchResults].
  const SearchResultsFamily();

  /// Returns the unified search result for [query].
  ///
  /// Returns `null` when the query is blank so the screen can distinguish
  /// "user has not typed anything yet" from "the search returned no results".
  ///
  /// Copied from [searchResults].
  SearchResultsProvider call({
    required String query,
  }) {
    return SearchResultsProvider(
      query: query,
    );
  }

  @override
  SearchResultsProvider getProviderOverride(
    covariant SearchResultsProvider provider,
  ) {
    return call(
      query: provider.query,
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
  String? get name => r'searchResultsProvider';
}

/// Returns the unified search result for [query].
///
/// Returns `null` when the query is blank so the screen can distinguish
/// "user has not typed anything yet" from "the search returned no results".
///
/// Copied from [searchResults].
class SearchResultsProvider extends AutoDisposeFutureProvider<SearchResult?> {
  /// Returns the unified search result for [query].
  ///
  /// Returns `null` when the query is blank so the screen can distinguish
  /// "user has not typed anything yet" from "the search returned no results".
  ///
  /// Copied from [searchResults].
  SearchResultsProvider({
    required String query,
  }) : this._internal(
          (ref) => searchResults(
            ref as SearchResultsRef,
            query: query,
          ),
          from: searchResultsProvider,
          name: r'searchResultsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchResultsHash,
          dependencies: SearchResultsFamily._dependencies,
          allTransitiveDependencies:
              SearchResultsFamily._allTransitiveDependencies,
          query: query,
        );

  SearchResultsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<SearchResult?> Function(SearchResultsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchResultsProvider._internal(
        (ref) => create(ref as SearchResultsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SearchResult?> createElement() {
    return _SearchResultsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchResultsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchResultsRef on AutoDisposeFutureProviderRef<SearchResult?> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchResultsProviderElement
    extends AutoDisposeFutureProviderElement<SearchResult?>
    with SearchResultsRef {
  _SearchResultsProviderElement(super.provider);

  @override
  String get query => (origin as SearchResultsProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
