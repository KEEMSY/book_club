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

String _$monthlyRecapHash() => r'e42973d4fe3e5d01898bdcc6ec8a8272e29be555';

/// Fetches the monthly recap for the given [year] and [month].
///
/// Both parameters are optional — omitting them requests the current month
/// from the backend. autoDispose keeps the card data out of memory after
/// the user navigates away.
///
/// Copied from [monthlyRecap].
@ProviderFor(monthlyRecap)
const monthlyRecapProvider = MonthlyRecapFamily();

/// Fetches the monthly recap for the given [year] and [month].
///
/// Both parameters are optional — omitting them requests the current month
/// from the backend. autoDispose keeps the card data out of memory after
/// the user navigates away.
///
/// Copied from [monthlyRecap].
class MonthlyRecapFamily extends Family<AsyncValue<MonthlyRecap>> {
  /// Fetches the monthly recap for the given [year] and [month].
  ///
  /// Both parameters are optional — omitting them requests the current month
  /// from the backend. autoDispose keeps the card data out of memory after
  /// the user navigates away.
  ///
  /// Copied from [monthlyRecap].
  const MonthlyRecapFamily();

  /// Fetches the monthly recap for the given [year] and [month].
  ///
  /// Both parameters are optional — omitting them requests the current month
  /// from the backend. autoDispose keeps the card data out of memory after
  /// the user navigates away.
  ///
  /// Copied from [monthlyRecap].
  MonthlyRecapProvider call({
    int? year,
    int? month,
  }) {
    return MonthlyRecapProvider(
      year: year,
      month: month,
    );
  }

  @override
  MonthlyRecapProvider getProviderOverride(
    covariant MonthlyRecapProvider provider,
  ) {
    return call(
      year: provider.year,
      month: provider.month,
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
  String? get name => r'monthlyRecapProvider';
}

/// Fetches the monthly recap for the given [year] and [month].
///
/// Both parameters are optional — omitting them requests the current month
/// from the backend. autoDispose keeps the card data out of memory after
/// the user navigates away.
///
/// Copied from [monthlyRecap].
class MonthlyRecapProvider extends AutoDisposeFutureProvider<MonthlyRecap> {
  /// Fetches the monthly recap for the given [year] and [month].
  ///
  /// Both parameters are optional — omitting them requests the current month
  /// from the backend. autoDispose keeps the card data out of memory after
  /// the user navigates away.
  ///
  /// Copied from [monthlyRecap].
  MonthlyRecapProvider({
    int? year,
    int? month,
  }) : this._internal(
          (ref) => monthlyRecap(
            ref as MonthlyRecapRef,
            year: year,
            month: month,
          ),
          from: monthlyRecapProvider,
          name: r'monthlyRecapProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$monthlyRecapHash,
          dependencies: MonthlyRecapFamily._dependencies,
          allTransitiveDependencies:
              MonthlyRecapFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  MonthlyRecapProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int? year;
  final int? month;

  @override
  Override overrideWith(
    FutureOr<MonthlyRecap> Function(MonthlyRecapRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyRecapProvider._internal(
        (ref) => create(ref as MonthlyRecapRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MonthlyRecap> createElement() {
    return _MonthlyRecapProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyRecapProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthlyRecapRef on AutoDisposeFutureProviderRef<MonthlyRecap> {
  /// The parameter `year` of this provider.
  int? get year;

  /// The parameter `month` of this provider.
  int? get month;
}

class _MonthlyRecapProviderElement
    extends AutoDisposeFutureProviderElement<MonthlyRecap>
    with MonthlyRecapRef {
  _MonthlyRecapProviderElement(super.provider);

  @override
  int? get year => (origin as MonthlyRecapProvider).year;
  @override
  int? get month => (origin as MonthlyRecapProvider).month;
}

String _$milestonesHash() => r'71dc2cb58b1ce1602164653ac218443e5547b697';

/// Fetches all milestones achieved by the current user.
///
/// autoDispose — milestones are only displayed on the grade screen and the
/// monthly recap, so caching them indefinitely is wasteful.
///
/// Copied from [milestones].
@ProviderFor(milestones)
final milestonesProvider =
    AutoDisposeFutureProvider<List<MilestoneItem>>.internal(
  milestones,
  name: r'milestonesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$milestonesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MilestonesRef = AutoDisposeFutureProviderRef<List<MilestoneItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
