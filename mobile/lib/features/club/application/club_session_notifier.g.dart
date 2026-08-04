// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clubSessionsHash() => r'5a2f63947386f6cb907f91bc06c8463e18c51e84';

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

/// Fetches all sessions ("회차") for [clubId].
///
/// Auto-disposed and family-keyed by club ID, same convention as
/// `clubRoomsProvider`. The list screen groups the result by
/// [ClubSession.bookId] client-side.
///
/// Copied from [clubSessions].
@ProviderFor(clubSessions)
const clubSessionsProvider = ClubSessionsFamily();

/// Fetches all sessions ("회차") for [clubId].
///
/// Auto-disposed and family-keyed by club ID, same convention as
/// `clubRoomsProvider`. The list screen groups the result by
/// [ClubSession.bookId] client-side.
///
/// Copied from [clubSessions].
class ClubSessionsFamily extends Family<AsyncValue<List<ClubSession>>> {
  /// Fetches all sessions ("회차") for [clubId].
  ///
  /// Auto-disposed and family-keyed by club ID, same convention as
  /// `clubRoomsProvider`. The list screen groups the result by
  /// [ClubSession.bookId] client-side.
  ///
  /// Copied from [clubSessions].
  const ClubSessionsFamily();

  /// Fetches all sessions ("회차") for [clubId].
  ///
  /// Auto-disposed and family-keyed by club ID, same convention as
  /// `clubRoomsProvider`. The list screen groups the result by
  /// [ClubSession.bookId] client-side.
  ///
  /// Copied from [clubSessions].
  ClubSessionsProvider call(
    String clubId,
  ) {
    return ClubSessionsProvider(
      clubId,
    );
  }

  @override
  ClubSessionsProvider getProviderOverride(
    covariant ClubSessionsProvider provider,
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
  String? get name => r'clubSessionsProvider';
}

/// Fetches all sessions ("회차") for [clubId].
///
/// Auto-disposed and family-keyed by club ID, same convention as
/// `clubRoomsProvider`. The list screen groups the result by
/// [ClubSession.bookId] client-side.
///
/// Copied from [clubSessions].
class ClubSessionsProvider
    extends AutoDisposeFutureProvider<List<ClubSession>> {
  /// Fetches all sessions ("회차") for [clubId].
  ///
  /// Auto-disposed and family-keyed by club ID, same convention as
  /// `clubRoomsProvider`. The list screen groups the result by
  /// [ClubSession.bookId] client-side.
  ///
  /// Copied from [clubSessions].
  ClubSessionsProvider(
    String clubId,
  ) : this._internal(
          (ref) => clubSessions(
            ref as ClubSessionsRef,
            clubId,
          ),
          from: clubSessionsProvider,
          name: r'clubSessionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clubSessionsHash,
          dependencies: ClubSessionsFamily._dependencies,
          allTransitiveDependencies:
              ClubSessionsFamily._allTransitiveDependencies,
          clubId: clubId,
        );

  ClubSessionsProvider._internal(
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
    FutureOr<List<ClubSession>> Function(ClubSessionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ClubSessionsProvider._internal(
        (ref) => create(ref as ClubSessionsRef),
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
  AutoDisposeFutureProviderElement<List<ClubSession>> createElement() {
    return _ClubSessionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClubSessionsProvider && other.clubId == clubId;
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
mixin ClubSessionsRef on AutoDisposeFutureProviderRef<List<ClubSession>> {
  /// The parameter `clubId` of this provider.
  String get clubId;
}

class _ClubSessionsProviderElement
    extends AutoDisposeFutureProviderElement<List<ClubSession>>
    with ClubSessionsRef {
  _ClubSessionsProviderElement(super.provider);

  @override
  String get clubId => (origin as ClubSessionsProvider).clubId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
