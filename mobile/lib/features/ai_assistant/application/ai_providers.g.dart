// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiRepositoryHash() => r'eca0049ee7a1dc3b5a9147797675e036a1aaf1f2';

/// Retrofit-backed repository for the AI assistant endpoints — built once per
/// Dio instance and kept alive for the session.
///
/// Copied from [aiRepository].
@ProviderFor(aiRepository)
final aiRepositoryProvider = Provider<AiRepository>.internal(
  aiRepository,
  name: r'aiRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$aiRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AiRepositoryRef = ProviderRef<AiRepository>;
String _$aiPrepCardHash() => r'aa551ee12b13d204e3e3ea6b05ffa14d8c314cd8';

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

/// Generates/returns the prep card for [bookId].
///
/// autoDispose: the prep sheet only needs it while open. The backend caches the
/// card for 72h, so re-opening is cheap and never re-charges the daily quota.
///
/// Copied from [aiPrepCard].
@ProviderFor(aiPrepCard)
const aiPrepCardProvider = AiPrepCardFamily();

/// Generates/returns the prep card for [bookId].
///
/// autoDispose: the prep sheet only needs it while open. The backend caches the
/// card for 72h, so re-opening is cheap and never re-charges the daily quota.
///
/// Copied from [aiPrepCard].
class AiPrepCardFamily extends Family<AsyncValue<AiPrepCard>> {
  /// Generates/returns the prep card for [bookId].
  ///
  /// autoDispose: the prep sheet only needs it while open. The backend caches the
  /// card for 72h, so re-opening is cheap and never re-charges the daily quota.
  ///
  /// Copied from [aiPrepCard].
  const AiPrepCardFamily();

  /// Generates/returns the prep card for [bookId].
  ///
  /// autoDispose: the prep sheet only needs it while open. The backend caches the
  /// card for 72h, so re-opening is cheap and never re-charges the daily quota.
  ///
  /// Copied from [aiPrepCard].
  AiPrepCardProvider call({
    required String bookId,
  }) {
    return AiPrepCardProvider(
      bookId: bookId,
    );
  }

  @override
  AiPrepCardProvider getProviderOverride(
    covariant AiPrepCardProvider provider,
  ) {
    return call(
      bookId: provider.bookId,
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
  String? get name => r'aiPrepCardProvider';
}

/// Generates/returns the prep card for [bookId].
///
/// autoDispose: the prep sheet only needs it while open. The backend caches the
/// card for 72h, so re-opening is cheap and never re-charges the daily quota.
///
/// Copied from [aiPrepCard].
class AiPrepCardProvider extends AutoDisposeFutureProvider<AiPrepCard> {
  /// Generates/returns the prep card for [bookId].
  ///
  /// autoDispose: the prep sheet only needs it while open. The backend caches the
  /// card for 72h, so re-opening is cheap and never re-charges the daily quota.
  ///
  /// Copied from [aiPrepCard].
  AiPrepCardProvider({
    required String bookId,
  }) : this._internal(
          (ref) => aiPrepCard(
            ref as AiPrepCardRef,
            bookId: bookId,
          ),
          from: aiPrepCardProvider,
          name: r'aiPrepCardProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$aiPrepCardHash,
          dependencies: AiPrepCardFamily._dependencies,
          allTransitiveDependencies:
              AiPrepCardFamily._allTransitiveDependencies,
          bookId: bookId,
        );

  AiPrepCardProvider._internal(
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
  Override overrideWith(
    FutureOr<AiPrepCard> Function(AiPrepCardRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AiPrepCardProvider._internal(
        (ref) => create(ref as AiPrepCardRef),
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
  AutoDisposeFutureProviderElement<AiPrepCard> createElement() {
    return _AiPrepCardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AiPrepCardProvider && other.bookId == bookId;
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
mixin AiPrepCardRef on AutoDisposeFutureProviderRef<AiPrepCard> {
  /// The parameter `bookId` of this provider.
  String get bookId;
}

class _AiPrepCardProviderElement
    extends AutoDisposeFutureProviderElement<AiPrepCard> with AiPrepCardRef {
  _AiPrepCardProviderElement(super.provider);

  @override
  String get bookId => (origin as AiPrepCardProvider).bookId;
}

String _$aiReflectionHash() => r'211452a3d5b3bade3b4b9a94864ae2ddc29b143d';

/// Generates/returns the completion reflection guide for [userBookId].
///
/// The backend is idempotent per (user, book), so a rebuild returns the stored
/// guide rather than re-generating.
///
/// Copied from [aiReflection].
@ProviderFor(aiReflection)
const aiReflectionProvider = AiReflectionFamily();

/// Generates/returns the completion reflection guide for [userBookId].
///
/// The backend is idempotent per (user, book), so a rebuild returns the stored
/// guide rather than re-generating.
///
/// Copied from [aiReflection].
class AiReflectionFamily extends Family<AsyncValue<AiReflection>> {
  /// Generates/returns the completion reflection guide for [userBookId].
  ///
  /// The backend is idempotent per (user, book), so a rebuild returns the stored
  /// guide rather than re-generating.
  ///
  /// Copied from [aiReflection].
  const AiReflectionFamily();

  /// Generates/returns the completion reflection guide for [userBookId].
  ///
  /// The backend is idempotent per (user, book), so a rebuild returns the stored
  /// guide rather than re-generating.
  ///
  /// Copied from [aiReflection].
  AiReflectionProvider call({
    required String userBookId,
  }) {
    return AiReflectionProvider(
      userBookId: userBookId,
    );
  }

  @override
  AiReflectionProvider getProviderOverride(
    covariant AiReflectionProvider provider,
  ) {
    return call(
      userBookId: provider.userBookId,
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
  String? get name => r'aiReflectionProvider';
}

/// Generates/returns the completion reflection guide for [userBookId].
///
/// The backend is idempotent per (user, book), so a rebuild returns the stored
/// guide rather than re-generating.
///
/// Copied from [aiReflection].
class AiReflectionProvider extends AutoDisposeFutureProvider<AiReflection> {
  /// Generates/returns the completion reflection guide for [userBookId].
  ///
  /// The backend is idempotent per (user, book), so a rebuild returns the stored
  /// guide rather than re-generating.
  ///
  /// Copied from [aiReflection].
  AiReflectionProvider({
    required String userBookId,
  }) : this._internal(
          (ref) => aiReflection(
            ref as AiReflectionRef,
            userBookId: userBookId,
          ),
          from: aiReflectionProvider,
          name: r'aiReflectionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$aiReflectionHash,
          dependencies: AiReflectionFamily._dependencies,
          allTransitiveDependencies:
              AiReflectionFamily._allTransitiveDependencies,
          userBookId: userBookId,
        );

  AiReflectionProvider._internal(
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
  Override overrideWith(
    FutureOr<AiReflection> Function(AiReflectionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AiReflectionProvider._internal(
        (ref) => create(ref as AiReflectionRef),
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
  AutoDisposeFutureProviderElement<AiReflection> createElement() {
    return _AiReflectionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AiReflectionProvider && other.userBookId == userBookId;
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
mixin AiReflectionRef on AutoDisposeFutureProviderRef<AiReflection> {
  /// The parameter `userBookId` of this provider.
  String get userBookId;
}

class _AiReflectionProviderElement
    extends AutoDisposeFutureProviderElement<AiReflection>
    with AiReflectionRef {
  _AiReflectionProviderElement(super.provider);

  @override
  String get userBookId => (origin as AiReflectionProvider).userBookId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
