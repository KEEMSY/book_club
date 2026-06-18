import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/reading_plan_providers.dart';

/// BottomSheet for a Pro club owner to create a shared reading plan (M52).
///
/// The book is fixed to the club's currently-set book; the owner only picks a
/// duration, from which start/end dates are derived (start = today).
class CreateReadingPlanSheet extends ConsumerStatefulWidget {
  const CreateReadingPlanSheet({
    super.key,
    required this.clubId,
    required this.bookId,
    this.bookTitle,
  });

  final String clubId;
  final String bookId;
  final String? bookTitle;

  static Future<bool?> show(
    BuildContext context, {
    required String clubId,
    required String bookId,
    String? bookTitle,
  }) =>
      showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => CreateReadingPlanSheet(
          clubId: clubId,
          bookId: bookId,
          bookTitle: bookTitle,
        ),
      );

  @override
  ConsumerState<CreateReadingPlanSheet> createState() =>
      _CreateReadingPlanSheetState();
}

class _CreateReadingPlanSheetState
    extends ConsumerState<CreateReadingPlanSheet> {
  static const _options = <int>[2, 4, 8];
  int _weeks = 4;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.sm,
        spacing.lg,
        spacing.lg + bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('독서 계획 만들기', style: theme.textTheme.titleLarge),
          SizedBox(height: spacing.lg),
          Text('대상 책', style: theme.textTheme.labelMedium),
          SizedBox(height: spacing.xs),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.md,
              vertical: spacing.sm,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: Text(
                    widget.bookTitle ?? '현재 클럽 책',
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: spacing.lg),
          Text('읽기 기간', style: theme.textTheme.labelMedium),
          SizedBox(height: spacing.xs),
          Wrap(
            spacing: spacing.sm,
            children: [
              for (final w in _options)
                ChoiceChip(
                  label: Text('$w주'),
                  selected: _weeks == w,
                  onSelected: (_) => setState(() => _weeks = w),
                ),
            ],
          ),
          SizedBox(height: spacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving ? null : _create,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('계획 생성'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _create() async {
    setState(() => _saving = true);
    final start = DateTime.now();
    final end = start.add(Duration(days: _weeks * 7));
    try {
      await ref.read(readingPlanRepositoryProvider).createPlan(
            widget.clubId,
            bookId: widget.bookId,
            startDate: start,
            endDate: end,
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('계획 생성에 실패했어요. 다시 시도해 주세요.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
