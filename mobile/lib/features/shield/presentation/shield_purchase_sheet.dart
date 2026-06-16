import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/shield_providers.dart';
import '../data/shield_repository.dart';
import '../domain/shield_purchase_result.dart';

/// Available shield product SKUs and their display metadata.
///
/// Real StoreKit / BillingClient integration is deferred. The mock receipt
/// format mirrors what the backend stub expects during development.
const _kProducts = [
  _ShieldProduct(id: 'shield_1', count: 1, price: '990원'),
  _ShieldProduct(id: 'shield_3', count: 3, price: '2,490원', recommended: true),
];

/// Modal bottom sheet for purchasing streak shields.
///
/// Shows the current shield balance, two product cards, and a purchase CTA.
/// On success a SnackBar confirms the shields added to the user's account.
class ShieldPurchaseSheet extends ConsumerStatefulWidget {
  const ShieldPurchaseSheet({super.key});

  @override
  ConsumerState<ShieldPurchaseSheet> createState() =>
      _ShieldPurchaseSheetState();
}

class _ShieldPurchaseSheetState extends ConsumerState<ShieldPurchaseSheet> {
  _ShieldProduct _selected = _kProducts[1]; // default: recommended product
  bool _loading = false;
  String? _errorMessage;

  Future<void> _onPurchase() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    // Mock receipt: real StoreKit / BillingClient integration is future work.
    final receiptData =
        'mock_receipt_${_selected.id}_${DateTime.now().millisecondsSinceEpoch}';

    try {
      final ShieldPurchaseResult result = await ref
          .read(shieldRepositoryProvider)
          .purchaseShield(
            productId: _selected.id,
            receiptData: receiptData,
          );

      if (!mounted) return;
      // Invalidate cached balance so any other widget re-fetches.
      ref.invalidate(shieldBalanceProvider);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🛡️ 쉴드 ${result.shieldsGranted}개가 추가됐어요!'),
        ),
      );
    } on ShieldRepositoryException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final balanceAsync = ref.watch(shieldBalanceProvider);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          spacing.lg,
          spacing.md,
          spacing.lg,
          spacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // -----------------------------------------------------------------
            // Drag handle
            // -----------------------------------------------------------------
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: spacing.md),
            // -----------------------------------------------------------------
            // Header: title + current balance
            // -----------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '스트릭 쉴드 구매',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                balanceAsync.when(
                  data: (n) => Text(
                    '🛡️ 현재 $n개',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                    ),
                  ),
                  loading: () => const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
            SizedBox(height: spacing.lg),
            // -----------------------------------------------------------------
            // Product cards
            // -----------------------------------------------------------------
            for (final product in _kProducts) ...[
              _ProductCard(
                product: product,
                selected: _selected.id == product.id,
                onTap: _loading
                    ? null
                    : () => setState(() => _selected = product),
              ),
              SizedBox(height: spacing.sm),
            ],
            SizedBox(height: spacing.sm),
            // -----------------------------------------------------------------
            // Error message
            // -----------------------------------------------------------------
            if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.sm),
            ],
            // -----------------------------------------------------------------
            // Purchase CTA
            // -----------------------------------------------------------------
            Semantics(
              button: true,
              label: '쉴드 구매하기',
              child: FilledButton(
                onPressed: _loading ? null : _onPurchase,
                style: FilledButton.styleFrom(
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
                        '구매하기 — ${_selected.price}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Product card
// ---------------------------------------------------------------------------

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.selected,
    required this.onTap,
  });

  final _ShieldProduct product;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? primary.withValues(alpha: 0.06)
              : theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? primary : theme.colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            const Text('🛡️', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '쉴드 ${product.count}개',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (product.recommended) ...[
                        const SizedBox(width: 8),
                        _RecommendedBadge(),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Text(
              product.price,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: selected ? primary : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        '추천',
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal product descriptor
// ---------------------------------------------------------------------------

class _ShieldProduct {
  const _ShieldProduct({
    required this.id,
    required this.count,
    required this.price,
    this.recommended = false,
  });

  final String id;
  final int count;
  final String price;
  final bool recommended;
}
