import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'feed_api.dart';
import 'feed_models.dart';

/// Picked image payload produced by the composer's image-picker row.
///
/// Carries the raw bytes (so web/Chrome works without dart:io) plus the
/// original filename and a content type the backend's presign step accepts.
class PickedImage {
  const PickedImage({
    required this.bytes,
    required this.contentType,
    this.filename,
  });

  final Uint8List bytes;
  final String contentType;
  final String? filename;

  int get sizeBytes => bytes.length;
}

/// Failure surface for the upload pipeline. The composer notifier maps
/// `code` to user-facing copy and to retry decisions (e.g. network errors
/// retry transparently, presign failures surface inline).
class ImageUploadException implements Exception {
  const ImageUploadException({required this.code, required this.message});
  final String code;
  final String message;

  @override
  String toString() => 'ImageUploadException(code: $code, message: $message)';
}

/// Orchestrates the 3-step R2 upload:
///   1. POST /uploads/presign-image → returns url, key, headers
///   2. PUT to that url with the exact headers + raw bytes (no Authorization)
///   3. return key — the caller bundles it into createPost(image_keys: [...])
///
/// Step 2 cannot ride on the dio instance that mounts [AuthInterceptor]
/// because the presigned PUT must be unauthenticated (the signature carries
/// auth instead). We accept a separate [_putClient] so tests can inject a
/// fake.
class ImageUploader {
  ImageUploader({required FeedApi api, required Dio putClient})
      : _api = api,
        _putClient = putClient;

  final FeedApi _api;
  final Dio _putClient;

  /// Presigns + uploads [image]. Returns the storage key the caller passes
  /// to `createPost(image_keys: [...])`.
  Future<String> upload(PickedImage image) async {
    final PresignImageResponse presign = await _presign(image.contentType);
    await _putBytes(presign, image.bytes);
    return presign.key;
  }

  Future<PresignImageResponse> _presign(String contentType) async {
    try {
      return await _api.presignImage(
        PresignImageRequest(contentType: contentType).toJson(),
      );
    } on DioException {
      throw const ImageUploadException(
        code: 'PRESIGN_FAILED',
        message: '이미지 업로드 준비에 실패했어요. 잠시 후 다시 시도해주세요.',
      );
    }
  }

  Future<void> _putBytes(
    PresignImageResponse presign,
    Uint8List bytes,
  ) async {
    try {
      await _putClient.putUri<void>(
        Uri.parse(presign.url),
        data: Stream<List<int>>.fromIterable(<List<int>>[bytes]),
        options: Options(
          headers: <String, dynamic>{
            ...presign.headers,
            'Content-Length': bytes.length,
          },
          // R2 returns 200 with an empty body on success; avoid response
          // parsing so we don't trip on the empty payload.
          responseType: ResponseType.plain,
        ),
      );
    } on DioException {
      throw const ImageUploadException(
        code: 'UPLOAD_FAILED',
        message: '이미지를 업로드하지 못했어요. 다시 시도해주세요.',
      );
    }
  }
}
