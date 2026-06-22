import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../data/ai_api.dart';
import '../data/ai_repository.dart';
import '../domain/ai_models.dart';

part 'ai_providers.g.dart';

/// Retrofit-backed repository for the AI assistant endpoints — built once per
/// Dio instance and kept alive for the session.
@Riverpod(keepAlive: true)
AiRepository aiRepository(AiRepositoryRef ref) {
  final api = AiApi(ref.watch(dioProvider));
  return AiRepository(api);
}

/// Generates/returns the prep card for [bookId].
///
/// autoDispose: the prep sheet only needs it while open. The backend caches the
/// card for 72h, so re-opening is cheap and never re-charges the daily quota.
@riverpod
Future<AiPrepCard> aiPrepCard(AiPrepCardRef ref, {required String bookId}) {
  return ref.watch(aiRepositoryProvider).getPrepCard(bookId);
}

/// Generates/returns the completion reflection guide for [userBookId].
///
/// The backend is idempotent per (user, book), so a rebuild returns the stored
/// guide rather than re-generating.
@riverpod
Future<AiReflection> aiReflection(
  AiReflectionRef ref, {
  required String userBookId,
}) {
  return ref.watch(aiRepositoryProvider).createReflection(userBookId);
}

/// The reader's prep-card persona style (M67).
///
/// keepAlive so the chosen style is read once per session; the prep-card sheet
/// invalidates it after the user picks a style so the next read reflects it.
@Riverpod(keepAlive: true)
Future<AiPreferences> userAiPreferences(UserAiPreferencesRef ref) {
  return ref.watch(aiRepositoryProvider).getPreferences();
}
