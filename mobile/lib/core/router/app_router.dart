import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../config/dev_login_gate.dart';
import '../config/feature_flags.dart';
import '../../features/auth/application/auth_notifier.dart';
import '../../features/auth/domain/auth_state.dart';
import '../../features/auth/presentation/dev_login_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/book/presentation/book_detail_screen.dart';
import '../../features/book/presentation/library_screen.dart';
import '../../features/book/presentation/search_screen.dart';
import '../../features/event/presentation/event_detail_screen.dart';
import '../../features/club/presentation/video_session_screen.dart';
import '../../features/challenge/presentation/badge_collection_screen.dart';
import '../../features/challenge/presentation/challenge_detail_screen.dart';
import '../../features/challenge/presentation/challenge_list_screen.dart';
import '../../features/community/presentation/community_home_screen.dart';
import '../../features/community/presentation/follower_list_screen.dart';
import '../../features/community/presentation/following_list_screen.dart';
import '../../features/community/presentation/leaderboard_screen.dart';
import '../../features/community/presentation/profile_edit_screen.dart';
import '../../features/community/presentation/user_profile_screen.dart';
import '../../features/social/domain/user_summary.dart';
import '../../features/feed/presentation/highlight_explore_screen.dart';
import '../../features/feed/presentation/post_compose_screen.dart';
import '../../features/club/presentation/club_chat_screen.dart';
import '../../features/club/presentation/club_detail_screen.dart';
import '../../features/club/presentation/club_events_screen.dart';
import '../../features/club/presentation/club_loader.dart';
import '../../features/club/presentation/club_room_chat_screen.dart';
import '../../features/club/presentation/club_rooms_screen.dart';
import '../../features/club/presentation/club_sessions_screen.dart';
import '../../features/club/presentation/public_clubs_screen.dart';
import '../../features/club/presentation/session_detail_screen.dart';
import '../../features/club/presentation/session_loader.dart';
import '../../features/club/presentation/agenda_editor_screen.dart';
import '../../features/club/domain/club.dart';
import '../../features/club/domain/club_session.dart';
import '../../features/notification/presentation/notification_screen.dart';
import '../../features/notification/presentation/weekly_report_screen.dart';
import '../../features/referral/application/referral_providers.dart';
import '../../features/referral/presentation/referral_screen.dart';
import '../../features/reminder/presentation/reminder_screen.dart';
import '../../features/legal/presentation/legal_screen.dart';
import '../../features/onboarding/application/onboarding_provider.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/onboarding/presentation/privacy_policy_screen.dart';
import '../../features/search/presentation/unified_search_screen.dart';
import '../../features/subscription/presentation/paywall_screen.dart';
import '../../features/subscription/presentation/team_admin_screen.dart';
import '../../features/reading/application/recap_notifier.dart';
import '../../features/reading/domain/reading_goal.dart';
import '../../features/reading/presentation/dashboard_screen.dart';
import '../../features/reading/presentation/goal_screen.dart';
import '../../features/reading/presentation/grade_screen.dart';
import '../../features/reading/presentation/session_summary_screen.dart';
import '../../features/retention/presentation/streak_recovery_screen.dart';
import '../../features/reading/presentation/monthly_recap_screen.dart';
import '../../features/reading/presentation/reading_recap_screen.dart';
import '../../features/reading/presentation/advanced_stats_screen.dart';
import '../../features/reading/presentation/reading_stats_screen.dart';
import '../../features/reading/presentation/timer_screen.dart';
import 'app_shell.dart';

/// Route paths, kept as constants so feature code does not stringly-type them.
class AppRoutes {
  const AppRoutes._();

  // Entry / auth.
  static const login = '/login';

  // BC-86 — hidden dev/tester login shortcuts (staging/dev builds only, see
  // [DevLoginGate]). Not linked from any UI; reachable only by direct
  // navigation to this path.
  static const devLogin = '/dev-login';

  // M3 destinations.
  static const home = '/home';
  static const grade = '/grade';
  static const goals = '/goals';
  static String timer(String userBookId) =>
      '/reading/timer?user_book_id=$userBookId';

  // M16 destinations — discovery tab (replaces plain search shell branch).
  static const discovery = '/discovery';

  // M2 destinations (still reachable through the shell).
  static const search = '/search';
  static const library = '/library';
  static String bookDetail(String id) => '/books/$id';

  // M5 destinations.
  static const notifications = '/notifications';
  static const weeklyReport = '/reports/weekly';

