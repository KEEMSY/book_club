// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$libraryNotifierHash() => r'8088ca608be7be4d3419a5ec68f79cc36183efd7';

/// Holds a `Map<BookStatus, LibraryListState>` so switching status tabs
/// preserves previously-loaded pages (Airbnb-style "sticky tabs" feel).
///
/// Each status has its own cursor; loading more on the `reading` tab does
/// not touch the `completed` cache and vice-versa. Refresh is explicit via
/// [refresh] so accidental re-fetch on tab pump does not hit the API.
///
/// Copied from [LibraryNotifier].
@ProviderFor(LibraryNotifier)
final libraryNotifierProvider = AutoDisposeNotifierProvider<LibraryNotifier,
    Map<BookStatus, LibraryListState>>.internal(
  LibraryNotifier.new,
  name: r'libraryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$libraryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LibraryNotifier
    = AutoDisposeNotifier<Map<BookStatus, LibraryListState>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
