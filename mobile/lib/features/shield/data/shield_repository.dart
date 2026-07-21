import 'package:dio/dio.dart';

import '../domain/shield_purchase_result.dart';
import 'shield_api.dart';
import 'shield_models.dart';

/// Typed domain failure surfaced by [ShieldRepository].
class ShieldRepositoryException implements Exception {
  const ShieldRepositoryException({
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
      'ShieldRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Wraps [ShieldApi], converts raw JSON to domain objects, and maps Dio
/// errors into typed [ShieldRepositoryException] values.
class ShieldRepository {
  ShieldRepository(this._api);

  final ShieldApi _api;

  /// Returns the number of streak shields the user currently holds.
  Future<int> getBalance() async {
    try {
      final dynamic raw = await _api.getBalance();
      final dto = ShieldBalanceDto.fromJson(raw as Map<String, dynamic>);
      return dto.streakShields;
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// Sends a purchase receipt to the backend and returns the result.
  ///
  /// [receiptData] is a platform receipt string. During development a mock
  /// value is passed — real StoreKit / BillingClient integration comes later.
  Future<ShieldPurchaseResult> purchaseShield({
    required String productId,
    required String receiptData,
  }) async {
    try {
      final dynamic raw = await _api.purchase({
        'product_id': productId,
        'receipt_data': receiptData,
      });
      final dto = ShieldPurchaseResultDto.fromJson(raw as Map<String, dynamic>);
      return ShieldPurchaseResult(
        shieldsGranted: dto.shieldsGranted,
        totalShields: dto.totalShields,
      );
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  ShieldRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return ShieldRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status != null && status >= 500) {
      return ShieldRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return ShieldRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
