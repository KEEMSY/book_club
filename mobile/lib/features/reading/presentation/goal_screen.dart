import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/goal_notifier.dart';
import '../application/goal_state.dart';
import '../application/reading_providers.dart';
import '../domain/goal_period.dart';
import '../domain/reading_goal.dart';
import 'widgets/goal_progress_card.dart';

/// `/goals` — three-tab view of 주간 · 월간 · 연간 reading goals.
///
/// Each tab either renders a [GoalProgressCard] for the active goal or
/// an empty-state prompt to create one. The create flow opens a bottom
/// sheet with books + hours inputs and POSTs to `/reading/goals`.
class GoalScreen extends ConsumerStatefulWidget {
  const GoalScreen({super.key});

  @override
  ConsumerState<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends ConsumerState<GoalScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalNotifierProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color accent = ref.watch(gradePrimaryProvider);
    final GoalState state = ref.watch(goalNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('독서 목표', style: theme.textTheme.titleLarge),
        bottom: TabBar(
          controller: _tabController,
          labelColor: accent,
          indicatorColor: accent,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          tabs: const <Widget>[
            Tab(text: '주간'),
            Tab(text: '월간'),
            Tab(text: '연간'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <GoalPeriod>[
          GoalPeriod.weekly,
          GoalPeriod.monthly,
          GoalPeriod.yearly,
        ]
            .map(
              (period) =>
                  _TabBody(period: period, state: state, accent: accent),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _TabBody extends ConsumerWidget {
  const _TabBody({
    required this.period,
    required this.state,
    required this.accent,
  });

  final GoalPeriod period;
  final GoalState state;
  final Color accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final GoalProgress? progress =
        ref.read(goalNotifierProvider.notifier).progressFor(period);
    final bool loading = state is GoalLoading || state is GoalInitial;

    return RefreshIndicator(
      onRefresh: () => ref.read(goalNotifierProvider.notifier).refresh(),
      color: accent,
      child: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: <Widget>[
          if (loading && progress == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 80),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (progress != null)
            GoalProgressCard(progress: progress, accent: accent)
          else
            _EmptyState(period: period, accent: accent),
          SizedBox(height: spacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _showCreateSheet(context, ref, period, accent),
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const StadiumBorder(),
              ),
              child: Text(
                progress == null ? '목표 만들기' : '목표 다시 설정',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateSheet(
    BuildContext context,
    WidgetRef ref,
    GoalPeriod period,
    Color accent,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CreateGoalSheet(period: period, accent: accent),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.period, required this.accent});

  final GoalPeriod period;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xl),
      child: Center(
        child: Column(
          children: <Widget>[
            Icon(Icons.flag_outlined, size: 48, color: accent),
            SizedBox(height: spacing.md),
            Text(
              '${period.label} 목표를 설정해보세요',
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: spacing.xs),
            Text(
              '꾸준한 기록을 위한 작은 약속',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Time-target input mode. "하루 기준" uses a per-day preset multiplied by
/// the period's day count; "일수 기준" asks the user to pick how many days
/// they'll read in the period and what the per-day average is. Weekly only
/// supports daily because "며칠 동안" collapses on a 7-day window.
enum _GoalTimeMode { daily, byDays }

/// One per-day preset chip. The underlying [minutes] feeds every multiplier
/// formula (weekly × 7, monthly × 30, yearly × 365). Keeping the labels
/// canonical — "하루 30분" reads the same across tabs.
class _DailyPreset {
  const _DailyPreset(this.label, this.minutes);
  final String label;
  final int minutes;
}

/// "며칠 동안" chip for the byDays mode. [days] = 0 means "매일" and resolves
/// to the period's full day count at save time (30 for monthly, 30 per
/// month for yearly).
class _DaysPreset {
  const _DaysPreset(this.label, this.days);
  final String label;
  final int days; // 0 sentinel = 매일
}

class _CreateGoalSheet extends ConsumerStatefulWidget {
  const _CreateGoalSheet({required this.period, required this.accent});

  final GoalPeriod period;
  final Color accent;

  @override
  ConsumerState<_CreateGoalSheet> createState() => _CreateGoalSheetState();
}

class _CreateGoalSheetState extends ConsumerState<_CreateGoalSheet> {
  late int _targetBooks = _defaultBooks(widget.period);
  late _GoalTimeMode _mode = _GoalTimeMode.daily;

  /// Selected preset minutes for "하루 기준". `null` means the user dragged
  /// the fine-tuning slider and is now in "custom" mode — no chip glows,
  /// only the slider's raw value drives the summary.
  int? _dailyPresetMinutes;

  /// Fine-tuning slider value (minutes / day). Weekly + 하루 기준 modes both
  /// read this. Stepped in 15-minute divisions.
  late double _customPerDayMinutes = _defaultPerDayMinutes(widget.period);
  bool _detailExpanded = false;

  /// Selected days chip for "일수 기준". `null` = 매일 sentinel resolves to
  /// the period's full day count at save time.
  int? _daysSelection;

  /// Average-minutes slider for "일수 기준" mode (15..180 minutes).
  double _daysAverageMinutes = 30;

  bool _saving = false;
  String? _errorMessage;

  static int _defaultBooks(GoalPeriod p) {
    switch (p) {
      case GoalPeriod.weekly:
        return 1;
      case GoalPeriod.monthly:
        return 4;
      case GoalPeriod.yearly:
        return 24;
    }
  }

  /// Per-day minutes seeded into the fine-tuning slider on first open.
  static double _defaultPerDayMinutes(GoalPeriod p) {
    switch (p) {
      case GoalPeriod.weekly:
        return 30;
      case GoalPeriod.monthly:
        return 30;
      case GoalPeriod.yearly:
        return 30;
    }
  }

  ({int min, int max}) _booksRange(GoalPeriod p) {
    switch (p) {
      case GoalPeriod.weekly:
        return (min: 1, max: 14);
      case GoalPeriod.monthly:
        return (min: 1, max: 30);
      case GoalPeriod.yearly:
        return (min: 5, max: 365);
    }
  }

  /// Per-day preset chip set. Weekly + monthly share the same ladder; yearly
  /// starts a tick lower because 15min × 365 still adds up to 91 hours.
  List<_DailyPreset> _dailyPresets(GoalPeriod p) {
    switch (p) {
      case GoalPeriod.weekly:
      case GoalPeriod.monthly:
        return const <_DailyPreset>[
          _DailyPreset('하루 30분', 30),
          _DailyPreset('하루 1시간', 60),
          _DailyPreset('하루 1시간 30분', 90),
          _DailyPreset('하루 2시간', 120),
          _DailyPreset('하루 3시간', 180),
        ];
      case GoalPeriod.yearly:
        return const <_DailyPreset>[
          _DailyPreset('하루 15분', 15),
          _DailyPreset('하루 30분', 30),
          _DailyPreset('하루 1시간', 60),
          _DailyPreset('하루 1시간 30분', 90),
          _DailyPreset('하루 2시간', 120),
        ];
    }
  }

  /// "며칠 동안" presets — 매일 is last so it reads as the "full-credit" option.
  List<_DaysPreset> _daysPresets(GoalPeriod p) {
    switch (p) {
      case GoalPeriod.monthly:
        return const <_DaysPreset>[
          _DaysPreset('10일', 10),
          _DaysPreset('15일', 15),
          _DaysPreset('20일', 20),
          _DaysPreset('매일', 0), // resolves to 30
        ];
      case GoalPeriod.yearly:
        return const <_DaysPreset>[
          _DaysPreset('월 10일', 10),
          _DaysPreset('월 15일', 15),
          _DaysPreset('월 20일', 20),
          _DaysPreset('매일 (월 30일)', 0), // resolves to 30
        ];
      case GoalPeriod.weekly:
        return const <_DaysPreset>[];
    }
  }

  /// Number of days the period encompasses when computing target_seconds.
  /// Weekly = 7, monthly = 30, yearly = 365.
  int _periodDays(GoalPeriod p) {
    switch (p) {
      case GoalPeriod.weekly:
        return 7;
      case GoalPeriod.monthly:
        return 30;
      case GoalPeriod.yearly:
        return 365;
    }
  }

  /// The per-day minute count the daily mode currently commits. Prefer the
  /// preset; fall back to the custom slider when the user fine-tuned.
  int get _effectiveDailyMinutes =>
      _dailyPresetMinutes ?? _customPerDayMinutes.round();

  /// Resolved days for the byDays mode. Sentinel 0 (매일) becomes 30 for
  /// monthly; for yearly the chip already reads "월 30일" so the period
  /// multiplier handles the per-month math at save time.
  int get _effectiveDays => (_daysSelection ?? 30).clamp(1, 30);

  /// Computed `target_seconds` for the currently selected mode and period.
  int get _targetSeconds {
    switch (_mode) {
      case _GoalTimeMode.daily:
        return _effectiveDailyMinutes * _periodDays(widget.period) * 60;
      case _GoalTimeMode.byDays:
        // Yearly "월 기준" multiplies days-per-month by 12 months; monthly
        // treats _effectiveDays as days-per-month directly.
        final int monthsMultiplier =
            widget.period == GoalPeriod.yearly ? 12 : 1;
        return _effectiveDays *
            _daysAverageMinutes.round() *
            60 *
            monthsMultiplier;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final bool supportsByDays = widget.period != GoalPeriod.weekly;
    final ({int min, int max}) booksRange = _booksRange(widget.period);

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
          Text(
            _sectionLabel(widget.period),
            style: theme.textTheme.headlineMedium,
          ),
          SizedBox(height: spacing.md),
          _BooksInputRow(
            value: _targetBooks,
            min: booksRange.min,
            max: booksRange.max,
            onChanged: (v) => setState(() => _targetBooks = v),
            accent: widget.accent,
          ),
          SizedBox(height: spacing.lg),
          Text('목표 시간', style: theme.textTheme.titleMedium),
          SizedBox(height: spacing.sm),
          if (supportsByDays) ...<Widget>[
            _ModeToggle(
              mode: _mode,
              onChanged: (m) => setState(() => _mode = m),
              accent: widget.accent,
              period: widget.period,
            ),
            SizedBox(height: spacing.md),
          ],
          if (_mode == _GoalTimeMode.daily)
            _DailyModeSection(
              presets: _dailyPresets(widget.period),
              selected: _dailyPresetMinutes,
              customMinutes: _customPerDayMinutes,
              accent: widget.accent,
              onPresetTap: (int minutes) => setState(() {
                _dailyPresetMinutes = minutes;
                _customPerDayMinutes = minutes.toDouble();
              }),
              detailExpanded: _detailExpanded,
              onToggleDetail: () =>
                  setState(() => _detailExpanded = !_detailExpanded),
              onSliderChanged: (double v) => setState(() {
                _customPerDayMinutes = v;
                // Any slider nudge drops the preset highlight — the user is
                // now in "custom" territory.
                _dailyPresetMinutes = null;
              }),
            )
          else
            _ByDaysModeSection(
              period: widget.period,
              daysPresets: _daysPresets(widget.period),
              daysSelection: _daysSelection,
              averageMinutes: _daysAverageMinutes,
              accent: widget.accent,
              onDaysTap: (int days) => setState(() => _daysSelection = days),
              onSliderChanged: (double v) =>
                  setState(() => _daysAverageMinutes = v),
            ),
          SizedBox(height: spacing.sm),
          Text(
            _summaryLine(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: EdgeInsets.only(top: spacing.sm),
              child: Text(
                _errorMessage!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          SizedBox(height: spacing.md),
          FilledButton(
            onPressed: _saving ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: widget.accent,
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
                : const Text('저장'),
          ),
        ],
      ),
    );
  }

  String _sectionLabel(GoalPeriod p) {
    switch (p) {
      case GoalPeriod.weekly:
        return '이번 주 목표';
      case GoalPeriod.monthly:
        return '이번 달 목표';
      case GoalPeriod.yearly:
        return '올해 목표';
    }
  }

  String _summaryLine() {
    final int totalSec = _targetSeconds;
    final int totalMin = totalSec ~/ 60;
    final int hours = totalMin ~/ 60;
    final int minutes = totalMin % 60;

    switch (_mode) {
      case _GoalTimeMode.daily:
        switch (widget.period) {
          case GoalPeriod.weekly:
            final int perDay = _effectiveDailyMinutes;
            final int avgH = perDay ~/ 60;
            final int avgM = perDay % 60;
            return '주간 목표 시간: 총 $hours시간 $minutes분 '
                '(하루 평균 $avgH시간 $avgM분)';
          case GoalPeriod.monthly:
            return '월간 목표 시간: 총 $hours시간 $minutes분 '
                '(30일 × 하루 $_effectiveDailyMinutes분)';
          case GoalPeriod.yearly:
            return '연간 목표 시간: 총 $hours시간 '
                '(365일 × 하루 $_effectiveDailyMinutes분)';
        }
      case _GoalTimeMode.byDays:
        final int avgMin = _daysAverageMinutes.round();
        switch (widget.period) {
          case GoalPeriod.monthly:
            return '월간 목표 시간: 총 $hours시간 $minutes분 '
                '($_effectiveDays일 × 하루 $avgMin분)';
          case GoalPeriod.yearly:
            return '연간 목표 시간: 총 $hours시간 '
                '(12개월 × 월 $_effectiveDays일 × 하루 $avgMin분)';
          case GoalPeriod.weekly:
            return ''; // byDays doesn't apply to weekly
        }
    }
  }

  Future<void> _submit() async {
    setState(() {
      _saving = true;
      _errorMessage = null;
    });
    try {
      await ref.read(goalNotifierProvider.notifier).createGoal(
            period: widget.period,
            targetBooks: _targetBooks,
            targetSeconds: _targetSeconds,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _errorMessage = '목표를 저장하지 못했어요. 잠시 후 다시 시도해주세요.';
        _saving = false;
      });
    }
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({
    required this.mode,
    required this.onChanged,
    required this.accent,
    required this.period,
  });

  final _GoalTimeMode mode;
  final ValueChanged<_GoalTimeMode> onChanged;
  final Color accent;
  final GoalPeriod period;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SegmentedButton<_GoalTimeMode>(
      segments: const <ButtonSegment<_GoalTimeMode>>[
        ButtonSegment<_GoalTimeMode>(
          value: _GoalTimeMode.daily,
          label: Text('하루 기준'),
        ),
        ButtonSegment<_GoalTimeMode>(
          value: _GoalTimeMode.byDays,
          label: Text('일수 기준'),
        ),
      ],
      selected: <_GoalTimeMode>{mode},
      onSelectionChanged: (Set<_GoalTimeMode> next) => onChanged(next.first),
      showSelectedIcon: false,
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll<TextStyle?>(
          theme.textTheme.labelMedium,
        ),
        backgroundColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> s) {
          if (s.contains(WidgetState.selected)) return accent;
          return Theme.of(context).colorScheme.surfaceContainerHigh;
        }),
        foregroundColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> s) {
          if (s.contains(WidgetState.selected)) return Colors.white;
          return Theme.of(context).colorScheme.onSurface;
        }),
      ),
    );
  }
}

class _DailyModeSection extends StatelessWidget {
  const _DailyModeSection({
    required this.presets,
    required this.selected,
    required this.customMinutes,
    required this.accent,
    required this.onPresetTap,
    required this.detailExpanded,
    required this.onToggleDetail,
    required this.onSliderChanged,
  });

  final List<_DailyPreset> presets;
  final int? selected;
  final double customMinutes;
  final Color accent;
  final ValueChanged<int> onPresetTap;
  final bool detailExpanded;
  final VoidCallback onToggleDetail;
  final ValueChanged<double> onSliderChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            for (final _DailyPreset p in presets)
              ChoiceChip(
                label: Text(p.label),
                selected: selected == p.minutes,
                onSelected: (_) => onPresetTap(p.minutes),
                selectedColor: accent,
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
                labelStyle: theme.textTheme.labelMedium?.copyWith(
                  color: selected == p.minutes
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                ),
                side: BorderSide(
                  color: selected == p.minutes
                      ? accent
                      : theme.colorScheme.outline.withValues(alpha: 0.6),
                ),
              ),
          ],
        ),
        SizedBox(height: spacing.sm),
        InkWell(
          onTap: onToggleDetail,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: <Widget>[
                Text(
                  '세부 조정',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                  ),
                ),
                Icon(
                  detailExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ],
            ),
          ),
        ),
        if (detailExpanded)
          Slider(
            // 15min..4hr in 15-minute steps → 16 divisions across a 240-min
            // range so the thumb always lands on a canonical preset.
            value: customMinutes.clamp(15.0, 240.0),
            min: 15,
            max: 240,
            divisions: 15,
            label: '${customMinutes.round()}분',
            activeColor: accent,
            onChanged: onSliderChanged,
          ),
      ],
    );
  }
}

