import 'package:book_club/app.dart';
import 'package:book_club/core/network/dio_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // Prevent google_fonts from attempting network fetches during tests.
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('home screen renders Book Club title', (tester) async {
    // Override dioProvider with a fake instance that is never called at M0.
    // Wiring it here prevents accidental network touches in future tests.
    final fakeDio = Dio();

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          dioProvider.overrideWithValue(fakeDio),
        ],
        child: const BookClubApp(),
      ),
    );

    // First frame is MaterialApp; let router settle.
    await tester.pumpAndSettle();

    // The home screen renders "Book Club" as the Large Title, plus the
    // Apple-themed subtitle and tinted CTA.
    expect(find.text('Book Club'), findsOneWidget);
    expect(find.text('독서를 기록하고, 책으로 대화하세요'), findsOneWidget);
    expect(find.text('시작하기'), findsOneWidget);
  });
}
