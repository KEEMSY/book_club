import 'package:dio/dio.dart';

import '../domain/subscription_status.dart';
import 'subscription_api.dart';

/// Typed domain failure surfaced by [SubscriptionRepository].
class SubscriptionRepositoryException implements Exception {
  const SubscriptionRepositoryException({
    required this.code,
    required this.message,
    this.statusCode,
    this.cause,
  });

  final String code;
  final String message;
  final int? statusCode;
  final Object? cause;

  @override
  String toString() =>
      'SubscriptionRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Wraps [SubscriptionApi], converts raw JSON to domain objects, and maps
/// Dio errors into typed [SubscriptionRepositoryException] values.
class SubscriptionRepository {
  SubscriptionRepository(this._api);

  final SubscriptionApi _api;

  /// Fetches the current user's subscription status.
  Future<SubscriptionStatus> getStatus() async {
    try {
      final dynamic raw = await _api.getStatus();
      return _parseStatus(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// Verifies a platform receipt and returns the updated subscription status.
  ///
  /// [platform] is either `"ios"` or `"android"`.
  /// [receiptData] is the base64-encoded receipt from the platform SDK.
  /// [productId] identifies the purchased SKU.
  Future<SubscriptionStatus> verifyReceipt({
    required String platform,
    required String receiptData,
    required String productId,
  }) async {
    try {
      final dynamic raw = await _api.verifyReceipt({
        'platform': platform,
        'receipt_data': receiptData,
        'product_id': productId,
      });
      final Map<String, dynamic> data = raw as Map<String, dynamic>;
      // Server returns { is_pro, expires_at, message } — map into SubscriptionStatus.
      return SubscriptionStatus(
        isPro: (data['is_pro'] as bool?) ?? false,
        proExpiresAt: data['expires_at'] != null
            ? DateTime.tryParse(data['expires_at'] as String)
            : null,
      );
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  SubscriptionStatus _parseStatus(Map<String, dynamic> data) {
    return SubscriptionStatus(
      isPro: (data['is_pro'] as bool?) ?? false,
      proExpiresAt: data['pro_expires_at'] != null
          ? DateTime.tryParse(data['pro_expires_at'] as String)
          : null,
      proProductId: data['pro_product_id'] as String?,
    );
  }

  SubscriptionRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return SubscriptionRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status != null && status >= 500) {
      return SubscriptionRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return SubscriptionRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
