import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../book/application/library_notifier.dart';
import '../../../book/application/library_state.dart';
import '../../../book/domain/book_status.dart';
import '../../../book/domain/user_book.dart';
import '../../application/reading_providers.dart';
import '../../data/reading_repository.dart';

/// Bottom-sheet entry point for manual reading-session logging.
///
/// Per design §5.1, manual sessions do NOT count toward the jan-dee or the
/// grade policy — only toward the book-count. The sheet surfaces this
/// disclaimer inline so users aren't surprised when the timer dashboard
/// stats stay unchanged after submission.
///
/// When [userBookId] is null the sheet renders an inline book picker that
/// loads the user's "읽는 중" library. Pass a non-null [userBookId] to skip
/// the picker (e.g. when called from the library detail 3-dot menu).
class ManualLogModal extends ConsumerStatefulWidget {
  const ManualLogModal({super.key, this.userBookId});

  final String? userBookId;

  static Future<void> show(
    BuildContext context, {
    String? userBookId,
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

  // Selected book when userBookId is not pre-supplied.
  String? _selectedUserBookId;
  String? _selectedBookTitle;

  static final DateFormat _displayFmt = DateFormat('yyyy-MM-dd HH:mm');

  @override
  void initState() {
    super.initState();
    _selectedUserBookId = widget.userBookId;
    if (widget.userBookId == null) {
      // Kick off library load so the picker has data.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(libraryNotifierProvider.notifier)
            .ensureLoaded(BookStatus.reading);
      });
    }
  }

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
          if (widget.userBookId == null) ...<Widget>[
            _BookPicker(
              selectedUserBookId: _selectedUserBookId,
              selectedTitle: _selectedBookTitle,
              onSelected: (String id, String title) {
                setState(() {
                  _selectedUserBookId = id;
                  _selectedBookTitle = title;
                });
              },
            ),
            SizedBox(height: spacing.md),
          ],
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
    final String? bookId = _selectedUserBookId;
    if (bookId == null) {
      setState(() => _errorMessage = '책을 선택해주세요');
      return;
    }
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
            userBookId: bookId,
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

/// Inline book picker — shows the "읽는 중" library as a scrollable chip list.
class _BookPicker extends ConsumerWidget {
  const _BookPicker({
    required this.selectedUserBookId,
    required this.selectedTitle,
    required this.onSelected,
  });

  final String? selectedUserBookId;
  final String? selectedTitle;
  final void Function(String id, String title) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final libraryMap = ref.watch(libraryNotifierProvider);
    final LibraryListState listState =
        libraryMap[BookStatus.reading] ?? const LibraryListState.initial();

    final List<UserBook> books = switch (listState) {
      LibraryListLoaded(:final items) => items,
      _ => const <UserBook>[],
    };

    if (listState is LibraryListLoading && books.isEmpty) {
      return const SizedBox(
        height: 48,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (books.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '읽는 중인 책이 없어요',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '책 선택',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final UserBook ub = books[index];
              final bool selected = ub.id == selectedUserBookId;
              return ChoiceChip(
                label: Text(
                  ub.book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                selected: selected,
                onSelected: (_) => onSelected(ub.id, ub.book.title),
              );
            },
          ),
        ),
        if (selectedTitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              '선택됨: $selectedTitle',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
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
