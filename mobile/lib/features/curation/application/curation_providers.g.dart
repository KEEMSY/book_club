// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$curationRepositoryHash() =>
    r'bfe21e01bc92860d80450c2870f6fb4894f44e99';

/// Retrofit client for the curation-card endpoints — built once per Dio
/// instance and kept alive for the session so repeated card fetches reuse
/// the same client.
///
/// Copied from [curationRepository].
@ProviderFor(curationRepository)
final curationRepositoryProvider = Provider<CurationRepository>.internal(
  curationRepository,
  name: r'curationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$curationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurationRepositoryRef = ProviderRef<CurationRepository>;
String _$firstCurationCardHash() => r'4f8b041fbe420eb8ea5021d4848437fbe2de1880';

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

/// Fetches the first curation card for [bookId].
///
/// autoDispose so the result is released when no widget is watching it.
/// The TimerScreen triggers this on build (before the user taps "시작"),
/// so the sheet is ready to show without a perceptible loading delay.
///
/// Copied from [firstCurationCard].
@ProviderFor(firstCurationCard)
const firstCurationCardProvider = FirstCurationCardFamily();

/// Fetches the first curation card for [bookId].
///
/// autoDispose so the result is released when no widget is watching it.
/// The TimerScreen triggers this on build (before the user taps "시작"),
/// so the sheet is ready to show without a perceptible loading delay.
///
/// Copied from [firstCurationCard].
class FirstCurationCardFamily extends Family<AsyncValue<CurationCard?>> {
  /// Fetches the first curation card for [bookId].
  ///
  /// autoDispose so the result is released when no widget is watching it.
  /// The TimerScreen triggers this on build (before the user taps "시작"),
  /// so the sheet is ready to show without a perceptible loading delay.
  ///
  /// Copied from [firstCurationCard].
  const FirstCurationCardFamily();

  /// Fetches the first curation card for [bookId].
  ///
  /// autoDispose so the result is released when no widget is watching it.
  /// The TimerScreen triggers this on build (before the user taps "시작"),
  /// so the sheet is ready to show without a perceptible loading delay.
  ///
  /// Copied from [firstCurationCard].
  FirstCurationCardProvider call({
    required String bookId,
  }) {
    return FirstCurationCardProvider(
      bookId: bookId,
    );
  }

  @override
  FirstCurationCardProvider getProviderOverride(
    covariant FirstCurationCardProvider provider,
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
  String? get name => r'firstCurationCardProvider';
}

/// Fetches the first curation card for [bookId].
///
/// autoDispose so the result is released when no widget is watching it.
/// The TimerScreen triggers this on build (before the user taps "시작"),
/// so the sheet is ready to show without a perceptible loading delay.
///
/// Copied from [firstCurationCard].
class FirstCurationCardProvider
    extends AutoDisposeFutureProvider<CurationCard?> {
  /// Fetches the first curation card for [bookId].
  ///
  /// autoDispose so the result is released when no widget is watching it.
  /// The TimerScreen triggers this on build (before the user taps "시작"),
  /// so the sheet is ready to show without a perceptible loading delay.
  ///
  /// Copied from [firstCurationCard].
  FirstCurationCardProvider({
    required String bookId,
  }) : this._internal(
          (ref) => firstCurationCard(
            ref as FirstCurationCardRef,
            bookId: bookId,
          ),
          from: firstCurationCardProvider,
          name: r'firstCurationCardProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$firstCurationCardHash,
          dependencies: FirstCurationCardFamily._dependencies,
          allTransitiveDependencies:
              FirstCurationCardFamily._allTransitiveDependencies,
          bookId: bookId,
        );

  FirstCurationCardProvider._internal(
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
    FutureOr<CurationCard?> Function(FirstCurationCardRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FirstCurationCardProvider._internal(
        (ref) => create(ref as FirstCurationCardRef),
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
  AutoDisposeFutureProviderElement<CurationCard?> createElement() {
    return _FirstCurationCardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FirstCurationCardProvider && other.bookId == bookId;
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
mixin FirstCurationCardRef on AutoDisposeFutureProviderRef<CurationCard?> {
  /// The parameter `bookId` of this provider.
  String get bookId;
}

class _FirstCurationCardProviderElement
    extends AutoDisposeFutureProviderElement<CurationCard?>
    with FirstCurationCardRef {
  _FirstCurationCardProviderElement(super.provider);

  @override
  String get bookId => (origin as FirstCurationCardProvider).bookId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
