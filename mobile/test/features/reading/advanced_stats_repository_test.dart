import 'package:book_club/features/reading/data/advanced_stats_api.dart';
import 'package:book_club/features/reading/data/advanced_stats_models.dart';
import 'package:book_club/features/reading/data/advanced_stats_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test double for [AdvancedStatsApi] — returns a canned payload or throws a
/// configured DioException so the repository's error mapping is exercised
/// without a live backend.
class _FakeAdvancedStatsApi implements AdvancedStatsApi {
  _FakeAdvancedStatsApi({this.result, this.error});

  final AdvancedStatsDto? result;
  final DioException? error;

  @override
  Future<AdvancedStatsDto> getAdvancedStats() async {
    if (error != null) throw error!;
    return result!;
  }
}

DioException _dioError(int status) {
  final RequestOptions options = RequestOptions(path: '/me/stats/advanced');
  return DioException(
    requestOptions: options,
    response: Response<dynamic>(requestOptions: options, statusCode: status),
    type: DioExceptionType.badResponse,
  );
}

void main() {
  group('AdvancedStatsRepository', () {
    test('returns the payload on success', () async {
      final dto = AdvancedStatsDto(
        speedTrend: <SpeedTrendItem>[
          SpeedTrendItem(weekStart: DateTime(2026, 6, 1), minutesPerPage: 2.5),
        ],
        genreDistribution: const <GenreDistributionItem>[
          GenreDistributionItem(genre: '소설', count: 3, pct: 60.0),
        ],
        yearlyComparison: const <String, int>{
          'current_year': 12,
          'prev_year': 8,
        },
        longestStreakDays: 21,
      );
      final repo = AdvancedStatsRepository(_FakeAdvancedStatsApi(result: dto));

      final result = await repo.fetchAdvancedStats();

      expect(result.longestStreakDays, 21);
      expect(result.yearlyComparison['current_year'], 12);
    });

    test('maps a 403 to ProRequiredException', () async {
      final repo =
          AdvancedStatsRepository(_FakeAdvancedStatsApi(error: _dioError(403)));

      expect(
        () => repo.fetchAdvancedStats(),
        throwsA(isA<ProRequiredException>()),
      );
    });

    test('maps other Dio errors to AdvancedStatsException', () async {
      final repo =
          AdvancedStatsRepository(_FakeAdvancedStatsApi(error: _dioError(500)));

      expect(
        () => repo.fetchAdvancedStats(),
        throwsA(isA<AdvancedStatsException>()),
      );
    });
  });
}