  // M7 destinations.
  static const community = '/community';
  static String userProfile(String userId) => '/users/$userId/profile';
  static String userFollowers(String userId) => '/users/$userId/followers';
  static String userFollowing(String userId) => '/users/$userId/following';

  // M9 destinations — challenge & badge.
  static const challenges = '/community/challenges';
  static String challengeDetail(String id) => '/community/challenges/$id';
  static const badges = '/community/badges';

  // M27 destination — weekly social leaderboard.
  static const leaderboard = '/community/leaderboard';

  // Profile edit — own profile only.
  static const profileEdit = '/profile/edit';

  // Reading recap — half-year card view, shown in June and December.
  static const readingRecap = '/reading/recap';

  // M21 — full reading analytics screen.
  static const readingStats = '/reading/stats';

  // M53 — Pro-only advanced analytics (speed trend, genre, yearly compare).
  static const advancedStats = '/reading/stats/advanced';

  // M28 — monthly recap card.
  static const monthlyRecap = '/reading/recap/monthly';

  // M31 — friend referral / invite screen.
  static const referral = '/profile/referral';

  // M33 — personalized reading reminders.
  static const reminders = '/profile/reminders';

  // Deeplink handled by go_router — applying a friend's invite code.
  static String invite(String code) => '/invite/$code';

  // M30 — offline reading meetup events list.
  static String clubEvents(String clubId) => '/clubs/$clubId/events';

  // M29 — chapter-gated chat rooms list and individual room chat.
  static String clubRooms(String clubId) => '/clubs/$clubId/rooms';
  static String clubRoomChat(String clubId, String roomId) =>
      '/clubs/$clubId/rooms/$roomId/chat';

  // BC-49 — session (회차) list and detail.
  static String clubSessions(String clubId) => '/clubs/$clubId/sessions';

  // BC-52 — [topicId] renders as a `?topic_id=` query param the session
  // route reads to auto-expand/scroll to that topic (feed-card taps and
  // push-notification deep links only carry ids, never the full
  // `ClubSession`/topic objects the list screen passes via `extra`).
  static String sessionDetail(
    String clubId,
    String sessionId, {
    String? topicId,
  }) {
    final base = '/clubs/$clubId/sessions/$sessionId';
    return topicId != null
        ? '$base?topic_id=${Uri.encodeQueryComponent(topicId)}'
        : base;
  }

  // BC-50 — agenda editor, opened from SessionDetailScreen's AppBar action
  // (host/presenter only — gated by canAuthorAgendaProvider both there and
  // inside the editor screen itself).
  static String agendaEditor(String clubId, String sessionId) =>
      '/clubs/$clubId/sessions/$sessionId/agenda/edit';

  // M32 — public club discovery screen.
  static const publicClubs = '/discover/clubs';

  // M34 — Pro subscription paywall.
  static const paywall = '/paywall';

  // M35 — first-run onboarding flow.
  static const onboarding = '/onboarding';

  // M38 — unified search (books + users + clubs).
  static const unifiedSearch = '/unified-search';

  // M45 — privacy policy screen (opens external browser).
  static const privacyPolicy = '/privacy-policy';

  // M57 — in-app legal documents (App Store submission requirement).
  static const settingsPrivacy = '/settings/privacy';
  static const settingsTerms = '/settings/terms';

  // Highlight discovery — community-wide highlight explore feed.
  static const highlightExplore = '/highlights/explore';

  // Post-session celebration; requires a SessionCompletion passed via extra.
  static const sessionSummary = '/reading/session-summary';

  // Broken-streak recovery; longest-streak count passed via extra.
  static const streakRecovery = '/streak-recovery';

  // Club detail; full Club passed via extra when available, else loaded by id.
  static String clubDetail(String clubId) => '/clubs/$clubId';

  // Club-level chat (distinct from chapter-gated room chat).
  static String clubChat(String clubId) => '/clubs/$clubId/chat';

  // M68 — location-based meetup detail.
  static String eventDetail(String eventId) => '/events/$eventId';

  // M68 — reading-club video call (Pro club owner).
  static String clubVideo(String clubId) => '/clubs/$clubId/video';

  // M70 — B2B team-plan admin console.
  static String teamAdmin(String teamId) => '/teams/$teamId';
}

