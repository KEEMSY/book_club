// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heatmap_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$heatmapNotifierHash() => r'1f85d9659de194d96d90ae78b7b94fbf14519155';

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

abstract class _$HeatmapNotifier
    extends BuildlessAutoDisposeNotifier<HeatmapState> {
  late final int year;

  HeatmapState build(
    int year,
  );
}

/// Manages the heatmap fetch for a specific [year].
///
/// Parameterised as a family provider so the dashboard can always watch
/// the current-year notifier for `todaySeconds`, while the `_HeatmapCard`
/// independently loads whichever year the user has navigated to. Each year's
/// data is cached for the lifetime of its listener.
///
/// Date range:
///   * Current year: Jan 1 → today (live window, re-fetched on invalidate).
///   * Past year:    Jan 1 → Dec 31 (static; re-fetched only when forced).
///
/// Copied from [HeatmapNotifier].
@ProviderFor(HeatmapNotifier)
const heatmapNotifierProvider = HeatmapNotifierFamily();

/// Manages the heatmap fetch for a specific [year].
///
/// Parameterised as a family provider so the dashboard can always watch
/// the current-year notifier for `todaySeconds`, while the `_HeatmapCard`
/// independently loads whichever year the user has navigated to. Each year's
/// data is cached for the lifetime of its listener.
///
/// Date range:
///   * Current year: Jan 1 → today (live window, re-fetched on invalidate).
///   * Past year:    Jan 1 → Dec 31 (static; re-fetched only when forced).
///
/// Copied from [HeatmapNotifier].
class HeatmapNotifierFamily extends Family<HeatmapState> {
  /// Manages the heatmap fetch for a specific [year].
  ///
  /// Parameterised as a family provider so the dashboard can always watch
  /// the current-year notifier for `todaySeconds`, while the `_HeatmapCard`
  /// independently loads whichever year the user has navigated to. Each year's
  /// data is cached for the lifetime of its listener.
  ///
  /// Date range:
  ///   * Current year: Jan 1 → today (live window, re-fetched on invalidate).
  ///   * Past year:    Jan 1 → Dec 31 (static; re-fetched only when forced).
  ///
  /// Copied from [HeatmapNotifier].
  const HeatmapNotifierFamily();

  /// Manages the heatmap fetch for a specific [year].
  ///
  /// Parameterised as a family provider so the dashboard can always watch
  /// the current-year notifier for `todaySeconds`, while the `_HeatmapCard`
  /// independently loads whichever year the user has navigated to. Each year's
  /// data is cached for the lifetime of its listener.
  ///
  /// Date range:
  ///   * Current year: Jan 1 → today (live window, re-fetched on invalidate).
  ///   * Past year:    Jan 1 → Dec 31 (static; re-fetched only when forced).
  ///
  /// Copied from [HeatmapNotifier].
  HeatmapNotifierProvider call(
    int year,
  ) {
    return HeatmapNotifierProvider(
      year,
    );
  }

  @override
  HeatmapNotifierProvider getProviderOverride(
    covariant HeatmapNotifierProvider provider,
  ) {
    return call(
      provider.year,
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
  String? get name => r'heatmapNotifierProvider';
}

/// Manages the heatmap fetch for a specific [year].
///
/// Parameterised as a family provider so the dashboard can always watch
/// the current-year notifier for `todaySeconds`, while the `_HeatmapCard`
/// independently loads whichever year the user has navigated to. Each year's
/// data is cached for the lifetime of its listener.
///
/// Date range:
///   * Current year: Jan 1 → today (live window, re-fetched on invalidate).
///   * Past year:    Jan 1 → Dec 31 (static; re-fetched only when forced).
///
/// Copied from [HeatmapNotifier].
class HeatmapNotifierProvider
    extends AutoDisposeNotifierProviderImpl<HeatmapNotifier, HeatmapState> {
  /// Manages the heatmap fetch for a specific [year].
  ///
  /// Parameterised as a family provider so the dashboard can always watch
  /// the current-year notifier for `todaySeconds`, while the `_HeatmapCard`
  /// independently loads whichever year the user has navigated to. Each year's
  /// data is cached for the lifetime of its listener.
  ///
  /// Date range:
  ///   * Current year: Jan 1 → today (live window, re-fetched on invalidate).
  ///   * Past year:    Jan 1 → Dec 31 (static; re-fetched only when forced).
  ///
  /// Copied from [HeatmapNotifier].
  HeatmapNotifierProvider(
    int year,
  ) : this._internal(
          () => HeatmapNotifier()..year = year,
          from: heatmapNotifierProvider,
          name: r'heatmapNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$heatmapNotifierHash,
          dependencies: HeatmapNotifierFamily._dependencies,
          allTransitiveDependencies:
              HeatmapNotifierFamily._allTransitiveDependencies,
          year: year,
        );

  HeatmapNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
  }) : super.internal();

  final int year;

  @override
  HeatmapState runNotifierBuild(
    covariant HeatmapNotifier notifier,
  ) {
    return notifier.build(
      year,
    );
  }

  @override
  Override overrideWith(HeatmapNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: HeatmapNotifierProvider._internal(
        () => create()..year = year,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<HeatmapNotifier, HeatmapState>
      createElement() {
    return _HeatmapNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HeatmapNotifierProvider && other.year == year;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HeatmapNotifierRef on AutoDisposeNotifierProviderRef<HeatmapState> {
  /// The parameter `year` of this provider.
  int get year;
}

class _HeatmapNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<HeatmapNotifier, HeatmapState>
    with HeatmapNotifierRef {
  _HeatmapNotifierProviderElement(super.provider);

  @override
  int get year => (origin as HeatmapNotifierProvider).year;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
