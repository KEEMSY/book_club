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
          unselectedLabelColor: AppPalette.secondaryGray,
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

class _CreateGoalSheet extends ConsumerStatefulWidget {
  const _CreateGoalSheet({required this.period, required this.accent});

  final GoalPeriod period;
  final Color accent;

  @override
  ConsumerState<_CreateGoalSheet> createState() => _CreateGoalSheetState();
}

class _CreateGoalSheetState extends ConsumerState<_CreateGoalSheet> {
  late int _targetBooks = _defaultBooks(widget.period);
  late double _targetHours = _defaultHours(widget.period);
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

  static double _defaultHours(GoalPeriod p) {
    switch (p) {
      case GoalPeriod.weekly:
        return 3;
      case GoalPeriod.monthly:
        return 12;
      case GoalPeriod.yearly:
        return 150;
    }
  }

  ({double min, double max}) _hoursRange(GoalPeriod p) {
    switch (p) {
      case GoalPeriod.weekly:
        return (min: 0.25, max: 168);
      case GoalPeriod.monthly:
        return (min: 1, max: 720);
      case GoalPeriod.yearly:
        return (min: 10, max: 8760);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final range = _hoursRange(widget.period);

    return Padding(
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
            '${widget.period.label} 목표 만들기',
            style: theme.textTheme.headlineMedium,
          ),
          SizedBox(height: spacing.md),
          _BooksInputRow(
            value: _targetBooks,
            onChanged: (v) => setState(() => _targetBooks = v),
            accent: widget.accent,
          ),
          SizedBox(height: spacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('목표 시간', style: theme.textTheme.titleMedium),
              Text(
                '${_targetHours.toStringAsFixed(_targetHours < 10 ? 2 : 0)}시간',
                style:
                    theme.textTheme.titleLarge?.copyWith(color: widget.accent),
              ),
            ],
          ),
          Slider(
            value: _targetHours,
            min: range.min,
            max: range.max,
            divisions: 200,
            activeColor: widget.accent,
            onChanged: (v) => setState(() => _targetHours = v),
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

  Future<void> _submit() async {
    setState(() {
      _saving = true;
      _errorMessage = null;
    });
    try {
      await ref.read(goalNotifierProvider.notifier).createGoal(
            period: widget.period,
            targetBooks: _targetBooks,
            targetSeconds: (_targetHours * 3600).round(),
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

class _BooksInputRow extends StatelessWidget {
  const _BooksInputRow({
    required this.value,
    required this.onChanged,
    required this.accent,
  });

  final int value;
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
              onTap: () => onChanged((value - 1).clamp(1, 365)),
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
              onTap: () => onChanged((value + 1).clamp(1, 365)),
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
    return Material(
      color: AppPalette.lightSurface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 20, color: AppPalette.nearBlack),
        ),
      ),
    );
  }
}
