// TODO(phase-1-prerelease): 실제 소셜 로그인 복원 시 아래 import 들을 정상화한다.
// 현재는 개발용 로그인 흐름만 노출하므로 unused 경고를 무시한다.
// ignore_for_file: unused_import, unused_element
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

  // TODO(phase-1-prerelease): 실제 카카오 로그인 복원 시 아래 init 과 경고 로그를
  // 되살린다. 현재는 개발용 로그인 버튼만 노출하므로 placeholder 키로 init 해도
  // 콘솔에만 경고가 쌓이는 상태를 피하기 위해 초기화를 건너뛴다.
  // if (_kakaoNativeAppKey == 'dev-placeholder') {
  //   developer.log(
  //     'KAKAO_NATIVE_APP_KEY is not configured (--dart-define missing); '
  //     'Kakao login will fail at runtime until a real key is supplied.',
  //     name: 'BookClub/auth',
  //   );
  // }
  // KakaoSdk.init(nativeAppKey: _kakaoNativeAppKey);

  runApp(
    const ProviderScope(
      child: BookClubApp(),
    ),
  );
}
