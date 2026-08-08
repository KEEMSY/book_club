import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

/// Auth provider the current session belongs to.
///
/// Mirrors the backend `UserPublic.provider` enum (`kakao`|`apple`). Kept as
/// a Dart `enum` on the client so UI branches (e.g. "애플 계정으로 로그인됨")
/// type-check without string comparisons.
enum AuthProvider {
  kakao,
  apple;

  /// Parses the wire value produced by the backend JSON schema. Unknown
  /// values default to [AuthProvider.kakao] so a future provider added
  /// backend-first cannot brick the login screen; callers should not rely on
  /// silent defaulting in critical flows.
  static AuthProvider fromWire(String value) {
    switch (value) {
      case 'apple':
        return AuthProvider.apple;
      case 'kakao':
      default:
        return AuthProvider.kakao;
    }
  }

  String get wire {
    switch (this) {
      case AuthProvider.kakao:
        return 'kakao';
      case AuthProvider.apple:
        return 'apple';
    }
  }
}

/// Domain-layer user projected from the backend `UserPublic` DTO.
///
/// Kept separate from [AuthUserDto] (data layer) so UI code never touches
/// raw wire types. [provider] is a typed enum here; the DTO keeps it as a
/// `String` so freezed/json_serializable deserialisation stays trivial.
@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String nickname,
    required AuthProvider provider,
    required DateTime createdAt,
    String? profileImageUrl,
    String? email,
    // BC-87: gates the admin console entry point / route. Defaults to false
    // so call sites that predate this field (tests, other builders) still
    // compile without passing it explicitly.
    @Default(false) bool isAdmin,
    // Profile expressiveness (backend BC-81, mobile UI BC-84). Raw wire
    // values — see the matching comment on `UserProfile`
    // (features/social/domain/user_summary.dart) for why `theme` isn't the
    // `ProfileTheme` enum here. Populated from `/me` (`UserPublic`) and used
    // to build the own-profile header when `FeatureFlags.community` is off
    // (community_providers.dart's degrade branch).
    String? coverImageUrl,
    String? theme,
    String? featuredBookId,
    String? featuredQuote,
  }) = _AuthUser;
}
