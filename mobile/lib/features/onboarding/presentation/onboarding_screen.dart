import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../application/onboarding_provider.dart';

/// Three-slide introduction shown to first-time users before login.
///
/// Slide 1: reading-timer value prop.
/// Slide 2: heatmap / growth value prop.
/// Slide 3: community value prop, with the "시작하기" CTA.
///
/// Completing ("시작하기") or skipping ("건너뛰기") marks onboarding done via
/// [markOnboardingDone] and navigates to [AppRoutes.login]; the auth redirect
/// takes over from there.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  static const List<_OnboardingSlide> _slides = <_OnboardingSlide>[
    _OnboardingSlide(
      icon: Icons.timer_outlined,
      title: '독서 시간을 기록하세요',
      description: '타이머로 매일의 독서를 가볍게 기록하고\n쌓이는 시간을 확인해요.',
    ),
    _OnboardingSlide(
      icon: Icons.grid_view_rounded,
      title: '성장을 눈으로 확인하세요',
      description: '독서 잔디와 통계로 나의 꾸준함을\n한눈에 돌아볼 수 있어요.',
    ),
    _OnboardingSlide(
      icon: Icons.chat_bubble_outline_rounded,
      title: '독서 친구와 대화하세요',
      description: '클럽과 커뮤니티에서 같은 책을 읽는\n친구들과 이야기를 나눠요.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isLastPage => _currentPage == _slides.length - 1;

  void _next() {
    if (!_isLastPage) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finish() async {
    await markOnboardingDone(ref);
    if (mounted) context.go(AppRoutes.login);
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
            // Skip button — hidden on the last slide.
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(top: spacing.sm, right: spacing.md),
                child: _isLastPage
                    ? const SizedBox(height: 40)
                    : TextButton(
                        onPressed: _finish,
                        child: Text(
                          '건너뛰기',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                itemBuilder: (context, index) =>
                    _OnboardingPage(slide: _slides[index]),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.md),
              child: _PageIndicator(
                count: _slides.length,
                current: _currentPage,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.lg,
                0,
                spacing.lg,
                spacing.xl,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: _isLastPage ? _finish : _next,
                  child: Text(_isLastPage ? '시작하기' : '다음'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Immutable content for a single onboarding slide.
class _OnboardingSlide {
  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

/// Renders one onboarding slide with a large circular icon, title, and copy.
class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.slide});

  final _OnboardingSlide slide;

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
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              slide.icon,
              size: 56,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(height: spacing.xl),
          Text(
            slide.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.md),
          Text(
            slide.description,
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

/// Row of animated dot indicators showing the current slide position.
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
