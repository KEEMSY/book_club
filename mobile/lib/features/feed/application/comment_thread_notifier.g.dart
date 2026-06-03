// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_thread_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$commentThreadNotifierHash() =>
    r'e11855a7aa3e36bc6a4064d94daece9e49ea754f';

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

abstract class _$CommentThreadNotifier
    extends BuildlessAutoDisposeNotifier<CommentThreadState> {
  late final String postId;

  CommentThreadState build(
    String postId,
  );
}

/// Drives the comments sheet — paginated comment list (ASC) plus an inline
/// composer state machine.
///
/// 1-level nesting: replies are siblings of root comments in the wire
/// payload (each carries its own `parent_id`). The UI groups them by parent
/// at render time; the backend rejects depth-2+ writes with 409
/// `COMMENT_DEPTH_EXCEEDED`. This notifier surfaces that code through
/// [CommentThreadLoaded.postError] so the composer can render an inline hint.
///
/// Copied from [CommentThreadNotifier].
@ProviderFor(CommentThreadNotifier)
const commentThreadNotifierProvider = CommentThreadNotifierFamily();

/// Drives the comments sheet — paginated comment list (ASC) plus an inline
/// composer state machine.
///
/// 1-level nesting: replies are siblings of root comments in the wire
/// payload (each carries its own `parent_id`). The UI groups them by parent
/// at render time; the backend rejects depth-2+ writes with 409
/// `COMMENT_DEPTH_EXCEEDED`. This notifier surfaces that code through
/// [CommentThreadLoaded.postError] so the composer can render an inline hint.
///
/// Copied from [CommentThreadNotifier].
class CommentThreadNotifierFamily extends Family<CommentThreadState> {
  /// Drives the comments sheet — paginated comment list (ASC) plus an inline
  /// composer state machine.
  ///
  /// 1-level nesting: replies are siblings of root comments in the wire
  /// payload (each carries its own `parent_id`). The UI groups them by parent
  /// at render time; the backend rejects depth-2+ writes with 409
  /// `COMMENT_DEPTH_EXCEEDED`. This notifier surfaces that code through
  /// [CommentThreadLoaded.postError] so the composer can render an inline hint.
  ///
  /// Copied from [CommentThreadNotifier].
  const CommentThreadNotifierFamily();

  /// Drives the comments sheet — paginated comment list (ASC) plus an inline
  /// composer state machine.
  ///
  /// 1-level nesting: replies are siblings of root comments in the wire
  /// payload (each carries its own `parent_id`). The UI groups them by parent
  /// at render time; the backend rejects depth-2+ writes with 409
  /// `COMMENT_DEPTH_EXCEEDED`. This notifier surfaces that code through
  /// [CommentThreadLoaded.postError] so the composer can render an inline hint.
  ///
  /// Copied from [CommentThreadNotifier].
  CommentThreadNotifierProvider call(
    String postId,
  ) {
    return CommentThreadNotifierProvider(
      postId,
    );
  }

  @override
  CommentThreadNotifierProvider getProviderOverride(
    covariant CommentThreadNotifierProvider provider,
  ) {
    return call(
      provider.postId,
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
  String? get name => r'commentThreadNotifierProvider';
}

/// Drives the comments sheet — paginated comment list (ASC) plus an inline
/// composer state machine.
///
/// 1-level nesting: replies are siblings of root comments in the wire
/// payload (each carries its own `parent_id`). The UI groups them by parent
/// at render time; the backend rejects depth-2+ writes with 409
/// `COMMENT_DEPTH_EXCEEDED`. This notifier surfaces that code through
/// [CommentThreadLoaded.postError] so the composer can render an inline hint.
///
/// Copied from [CommentThreadNotifier].
class CommentThreadNotifierProvider extends AutoDisposeNotifierProviderImpl<
    CommentThreadNotifier, CommentThreadState> {
  /// Drives the comments sheet — paginated comment list (ASC) plus an inline
  /// composer state machine.
  ///
  /// 1-level nesting: replies are siblings of root comments in the wire
  /// payload (each carries its own `parent_id`). The UI groups them by parent
  /// at render time; the backend rejects depth-2+ writes with 409
  /// `COMMENT_DEPTH_EXCEEDED`. This notifier surfaces that code through
  /// [CommentThreadLoaded.postError] so the composer can render an inline hint.
  ///
  /// Copied from [CommentThreadNotifier].
  CommentThreadNotifierProvider(
    String postId,
  ) : this._internal(
          () => CommentThreadNotifier()..postId = postId,
          from: commentThreadNotifierProvider,
          name: r'commentThreadNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$commentThreadNotifierHash,
          dependencies: CommentThreadNotifierFamily._dependencies,
          allTransitiveDependencies:
              CommentThreadNotifierFamily._allTransitiveDependencies,
          postId: postId,
        );

  CommentThreadNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  CommentThreadState runNotifierBuild(
    covariant CommentThreadNotifier notifier,
  ) {
    return notifier.build(
      postId,
    );
  }

  @override
  Override overrideWith(CommentThreadNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: CommentThreadNotifierProvider._internal(
        () => create()..postId = postId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<CommentThreadNotifier, CommentThreadState>
      createElement() {
    return _CommentThreadNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommentThreadNotifierProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CommentThreadNotifierRef
    on AutoDisposeNotifierProviderRef<CommentThreadState> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _CommentThreadNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<CommentThreadNotifier,
        CommentThreadState> with CommentThreadNotifierRef {
  _CommentThreadNotifierProviderElement(super.provider);

  @override
  String get postId => (origin as CommentThreadNotifierProvider).postId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
