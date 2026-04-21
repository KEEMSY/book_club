import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth_user.dart';

part 'auth_state.freezed.dart';

/// Sealed authentication state machine consumed by the router and UI.
///
/// Transitions:
///   - [AuthState.initial]          — boot splash, rehydration not started.
///   - [AuthState.unauthenticated]  — no tokens or rehydrate failed. Router
///     redirects any protected route to `/login`.
///   - [AuthState.authenticating]   — active login RPC in flight; the login
///     screen shows a modal barrier but stays mounted.
///   - [AuthState.authenticated]    — valid session + user snapshot.
///   - [AuthState.failure]          — last login attempt failed with a
///     human-readable [message] and a machine [code] from the backend error
///     envelope (e.g. `APPLE_TOKEN_EXPIRED`).
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.authenticating() = Authenticating;
  const factory AuthState.authenticated(AuthUser user) = Authenticated;
  const factory AuthState.failure({
    required String code,
    required String message,
  }) = AuthFailure;
}
