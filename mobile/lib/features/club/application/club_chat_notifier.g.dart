// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_chat_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clubChatNotifierHash() => r'f01b2f33e7f414442d590201d09d5eb50280d58e';

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

abstract class _$ClubChatNotifier extends BuildlessNotifier<ClubChatState> {
  late final String clubId;

  ClubChatState build(
    String clubId,
  );
}

/// See also [ClubChatNotifier].
@ProviderFor(ClubChatNotifier)
const clubChatNotifierProvider = ClubChatNotifierFamily();

/// See also [ClubChatNotifier].
class ClubChatNotifierFamily extends Family<ClubChatState> {
  /// See also [ClubChatNotifier].
  const ClubChatNotifierFamily();

  /// See also [ClubChatNotifier].
  ClubChatNotifierProvider call(
    String clubId,
  ) {
    return ClubChatNotifierProvider(
      clubId,
    );
  }

  @override
  ClubChatNotifierProvider getProviderOverride(
    covariant ClubChatNotifierProvider provider,
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
  String? get name => r'clubChatNotifierProvider';
}

/// See also [ClubChatNotifier].
class ClubChatNotifierProvider
    extends NotifierProviderImpl<ClubChatNotifier, ClubChatState> {
  /// See also [ClubChatNotifier].
  ClubChatNotifierProvider(
    String clubId,
  ) : this._internal(
          () => ClubChatNotifier()..clubId = clubId,
          from: clubChatNotifierProvider,
          name: r'clubChatNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clubChatNotifierHash,
          dependencies: ClubChatNotifierFamily._dependencies,
          allTransitiveDependencies:
              ClubChatNotifierFamily._allTransitiveDependencies,
          clubId: clubId,
        );

  ClubChatNotifierProvider._internal(
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
  ClubChatState runNotifierBuild(
    covariant ClubChatNotifier notifier,
  ) {
    return notifier.build(
      clubId,
    );
  }

  @override
  Override overrideWith(ClubChatNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ClubChatNotifierProvider._internal(
        () => create()..clubId = clubId,
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
  NotifierProviderElement<ClubChatNotifier, ClubChatState> createElement() {
    return _ClubChatNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClubChatNotifierProvider && other.clubId == clubId;
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
mixin ClubChatNotifierRef on NotifierProviderRef<ClubChatState> {
  /// The parameter `clubId` of this provider.
  String get clubId;
}

class _ClubChatNotifierProviderElement
    extends NotifierProviderElement<ClubChatNotifier, ClubChatState>
    with ClubChatNotifierRef {
  _ClubChatNotifierProviderElement(super.provider);

  @override
  String get clubId => (origin as ClubChatNotifierProvider).clubId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
