// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_comments_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$topicCommentsHash() => r'afc80cdccbaf59a9bcea53fbea987b3dd745359a';

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

/// Fetches replies for [topicId].
///
/// BC-49 only uses this to derive a reply count and last-reply preview for
/// the collapsed agenda-topic accordion tile. The full threaded reply UI
/// (composer, nested rendering) is BC-51 — it reuses this same provider.
///
/// Copied from [topicComments].
@ProviderFor(topicComments)
const topicCommentsProvider = TopicCommentsFamily();

/// Fetches replies for [topicId].
///
/// BC-49 only uses this to derive a reply count and last-reply preview for
/// the collapsed agenda-topic accordion tile. The full threaded reply UI
/// (composer, nested rendering) is BC-51 — it reuses this same provider.
///
/// Copied from [topicComments].
class TopicCommentsFamily extends Family<AsyncValue<List<TopicComment>>> {
  /// Fetches replies for [topicId].
  ///
  /// BC-49 only uses this to derive a reply count and last-reply preview for
  /// the collapsed agenda-topic accordion tile. The full threaded reply UI
  /// (composer, nested rendering) is BC-51 — it reuses this same provider.
  ///
  /// Copied from [topicComments].
  const TopicCommentsFamily();

  /// Fetches replies for [topicId].
  ///
  /// BC-49 only uses this to derive a reply count and last-reply preview for
  /// the collapsed agenda-topic accordion tile. The full threaded reply UI
  /// (composer, nested rendering) is BC-51 — it reuses this same provider.
  ///
  /// Copied from [topicComments].
  TopicCommentsProvider call(
    String topicId,
  ) {
    return TopicCommentsProvider(
      topicId,
    );
  }

  @override
  TopicCommentsProvider getProviderOverride(
    covariant TopicCommentsProvider provider,
  ) {
    return call(
      provider.topicId,
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
  String? get name => r'topicCommentsProvider';
}

/// Fetches replies for [topicId].
///
/// BC-49 only uses this to derive a reply count and last-reply preview for
/// the collapsed agenda-topic accordion tile. The full threaded reply UI
/// (composer, nested rendering) is BC-51 — it reuses this same provider.
///
/// Copied from [topicComments].
class TopicCommentsProvider
    extends AutoDisposeFutureProvider<List<TopicComment>> {
  /// Fetches replies for [topicId].
  ///
  /// BC-49 only uses this to derive a reply count and last-reply preview for
  /// the collapsed agenda-topic accordion tile. The full threaded reply UI
  /// (composer, nested rendering) is BC-51 — it reuses this same provider.
  ///
  /// Copied from [topicComments].
  TopicCommentsProvider(
    String topicId,
  ) : this._internal(
          (ref) => topicComments(
            ref as TopicCommentsRef,
            topicId,
          ),
          from: topicCommentsProvider,
          name: r'topicCommentsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$topicCommentsHash,
          dependencies: TopicCommentsFamily._dependencies,
          allTransitiveDependencies:
              TopicCommentsFamily._allTransitiveDependencies,
          topicId: topicId,
        );

  TopicCommentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.topicId,
  }) : super.internal();

  final String topicId;

  @override
  Override overrideWith(
    FutureOr<List<TopicComment>> Function(TopicCommentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TopicCommentsProvider._internal(
        (ref) => create(ref as TopicCommentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        topicId: topicId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TopicComment>> createElement() {
    return _TopicCommentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TopicCommentsProvider && other.topicId == topicId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, topicId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TopicCommentsRef on AutoDisposeFutureProviderRef<List<TopicComment>> {
  /// The parameter `topicId` of this provider.
  String get topicId;
}

class _TopicCommentsProviderElement
    extends AutoDisposeFutureProviderElement<List<TopicComment>>
    with TopicCommentsRef {
  _TopicCommentsProviderElement(super.provider);

  @override
  String get topicId => (origin as TopicCommentsProvider).topicId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
