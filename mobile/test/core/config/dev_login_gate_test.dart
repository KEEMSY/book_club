import 'package:book_club/core/config/dev_login_gate.dart';
import 'package:flutter_test/flutter_test.dart';

/// `flutter test` always runs with asserts enabled, so [DevLoginGate]'s real
/// `kDebugMode` default is unconditionally true inside the test binary and
/// can't exercise the release-mode branch on its own. [DevLoginGate.isEnabled]
/// takes `debugMode` as an injectable parameter for exactly this reason —
/// production call sites rely on the default, these tests pin it explicitly.
void main() {
  test('debug builds are always enabled regardless of the dart-define', () {
    expect(DevLoginGate.isEnabled(debugMode: true), isTrue);
  });

  test(
    'a release build with no SHOW_DEV_LOGIN dart-define is disabled '
    '(production default — safe failure mode is hidden, not exposed)',
    () {
      expect(DevLoginGate.isEnabled(debugMode: false), isFalse);
    },
  );

  // The `--dart-define=SHOW_DEV_LOGIN=true` opt-in branch (staging/QA release
  // builds) can't be exercised here: `bool.fromEnvironment` is resolved at
  // compile time from the actual build invocation, not at test runtime, so
  // there is no way to set it from within a test. That branch is verified by
  // building with the define and confirming DevLoginScreen is reachable.
}
