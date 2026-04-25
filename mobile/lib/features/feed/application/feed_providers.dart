import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/feed_api.dart';
import '../data/feed_repository.dart';
import '../data/image_uploader.dart';

/// retrofit client for `/books/{id}/posts`, `/posts/*`, `/uploads/*`.
final feedApiProvider = Provider<FeedApi>((ref) {
  final Dio dio = ref.watch(dioProvider);
  return FeedApi(dio);
});

/// Bare dio used by the image PUT step. The presigned URL carries auth via
/// the signature, so the AuthInterceptor on the main dio would be wrong
/// here (it would attach an Authorization header that R2 rejects).
final imagePutClientProvider = Provider<Dio>((ref) {
  final Dio bare = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  ref.onDispose(bare.close);
  return bare;
});

final imageUploaderProvider = Provider<ImageUploader>((ref) {
  return ImageUploader(
    api: ref.watch(feedApiProvider),
    putClient: ref.watch(imagePutClientProvider),
  );
});

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepository(
    api: ref.watch(feedApiProvider),
    uploader: ref.watch(imageUploaderProvider),
  );
});
