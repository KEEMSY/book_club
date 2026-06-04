// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recap_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$readingRecapHash() => r'f4dee2f79c07bc03096b2e6e61b081c3e58110ff';

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

/// Fetches the half-year recap for the given [key].
///
/// Kept as autoDispose so the heavy card assets are released when the user
/// leaves the recap screen. The banner only triggers this on explicit tap.
///
/// Copied from [readingRecap].
@ProviderFor(readingRecap)
const readingRecapProvider = ReadingRecapFamily();

/// Fetches the half-year recap for the given [key].
///
/// Kept as autoDispose so the heavy card assets are released when the user
/// leaves the recap screen. The banner only triggers this on explicit tap.
///
/// Copied from [readingRecap].
class ReadingRecapFamily extends Family<AsyncValue<ReadingRecap>> {
  /// Fetches the half-year recap for the given [key].
  ///
  /// Kept as autoDispose so the heavy card assets are released when the user
  /// leaves the recap screen. The banner only triggers this on explicit tap.
  ///
  /// Copied from [readingRecap].
  const ReadingRecapFamily();

  /// Fetches the half-year recap for the given [key].
  ///
  /// Kept as autoDispose so the heavy card assets are released when the user
  /// leaves the recap screen. The banner only triggers this on explicit tap.
  ///
  /// Copied from [readingRecap].
  ReadingRecapProvider call(
    ({int half, int year}) key,
  ) {
    return ReadingRecapProvider(
      key,
    );
  }

  @override
  ReadingRecapProvider getProviderOverride(
    covariant ReadingRecapProvider provider,
  ) {
    return call(
      provider.key,
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
  String? get name => r'readingRecapProvider';
}

/// Fetches the half-year recap for the given [key].
///
/// Kept as autoDispose so the heavy card assets are released when the user
/// leaves the recap screen. The banner only triggers this on explicit tap.
///
/// Copied from [readingRecap].
class ReadingRecapProvider extends AutoDisposeFutureProvider<ReadingRecap> {
  /// Fetches the half-year recap for the given [key].
  ///
  /// Kept as autoDispose so the heavy card assets are released when the user
  /// leaves the recap screen. The banner only triggers this on explicit tap.
  ///
  /// Copied from [readingRecap].
  ReadingRecapProvider(
    ({int half, int year}) key,
  ) : this._internal(
          (ref) => readingRecap(
            ref as ReadingRecapRef,
            key,
          ),
          from: readingRecapProvider,
          name: r'readingRecapProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$readingRecapHash,
          dependencies: ReadingRecapFamily._dependencies,
          allTransitiveDependencies:
              ReadingRecapFamily._allTransitiveDependencies,
          key: key,
        );

  ReadingRecapProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final ({int half, int year}) key;

  @override
  Override overrideWith(
    FutureOr<ReadingRecap> Function(ReadingRecapRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReadingRecapProvider._internal(
        (ref) => create(ref as ReadingRecapRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ReadingRecap> createElement() {
    return _ReadingRecapProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReadingRecapProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReadingRecapRef on AutoDisposeFutureProviderRef<ReadingRecap> {
  /// The parameter `key` of this provider.
  ({int half, int year}) get key;
}

class _ReadingRecapProviderElement
    extends AutoDisposeFutureProviderElement<ReadingRecap>
    with ReadingRecapRef {
  _ReadingRecapProviderElement(super.provider);

  @override
  ({int half, int year}) get key => (origin as ReadingRecapProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
