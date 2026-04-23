import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../application/reading_providers.dart';
import '../../data/reading_repository.dart';

/// Bottom-sheet entry point for manual reading-session logging.
///
/// Per design §5.1, manual sessions do NOT count toward the jan-dee or the
/// grade policy — only toward the book-count. The sheet surfaces this
/// disclaimer inline so users aren't surprised when the timer dashboard
/// stats stay unchanged after submission.
class ManualLogModal extends ConsumerStatefulWidget {
  const ManualLogModal({super.key, required this.userBookId});

  final String userBookId;

  static Future<void> show(
    BuildContext context, {
    required String userBookId,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ManualLogModal(userBookId: userBookId),
    );
  }

  @override
  ConsumerState<ManualLogModal> createState() => _ManualLogModalState();
}

class _ManualLogModalState extends ConsumerState<ManualLogModal> {
  late DateTime _startedAt = DateTime.now().subtract(const Duration(hours: 1));
  late DateTime _endedAt = DateTime.now();
  final TextEditingController _noteController = TextEditingController();
  bool _saving = false;
  String? _errorMessage;

  static final DateFormat _displayFmt = DateFormat('yyyy-MM-dd HH:mm');

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final Color accent = ref.watch(gradePrimaryProvider);

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
          Text('수동 기록', style: theme.textTheme.headlineMedium),
          SizedBox(height: spacing.xs),
          Text(
            '수동 기록은 독서 캘린더·등급에 반영되지 않아요. 권수 카운트에만 포함됩니다.',
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: spacing.lg),
          _TimeRow(
            label: '시작 시각',
            value: _startedAt,
            onTap: () => _pick(
              initial: _startedAt,
              onPicked: (v) => setState(() => _startedAt = v),
            ),
          ),
          SizedBox(height: spacing.sm),
          _TimeRow(
            label: '종료 시각',
            value: _endedAt,
            onTap: () => _pick(
              initial: _endedAt,
              onPicked: (v) => setState(() => _endedAt = v),
            ),
          ),
          SizedBox(height: spacing.md),
          TextField(
            controller: _noteController,
            maxLength: 200,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: '메모 (선택)',
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: EdgeInsets.only(top: spacing.sm),
              child: Text(
                _errorMessage!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.error),
              ),
            ),
          SizedBox(height: spacing.md),
          FilledButton(
            onPressed: _saving ? null : _submit,
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
                : const Text('저장'),
          ),
        ],
      ),
    );
  }

  Future<void> _pick({
    required DateTime initial,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (date == null || !mounted) return;
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;
    onPicked(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _submit() async {
    if (!_endedAt.isAfter(_startedAt)) {
      setState(() => _errorMessage = '종료 시각이 시작 시각보다 늦어야 해요');
      return;
    }
    final int diffSec = _endedAt.difference(_startedAt).inSeconds;
    if (diffSec < 60 || diffSec > 14400) {
      setState(() => _errorMessage = '1분 이상 4시간 이하로 입력해주세요');
      return;
    }
    setState(() {
      _saving = true;
      _errorMessage = null;
    });
    try {
      await ref.read(readingRepositoryProvider).logManualSession(
            userBookId: widget.userBookId,
            startedAt: _startedAt,
            endedAt: _endedAt,
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
          );
      if (mounted) Navigator.of(context).pop();
    } on ReadingRepositoryException catch (e) {
      setState(() {
        _saving = false;
        _errorMessage = e.code == 'MANUAL_SESSION_OUT_OF_RANGE'
            ? '1분 이상 4시간 이하로 입력해주세요'
            : e.message;
      });
    } catch (_) {
      setState(() {
        _saving = false;
        _errorMessage = '저장하지 못했어요. 잠시 후 다시 시도해주세요.';
      });
    }
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final DateTime value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            Text(label, style: theme.textTheme.bodyMedium),
            const Spacer(),
            Text(
              _ManualLogModalState._displayFmt.format(value),
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(width: 8),
            const Icon(Icons.edit_calendar_outlined, size: 18),
          ],
        ),
      ),
    );
  }
}
