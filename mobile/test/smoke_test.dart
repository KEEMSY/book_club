import 'package:book_club/app.dart';
import 'package:book_club/core/network/dio_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // Prevent google_fonts from attempting network fetches during tests.
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('home screen renders Airbnb-themed hero, subhead and CTAs',
      (tester) async {
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

    // The home screen renders "Book Club" as the editorial serif hero, the
    // softened 감성 subhead, a Rausch Red primary CTA, and the pill-shaped
    // secondary CTA that substitutes for Airbnb's 50%-radius rectangle
    // controls on mobile.
    expect(find.text('Book Club'), findsOneWidget);
    expect(find.text('오늘 읽은 책을 기록하고, 책으로 사람과 만나요'), findsOneWidget);
    expect(find.text('시작하기'), findsOneWidget);
    expect(find.text('어떤 책이 있을까?'), findsOneWidget);
  });
}
