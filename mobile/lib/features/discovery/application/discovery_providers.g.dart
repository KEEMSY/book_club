// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$discoveryRepositoryHash() =>
    r'c81672190c129d88bc6f78aff1ada2159293335f';

/// See also [discoveryRepository].
@ProviderFor(discoveryRepository)
final discoveryRepositoryProvider =
    AutoDisposeProvider<DiscoveryRepository>.internal(
  discoveryRepository,
  name: r'discoveryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$discoveryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DiscoveryRepositoryRef = AutoDisposeProviderRef<DiscoveryRepository>;
String _$recommendationsHash() => r'cac06b15dda56ce37780ef50957af1d09bf3c5c5';

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

/// M44 — fetches ML recommendations for the given [strategy].
///
/// [strategy] must be one of "collaborative", "similar_readers", or
/// "taste_match". Defaults to "collaborative" when omitted.
///
/// Copied from [recommendations].
@ProviderFor(recommendations)
const recommendationsProvider = RecommendationsFamily();

/// M44 — fetches ML recommendations for the given [strategy].
///
/// [strategy] must be one of "collaborative", "similar_readers", or
/// "taste_match". Defaults to "collaborative" when omitted.
///
/// Copied from [recommendations].
class RecommendationsFamily extends Family<AsyncValue<List<RecommendedBook>>> {
  /// M44 — fetches ML recommendations for the given [strategy].
  ///
  /// [strategy] must be one of "collaborative", "similar_readers", or
  /// "taste_match". Defaults to "collaborative" when omitted.
  ///
  /// Copied from [recommendations].
  const RecommendationsFamily();

  /// M44 — fetches ML recommendations for the given [strategy].
  ///
  /// [strategy] must be one of "collaborative", "similar_readers", or
  /// "taste_match". Defaults to "collaborative" when omitted.
  ///
  /// Copied from [recommendations].
  RecommendationsProvider call({
    String strategy = 'collaborative',
  }) {
    return RecommendationsProvider(
      strategy: strategy,
    );
  }

  @override
  RecommendationsProvider getProviderOverride(
    covariant RecommendationsProvider provider,
  ) {
    return call(
      strategy: provider.strategy,
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
  String? get name => r'recommendationsProvider';
}

/// M44 — fetches ML recommendations for the given [strategy].
///
/// [strategy] must be one of "collaborative", "similar_readers", or
/// "taste_match". Defaults to "collaborative" when omitted.
///
/// Copied from [recommendations].
class RecommendationsProvider
    extends AutoDisposeFutureProvider<List<RecommendedBook>> {
  /// M44 — fetches ML recommendations for the given [strategy].
  ///
  /// [strategy] must be one of "collaborative", "similar_readers", or
  /// "taste_match". Defaults to "collaborative" when omitted.
  ///
  /// Copied from [recommendations].
  RecommendationsProvider({
    String strategy = 'collaborative',
  }) : this._internal(
          (ref) => recommendations(
            ref as RecommendationsRef,
            strategy: strategy,
          ),
          from: recommendationsProvider,
          name: r'recommendationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recommendationsHash,
          dependencies: RecommendationsFamily._dependencies,
          allTransitiveDependencies:
              RecommendationsFamily._allTransitiveDependencies,
          strategy: strategy,
        );

  RecommendationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.strategy,
  }) : super.internal();

  final String strategy;

  @override
  Override overrideWith(
    FutureOr<List<RecommendedBook>> Function(RecommendationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecommendationsProvider._internal(
        (ref) => create(ref as RecommendationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        strategy: strategy,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RecommendedBook>> createElement() {
    return _RecommendationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecommendationsProvider && other.strategy == strategy;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, strategy.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecommendationsRef
    on AutoDisposeFutureProviderRef<List<RecommendedBook>> {
  /// The parameter `strategy` of this provider.
  String get strategy;
}

class _RecommendationsProviderElement
    extends AutoDisposeFutureProviderElement<List<RecommendedBook>>
    with RecommendationsRef {
  _RecommendationsProviderElement(super.provider);

  @override
  String get strategy => (origin as RecommendationsProvider).strategy;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