/// Adapter that bridges a Riverpod [ValueNotifier]-free state stream into a
/// [Listenable] `go_router` can watch. Emits a tick every time the underlying
/// provider produces a new value.
class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(Ref ref) {
    _sub = ref.listen<AuthState>(
      authNotifierProvider,
      (_, __) => notifyListeners(),
      fireImmediately: false,
    );
    ref.onDispose(() => _sub.close());
  }

  late final ProviderSubscription<AuthState> _sub;
}

final _shellHomeKey = GlobalKey<NavigatorState>();
final _shellSearchKey = GlobalKey<NavigatorState>();
final _shellLibraryKey = GlobalKey<NavigatorState>();
final _shellCommunityKey = GlobalKey<NavigatorState>();
final _rootKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final listenable = _AuthStateListenable(ref);
  return GoRouter(
    initialLocation: AppRoutes.home,
    navigatorKey: _rootKey,
    refreshListenable: listenable,
    redirect: (context, state) {
      final AuthState auth = ref.read(authNotifierProvider);
      final String target = state.matchedLocation;

      // M3 promotes `/home` back to the authenticated landing.
      final String canonical = target == '/' ? AppRoutes.home : target;

      if (auth is AuthInitial) {
        return canonical == target ? null : canonical;
      }

      final bool authenticated = auth is Authenticated;
      final bool onLogin = canonical == AppRoutes.login;
      final bool onOnboarding = canonical == AppRoutes.onboarding;
      final bool onDevLogin = canonical == AppRoutes.devLogin;

      // Authenticated users never need the onboarding/login/dev-login screens.
      if (authenticated && (onLogin || onOnboarding || onDevLogin)) {
        return AppRoutes.home;
      }

      // Deferred features (BC-23): their nav entry points are hidden, but guard
      // direct/persisted navigation so a deep link doesn't land on a screen
      // whose backend router is unmounted (404). Only unambiguous stand-alone
      // routes are listed — kept features that share a prefix (e.g.
      // /community/challenges, /discover/clubs) are intentionally excluded.
      if (authenticated) {
        const Set<String> deferredRoutes = <String>{
          AppRoutes.discovery,
          AppRoutes.community,
          AppRoutes.unifiedSearch,
          AppRoutes.paywall,
        };
        if (deferredRoutes.contains(canonical)) {
          return AppRoutes.home;
        }
      }

      // Unauthenticated: decide between onboarding and login. The hidden
      // dev-login route (BC-86) is treated like login/onboarding here — its
      // own redirect below is the actual gate enforcement point, so a
      // disabled [DevLoginGate] still falls through this branch onto login
      // rather than ever rendering [DevLoginScreen].
      if (!authenticated && !onLogin && !onOnboarding && !onDevLogin) {
        // Check the onboarding-complete flag synchronously from the cache.
        // The provider is pre-warmed in main.dart so the value is available.
        final bool onboardingDone =
            ref.read(onboardingCompletedProvider).valueOrNull ?? false;
        return onboardingDone ? AppRoutes.login : AppRoutes.onboarding;
      }

      return canonical == target ? null : canonical;
    },
    routes: <RouteBase>[
      // Onboarding — shown on first launch before login.
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      // Login sits outside the shell — no bottom nav on the login screen.
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      // BC-86 — hidden dev/tester login shortcuts, moved off the main login
      // screen so a production build never surfaces a backend-login bypass
      // next to the real Kakao/Apple CTAs. Reachable only by direct
      // navigation (no UI links here); [DevLoginGate.isEnabled] is true
      // automatically in debug builds and otherwise requires an explicit
      // `--dart-define=SHOW_DEV_LOGIN=true` (e.g. a staging/QA release
      // build) — a plain production release build redirects straight to
      // `/login`, matching the top-level redirect's authenticated bounce-home
      // above (same double-gate pattern as AppRoutes.paywall below).
      GoRoute(
        path: AppRoutes.devLogin,
        redirect: (context, state) =>
            DevLoginGate.isEnabled() ? null : AppRoutes.login,
        builder: (context, state) => const DevLoginScreen(),
      ),
      // Book detail is pushed on top of whichever shell branch the user is on
      // (home vs search vs library), so it lives on the root navigator.
      GoRoute(
        path: '/books/:id',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final String id = state.pathParameters['id']!;
          final String? userBookId = state.extra as String?;
          return BookDetailScreen(bookId: id, userBookId: userBookId);
        },
        routes: <RouteBase>[
          // Compose surface stacked above the detail screen — full-screen
          // modal route owned by the root navigator.
          GoRoute(
            path: 'posts/new',
            parentNavigatorKey: _rootKey,
            builder: (context, state) {
              final String id = state.pathParameters['id']!;
              return PostComposeScreen(bookId: id);
            },
          ),
        ],
      ),
      // Timer lives above the shell so the session UI takes the full screen
      // without the bottom-nav strip stealing focus.
      GoRoute(
        path: '/reading/timer',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final String userBookId =
              state.uri.queryParameters['user_book_id'] ?? '';
          final String bookId = state.uri.queryParameters['book_id'] ?? '';
          final bool autoStart =
              state.uri.queryParameters['auto_start'] == 'true';
          final int? targetSeconds = int.tryParse(
            state.uri.queryParameters['target_seconds'] ?? '',
          );
          return TimerScreen(
            userBookId: userBookId,
            bookId: bookId,
            autoStart: autoStart,
            targetSeconds: targetSeconds,
          );
        },
      ),
      // Grade + Goals are reachable from the dashboard but render without
      // the shell so their AppBar back-arrow pops cleanly.
      GoRoute(
        path: AppRoutes.grade,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const GradeScreen(),
      ),
      GoRoute(
        path: AppRoutes.goals,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const GoalScreen(),
      ),
      GoRoute(
        path: AppRoutes.readingRecap,
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          // RecapKey is passed via go_router extra from RecapBanner.
          final RecapKey key = state.extra! as RecapKey;
          return ReadingRecapScreen(recapKey: key);
        },
      ),
      GoRoute(
        path: AppRoutes.readingStats,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const ReadingStatsScreen(),
      ),
      GoRoute(
        path: AppRoutes.advancedStats,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const AdvancedStatsScreen(),
      ),
      // Community-wide highlight discovery feed.
      GoRoute(
        path: AppRoutes.highlightExplore,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const HighlightExploreScreen(),
      ),
      // Post-session celebration. Requires a SessionCompletion via extra;
      // without it there is nothing to summarise, so fall back to home.
      GoRoute(
        path: AppRoutes.sessionSummary,
        parentNavigatorKey: _rootKey,
        redirect: (context, state) =>
            state.extra is SessionCompletion ? null : AppRoutes.home,
        builder: (context, state) =>
            SessionSummaryScreen(completion: state.extra! as SessionCompletion),
      ),
      // Broken-streak recovery. Longest-streak count passed via extra int.
      GoRoute(
        path: AppRoutes.streakRecovery,
        parentNavigatorKey: _rootKey,
        builder: (context, state) =>
            StreakRecoveryScreen(longest: state.extra as int? ?? 0),
      ),
      // M28 — monthly recap card. Optional (year, month) passed as extra Map.
      GoRoute(
        path: AppRoutes.monthlyRecap,
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final Map<String, int>? extra = state.extra as Map<String, int>?;
          return MonthlyRecapScreen(
            year: extra?['year'],
            month: extra?['month'],
          );
        },
      ),
      // M32 — public club discovery screen.
      GoRoute(
        path: AppRoutes.publicClubs,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const PublicClubsScreen(),
      ),
      // M30 — club events list (offline reading meetup UI).
      GoRoute(
        path: '/clubs/:clubId/events',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final String clubId = state.pathParameters['clubId']!;
          return ClubEventsScreen(clubId: clubId);
        },
      ),
      // M68 — reading-club video call; Pro club owner only (backend re-checks).
      // Deferred by BC-18 (Agora RTC cost); guard the deep-link entry too since
      // the club-detail button is flag-gated.
      GoRoute(
        path: '/clubs/:clubId/video',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          if (!FeatureFlags.video) return const _DeferredFeatureScreen();
          final String clubId = state.pathParameters['clubId']!;
          return VideoSessionScreen(clubId: clubId);
        },
      ),
      // M68 — location-based meetup detail screen.
      GoRoute(
        path: '/events/:eventId',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final String eventId = state.pathParameters['eventId']!;
          return EventDetailScreen(eventId: eventId);
        },
      ),
      // M70 — B2B team-plan admin console. Deferred by BC-18 (non-MVP scope);
      // this route is the feature's only entry point, so guard it here.
      GoRoute(
        path: '/teams/:id',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          if (!FeatureFlags.team) return const _DeferredFeatureScreen();
          final String teamId = state.pathParameters['id']!;
          return TeamAdminScreen(teamId: teamId);
        },
      ),
      // M29 — chapter-gated room list; Club object passed via extra.
      GoRoute(
        path: '/clubs/:clubId/rooms',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final Club club = state.extra! as Club;
          return ClubRoomsScreen(club: club);
        },
      ),
      // M29 — individual room chat screen.
      GoRoute(
        path: '/clubs/:clubId/rooms/:roomId/chat',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final String clubId = state.pathParameters['clubId']!;
          final String roomId = state.pathParameters['roomId']!;
          // Room name is optionally passed as extra String for AppBar display.
          final String roomName = state.extra as String? ?? '채팅방';
          return ClubRoomChatScreen(
            clubId: clubId,
            roomId: roomId,
            roomName: roomName,
          );
        },
      ),
      // BC-49 — session list; Club passed via extra (same convention as the
      // room list above). Unlike the session-detail route below, this list
      // route has no id-only fallback — feed cards/notifications deep-link
      // straight to a session, never to "the session list for this club".
      GoRoute(
        path: '/clubs/:clubId/sessions',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final Club club = state.extra! as Club;
          return ClubSessionsScreen(club: club);
        },
      ),
      // BC-49 — session detail; ClubSession passed via extra from the list.
      // BC-52 — also reachable by id alone (ClubSession absent from extra)
      // from feed-card taps and push-notification deep links, resolved via
      // SessionLoader; an optional `?topic_id=` focuses/scrolls to a topic.
      GoRoute(
        path: '/clubs/:clubId/sessions/:sessionId',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final String clubId = state.pathParameters['clubId']!;
          final String sessionId = state.pathParameters['sessionId']!;
          final ClubSession? session = state.extra as ClubSession?;
          final String? focusTopicId = state.uri.queryParameters['topic_id'];
          return session != null
              ? SessionDetailScreen(
                  session: session,
                  focusTopicId: focusTopicId,
                )
              : SessionLoader(
                  clubId: clubId,
                  sessionId: sessionId,
                  builder: (loaded) => SessionDetailScreen(
                    session: loaded,
                    focusTopicId: focusTopicId,
                  ),
                );
        },
      ),
      // BC-50 — agenda editor; ClubSession passed via extra from the detail
      // screen's AppBar action.
      GoRoute(
        path: '/clubs/:clubId/sessions/:sessionId/agenda/edit',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final ClubSession session = state.extra! as ClubSession;
          return AgendaEditorScreen(session: session);
        },
      ),
      // Club-level chat — opened directly from chat notifications/deeplinks.
      // The full Club is loaded by id since notification payloads carry only
      // the club id.
      GoRoute(
        path: '/clubs/:clubId/chat',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final String clubId = state.pathParameters['clubId']!;
          final Club? club = state.extra as Club?;
          return club != null
              ? ClubChatPage(club: club)
              : ClubLoader(
                  clubId: clubId,
                  builder: (loaded) => ClubChatPage(club: loaded),
                );
        },
      ),
      // Club detail — reachable from club lists (Club passed via extra) and from
      // notifications (loaded by id).
      GoRoute(
        path: '/clubs/:clubId',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final String clubId = state.pathParameters['clubId']!;
          final Club? club = state.extra as Club?;
          return club != null
              ? ClubDetailScreen(club: club)
              : ClubLoader(
                  clubId: clubId,
                  builder: (loaded) => ClubDetailScreen(club: loaded),
                );
        },
      ),
      GoRoute(
        path: AppRoutes.notifications,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.weeklyReport,
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final String? week = state.uri.queryParameters['week'];
          return WeeklyReportScreen(weekStart: week);
        },
      ),
      // Profile edit — own profile only, pushed above the shell.
      GoRoute(
        path: AppRoutes.profileEdit,
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final UserProfile profile = state.extra! as UserProfile;
          return ProfileEditScreen(profile: profile);
        },
      ),
      // M31 — friend invite / referral screen, pushed above the shell.
      // Deferred (BC-19): when the referral feature is off, block the route.
      GoRoute(
        path: AppRoutes.referral,
        parentNavigatorKey: _rootKey,
        redirect: (context, state) =>
            FeatureFlags.referral ? null : AppRoutes.home,
        builder: (context, state) => const ReferralScreen(),
      ),
      // M33 — personalized reading reminders, pushed above the shell.
      GoRoute(
        path: AppRoutes.reminders,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const ReminderScreen(),
      ),
      // M34 — Pro subscription paywall, reachable from any tab.
      // Deferred (BC-19): when subscription is off, block the route.
      GoRoute(
        path: AppRoutes.paywall,
        parentNavigatorKey: _rootKey,
        redirect: (context, state) =>
            FeatureFlags.subscription ? null : AppRoutes.home,
        builder: (context, state) => const PaywallScreen(),
      ),
      // M38 — unified search (books + users + clubs), pushed above the shell.
      GoRoute(
        path: AppRoutes.unifiedSearch,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const UnifiedSearchScreen(),
      ),
      // M45 — privacy policy: opens external browser then pops.
      GoRoute(
        path: AppRoutes.privacyPolicy,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      // M57 — in-app legal documents rendered from bundled Markdown assets.
      GoRoute(
        path: AppRoutes.settingsPrivacy,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const LegalScreen(
          title: '개인정보처리방침',
          assetPath: 'assets/legal/privacy_policy.md',
        ),
      ),
      GoRoute(
        path: AppRoutes.settingsTerms,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const LegalScreen(
          title: '이용약관',
          assetPath: 'assets/legal/terms.md',
        ),
      ),
      // M31 — deeplink entry point: bookclub.app/invite/{code}
      // Applies the referral code and then redirects to home. The apply call
      // is fire-and-forget here; errors are silently swallowed so the UX stays
      // frictionless (the user lands on home regardless).
      GoRoute(
        path: '/invite/:code',
        parentNavigatorKey: _rootKey,
        redirect: (context, state) {
          // Deferred (BC-19): skip applying referral codes when the feature is
          // off; land the user on home regardless.
          if (!FeatureFlags.referral) return AppRoutes.home;
          final String code = state.pathParameters['code']!;
          // Obtain the repository via ProviderScope without a ref by reading
          // through the container exposed on the root element. We use a
          // builder+redirect hybrid: the redirect triggers the side-effect and
          // immediately sends the user to home.
          final container = ProviderScope.containerOf(context, listen: false);
          // ignore: unawaited_futures — intentional fire-and-forget
          container
              .read(
                // Import deferred to avoid a direct reference that would
                // couple the router to the referral feature's internals.
                // We pass the provider by dynamic lookup so build_runner does
                // not need to codegen this file.
                referralRepositoryProvider,
              )
              .applyReferral(code)
              .catchError((_) {});
          return AppRoutes.home;
        },
      ),
      // User profile — pushed above the shell so the nav bar disappears and
      // the AppBar back-arrow pops cleanly regardless of originating tab.
      GoRoute(
        path: '/users/:id/profile',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final String id = state.pathParameters['id']!;
          return UserProfileScreen(userId: id);
        },
      ),
      GoRoute(
        path: '/users/:id/followers',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final String id = state.pathParameters['id']!;
          return FollowerListScreen(userId: id);
        },
      ),
      GoRoute(
        path: '/users/:id/following',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final String id = state.pathParameters['id']!;
          return FollowingListScreen(userId: id);
        },
      ),
      // Four-tab StatefulShellRoute — 홈 · 검색 · 서재 · 커뮤니티.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _shellHomeKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellSearchKey,
            routes: <RouteBase>[
              // BC-79: middle tab is book search (MVP core), not the deferred
              // discovery tab. Restores 홈·검색·서재 after BC-23's discovery
              // deferral removed the only search entry point.
              GoRoute(
                path: AppRoutes.search,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellLibraryKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.library,
                builder: (context, state) {
                  final String? highlight =
                      state.uri.queryParameters['highlight'];
                  return LibraryScreen(highlightUserBookId: highlight);
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellCommunityKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.community,
                builder: (context, state) => const CommunityHomeScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'challenges',
                    builder: (context, state) => const ChallengeListScreen(),
                    routes: <RouteBase>[
                      GoRoute(
                        path: ':id',
                        builder: (context, state) => ChallengeDetailScreen(
                          challengeId: state.pathParameters['id']!,
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'badges',
                    builder: (context, state) => const BadgeCollectionScreen(),
                  ),
                  GoRoute(
                    path: 'leaderboard',
                    builder: (context, state) => const LeaderboardScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// Shown when a deep-link targets a feature deferred by the scope cleanup
/// (BC-18). The route stays registered so the code path is intact; only the
/// screen is withheld while its [FeatureFlags] entry is false.
class _DeferredFeatureScreen extends StatelessWidget {
  const _DeferredFeatureScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('현재 사용할 수 없는 기능입니다.')),
    );
  }
}
