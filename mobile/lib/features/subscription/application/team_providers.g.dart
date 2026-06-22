// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teamHash() => r'18423d3fe9c27ebab51209f3f652970a3439e97c';

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

/// Team plan details + roster by id (`GET /teams/{id}`).
///
/// autoDispose: the admin screen only needs it while visible. Invalidate after
/// add/remove to refresh the roster and seat usage.
///
/// Copied from [team].
@ProviderFor(team)
const teamProvider = TeamFamily();

/// Team plan details + roster by id (`GET /teams/{id}`).
///
/// autoDispose: the admin screen only needs it while visible. Invalidate after
/// add/remove to refresh the roster and seat usage.
///
/// Copied from [team].
class TeamFamily extends Family<AsyncValue<TeamSubscription>> {
  /// Team plan details + roster by id (`GET /teams/{id}`).
  ///
  /// autoDispose: the admin screen only needs it while visible. Invalidate after
  /// add/remove to refresh the roster and seat usage.
  ///
  /// Copied from [team].
  const TeamFamily();

  /// Team plan details + roster by id (`GET /teams/{id}`).
  ///
  /// autoDispose: the admin screen only needs it while visible. Invalidate after
  /// add/remove to refresh the roster and seat usage.
  ///
  /// Copied from [team].
  TeamProvider call(
    String teamId,
  ) {
    return TeamProvider(
      teamId,
    );
  }

  @override
  TeamProvider getProviderOverride(
    covariant TeamProvider provider,
  ) {
    return call(
      provider.teamId,
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
  String? get name => r'teamProvider';
}

/// Team plan details + roster by id (`GET /teams/{id}`).
///
/// autoDispose: the admin screen only needs it while visible. Invalidate after
/// add/remove to refresh the roster and seat usage.
///
/// Copied from [team].
class TeamProvider extends AutoDisposeFutureProvider<TeamSubscription> {
  /// Team plan details + roster by id (`GET /teams/{id}`).
  ///
  /// autoDispose: the admin screen only needs it while visible. Invalidate after
  /// add/remove to refresh the roster and seat usage.
  ///
  /// Copied from [team].
  TeamProvider(
    String teamId,
  ) : this._internal(
          (ref) => team(
            ref as TeamRef,
            teamId,
          ),
          from: teamProvider,
          name: r'teamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$teamHash,
          dependencies: TeamFamily._dependencies,
          allTransitiveDependencies: TeamFamily._allTransitiveDependencies,
          teamId: teamId,
        );

  TeamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.teamId,
  }) : super.internal();

  final String teamId;

  @override
  Override overrideWith(
    FutureOr<TeamSubscription> Function(TeamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TeamProvider._internal(
        (ref) => create(ref as TeamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        teamId: teamId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TeamSubscription> createElement() {
    return _TeamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamProvider && other.teamId == teamId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, teamId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TeamRef on AutoDisposeFutureProviderRef<TeamSubscription> {
  /// The parameter `teamId` of this provider.
  String get teamId;
}

class _TeamProviderElement
    extends AutoDisposeFutureProviderElement<TeamSubscription> with TeamRef {
  _TeamProviderElement(super.provider);

  @override
  String get teamId => (origin as TeamProvider).teamId;
}

String _$myTeamHash() => r'e8ec56fb443302d85e82eb83392b844baf023150';

/// The current user's team, or `null` when they belong to none.
///
/// The team id is read from local prefs (no "my teams" endpoint in the MVP);
/// returns `null` when unset so callers can hide team UI.
///
/// Copied from [myTeam].
@ProviderFor(myTeam)
final myTeamProvider = AutoDisposeFutureProvider<TeamSubscription?>.internal(
  myTeam,
  name: r'myTeamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myTeamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyTeamRef = AutoDisposeFutureProviderRef<TeamSubscription?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
