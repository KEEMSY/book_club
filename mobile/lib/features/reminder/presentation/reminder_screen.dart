import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/reminder_notifier.dart';
import '../data/reminder_repository.dart';
import '../domain/reading_reminder.dart';

/// Full-screen surface for managing personalized reading reminders.
///
/// Entry point: profile screen → "독서 리마인더" list tile.
///
/// Layout (top to bottom):
///   1. AppBar — "독서 리마인더" + "+" FAB
///   2. AsyncValue loading / error / empty states
///   3. Swipeable [_ReminderCard] list
class ReminderScreen extends ConsumerWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(reminderListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('독서 리마인더')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context, ref),
        tooltip: '리마인더 추가',
        child: const Icon(Icons.add),
      ),
      body: remindersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _ErrorBody(
          onRetry: () => ref.invalidate(reminderListProvider),
        ),
        data: (items) => items.isEmpty
            ? _EmptyBody(onAdd: () => _showAddSheet(context, ref))
            : _ReminderList(reminders: items),
      ),
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _AddReminderSheet(
        onSaved: (days, time) async {
          await ref
              .read(reminderListProvider.notifier)
              .create(days: days, time: time);
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error state
// ---------------------------------------------------------------------------

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '리마인더를 불러오지 못했습니다.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.md),
            FilledButton(
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyBody extends StatelessWidget {
  const _EmptyBody({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.alarm_add_rounded,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: spacing.md),
            Text(
              '아직 독서 리마인더가 없어요',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              '매일 꾸준히 읽을 수 있도록\n리마인더를 설정해보세요.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.lg),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('리마인더 추가'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// List of reminders
// ---------------------------------------------------------------------------

class _ReminderList extends ConsumerWidget {
  const _ReminderList({required this.reminders});

  final List<ReadingReminder> reminders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.md,
      ),
      itemCount: reminders.length,
      separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
      itemBuilder: (context, index) {
        final reminder = reminders[index];
        return Dismissible(
          key: ValueKey(reminder.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
          confirmDismiss: (_) async {
            return _confirmDelete(context);
          },
          onDismissed: (_) async {
            try {
              await ref.read(reminderListProvider.notifier).delete(reminder.id);
            } on ReminderRepositoryException catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.message)),
                );
              }
            }
          },
          child: _ReminderCard(
            reminder: reminder,
            onToggle: (value) async {
              try {
                await ref
                    .read(reminderListProvider.notifier)
                    .toggle(reminder.id, active: value);
              } on ReminderRepositoryException catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.message)),
                  );
                }
              }
            },
          ),
        );
      },
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('리마인더 삭제'),
        content: const Text('이 리마인더를 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              '삭제',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

// ---------------------------------------------------------------------------
// Single reminder card
// ---------------------------------------------------------------------------

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({
    required this.reminder,
    required this.onToggle,
  });

  final ReadingReminder reminder;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatTime(reminder.remindAt),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: reminder.isActive
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _DayChips(
                    selected: reminder.daysOfWeek,
                    active: reminder.isActive,
                  ),
                ],
              ),
            ),
            Switch(
              value: reminder.isActive,
              onChanged: onToggle,
            ),
          ],
        ),
      ),
    );
  }

  /// Converts "HH:MM:SS" into a human-friendly "HH:MM" (24-hour) string.
  static String _formatTime(String remindAt) {
    final parts = remindAt.split(':');
    if (parts.length < 2) return remindAt;
    return '${parts[0]}:${parts[1]}';
  }
}

class _DayChips extends StatelessWidget {
  const _DayChips({required this.selected, required this.active});

  final List<int> selected;
  final bool active;

  static const _labels = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = active
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.3);

    return Row(
      children: List.generate(_labels.length, (i) {
        final isSelected = selected.contains(i);
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? selectedColor.withValues(alpha: 0.15)
                  : Colors.transparent,
            ),
            child: Text(
              _labels[i],
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? selectedColor
                    : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Add reminder bottom sheet
// ---------------------------------------------------------------------------

class _AddReminderSheet extends ConsumerStatefulWidget {
  const _AddReminderSheet({required this.onSaved});

  /// Called with the selected [days] (0=Mon..6=Sun) and [time] ("HH:MM:SS")
  /// after the user taps 저장.
  final Future<void> Function(List<int> days, String time) onSaved;

  @override
  ConsumerState<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends ConsumerState<_AddReminderSheet> {
  final Set<int> _selectedDays = {};
  TimeOfDay _time = const TimeOfDay(hour: 9, minute: 0);
  bool _saving = false;
  String? _errorMessage;

  static const _dayLabels = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: spacing.lg,
        right: spacing.lg,
        top: spacing.lg,
        bottom: spacing.lg + bottomPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text('리마인더 추가', style: theme.textTheme.titleLarge),
          SizedBox(height: spacing.lg),

          // Day picker
          Text('요일', style: theme.textTheme.labelLarge),
          SizedBox(height: spacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_dayLabels.length, (i) {
              final selected = _selectedDays.contains(i);
              return _DayToggleButton(
                label: _dayLabels[i],
                selected: selected,
                onTap: () {
                  setState(() {
                    if (selected) {
                      _selectedDays.remove(i);
                    } else {
                      _selectedDays.add(i);
                    }
                  });
                },
              );
            }),
          ),
          SizedBox(height: spacing.lg),

          // Time picker trigger
          Text('시간', style: theme.textTheme.labelLarge),
          SizedBox(height: spacing.sm),
          InkWell(
            onTap: _pickTime,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _time.format(context),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_errorMessage != null) ...[
            SizedBox(height: spacing.sm),
            Text(
              _errorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],

          SizedBox(height: spacing.lg),

          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('저장'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  Future<void> _save() async {
    if (_selectedDays.isEmpty) {
      setState(() => _errorMessage = '요일을 하나 이상 선택해주세요.');
      return;
    }
    setState(() {
      _saving = true;
      _errorMessage = null;
    });

    final timeStr = '${_time.hour.toString().padLeft(2, '0')}:'
        '${_time.minute.toString().padLeft(2, '0')}:00';

    try {
      await widget.onSaved(_selectedDays.toList()..sort(), timeStr);
      if (mounted) Navigator.of(context).pop();
    } on ReminderRepositoryException catch (e) {
      setState(() {
        _saving = false;
        _errorMessage = e.message;
      });
    } catch (_) {
      setState(() {
        _saving = false;
        _errorMessage = '저장에 실패했습니다. 다시 시도해주세요.';
      });
    }
  }
}

class _DayToggleButton extends StatelessWidget {
  const _DayToggleButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerLow,
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: selected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
