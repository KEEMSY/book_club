import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../application/monetization_providers.dart';
import '../application/subscription_notifier.dart';
import '../domain/promo.dart';

const Color _kProPurple = Color(0xFF6B21A8);

/// RevenueCat API key, injected via `--dart-define=REVENUECAT_API_KEY`. Empty
/// in dev builds — when empty the paywall uses the backend test-receipt path
/// instead of the store SDK (mirrors the skip in `main.dart`).
const String _kRevenueCatApiKey =
    String.fromEnvironment('REVENUECAT_API_KEY', defaultValue: '');

/// RevenueCat entitlement identifier that unlocks Pro. Must match the
/// entitlement configured in the RevenueCat dashboard.
const String _kProEntitlement = 'pro';

/// Result of a paywall purchase attempt — distinguishes a user cancel (no
/// error toast) from an outright failure.
enum _PurchaseOutcome { success, cancelled, failure }

/// Selectable billing cadence on the paywall.
///
/// [productId] mirrors the RevenueCat / store SKU sent to the backend for
/// receipt verification.
enum _PaywallPlan {
  monthly(
    productId: 'monthly_pro_6900',
    price: '월 6,900원',
    subLabel: '매월 결제 · 언제든 해지',
  ),
  annual(
    productId: 'annual_pro_59000',
    price: '59,000원/년',
    subLabel: '월 4,917원으로 환산 · 약 29% 절약',
  );

  const _PaywallPlan({
    required this.productId,
    required this.price,
    required this.subLabel,
  });

  final String productId;
  final String price;
  final String subLabel;
}

