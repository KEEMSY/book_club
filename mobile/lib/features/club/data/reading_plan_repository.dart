import '../domain/reading_plan.dart';
import 'reading_plan_api.dart';
import 'reading_plan_models.dart';

class ReadingPlanRepository {
  ReadingPlanRepository(this._api);

  final ReadingPlanApi _api;

  Future<ReadingPlan> createPlan(
    String clubId, {
    required String bookId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final request = CreateReadingPlanRequest(
      bookId: bookId,
      startDate: _formatDate(startDate),
      endDate: _formatDate(endDate),
    );
    final data = await _api.createPlan(clubId, request.toJson());
    return ReadingPlan.fromDto(
      ReadingPlanDto.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<ReadingPlan?> getPlan(String clubId) async {
    final data = await _api.getPlan(clubId);
    if (data == null) return null;
    return ReadingPlan.fromDto(
      ReadingPlanDto.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<void> updateProgress(String clubId, int currentPage) =>
      _api.updateProgress(
        clubId,
        UpdateProgressRequest(currentPage: currentPage).toJson(),
      );

  Future<ClubProgress> getProgress(String clubId) async {
    final data = await _api.getProgress(clubId);
    return ClubProgress.fromDto(
      ClubProgressDto.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Date-only `yyyy-MM-dd` for the backend's date columns.
  String _formatDate(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
