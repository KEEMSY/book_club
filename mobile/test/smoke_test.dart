import 'package:book_club/app.dart';
import 'package:book_club/core/network/dio_provider.dart';
import 'package:book_club/core/storage/secure_storage.dart';
import 'package:book_club/features/auth/application/auth_providers.dart';
import 'package:book_club/features/auth/data/auth_repository.dart';
import 'package:book_club/features/auth/data/social_login_port.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/auth/fakes.dart';

void main() {
  // Prevent google_fonts from attempting network fetches during tests.
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('unauthenticated launch lands on the Airbnb-toned login screen',
      (tester) async {
    // Override dio + AuthRepository so the bootstrap path resolves without
    // touching flutter_secure_storage (which throws MissingPluginException
    // in the widget-test zone) and without hitting the network.
    final fakeDio = Dio();
    final storage = InMemorySecureStorage();
    final api = FakeAuthApi();
    final social = FakeSocialLoginPort(
      kakaoResult: const SocialLoginResult(accessToken: 'k'),
      appleResult: const SocialLoginResult(identityToken: 'a'),
    );
    final repository = AuthRepository(
      api: api,
      secureStorage: storage,
      socialLogin: social,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          dioProvider.overrideWithValue(fakeDio),
          secureStorageProvider.overrideWithValue(storage),
          authRepositoryProvider.overrideWithValue(repository),
        ],
        child: const BookClubApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Router guard resolves Unauthenticated → /login. The login screen
    // renders the Playfair "Book Club" hero + the warm subhead copy.
    expect(find.text('Book Club'), findsOneWidget);
    expect(find.text('책으로 연결되는 모든 순간'), findsOneWidget);
  });
}
