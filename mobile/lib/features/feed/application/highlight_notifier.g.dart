// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'highlight_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$highlightNotifierHash() => r'49758c2b0192573f998ea0435a4ca3d0312c61d0';

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

abstract class _$HighlightNotifier
    extends BuildlessAutoDisposeNotifier<HighlightState> {
  late final String userBookId;

  HighlightState build(
    String userBookId,
  );
}

/// Manages the list of private highlights for a single [UserBook].
///
/// Copied from [HighlightNotifier].
@ProviderFor(HighlightNotifier)
const highlightNotifierProvider = HighlightNotifierFamily();

/// Manages the list of private highlights for a single [UserBook].
///
/// Copied from [HighlightNotifier].
class HighlightNotifierFamily extends Family<HighlightState> {
  /// Manages the list of private highlights for a single [UserBook].
  ///
  /// Copied from [HighlightNotifier].
  const HighlightNotifierFamily();

  /// Manages the list of private highlights for a single [UserBook].
  ///
  /// Copied from [HighlightNotifier].
  HighlightNotifierProvider call(
    String userBookId,
  ) {
    return HighlightNotifierProvider(
      userBookId,
    );
  }

  @override
  HighlightNotifierProvider getProviderOverride(
    covariant HighlightNotifierProvider provider,
  ) {
    return call(
      provider.userBookId,
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
  String? get name => r'highlightNotifierProvider';
}

/// Manages the list of private highlights for a single [UserBook].
///
/// Copied from [HighlightNotifier].
class HighlightNotifierProvider
    extends AutoDisposeNotifierProviderImpl<HighlightNotifier, HighlightState> {
  /// Manages the list of private highlights for a single [UserBook].
  ///
  /// Copied from [HighlightNotifier].
  HighlightNotifierProvider(
    String userBookId,
  ) : this._internal(
          () => HighlightNotifier()..userBookId = userBookId,
          from: highlightNotifierProvider,
          name: r'highlightNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$highlightNotifierHash,
          dependencies: HighlightNotifierFamily._dependencies,
          allTransitiveDependencies:
              HighlightNotifierFamily._allTransitiveDependencies,
          userBookId: userBookId,
        );

  HighlightNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userBookId,
  }) : super.internal();

  final String userBookId;

  @override
  HighlightState runNotifierBuild(
    covariant HighlightNotifier notifier,
  ) {
    return notifier.build(
      userBookId,
    );
  }

  @override
  Override overrideWith(HighlightNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: HighlightNotifierProvider._internal(
        () => create()..userBookId = userBookId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userBookId: userBookId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<HighlightNotifier, HighlightState>
      createElement() {
    return _HighlightNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HighlightNotifierProvider && other.userBookId == userBookId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userBookId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HighlightNotifierRef on AutoDisposeNotifierProviderRef<HighlightState> {
  /// The parameter `userBookId` of this provider.
  String get userBookId;
}

class _HighlightNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<HighlightNotifier,
        HighlightState> with HighlightNotifierRef {
  _HighlightNotifierProviderElement(super.provider);

  @override
  String get userBookId => (origin as HighlightNotifierProvider).userBookId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
