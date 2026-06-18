// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_plan_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$readingPlanRepositoryHash() =>
    r'da901a6d8d51fb2b3dd4edf227882ef02943e072';

/// See also [readingPlanRepository].
@ProviderFor(readingPlanRepository)
final readingPlanRepositoryProvider =
    AutoDisposeProvider<ReadingPlanRepository>.internal(
  readingPlanRepository,
  name: r'readingPlanRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$readingPlanRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReadingPlanRepositoryRef
    = AutoDisposeProviderRef<ReadingPlanRepository>;
String _$clubReadingPlanHash() => r'6b46e35ac7c7d8940ff9d9af5052684b2d99efd5';

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

/// The club's current reading plan, or null when none exists yet.
///
/// Copied from [clubReadingPlan].
@ProviderFor(clubReadingPlan)
const clubReadingPlanProvider = ClubReadingPlanFamily();

/// The club's current reading plan, or null when none exists yet.
///
/// Copied from [clubReadingPlan].
class ClubReadingPlanFamily extends Family<AsyncValue<ReadingPlan?>> {
  /// The club's current reading plan, or null when none exists yet.
  ///
  /// Copied from [clubReadingPlan].
  const ClubReadingPlanFamily();

  /// The club's current reading plan, or null when none exists yet.
  ///
  /// Copied from [clubReadingPlan].
  ClubReadingPlanProvider call(
    String clubId,
  ) {
    return ClubReadingPlanProvider(
      clubId,
    );
  }

  @override
  ClubReadingPlanProvider getProviderOverride(
    covariant ClubReadingPlanProvider provider,
  ) {
    return call(
      provider.clubId,
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
  String? get name => r'clubReadingPlanProvider';
}

/// The club's current reading plan, or null when none exists yet.
///
/// Copied from [clubReadingPlan].
class ClubReadingPlanProvider extends AutoDisposeFutureProvider<ReadingPlan?> {
  /// The club's current reading plan, or null when none exists yet.
  ///
  /// Copied from [clubReadingPlan].
  ClubReadingPlanProvider(
    String clubId,
  ) : this._internal(
          (ref) => clubReadingPlan(
            ref as ClubReadingPlanRef,
            clubId,
          ),
          from: clubReadingPlanProvider,
          name: r'clubReadingPlanProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clubReadingPlanHash,
          dependencies: ClubReadingPlanFamily._dependencies,
          allTransitiveDependencies:
              ClubReadingPlanFamily._allTransitiveDependencies,
          clubId: clubId,
        );

  ClubReadingPlanProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clubId,
  }) : super.internal();

  final String clubId;

  @override
  Override overrideWith(
    FutureOr<ReadingPlan?> Function(ClubReadingPlanRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ClubReadingPlanProvider._internal(
        (ref) => create(ref as ClubReadingPlanRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clubId: clubId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ReadingPlan?> createElement() {
    return _ClubReadingPlanProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClubReadingPlanProvider && other.clubId == clubId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clubId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ClubReadingPlanRef on AutoDisposeFutureProviderRef<ReadingPlan?> {
  /// The parameter `clubId` of this provider.
  String get clubId;
}

class _ClubReadingPlanProviderElement
    extends AutoDisposeFutureProviderElement<ReadingPlan?>
    with ClubReadingPlanRef {
  _ClubReadingPlanProviderElement(super.provider);

  @override
  String get clubId => (origin as ClubReadingPlanProvider).clubId;
}

String _$clubProgressHash() => r'2f99c893bf08dc9e04b5b1143e487d0ccd4acf06';

/// Aggregate member progress for the club plan.
///
/// Copied from [clubProgress].
@ProviderFor(clubProgress)
const clubProgressProvider = ClubProgressFamily();

/// Aggregate member progress for the club plan.
///
/// Copied from [clubProgress].
class ClubProgressFamily extends Family<AsyncValue<ClubProgress>> {
  /// Aggregate member progress for the club plan.
  ///
  /// Copied from [clubProgress].
  const ClubProgressFamily();

  /// Aggregate member progress for the club plan.
  ///
  /// Copied from [clubProgress].
  ClubProgressProvider call(
    String clubId,
  ) {
    return ClubProgressProvider(
      clubId,
    );
  }

  @override
  ClubProgressProvider getProviderOverride(
    covariant ClubProgressProvider provider,
  ) {
    return call(
      provider.clubId,
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
  String? get name => r'clubProgressProvider';
}

/// Aggregate member progress for the club plan.
///
/// Copied from [clubProgress].
class ClubProgressProvider extends AutoDisposeFutureProvider<ClubProgress> {
  /// Aggregate member progress for the club plan.
  ///
  /// Copied from [clubProgress].
  ClubProgressProvider(
    String clubId,
  ) : this._internal(
          (ref) => clubProgress(
            ref as ClubProgressRef,
            clubId,
          ),
          from: clubProgressProvider,
          name: r'clubProgressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clubProgressHash,
          dependencies: ClubProgressFamily._dependencies,
          allTransitiveDependencies:
              ClubProgressFamily._allTransitiveDependencies,
          clubId: clubId,
        );

  ClubProgressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clubId,
  }) : super.internal();

  final String clubId;

  @override
  Override overrideWith(
    FutureOr<ClubProgress> Function(ClubProgressRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ClubProgressProvider._internal(
        (ref) => create(ref as ClubProgressRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clubId: clubId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ClubProgress> createElement() {
    return _ClubProgressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClubProgressProvider && other.clubId == clubId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clubId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ClubProgressRef on AutoDisposeFutureProviderRef<ClubProgress> {
  /// The parameter `clubId` of this provider.
  String get clubId;
}

class _ClubProgressProviderElement
    extends AutoDisposeFutureProviderElement<ClubProgress>
    with ClubProgressRef {
  _ClubProgressProviderElement(super.provider);

  @override
  String get clubId => (origin as ClubProgressProvider).clubId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
