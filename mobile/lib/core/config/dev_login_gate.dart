import 'package:flutter/foundation.dart';

/// Gates the hidden dev/tester login route (BC-86).
///
/// The two shortcut logins (`AuthNotifier.loginDev` / `loginTester`) used to
/// sit on the main login screen behind a debug-only check. They now live on
/// a separate, unlisted `/dev-login` route so a production build never
/// shows — or even leaves reachable — a backend-login bypass next to the
/// real Kakao/Apple CTAs.
///
/// Reachable when:
///   - the build is a debug build (`flutter run`, no extra flags needed), or
///   - the build explicitly opts in via `--dart-define=SHOW_DEV_LOGIN=true`
///     (e.g. a `--release` staging/QA build pointed at the dev backend).
///
/// `bool.fromEnvironment` defaults to `false` when the define is absent, so
/// a production release build that forgets to pass it stays hidden — the
/// safe failure mode is "route unreachable", not "route exposed".
class DevLoginGate {
  const DevLoginGate._();

  static const bool _showDevLoginDefine = bool.fromEnvironment(
    'SHOW_DEV_LOGIN',
  );

  /// [debugMode] is injectable purely so tests can exercise the release-mode
  /// branch without compiling an actual release build; call sites in app
  /// code always rely on the default (the real [kDebugMode]).
  static bool isEnabled({bool debugMode = kDebugMode}) =>
      debugMode || _showDevLoginDefine;
}
