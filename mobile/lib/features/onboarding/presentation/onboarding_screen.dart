import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/presentation/widgets/kakao_login_button.dart';

/// SharedPreferences key that records whether the user has completed the
/// first-run onboarding flow.
const String kOnboardingCompleteKey = 'onboarding_complete';

/// Provider that exposes the onboarding-complete flag.
///
/// Reads [SharedPreferences] once at startup. The value is updated by
/// [OnboardingScreen] when the user finishes (or skips) the flow.
final onboardingCompleteProvider =
    FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(kOnboardingCompleteKey) ?? false;
});

/// Three-page introduction shown to first-time users.
///
/// Page 1: app value proposition — books / streaks / clubs.
/// Page 2: reading habit tracking illustration.
/// Page 3: call-to-action with Kakao login button.
///
/// Completing or skipping the flow writes [kOnboardingCompleteKey] = true and
/// navigates to [AppRoutes.login] (auth redirect takes over from there).
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  static const int _pageCount = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _markComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kOnboardingCompleteKey, true);
    // Invalidate provider so the router redirect re-evaluates.
    ref.invalidate(onboardingCompleteProvider);
  }

  void _next() {
    if (_currentPage < _pageCount - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _skip() async {
    await _markComplete();
    if (mounted) context.go(AppRoutes.login);
  }

  Future<void> _onKakaoLogin() async {
    await _markComplete();
    if (mounted) {
      // Trigger Kakao login; if already on login screen the auth notifier
      // handles the flow. Navigate to login first so the auth state watcher
      // can redirect to home after success.
      context.go(AppRoutes.login);
      // Kick off Kakao flow immediately after navigation settles.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(authNotifierProvider.notifier).loginWithKakao();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Skip button — hidden on the last page.
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(top: spacing.sm, right: spacing.md),
                child: _currentPage < _pageCount - 1
                    ? TextButton(
                        onPressed: _skip,
                        child: Text(
                          '건너뛰기',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : const SizedBox(height: 40),
              ),
            ),
            // Page content.
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                children: const <Widget>[
                  _OnboardingPage(
                    icon: Icons.auto_stories_rounded,
                    title: '함께 읽는 즐거움',
                    description: '독서 기록, 스트릭, 클럽 — 모두 한 곳에',
                  ),
                  _OnboardingPage(
                    icon: Icons.local_fire_department_rounded,
                    title: '내 독서 습관 추적',
                    description: '매일의 기록이 쌓여 멋진 통계가 돼요',
                  ),
                  _OnboardingPage(
                    icon: Icons.group_rounded,
                    title: '지금 시작하기',
                    description: '카카오 계정으로 간편하게 시작해보세요',
                    isLast: true,
                  ),
                ],
              ),
            ),
            // Dot indicator.
            Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.md),
              child: _PageIndicator(
                count: _pageCount,
                current: _currentPage,
              ),
            ),
            // Bottom CTA.
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.lg,
                0,
                spacing.lg,
                spacing.xl,
              ),
              child: _currentPage < _pageCount - 1
                  ? SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton(
                        onPressed: _next,
                        child: const Text('다음'),
                      ),
                    )
                  : KakaoLoginButton(
                      onPressed: _onKakaoLogin,
                      label: '카카오로 시작하기',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single onboarding page with a large icon, title, and description.
class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final String description;

  /// When true the icon renders slightly larger to give the final CTA page
  /// a bit more visual weight.
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: isLast ? 120 : 100,
            height: isLast ? 120 : 100,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: isLast ? 56 : 48,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(height: spacing.xl),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.md),
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Row of circular dot indicators showing page position.
class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(count, (i) {
        final bool active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
