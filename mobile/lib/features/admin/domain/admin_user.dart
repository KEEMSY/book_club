import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_user.freezed.dart';

/// Flattened user record shown in the admin console's user-management list.
///
/// Mirrors the backend `UserAdminItem` (`GET/PATCH /admin/users/...`).
@freezed
abstract class AdminUser with _$AdminUser {
  const factory AdminUser({
    required String id,
    required String nickname,
    String? email,
    required bool isActive,
    required bool isAdmin,
    required bool isPro,
    required DateTime createdAt,
  }) = _AdminUser;
}
