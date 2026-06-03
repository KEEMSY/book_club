import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/reading_recap.dart';
import 'reading_providers.dart';

part 'recap_notifier.g.dart';

/// Recap period identifier — (year, half) pair.
typedef RecapKey = ({int year, int half});

/// Fetches the half-year recap for the given [key].
///
/// Kept as autoDispose so the heavy card assets are released when the user
/// leaves the recap screen. The banner only triggers this on explicit tap.
@riverpod
Future<ReadingRecap> readingRecap(ReadingRecapRef ref, RecapKey key) async {
  final repo = ref.read(readingRepositoryProvider);
  return repo.getReadingRecap(year: key.year, half: key.half);
}

/// Returns the [RecapKey] that corresponds to the current calendar date,
/// or null when we are outside the 6월/12월 display window.
///
/// The recap reflects the just-concluded half:
///   * June (month 6)  → 상반기 (half 1) of this year.
///   * December (month 12) → 하반기 (half 2) of this year.
RecapKey? currentRecapKey() {
  final DateTime now = DateTime.now();
  if (now.month == 6) return (year: now.year, half: 1);
  if (now.month == 12) return (year: now.year, half: 2);
  return null;
}
