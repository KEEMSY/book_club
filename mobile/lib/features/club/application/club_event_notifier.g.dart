// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_event_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clubEventsHash() => r'497d23704b7b72370eb49e03475d44cfe7586153';

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

/// See also [clubEvents].
@ProviderFor(clubEvents)
const clubEventsProvider = ClubEventsFamily();

/// See also [clubEvents].
class ClubEventsFamily extends Family<AsyncValue<List<ClubEvent>>> {
  /// See also [clubEvents].
  const ClubEventsFamily();

  /// See also [clubEvents].
  ClubEventsProvider call(
    String clubId,
  ) {
    return ClubEventsProvider(
      clubId,
    );
  }

  @override
  ClubEventsProvider getProviderOverride(
    covariant ClubEventsProvider provider,
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
  String? get name => r'clubEventsProvider';
}

/// See also [clubEvents].
class ClubEventsProvider extends AutoDisposeFutureProvider<List<ClubEvent>> {
  /// See also [clubEvents].
  ClubEventsProvider(
    String clubId,
  ) : this._internal(
          (ref) => clubEvents(
            ref as ClubEventsRef,
            clubId,
          ),
          from: clubEventsProvider,
          name: r'clubEventsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clubEventsHash,
          dependencies: ClubEventsFamily._dependencies,
          allTransitiveDependencies:
              ClubEventsFamily._allTransitiveDependencies,
          clubId: clubId,
        );

  ClubEventsProvider._internal(
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
    FutureOr<List<ClubEvent>> Function(ClubEventsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ClubEventsProvider._internal(
        (ref) => create(ref as ClubEventsRef),
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
  AutoDisposeFutureProviderElement<List<ClubEvent>> createElement() {
    return _ClubEventsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClubEventsProvider && other.clubId == clubId;
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
mixin ClubEventsRef on AutoDisposeFutureProviderRef<List<ClubEvent>> {
  /// The parameter `clubId` of this provider.
  String get clubId;
}

class _ClubEventsProviderElement
    extends AutoDisposeFutureProviderElement<List<ClubEvent>>
    with ClubEventsRef {
  _ClubEventsProviderElement(super.provider);

  @override
  String get clubId => (origin as ClubEventsProvider).clubId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
