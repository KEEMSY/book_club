import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../application/subscription_notifier.dart';

/// Full-screen Pro subscription paywall.
///
/// Shown to any user who taps "Book Club Pro" on their profile. In the current
/// development build the purchase flow bypasses the real App Store: the
/// notifier always sends `receipt_data: "test_receipt"` so the backend can
/// activate Pro without a real receipt.
///
/// Layout (top → bottom):
///   1. Hero gradient header — crown icon + "Book Club Pro" headline
///   2. Benefit list — four items with check icons
///   3. Price label + CTA button
///   4. Legal caption
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _loading = false;

  Future<void> _onSubscribe() async {
    setState(() => _loading = true);
    final success = await ref.read(subscriptionNotifierProvider.notifier).verify(
          platform: 'ios',
          productId: 'bookclub_pro_monthly',
        );
    if (!mounted) return;
    setState(() => _loading = false);
    if (success) {
      GoRouter.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pro 구독 활성화!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('구독 처리에 실패했습니다. 잠시 후 다시 시도해주세요.')),
      );
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // -----------------------------------------------------------------
            // Hero gradient header
            // -----------------------------------------------------------------
            _HeroHeader(spacing: spacing),
            // -----------------------------------------------------------------
            // Benefit list
            // -----------------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.lg,
                  vertical: spacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pro 혜택',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacing.md),
                    const _BenefitTile(text: '스트릭 쉴드 최대 5개 보관'),
                    const _BenefitTile(text: '클럽 최대 3개 운영'),
                    const _BenefitTile(text: '고급 독서 통계'),
                    const _BenefitTile(text: '광고 없는 경험'),
                  ],
                ),
              ),
            ),
            // -----------------------------------------------------------------
            // CTA area
            // -----------------------------------------------------------------
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.lg,
                0,
                spacing.lg,
                spacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '월 4,900원',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6B21A8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: spacing.md),
                  FilledButton(
                    onPressed: _loading ? null : _onSubscribe,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF6B21A8),
                      padding: EdgeInsets.symmetric(vertical: spacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Pro 시작하기',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  SizedBox(height: spacing.sm),
                  Text(
                    '언제든 해지 가능 · App Store에서 관리',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero gradient header
// ---------------------------------------------------------------------------

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.spacing});

  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.38,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6B21A8), // deep purple
            Color(0xFF9333EA), // medium purple
            Color(0xFFFF385C), // Rausch — app brand accent
          ],
        ),
      ),
      child: Stack(
        children: [
          // Close button top-left
          Positioned(
            top: 8,
            left: 8,
            child: IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.white70),
              onPressed: () => GoRouter.of(context).pop(),
            ),
          ),
          // Central content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Book Club Pro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '독서를 더 깊게, 더 오래',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Benefit list tile
// ---------------------------------------------------------------------------

class _BenefitTile extends StatelessWidget {
  const _BenefitTile({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF6B21A8),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
