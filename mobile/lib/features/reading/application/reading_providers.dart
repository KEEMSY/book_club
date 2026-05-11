import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/theme/grade_theme.dart';
import '../data/reading_api.dart';
import '../data/reading_repository.dart';
import '../data/reading_models.dart' show DailySessionsResponseDto;
import '../domain/bookmark.dart';
import 'grade_notifier.dart';
import 'grade_state.dart';
import 'reading_journey_inputs.dart';

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

/// User's daily reading goal in seconds, read from the persisted journey preset.
/// Falls back to 30 min (1800 s) when no preset exists. Consumed by TimerRing
/// so the arc fills proportionally to today's target instead of wrapping hourly.
final dailyGoalSecondsProvider = FutureProvider<int>((ref) async {
  final store = ref.watch(journeyPresetStoreProvider);
  final inputs = await store.read();
  final dailyMinutes =
      inputs?.dailyMinutes ?? ReadingJourneyInputs.defaults.dailyMinutes;
  return dailyMinutes * 60;
});

/// Fetches the most recent bookmark for a given userBookId. Used in the
/// "start reading" sheet to show where the user left off per book.
final latestBookmarkProvider = FutureProvider.autoDispose
    .family<Bookmark?, String>((ref, userBookId) async {
  final repo = ref.read(readingRepositoryProvider);
  return repo.getLatestBookmark(userBookId: userBookId);
});

/// Sessions + book metadata for a given calendar date ("YYYY-MM-DD").
/// Used by the heatmap day-detail bottom sheet.
final dailySessionsProvider = FutureProvider.autoDispose
    .family<DailySessionsResponseDto, String>((ref, date) async {
  final repo = ref.read(readingRepositoryProvider);
  return repo.getDailySessions(DateTime.parse(date));
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
