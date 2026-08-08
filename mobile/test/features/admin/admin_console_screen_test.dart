import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/admin/application/admin_providers.dart';
import 'package:book_club/features/admin/data/admin_api.dart';
import 'package:book_club/features/admin/data/admin_repository.dart';
import 'package:book_club/features/admin/domain/admin_overview.dart';
import 'package:book_club/features/admin/domain/admin_stats.dart';
import 'package:book_club/features/admin/domain/admin_user.dart';
import 'package:book_club/features/admin/domain/conversion_funnel.dart';
import 'package:book_club/features/admin/domain/revenue_metrics.dart';
import 'package:book_club/features/admin/presentation/admin_console_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

/// Serves canned metrics + a one-user page so the console renders without any
/// network. Extends the concrete repository (the console's single seam —
/// `adminOverviewProvider` and `adminUsersNotifierProvider` both resolve
/// through `adminRepositoryProvider`) and overrides only the three calls.
class _FakeAdminRepository extends AdminRepository {
  _FakeAdminRepository() : super(AdminApi(Dio()));

  @override
  Future<AdminOverview> getOverview() async => const AdminOverview(
        stats: AdminStats(mau: 1200, dau: 300, newUsers7d: 42, proUsers: 88),
        funnel: ConversionFunnel(
          paywallViews: 500,
          paywallClicks: 120,
          subscriptions: 30,
          conversionRate: 0.06,
        ),
        revenue: RevenueMetrics(
          mrr: 990000,
          arr: 11880000,
          activeSubscribers: 88,
          churned30d: 5,
          teamMrr: 0,
          monthlyTrend: <MonthlyMrrPoint>[],
        ),
      );

  @override
  Future<AdminUserPage> listUsers({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) async =>
      AdminUserPage(
        items: <AdminUser>[
          AdminUser(
            id: 'u1',
            nickname: '테스터',
            email: 't@example.com',
            isActive: true,
            isAdmin: false,
            isPro: true,
            createdAt: DateTime(2026, 1, 1),
          ),
        ],
        total: 1,
        page: 1,
        pageSize: 20,
      );

  @override
  Future<AdminUser> patchUser(
    String userId, {
    bool? isActive,
    bool? isAdmin,
  }) async =>
      AdminUser(
        id: userId,
        nickname: '테스터',
        email: 't@example.com',
        isActive: isActive ?? true,
        isAdmin: isAdmin ?? false,
        isPro: true,
        createdAt: DateTime(2026, 1, 1),
      );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget host() => ProviderScope(
        overrides: <Override>[
          adminRepositoryProvider.overrideWithValue(_FakeAdminRepository()),
        ],
        child: MaterialApp(
            theme: AppTheme.light, home: const AdminConsoleScreen()),
      );

  testWidgets('renders metrics + user list from the repository', (
    tester,
  ) async {
    // Tall viewport so the lazily-built user SliverList row is laid out
    // (metrics + dev-tools + search push it below the default 600px fold).
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    expect(find.text('관리자 콘솔'), findsOneWidget);
    expect(find.text('사용자 관리'), findsOneWidget);
    // The seeded user row proves the overview + user-list pipeline resolved
    // through the fake repository.
    expect(find.text('테스터'), findsOneWidget);
  });
}
