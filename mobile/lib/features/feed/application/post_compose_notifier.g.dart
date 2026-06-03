// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_compose_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postComposeNotifierHash() =>
    r'c69147a2c43c9836b90db8f36036b51aaee906c6';

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

abstract class _$PostComposeNotifier
    extends BuildlessAutoDisposeNotifier<PostComposeState> {
  late final String bookId;

  PostComposeState build(
    String bookId,
  );
}

/// Drives the compose screen state machine.
///
/// Editing → Uploading(N images) → Posting → Success | Failure(retry)
///
/// On failure, content / type / picked-images are preserved so the user can
/// re-tap "공유" without losing what they typed. Maximum image attachments
/// is 4 — backend rejects anything more with `IMAGE_LIMIT_EXCEEDED`, but we
/// also cap on the client to avoid wasting the failing presign step.
///
/// Copied from [PostComposeNotifier].
@ProviderFor(PostComposeNotifier)
const postComposeNotifierProvider = PostComposeNotifierFamily();

/// Drives the compose screen state machine.
///
/// Editing → Uploading(N images) → Posting → Success | Failure(retry)
///
/// On failure, content / type / picked-images are preserved so the user can
/// re-tap "공유" without losing what they typed. Maximum image attachments
/// is 4 — backend rejects anything more with `IMAGE_LIMIT_EXCEEDED`, but we
/// also cap on the client to avoid wasting the failing presign step.
///
/// Copied from [PostComposeNotifier].
class PostComposeNotifierFamily extends Family<PostComposeState> {
  /// Drives the compose screen state machine.
  ///
  /// Editing → Uploading(N images) → Posting → Success | Failure(retry)
  ///
  /// On failure, content / type / picked-images are preserved so the user can
  /// re-tap "공유" without losing what they typed. Maximum image attachments
  /// is 4 — backend rejects anything more with `IMAGE_LIMIT_EXCEEDED`, but we
  /// also cap on the client to avoid wasting the failing presign step.
  ///
  /// Copied from [PostComposeNotifier].
  const PostComposeNotifierFamily();

  /// Drives the compose screen state machine.
  ///
  /// Editing → Uploading(N images) → Posting → Success | Failure(retry)
  ///
  /// On failure, content / type / picked-images are preserved so the user can
  /// re-tap "공유" without losing what they typed. Maximum image attachments
  /// is 4 — backend rejects anything more with `IMAGE_LIMIT_EXCEEDED`, but we
  /// also cap on the client to avoid wasting the failing presign step.
  ///
  /// Copied from [PostComposeNotifier].
  PostComposeNotifierProvider call(
    String bookId,
  ) {
    return PostComposeNotifierProvider(
      bookId,
    );
  }

  @override
  PostComposeNotifierProvider getProviderOverride(
    covariant PostComposeNotifierProvider provider,
  ) {
    return call(
      provider.bookId,
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
  String? get name => r'postComposeNotifierProvider';
}

/// Drives the compose screen state machine.
///
/// Editing → Uploading(N images) → Posting → Success | Failure(retry)
///
/// On failure, content / type / picked-images are preserved so the user can
/// re-tap "공유" without losing what they typed. Maximum image attachments
/// is 4 — backend rejects anything more with `IMAGE_LIMIT_EXCEEDED`, but we
/// also cap on the client to avoid wasting the failing presign step.
///
/// Copied from [PostComposeNotifier].
class PostComposeNotifierProvider extends AutoDisposeNotifierProviderImpl<
    PostComposeNotifier, PostComposeState> {
  /// Drives the compose screen state machine.
  ///
  /// Editing → Uploading(N images) → Posting → Success | Failure(retry)
  ///
  /// On failure, content / type / picked-images are preserved so the user can
  /// re-tap "공유" without losing what they typed. Maximum image attachments
  /// is 4 — backend rejects anything more with `IMAGE_LIMIT_EXCEEDED`, but we
  /// also cap on the client to avoid wasting the failing presign step.
  ///
  /// Copied from [PostComposeNotifier].
  PostComposeNotifierProvider(
    String bookId,
  ) : this._internal(
          () => PostComposeNotifier()..bookId = bookId,
          from: postComposeNotifierProvider,
          name: r'postComposeNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postComposeNotifierHash,
          dependencies: PostComposeNotifierFamily._dependencies,
          allTransitiveDependencies:
              PostComposeNotifierFamily._allTransitiveDependencies,
          bookId: bookId,
        );

  PostComposeNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookId,
  }) : super.internal();

  final String bookId;

  @override
  PostComposeState runNotifierBuild(
    covariant PostComposeNotifier notifier,
  ) {
    return notifier.build(
      bookId,
    );
  }

  @override
  Override overrideWith(PostComposeNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: PostComposeNotifierProvider._internal(
        () => create()..bookId = bookId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookId: bookId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<PostComposeNotifier, PostComposeState>
      createElement() {
    return _PostComposeNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostComposeNotifierProvider && other.bookId == bookId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostComposeNotifierRef
    on AutoDisposeNotifierProviderRef<PostComposeState> {
  /// The parameter `bookId` of this provider.
  String get bookId;
}

class _PostComposeNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<PostComposeNotifier,
        PostComposeState> with PostComposeNotifierRef {
  _PostComposeNotifierProviderElement(super.provider);

  @override
  String get bookId => (origin as PostComposeNotifierProvider).bookId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
