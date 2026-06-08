// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_room_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clubRoomsHash() => r'14323826575e2bcbfe4bdbae367edeeb74d454fd';

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

/// Fetches the list of chapter-gated chat rooms for [clubId].
///
/// Auto-disposed and family-keyed by club ID so multiple club detail screens
/// can be open simultaneously without sharing state.
///
/// Copied from [clubRooms].
@ProviderFor(clubRooms)
const clubRoomsProvider = ClubRoomsFamily();

/// Fetches the list of chapter-gated chat rooms for [clubId].
///
/// Auto-disposed and family-keyed by club ID so multiple club detail screens
/// can be open simultaneously without sharing state.
///
/// Copied from [clubRooms].
class ClubRoomsFamily extends Family<AsyncValue<List<ClubRoom>>> {
  /// Fetches the list of chapter-gated chat rooms for [clubId].
  ///
  /// Auto-disposed and family-keyed by club ID so multiple club detail screens
  /// can be open simultaneously without sharing state.
  ///
  /// Copied from [clubRooms].
  const ClubRoomsFamily();

  /// Fetches the list of chapter-gated chat rooms for [clubId].
  ///
  /// Auto-disposed and family-keyed by club ID so multiple club detail screens
  /// can be open simultaneously without sharing state.
  ///
  /// Copied from [clubRooms].
  ClubRoomsProvider call(
    String clubId,
  ) {
    return ClubRoomsProvider(
      clubId,
    );
  }

  @override
  ClubRoomsProvider getProviderOverride(
    covariant ClubRoomsProvider provider,
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
  String? get name => r'clubRoomsProvider';
}

/// Fetches the list of chapter-gated chat rooms for [clubId].
///
/// Auto-disposed and family-keyed by club ID so multiple club detail screens
/// can be open simultaneously without sharing state.
///
/// Copied from [clubRooms].
class ClubRoomsProvider extends AutoDisposeFutureProvider<List<ClubRoom>> {
  /// Fetches the list of chapter-gated chat rooms for [clubId].
  ///
  /// Auto-disposed and family-keyed by club ID so multiple club detail screens
  /// can be open simultaneously without sharing state.
  ///
  /// Copied from [clubRooms].
  ClubRoomsProvider(
    String clubId,
  ) : this._internal(
          (ref) => clubRooms(
            ref as ClubRoomsRef,
            clubId,
          ),
          from: clubRoomsProvider,
          name: r'clubRoomsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clubRoomsHash,
          dependencies: ClubRoomsFamily._dependencies,
          allTransitiveDependencies: ClubRoomsFamily._allTransitiveDependencies,
          clubId: clubId,
        );

  ClubRoomsProvider._internal(
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
    FutureOr<List<ClubRoom>> Function(ClubRoomsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ClubRoomsProvider._internal(
        (ref) => create(ref as ClubRoomsRef),
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
  AutoDisposeFutureProviderElement<List<ClubRoom>> createElement() {
    return _ClubRoomsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClubRoomsProvider && other.clubId == clubId;
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
mixin ClubRoomsRef on AutoDisposeFutureProviderRef<List<ClubRoom>> {
  /// The parameter `clubId` of this provider.
  String get clubId;
}

class _ClubRoomsProviderElement
    extends AutoDisposeFutureProviderElement<List<ClubRoom>> with ClubRoomsRef {
  _ClubRoomsProviderElement(super.provider);

  @override
  String get clubId => (origin as ClubRoomsProvider).clubId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
