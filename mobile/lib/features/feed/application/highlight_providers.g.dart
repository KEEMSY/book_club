// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'highlight_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$highlightApiHash() => r'6dac7eefc01fb6054576a49100f898bc11415766';

/// retrofit client for the M51 highlight social endpoints.
///
/// Copied from [highlightApi].
@ProviderFor(highlightApi)
final highlightApiProvider = AutoDisposeProvider<HighlightApi>.internal(
  highlightApi,
  name: r'highlightApiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$highlightApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HighlightApiRef = AutoDisposeProviderRef<HighlightApi>;
String _$highlightRepositoryHash() =>
    r'f7cdca5968a173cf4f0adfd4e6ed4bac244e913b';

/// Repository for visibility toggles, feed sharing, and explore listing.
///
/// Copied from [highlightRepository].
@ProviderFor(highlightRepository)
final highlightRepositoryProvider =
    AutoDisposeProvider<HighlightRepository>.internal(
  highlightRepository,
  name: r'highlightRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$highlightRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HighlightRepositoryRef = AutoDisposeProviderRef<HighlightRepository>;
String _$exploreHighlightsHash() => r'afc6aba1466a411b2c4f7effa7c9f7a69e3ab64b';

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

/// Public highlight explore feed.
///
/// autoDispose (the codegen default) releases the list when the explore
/// screen is popped; [sort] keys separate cached variants ("recent" / "top").
///
/// Copied from [exploreHighlights].
@ProviderFor(exploreHighlights)
const exploreHighlightsProvider = ExploreHighlightsFamily();

/// Public highlight explore feed.
///
/// autoDispose (the codegen default) releases the list when the explore
/// screen is popped; [sort] keys separate cached variants ("recent" / "top").
///
/// Copied from [exploreHighlights].
class ExploreHighlightsFamily
    extends Family<AsyncValue<List<HighlightExplore>>> {
  /// Public highlight explore feed.
  ///
  /// autoDispose (the codegen default) releases the list when the explore
  /// screen is popped; [sort] keys separate cached variants ("recent" / "top").
  ///
  /// Copied from [exploreHighlights].
  const ExploreHighlightsFamily();

  /// Public highlight explore feed.
  ///
  /// autoDispose (the codegen default) releases the list when the explore
  /// screen is popped; [sort] keys separate cached variants ("recent" / "top").
  ///
  /// Copied from [exploreHighlights].
  ExploreHighlightsProvider call({
    String sort = 'recent',
  }) {
    return ExploreHighlightsProvider(
      sort: sort,
    );
  }

  @override
  ExploreHighlightsProvider getProviderOverride(
    covariant ExploreHighlightsProvider provider,
  ) {
    return call(
      sort: provider.sort,
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
  String? get name => r'exploreHighlightsProvider';
}

/// Public highlight explore feed.
///
/// autoDispose (the codegen default) releases the list when the explore
/// screen is popped; [sort] keys separate cached variants ("recent" / "top").
///
/// Copied from [exploreHighlights].
class ExploreHighlightsProvider
    extends AutoDisposeFutureProvider<List<HighlightExplore>> {
  /// Public highlight explore feed.
  ///
  /// autoDispose (the codegen default) releases the list when the explore
  /// screen is popped; [sort] keys separate cached variants ("recent" / "top").
  ///
  /// Copied from [exploreHighlights].
  ExploreHighlightsProvider({
    String sort = 'recent',
  }) : this._internal(
          (ref) => exploreHighlights(
            ref as ExploreHighlightsRef,
            sort: sort,
          ),
          from: exploreHighlightsProvider,
          name: r'exploreHighlightsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$exploreHighlightsHash,
          dependencies: ExploreHighlightsFamily._dependencies,
          allTransitiveDependencies:
              ExploreHighlightsFamily._allTransitiveDependencies,
          sort: sort,
        );

  ExploreHighlightsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sort,
  }) : super.internal();

  final String sort;

  @override
  Override overrideWith(
    FutureOr<List<HighlightExplore>> Function(ExploreHighlightsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExploreHighlightsProvider._internal(
        (ref) => create(ref as ExploreHighlightsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sort: sort,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<HighlightExplore>> createElement() {
    return _ExploreHighlightsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExploreHighlightsProvider && other.sort == sort;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sort.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExploreHighlightsRef
    on AutoDisposeFutureProviderRef<List<HighlightExplore>> {
  /// The parameter `sort` of this provider.
  String get sort;
}

class _ExploreHighlightsProviderElement
    extends AutoDisposeFutureProviderElement<List<HighlightExplore>>
    with ExploreHighlightsRef {
  _ExploreHighlightsProviderElement(super.provider);

  @override
  String get sort => (origin as ExploreHighlightsProvider).sort;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
