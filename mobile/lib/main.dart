import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'app.dart';

/// Kakao native-app key. Supplied via `--dart-define=KAKAO_NATIVE_APP_KEY=...`
/// in release / staging builds. Falls back to `dev-placeholder` for local runs
/// without credentials — the placeholder is rejected by Kakao's server on the
/// first OAuth call, which is the intended behaviour in dev mode.
const String _kakaoNativeAppKey = String.fromEnvironment(
  'KAKAO_NATIVE_APP_KEY',
  defaultValue: 'dev-placeholder',
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (_kakaoNativeAppKey == 'dev-placeholder') {
    developer.log(
      'KAKAO_NATIVE_APP_KEY not set (--dart-define missing). '
      'Kakao login will fail until a real key is supplied.',
      name: 'BookClub/auth',
    );
  }

  KakaoSdk.init(nativeAppKey: _kakaoNativeAppKey);

  runApp(
    const ProviderScope(
      child: BookClubApp(),
    ),
  );
}