class _ByDaysModeSection extends StatelessWidget {
  const _ByDaysModeSection({
    required this.period,
    required this.daysPresets,
    required this.daysSelection,
    required this.averageMinutes,
    required this.accent,
    required this.onDaysTap,
    required this.onSliderChanged,
  });

  final GoalPeriod period;
  final List<_DaysPreset> daysPresets;
  final int? daysSelection;
  final double averageMinutes;
  final Color accent;
  final ValueChanged<int> onDaysTap;
  final ValueChanged<double> onSliderChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('며칠 동안', style: theme.textTheme.titleSmall),
        SizedBox(height: spacing.xs),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            for (final _DaysPreset p in daysPresets)
              ChoiceChip(
                label: Text(p.label),
                selected: daysSelection == p.days,
                onSelected: (_) => onDaysTap(p.days),
                selectedColor: accent,
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
                labelStyle: theme.textTheme.labelMedium?.copyWith(
                  color: daysSelection == p.days
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                ),
                side: BorderSide(
                  color: daysSelection == p.days
                      ? accent
                      : theme.colorScheme.outline.withValues(alpha: 0.6),
                ),
              ),
          ],
        ),
        SizedBox(height: spacing.md),
        Text('하루 평균', style: theme.textTheme.titleSmall),
        Slider(
          // 15min..3hr in 15-minute steps.
          value: averageMinutes.clamp(15.0, 180.0),
          min: 15,
          max: 180,
          divisions: 11,
          label: '${averageMinutes.round()}분',
          activeColor: accent,
          onChanged: onSliderChanged,
        ),
      ],
    );
  }
}

class _BooksInputRow extends StatelessWidget {
  const _BooksInputRow({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.accent,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('목표 권수', style: theme.textTheme.titleMedium),
        Row(
          children: <Widget>[
            _Stepper(
              icon: Icons.remove_rounded,
              onTap: () => onChanged((value - 1).clamp(min, max)),
            ),
            SizedBox(
              width: 60,
              child: Text(
                '$value 권',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(color: accent),
              ),
            ),
            _Stepper(
              icon: Icons.add_rounded,
              onTap: () => onChanged((value + 1).clamp(min, max)),
            ),
          ],
        ),
      ],
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 20, color: theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}
