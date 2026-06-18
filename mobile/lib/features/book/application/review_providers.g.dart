// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reviewApiHash() => r'3440c6b9e2f99f320d9c44262476710fb3129f10';

/// retrofit client for the M54 `/books/{id}/reviews` endpoints.
///
/// Copied from [reviewApi].
@ProviderFor(reviewApi)
final reviewApiProvider = AutoDisposeProvider<ReviewApi>.internal(
  reviewApi,
  name: r'reviewApiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$reviewApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReviewApiRef = AutoDisposeProviderRef<ReviewApi>;
String _$reviewRepositoryHash() => r'd16cc76ce5ce7553fb4813ced2295253e8919b61';

/// See also [reviewRepository].
@ProviderFor(reviewRepository)
final reviewRepositoryProvider = AutoDisposeProvider<ReviewRepository>.internal(
  reviewRepository,
  name: r'reviewRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reviewRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReviewRepositoryRef = AutoDisposeProviderRef<ReviewRepository>;
String _$bookReviewSummaryHash() => r'e49ce7ae47e8f74fc2d209377487cc266a414079';

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

/// Aggregate review summary for a book — average, distribution, and the latest
/// page of reviews. Named distinctly from the legacy `bookReviews` provider to
/// avoid a generated-symbol collision.
///
/// Copied from [bookReviewSummary].
@ProviderFor(bookReviewSummary)
const bookReviewSummaryProvider = BookReviewSummaryFamily();

/// Aggregate review summary for a book — average, distribution, and the latest
/// page of reviews. Named distinctly from the legacy `bookReviews` provider to
/// avoid a generated-symbol collision.
///
/// Copied from [bookReviewSummary].
class BookReviewSummaryFamily extends Family<AsyncValue<BookReviewSummaryDto>> {
  /// Aggregate review summary for a book — average, distribution, and the latest
  /// page of reviews. Named distinctly from the legacy `bookReviews` provider to
  /// avoid a generated-symbol collision.
  ///
  /// Copied from [bookReviewSummary].
  const BookReviewSummaryFamily();

  /// Aggregate review summary for a book — average, distribution, and the latest
  /// page of reviews. Named distinctly from the legacy `bookReviews` provider to
  /// avoid a generated-symbol collision.
  ///
  /// Copied from [bookReviewSummary].
  BookReviewSummaryProvider call(
    String bookId,
  ) {
    return BookReviewSummaryProvider(
      bookId,
    );
  }

  @override
  BookReviewSummaryProvider getProviderOverride(
    covariant BookReviewSummaryProvider provider,
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
  String? get name => r'bookReviewSummaryProvider';
}

/// Aggregate review summary for a book — average, distribution, and the latest
/// page of reviews. Named distinctly from the legacy `bookReviews` provider to
/// avoid a generated-symbol collision.
///
/// Copied from [bookReviewSummary].
class BookReviewSummaryProvider
    extends AutoDisposeFutureProvider<BookReviewSummaryDto> {
  /// Aggregate review summary for a book — average, distribution, and the latest
  /// page of reviews. Named distinctly from the legacy `bookReviews` provider to
  /// avoid a generated-symbol collision.
  ///
  /// Copied from [bookReviewSummary].
  BookReviewSummaryProvider(
    String bookId,
  ) : this._internal(
          (ref) => bookReviewSummary(
            ref as BookReviewSummaryRef,
            bookId,
          ),
          from: bookReviewSummaryProvider,
          name: r'bookReviewSummaryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookReviewSummaryHash,
          dependencies: BookReviewSummaryFamily._dependencies,
          allTransitiveDependencies:
              BookReviewSummaryFamily._allTransitiveDependencies,
          bookId: bookId,
        );

  BookReviewSummaryProvider._internal(
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
    FutureOr<BookReviewSummaryDto> Function(BookReviewSummaryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookReviewSummaryProvider._internal(
        (ref) => create(ref as BookReviewSummaryRef),
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
  AutoDisposeFutureProviderElement<BookReviewSummaryDto> createElement() {
    return _BookReviewSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookReviewSummaryProvider && other.bookId == bookId;
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
mixin BookReviewSummaryRef
    on AutoDisposeFutureProviderRef<BookReviewSummaryDto> {
  /// The parameter `bookId` of this provider.
  String get bookId;
}

class _BookReviewSummaryProviderElement
    extends AutoDisposeFutureProviderElement<BookReviewSummaryDto>
    with BookReviewSummaryRef {
  _BookReviewSummaryProviderElement(super.provider);

  @override
  String get bookId => (origin as BookReviewSummaryProvider).bookId;
}

String _$reviewNotifierHash() => r'6112999fdd4687df026c3a90c3ed39165d0145d5';

/// Drives create / update / delete mutations and exposes their in-flight and
/// error state. Each mutation invalidates [bookReviewSummaryProvider] for the
/// affected book so the section re-fetches the fresh aggregate.
///
/// Copied from [ReviewNotifier].
@ProviderFor(ReviewNotifier)
final reviewNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ReviewNotifier, void>.internal(
  ReviewNotifier.new,
  name: r'reviewNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reviewNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReviewNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
