import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'app.dart';

/// Kakao native-app key override. Supplied via
/// `--dart-define=KAKAO_NATIVE_APP_KEY=...` in CI / release builds; falls
/// back to the literal `dev-placeholder` string so `flutter run` starts
/// locally without credentials. The placeholder is rejected by the Kakao
/// server at the first OAuth call, which is the intended behaviour.
const String _kakaoNativeAppKey = String.fromEnvironment(
  'KAKAO_NATIVE_APP_KEY',
  defaultValue: 'dev-placeholder',
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (_kakaoNativeAppKey == 'dev-placeholder') {
    developer.log(
      'KAKAO_NATIVE_APP_KEY is not configured (--dart-define missing); '
      'Kakao login will fail at runtime until a real key is supplied.',
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