/// Full-screen Pro subscription paywall.
///
/// Shown to any user who taps "Book Club Pro" on their profile. When a
/// RevenueCat API key is configured the CTA runs the real store purchase via
/// `Purchases.purchasePackage`; dev builds without a key fall back to the
/// backend test-receipt path so Pro can be activated without a real receipt.
///
/// Layout (top → bottom):
///   1. Hero gradient header — crown icon + "Book Club Pro" headline
///   2. Benefit list — four items with check icons
///   3. Plan segmented control (월간 / 연간) + price label + CTA button
///   4. Legal caption
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  // Annual is preselected — it carries the "가장 인기" badge and best value.
  _PaywallPlan _plan = _PaywallPlan.annual;
  bool _loading = false;

  Future<void> _onSubscribe() async {
    setState(() => _loading = true);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    final _PurchaseOutcome outcome = await _purchase();

    if (!mounted) return;
    setState(() => _loading = false);
    switch (outcome) {
      case _PurchaseOutcome.success:
        router.pop();
        messenger.showSnackBar(
          const SnackBar(content: Text('Pro 구독 활성화!')),
        );
      case _PurchaseOutcome.cancelled:
        break;
      case _PurchaseOutcome.failure:
        messenger.showSnackBar(
          const SnackBar(content: Text('구독 처리에 실패했습니다. 잠시 후 다시 시도해주세요.')),
        );
    }
  }

  /// Runs the purchase through RevenueCat when configured, otherwise the
  /// backend test-receipt path used in dev builds.
  Future<_PurchaseOutcome> _purchase() async {
    if (_kRevenueCatApiKey.isEmpty) {
      final ok = await ref.read(subscriptionNotifierProvider.notifier).verify(
            platform: 'ios',
            productId: _plan.productId,
          );
      return ok ? _PurchaseOutcome.success : _PurchaseOutcome.failure;
    }

    try {
      final Offerings offerings = await Purchases.getOfferings();
      final Package? package = _packageFor(offerings, _plan.productId);
      if (package == null) return _PurchaseOutcome.failure;

      final PurchaseResult result = await Purchases.purchasePackage(package);
      final bool isPro =
          result.customerInfo.entitlements.active.containsKey(_kProEntitlement);
      if (!isPro) return _PurchaseOutcome.failure;

      // RevenueCat webhooks tell the backend about the entitlement; refresh the
      // app-wide status so every isPro watcher reflects the new state.
      ref.invalidate(subscriptionNotifierProvider);
      return _PurchaseOutcome.success;
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return _PurchaseOutcome.cancelled;
      }
      return _PurchaseOutcome.failure;
    }
  }

  /// Finds the store package whose product id matches [productId] across the
  /// current and all configured offerings.
  Package? _packageFor(Offerings offerings, String productId) {
    for (final Offering offering in <Offering?>[
      offerings.current,
      ...offerings.all.values,
    ].whereType<Offering>()) {
      for (final Package package in offering.availablePackages) {
        if (package.storeProduct.identifier == productId) return package;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    // Early-bird promo (countdown banner) and trial state drive the optional
    // header banner and the CTA label; both degrade silently on error/loading.
    final Promo? promo = ref.watch(activePromoProvider).valueOrNull;
    final bool isInTrial =
        ref.watch(trialStatusProvider).valueOrNull?.isInTrial ?? false;

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
                    if (promo != null) ...[
                      _EarlyBirdBanner(promo: promo),
                      SizedBox(height: spacing.lg),
                    ],
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
                  _PlanSelector(
                    plan: _plan,
                    onChanged:
                        _loading ? null : (p) => setState(() => _plan = p),
                  ),
                  SizedBox(height: spacing.md),
                  Text(
                    _plan.price,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _kProPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _plan.subLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _kProPurple.withValues(alpha: 0.75),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: spacing.md),
                  Semantics(
                    button: true,
                    label: 'Pro 구독 시작하기',
                    child: FilledButton(
                      onPressed: _loading ? null : _onSubscribe,
                      style: FilledButton.styleFrom(
                        backgroundColor: _kProPurple,
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
                              isInTrial ? '7일 무료 체험 시작' : 'Pro 시작하기',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
// Plan selector — 월간 / 연간 segmented control with "가장 인기" badge
// ---------------------------------------------------------------------------

class _PlanSelector extends StatelessWidget {
  const _PlanSelector({required this.plan, required this.onChanged});

  final _PaywallPlan plan;
  final ValueChanged<_PaywallPlan>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        SegmentedButton<_PaywallPlan>(
          segments: const <ButtonSegment<_PaywallPlan>>[
            ButtonSegment<_PaywallPlan>(
              value: _PaywallPlan.monthly,
              label: Text('월간'),
            ),
            ButtonSegment<_PaywallPlan>(
              value: _PaywallPlan.annual,
              label: Text('연간'),
            ),
          ],
          selected: <_PaywallPlan>{plan},
          showSelectedIcon: false,
          onSelectionChanged: onChanged == null
              ? null
              : (selection) => onChanged!(selection.first),
          style: SegmentedButton.styleFrom(
            selectedBackgroundColor: _kProPurple.withValues(alpha: 0.12),
            selectedForegroundColor: _kProPurple,
          ),
        ),
        // "가장 인기" badge pinned over the annual segment (right half).
        Positioned(
          top: -10,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFF385C), // Rausch — app brand accent
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '가장 인기',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
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
            color: _kProPurple,
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

// ---------------------------------------------------------------------------
// Early-bird promo banner with a live countdown to the promo's expiry
// ---------------------------------------------------------------------------

const Color _kEarlyBird = Color(0xFFFF385C); // Rausch — app brand accent

class _EarlyBirdBanner extends StatefulWidget {
  const _EarlyBirdBanner({required this.promo});

  final Promo promo;

  @override
  State<_EarlyBirdBanner> createState() => _EarlyBirdBannerState();
}

class _EarlyBirdBannerState extends State<_EarlyBirdBanner> {
  Timer? _ticker;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = _timeLeft();
    // One tick per second keeps the countdown live without a heavy rebuild.
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _remaining = _timeLeft());
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Duration _timeLeft() {
    final left = widget.promo.validUntil.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  String _format(Duration d) {
    final days = d.inDays;
    final hh = (d.inHours % 24).toString().padLeft(2, '0');
    final mm = (d.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (d.inSeconds % 60).toString().padLeft(2, '0');
    return days > 0 ? '$days일 $hh:$mm:$ss' : '$hh:$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _kEarlyBird.withValues(alpha: 0.12),
            _kProPurple.withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kEarlyBird.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department_rounded, color: _kEarlyBird, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '얼리버드 혜택',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _kEarlyBird,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.promo.discountPct}% 할인',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _kProPurple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _remaining == Duration.zero
                      ? '혜택이 종료되었어요'
                      : '남은 시간 ${_format(_remaining)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontFeatures: const [FontFeature.tabularFigures()],
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
