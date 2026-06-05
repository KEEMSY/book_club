import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/reading_stats.dart';
import 'reading_providers.dart';

part 'reading_stats_notifier.g.dart';

/// Fetches the full reading analytics summary from `GET /me/reading-stats`.
///
/// autoDispose — the stats screen is an occasional visit; releasing the cache
/// on exit keeps idle memory low.
@riverpod
Future<ReadingStats> readingStats(ReadingStatsRef ref) async {
  final repo = ref.read(readingRepositoryProvider);
  return repo.getReadingStats();
}
