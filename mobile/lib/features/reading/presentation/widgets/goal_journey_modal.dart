import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../application/goal_notifier.dart';
import '../../application/reading_journey_inputs.dart';
import '../../application/reading_providers.dart';

/// Single-flow setup for the entire reading journey. The modal collects the
/// three high-level inputs (yearly books · daily minutes · weekly days) and
/// derives the per-period targets via [ReadingJourneyTargets] for the live
/// summary panel before posting all three goals through `createJourney`.
///
/// Per-period creation modals were removed when the goal screen consolidated
/// into the "올해의 독서 여정" continuous view — every empty / reset CTA
/// routes through this single sheet.
class GoalJourneyModal extends ConsumerStatefulWidget {
  const GoalJourneyModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const GoalJourneyModal(),
    );
  }

  @override
  ConsumerState<GoalJourneyModal> createState() => _GoalJourneyModalState();
}

class _GoalJourneyModalState extends ConsumerState<GoalJourneyModal> {
  // Seeded from defaults; overwritten with the persisted preset on first
  // build via _hydrate(). Keeping non-late so we can show the modal even if
  // the preset read fails.
  int _yearlyBooks = ReadingJourneyInputs.defaults.yearlyBooks;
  double _dailyMinutes = ReadingJourneyInputs.defaults.dailyMinutes.toDouble();
  int _weeklyDays = ReadingJourneyInputs.defaults.weeklyDays;

  bool _saving = false;
  String? _errorMessage;

  static const List<int> _weeklyDaysOptions = <int>[3, 4, 5, 7];

  @override
  void initState() {
    super.initState();
    _hydrate();
  }

  Future<void> _hydrate() async {
    final ReadingJourneyInputs? preset =
        await ref.read(journeyPresetStoreProvider).read();
    if (!mounted || preset == null) return;
    setState(() {
      _yearlyBooks = preset.yearlyBooks.clamp(5, 365);
      _dailyMinutes = preset.dailyMinutes.clamp(15, 240).toDouble();
      _weeklyDays = _weeklyDaysOptions.contains(preset.weeklyDays)
          ? preset.weeklyDays
          : 7;
    });
  }

