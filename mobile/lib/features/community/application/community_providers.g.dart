// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$followingFeedHash() => r'5aa870819c4c6ed4f14de122006134fea7449378';

/// See also [FollowingFeed].
@ProviderFor(FollowingFeed)
final followingFeedProvider =
    AutoDisposeNotifierProvider<FollowingFeed, FeedState>.internal(
  FollowingFeed.new,
  name: r'followingFeedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$followingFeedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FollowingFeed = AutoDisposeNotifier<FeedState>;
String _$userPostsFeedHash() => r'f52759c6fa54a29b66283a6af04140738efcdf71';

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

abstract class _$UserPostsFeed extends BuildlessAutoDisposeNotifier<FeedState> {
  late final String userId;

  FeedState build(
    String userId,
  );
}

/// See also [UserPostsFeed].
@ProviderFor(UserPostsFeed)
const userPostsFeedProvider = UserPostsFeedFamily();

/// See also [UserPostsFeed].
class UserPostsFeedFamily extends Family<FeedState> {
  /// See also [UserPostsFeed].
  const UserPostsFeedFamily();

  /// See also [UserPostsFeed].
  UserPostsFeedProvider call(
    String userId,
  ) {
    return UserPostsFeedProvider(
      userId,
    );
  }

  @override
  UserPostsFeedProvider getProviderOverride(
    covariant UserPostsFeedProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userPostsFeedProvider';
}

/// See also [UserPostsFeed].
class UserPostsFeedProvider
    extends AutoDisposeNotifierProviderImpl<UserPostsFeed, FeedState> {
  /// See also [UserPostsFeed].
  UserPostsFeedProvider(
    String userId,
  ) : this._internal(
          () => UserPostsFeed()..userId = userId,
          from: userPostsFeedProvider,
          name: r'userPostsFeedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userPostsFeedHash,
          dependencies: UserPostsFeedFamily._dependencies,
          allTransitiveDependencies:
              UserPostsFeedFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserPostsFeedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  FeedState runNotifierBuild(
    covariant UserPostsFeed notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(UserPostsFeed Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserPostsFeedProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<UserPostsFeed, FeedState> createElement() {
    return _UserPostsFeedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserPostsFeedProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserPostsFeedRef on AutoDisposeNotifierProviderRef<FeedState> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserPostsFeedProviderElement
    extends AutoDisposeNotifierProviderElement<UserPostsFeed, FeedState>
    with UserPostsFeedRef {
  _UserPostsFeedProviderElement(super.provider);

  @override
  String get userId => (origin as UserPostsFeedProvider).userId;
}

String _$exploreFeedHash() => r'aab605cfe33e4ea0082889774635333bc6f1f4eb';

abstract class _$ExploreFeed extends BuildlessAutoDisposeNotifier<FeedState> {
  late final String sort;

  FeedState build(
    String sort,
  );
}

/// See also [ExploreFeed].
@ProviderFor(ExploreFeed)
const exploreFeedProvider = ExploreFeedFamily();

/// See also [ExploreFeed].
class ExploreFeedFamily extends Family<FeedState> {
  /// See also [ExploreFeed].
  const ExploreFeedFamily();

  /// See also [ExploreFeed].
  ExploreFeedProvider call(
    String sort,
  ) {
    return ExploreFeedProvider(
      sort,
    );
  }

  @override
  ExploreFeedProvider getProviderOverride(
    covariant ExploreFeedProvider provider,
  ) {
    return call(
      provider.sort,
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
  String? get name => r'exploreFeedProvider';
}

/// See also [ExploreFeed].
class ExploreFeedProvider
    extends AutoDisposeNotifierProviderImpl<ExploreFeed, FeedState> {
  /// See also [ExploreFeed].
  ExploreFeedProvider(
    String sort,
  ) : this._internal(
          () => ExploreFeed()..sort = sort,
          from: exploreFeedProvider,
          name: r'exploreFeedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$exploreFeedHash,
          dependencies: ExploreFeedFamily._dependencies,
          allTransitiveDependencies:
              ExploreFeedFamily._allTransitiveDependencies,
          sort: sort,
        );

  ExploreFeedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sort,
  }) : super.internal();

  final String sort;

  @override
  FeedState runNotifierBuild(
    covariant ExploreFeed notifier,
  ) {
    return notifier.build(
      sort,
    );
  }

  @override
  Override overrideWith(ExploreFeed Function() create) {
    return ProviderOverride(
      origin: this,
      override: ExploreFeedProvider._internal(
        () => create()..sort = sort,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sort: sort,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ExploreFeed, FeedState> createElement() {
    return _ExploreFeedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExploreFeedProvider && other.sort == sort;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sort.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExploreFeedRef on AutoDisposeNotifierProviderRef<FeedState> {
  /// The parameter `sort` of this provider.
  String get sort;
}

class _ExploreFeedProviderElement
    extends AutoDisposeNotifierProviderElement<ExploreFeed, FeedState>
    with ExploreFeedRef {
  _ExploreFeedProviderElement(super.provider);

  @override
  String get sort => (origin as ExploreFeedProvider).sort;
}

String _$highlightFeedHash() => r'c7f818067edd8370708c489011ee91f6045db644';

/// See also [HighlightFeed].
@ProviderFor(HighlightFeed)
final highlightFeedProvider =
    AutoDisposeNotifierProvider<HighlightFeed, FeedState>.internal(
  HighlightFeed.new,
  name: r'highlightFeedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$highlightFeedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HighlightFeed = AutoDisposeNotifier<FeedState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
