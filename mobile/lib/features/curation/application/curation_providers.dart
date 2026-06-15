import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../data/curation_api.dart';
import '../data/curation_repository.dart';
import '../domain/curation_card.dart';

part 'curation_providers.g.dart';

/// Retrofit client for the curation-card endpoints — built once per Dio
/// instance and kept alive for the session so repeated card fetches reuse
/// the same client.
@Riverpod(keepAlive: true)
CurationRepository curationRepository(CurationRepositoryRef ref) {
  final api = CurationApi(ref.watch(dioProvider));
  return CurationRepository(api);
}

/// Fetches the first curation card for [bookId].
///
/// autoDispose so the result is released when no widget is watching it.
/// The TimerScreen triggers this on build (before the user taps "시작"),
/// so the sheet is ready to show without a perceptible loading delay.
@riverpod
Future<CurationCard?> firstCurationCard(
  FirstCurationCardRef ref, {
  required String bookId,
}) {
  return ref.watch(curationRepositoryProvider).getFirstCard(bookId);
}
