import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/club/application/session_providers.dart';
import 'package:book_club/features/club/data/club_session_repository.dart';
import 'package:book_club/features/club/presentation/session_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildApp(String sessionId) {
    return ProviderScope(
      overrides: <Override>[
        clubSessionRepositoryProvider.overrideWithValue(
          FakeClubSessionRepository(),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: SessionLoader(
          clubId: 'club-1',
          sessionId: sessionId,
          builder: (session) =>
              Scaffold(body: Text('loaded: ${session.id} (${session.title})')),
        ),
      ),
    );
  }

  testWidgets('resolves a session by id alone and hands it to builder', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp(FakeClubSessionRepository.sessionOpenId));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'loaded: ${FakeClubSessionRepository.sessionOpenId} (1회차 · 1~3장)',
      ),
      findsOneWidget,
    );
  });

  testWidgets('renders an error state for an unknown session id', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp('no-such-session'));
    await tester.pumpAndSettle();

    expect(find.text('회차를 불러오지 못했어요'), findsOneWidget);
  });
}
