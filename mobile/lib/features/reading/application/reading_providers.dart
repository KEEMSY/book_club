import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/theme/grade_theme.dart';
import '../data/reading_api.dart';
import '../data/reading_repository.dart';
import 'grade_notifier.dart';
import 'grade_state.dart';

/// retrofit client for `/reading/*` — built once per Dio instance.
final readingApiProvider = Provider<ReadingApi>((ref) {
  final dio = ref.watch(dioProvider);
  return ReadingApi(dio);
});

/// Domain-shaped reading repository consumed by every reading notifier. All
/// retrofit ↔ domain conversion lives here so notifiers never reach into the
/// data layer.
final readingRepositoryProvider = Provider<ReadingRepository>((ref) {
  return ReadingRepository(ref.watch(readingApiProvider));
});

/// Single-source-of-truth for the grade accent color. TimerRing, GradeBadge,
/// JanDeeGrid, and the dashboard's today CTA read this provider so the whole
/// reading surface shifts color in lockstep when a grade-up arrives.
final gradePrimaryProvider = Provider<Color>((ref) {
  final gradeState = ref.watch(gradeNotifierProvider);
  if (gradeState is GradeLoaded) {
    return GradeTheme.primaryOf(gradeState.summary.readerGrade);
  }
  // Before the grade request completes we show the brand accent so the UI
  // doesn't flicker through a placeholder color.
  return GradeTheme.primaryOf(ReaderGrade.sprout);
});
