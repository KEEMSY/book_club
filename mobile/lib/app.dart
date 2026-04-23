import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class BookClubApp extends ConsumerWidget {
  const BookClubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Book Club',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // TODO(phase-1-postlaunch): 대시보드 · 서재 등 대부분의 위젯이
      // AppPalette.nearBlack / pureWhite 같은 라이트 팔레트 토큰을
      // 하드코딩해서 다크 모드에서 텍스트가 배경과 묻힌다. 전체 위젯을
      // colorScheme.onSurface / surface 로 마이그레이션하기 전까지는
      // 라이트 모드로 강제해 가독성 사고를 차단한다.
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