  ReadingJourneyTargets get _targets => ReadingJourneyTargets.derive(
        yearlyBooks: _yearlyBooks,
        dailyMinutes: _dailyMinutes.round(),
        weeklyDays: _weeklyDays,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final Color accent = ref.watch(gradePrimaryProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: spacing.lg,
        right: spacing.lg,
        top: spacing.sm,
        bottom: MediaQuery.of(context).viewInsets.bottom + spacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '독서 여정 설정',
                  style: theme.textTheme.headlineMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SizedBox(height: spacing.sm),
          Text(
            '한 해의 끝과 이번 주의 걸음을 한 번에 설정해요',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: spacing.lg),

          // -- Yearly books stepper --------------------------------------
          const _SectionLabel(label: '올해 읽고 싶은 권수'),
          SizedBox(height: spacing.sm),
          _YearlyStepper(
            value: _yearlyBooks,
            accent: accent,
            onChanged: (int v) => setState(() => _yearlyBooks = v),
          ),
          SizedBox(height: spacing.lg),

          // -- Daily minutes slider ---------------------------------------
          const _SectionLabel(label: '하루 평균 독서 시간'),
          SizedBox(height: spacing.xs),
          Row(
            children: <Widget>[
              Expanded(
                child: Slider(
                  value: _dailyMinutes.clamp(15, 240),
                  min: 15,
                  max: 240,
                  divisions: 15,
                  label: _formatMinutes(_dailyMinutes.round()),
                  activeColor: accent,
                  onChanged: (double v) => setState(() => _dailyMinutes = v),
                ),
              ),
              SizedBox(
                width: 84,
                child: Text(
                  _formatMinutes(_dailyMinutes.round()),
                  textAlign: TextAlign.end,
                  style: theme.textTheme.titleMedium?.copyWith(color: accent),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),

          // -- Weekly days chips ------------------------------------------
          const _SectionLabel(label: '독서하는 요일'),
          SizedBox(height: spacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final int days in _weeklyDaysOptions)
                ChoiceChip(
                  label: Text('주 $days일'),
                  selected: _weeklyDays == days,
                  selectedColor: accent,
                  backgroundColor: theme.colorScheme.surfaceContainerHigh,
                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                    color: _weeklyDays == days
                        ? Colors.white
                        : theme.colorScheme.onSurface,
                  ),
                  side: BorderSide(
                    color: _weeklyDays == days
                        ? accent
                        : theme.colorScheme.outline.withValues(alpha: 0.6),
                  ),
                  onSelected: (_) => setState(() => _weeklyDays = days),
                ),
            ],
          ),
          SizedBox(height: spacing.lg),

          // -- Live summary -----------------------------------------------
          _SummaryPanel(targets: _targets, accent: accent),
          if (_errorMessage != null)
            Padding(
              padding: EdgeInsets.only(top: spacing.sm),
              child: Text(
                _errorMessage!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          SizedBox(height: spacing.lg),

          // -- Save -------------------------------------------------------
          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const StadiumBorder(),
            ),
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('여정 저장하기'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _errorMessage = null;
    });
    try {
      await ref.read(goalNotifierProvider.notifier).createJourney(
            yearlyBooks: _yearlyBooks,
            dailyMinutes: _dailyMinutes.round(),
            weeklyDays: _weeklyDays,
          );
      // Persist preset only after a successful save so a transient failure
      // doesn't pollute the next session's prefill.
      await ref.read(journeyPresetStoreProvider).save(
            ReadingJourneyInputs(
              yearlyBooks: _yearlyBooks,
              dailyMinutes: _dailyMinutes.round(),
              weeklyDays: _weeklyDays,
            ),
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('여정이 시작됐어요')),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _errorMessage = '여정을 저장하지 못했어요. 잠시 후 다시 시도해주세요.';
      });
    }
  }

  static String _formatMinutes(int minutes) {
    if (minutes < 60) return '$minutes분';
    final int hours = minutes ~/ 60;
    final int rest = minutes % 60;
    if (rest == 0) return '$hours시간';
    return '$hours시간 $rest분';
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(label, style: theme.textTheme.titleMedium);
  }
}

class _YearlyStepper extends StatelessWidget {
  const _YearlyStepper({
    required this.value,
    required this.onChanged,
    required this.accent,
  });

  final int value;
  final Color accent;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _StepperButton(
          icon: Icons.remove_rounded,
          onTap: () => onChanged((value - 1).clamp(5, 365)),
        ),
        SizedBox(
          width: 120,
          child: Text(
            '$value 권',
            textAlign: TextAlign.center,
            style: theme.textTheme.displaySmall?.copyWith(color: accent),
          ),
        ),
        _StepperButton(
          icon: Icons.add_rounded,
          onTap: () => onChanged((value + 1).clamp(5, 365)),
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 22, color: theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({required this.targets, required this.accent});

  final ReadingJourneyTargets targets;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final int yearlyHours = targets.yearlySeconds ~/ 3600;
    final int monthlyHours = targets.monthlySeconds ~/ 3600;
    final int weeklyMin = targets.weeklySeconds ~/ 60;
    final String weeklyTime = weeklyMin >= 60
        ? '${weeklyMin ~/ 60}시간 ${weeklyMin % 60 == 0 ? '' : '${weeklyMin % 60}분 '}'
            .trim()
        : '$weeklyMin분';

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _summaryRow(
            theme,
            label: '올해',
            value: '${targets.yearlyBooks}권 · 연 $yearlyHours시간',
            accent: accent,
            emphasis: true,
          ),
          SizedBox(height: spacing.xs),
          _summaryRow(
            theme,
            label: '이번 달',
            value: '${targets.monthlyBooks}권 · $monthlyHours시간',
            accent: accent,
          ),
          SizedBox(height: spacing.xs),
          _summaryRow(
            theme,
            label: '이번 주',
            value: '${targets.weeklyBooks}권 · $weeklyTime',
            accent: accent,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    ThemeData theme, {
    required String label,
    required String value,
    required Color accent,
    bool emphasis = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: emphasis
              ? theme.textTheme.titleMedium?.copyWith(color: accent)
              : theme.textTheme.titleSmall,
        ),
      ],
    );
  }
}
