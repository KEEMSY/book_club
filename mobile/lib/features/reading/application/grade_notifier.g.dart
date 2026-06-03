// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gradeNotifierHash() => r'10dc7a4301e422da143630324cb868f6aff1ea03';

/// Holds the current `GradeSummary` plus a `recentGradeUp` flag the
/// dashboard toasts the user about once on the next `/home` render.
///
/// Copied from [GradeNotifier].
@ProviderFor(GradeNotifier)
final gradeNotifierProvider =
    NotifierProvider<GradeNotifier, GradeState>.internal(
  GradeNotifier.new,
  name: r'gradeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gradeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GradeNotifier = Notifier<GradeState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
