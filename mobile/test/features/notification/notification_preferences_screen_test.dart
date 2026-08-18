import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/notification/data/notification_models.dart';
import 'package:book_club/features/notification/data/notification_repository.dart';
import 'package:book_club/features/notification/presentation/notification_preferences_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fakes.dart';

/// BC-92 — notification preferences toggle screen.
///
/// Covers: toggle rendering (on/off/default), PATCH call on toggle,
/// required-type rows rendering always-on and disabled, and optimistic
/// rollback + snackbar on a failed PATCH.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  NotificationPreferencesResponse buildPrefs({
    Map<String, bool> preferences = const {'comment': false},
    List<String> requiredTypes = const ['subscription_reminder'],
  }) {
    return NotificationPreferencesResponse(
      preferences: preferences,
      requiredTypes: requiredTypes,
    );
  }

  Finder tileFor(String label) => find.ancestor(
        of: find.text(label),
        matching: find.byType(SwitchListTile),
      );

  Future<FakeNotificationRepository> pumpScreen(
    WidgetTester tester, {
    NotificationPreferencesResponse? prefs,
  }) async {
    final repo = FakeNotificationRepository()
      ..preferencesResult = prefs ?? buildPrefs();

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          notificationRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const NotificationPreferencesScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return repo;
  }

  testWidgets(
      'renders toggleable rows with server value, missing keys default to on',
      (tester) async {
    await pumpScreen(
      tester,
      prefs: buildPrefs(
        preferences: const {'reaction': true, 'comment': false},
      ),
    );

    expect(tester.widget<SwitchListTile>(tileFor('반응')).value, isTrue);
    expect(tester.widget<SwitchListTile>(tileFor('댓글')).value, isFalse);
    // 'grade_up' is absent from the preferences map — missing key means on.
    expect(tester.widget<SwitchListTile>(tileFor('등급 상승')).value, isTrue);
  });

  testWidgets(
      'required type renders always-on and disabled with the 필수 subtitle',
      (tester) async {
    await pumpScreen(tester);

    final tile = tester.widget<SwitchListTile>(tileFor('구독 안내'));
    expect(tile.value, isTrue);
    // A null onChanged is what actually disables the switch — a real tap
    // wouldn't call it either way, so asserting this is the reliable check.
    expect(tile.onChanged, isNull);
    expect(find.text('끌 수 없는 필수 알림입니다'), findsOneWidget);
  });

  testWidgets('toggling a switch sends a partial PATCH with the new value',
      (tester) async {
    final repo = await pumpScreen(
      tester,
      prefs: buildPrefs(preferences: const {'reaction': true}),
    );
    repo.updateResult = buildPrefs(
      preferences: const {'reaction': false},
    );

    await tester.tap(tileFor('반응'));
    await tester.pumpAndSettle();

    expect(repo.updateCalls, <Map<String, bool>>[
      {'reaction': false},
    ]);
    expect(tester.widget<SwitchListTile>(tileFor('반응')).value, isFalse);
  });

  testWidgets(
      'failed PATCH rolls the switch back and shows a snackbar with the error',
      (tester) async {
    final repo = await pumpScreen(
      tester,
      prefs: buildPrefs(preferences: const {'comment': false}),
    );
    repo.updateError = const NotificationRepositoryException(
      code: 'UPSTREAM_UNAVAILABLE',
      message: '변경에 실패했어요. 다시 시도해주세요.',
    );

    // The fake repository rejects synchronously, so the optimistic frame and
    // its rollback can both land within tester.tap()'s own event-processing
    // microtasks — asserting only the settled end state keeps this robust.
    await tester.tap(tileFor('댓글'));
    await tester.pumpAndSettle();

    expect(tester.widget<SwitchListTile>(tileFor('댓글')).value, isFalse);
    expect(find.text('변경에 실패했어요. 다시 시도해주세요.'), findsOneWidget);
  });
}
