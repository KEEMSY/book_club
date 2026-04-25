import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/secure_storage.dart';

/// Three high-level inputs the "독서 여정" modal collects before deriving
/// per-period targets. Stored under [JourneyPresetStore.storageKey] so the
/// modal can prefill on next open.
class ReadingJourneyInputs {
  const ReadingJourneyInputs({
    required this.yearlyBooks,
    required this.dailyMinutes,
    required this.weeklyDays,
  });

  final int yearlyBooks;
  final int dailyMinutes;
  final int weeklyDays;

  /// Defaults align with the modal's seeded values when no preset exists.
  static const ReadingJourneyInputs defaults = ReadingJourneyInputs(
    yearlyBooks: 24,
    dailyMinutes: 30,
    weeklyDays: 7,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'yearlyBooks': yearlyBooks,
        'dailyMinutes': dailyMinutes,
        'weeklyDays': weeklyDays,
      };

  static ReadingJourneyInputs fromJson(Map<String, dynamic> json) {
    return ReadingJourneyInputs(
      yearlyBooks: (json['yearlyBooks'] as num?)?.toInt() ?? 24,
      dailyMinutes: (json['dailyMinutes'] as num?)?.toInt() ?? 30,
      weeklyDays: (json['weeklyDays'] as num?)?.toInt() ?? 7,
    );
  }
}

/// Pure derivation of weekly / monthly / yearly targets from a journey input.
/// Kept side-effect free so the modal can recompute its live summary panel
/// on every input change without touching the network.
class ReadingJourneyTargets {
  const ReadingJourneyTargets({
    required this.weeklyBooks,
    required this.weeklySeconds,
    required this.monthlyBooks,
    required this.monthlySeconds,
    required this.yearlyBooks,
    required this.yearlySeconds,
  });

  final int weeklyBooks;
  final int weeklySeconds;
  final int monthlyBooks;
  final int monthlySeconds;
  final int yearlyBooks;
  final int yearlySeconds;

  /// Calendar approximations: 52 weeks ≈ 12 months ≈ 1 year. We avoid 365-day
  /// rounding because the per-period UI surfaces (this week / this month / this
  /// year) all key off these calendar buckets.
  static const int weeksPerYear = 52;
  static const int monthsPerYear = 12;

  static ReadingJourneyTargets derive({
    required int yearlyBooks,
    required int dailyMinutes,
    required int weeklyDays,
  }) {
    final int weeklySeconds = dailyMinutes * 60 * weeklyDays;
    // Distributing weekly time across 52/12 months keeps the monthly target
    // consistent with the weekly cadence; rounding lands on the nearest second.
    final int monthlySeconds =
        (weeklySeconds * weeksPerYear / monthsPerYear).round();
    final int yearlySeconds = weeklySeconds * weeksPerYear;

    final int weeklyBookTarget = (yearlyBooks / weeksPerYear).ceil();
    final int monthlyBookTarget = (yearlyBooks / monthsPerYear).ceil();

    return ReadingJourneyTargets(
      weeklyBooks: weeklyBookTarget,
      weeklySeconds: weeklySeconds,
      monthlyBooks: monthlyBookTarget,
      monthlySeconds: monthlySeconds,
      yearlyBooks: yearlyBooks,
      yearlySeconds: yearlySeconds,
    );
  }
}

/// Persists the most-recent journey inputs so the setup modal feels like it
/// remembers the user. Not security-sensitive — co-locating with the auth
/// tokens in SecureStorage just keeps a single platform-key namespace.
class JourneyPresetStore {
  JourneyPresetStore(this._storage);

  final SecureStorage _storage;

  static const String storageKey = 'goal.journey.preset';

  Future<ReadingJourneyInputs?> read() async {
    final String? raw = await _storage.readRaw(storageKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
      return ReadingJourneyInputs.fromJson(json);
    } on FormatException {
      // Corrupted preset — drop it so the next save starts clean.
      await _storage.deleteRaw(storageKey);
      return null;
    }
  }

  Future<void> save(ReadingJourneyInputs inputs) =>
      _storage.writeRaw(storageKey, jsonEncode(inputs.toJson()));
}

final journeyPresetStoreProvider = Provider<JourneyPresetStore>((ref) {
  return JourneyPresetStore(ref.watch(secureStorageProvider));
});
