import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../book/application/book_search_notifier.dart';
import '../../book/application/book_search_state.dart';
import '../../book/domain/book.dart';
import '../application/event_notifier.dart';
import '../application/event_providers.dart';
import '../domain/event.dart';

/// Bottom sheet to create a public "번개 모임" (no map/SDK — place is free text).
class EventCreateSheet extends ConsumerStatefulWidget {
  const EventCreateSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const EventCreateSheet(),
      );

  @override
  ConsumerState<EventCreateSheet> createState() => _EventCreateSheetState();
}

class _EventCreateSheetState extends ConsumerState<EventCreateSheet> {
  final _titleCtrl = TextEditingController();
  final _placeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _capacityCtrl = TextEditingController();

  String? _category;
  DateTime _eventAt = DateTime.now().add(const Duration(days: 3));
  Book? _selectedBook;
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _placeCtrl.dispose();
    _descCtrl.dispose();
    _capacityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final double bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.lg + bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('번개 모임 만들기', style: theme.textTheme.titleLarge),
            SizedBox(height: spacing.lg),
            TextField(
              controller: _titleCtrl,
              maxLength: 200,
              decoration: const InputDecoration(labelText: '모임 제목 *'),
            ),
            SizedBox(height: spacing.sm),
            TextField(
              controller: _placeCtrl,
              decoration: const InputDecoration(
                labelText: '장소 (예: 강남역 스타벅스)',
              ),
            ),
            SizedBox(height: spacing.sm),
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: '소개 (선택)'),
            ),
            SizedBox(height: spacing.sm),
            TextField(
              controller: _capacityCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(labelText: '정원 (선택)'),
            ),
            SizedBox(height: spacing.md),
            Text('분야', style: theme.textTheme.labelLarge),
            SizedBox(height: spacing.xs),
            Wrap(
              spacing: spacing.xs,
              children: <Widget>[
                for (final String c in kEventCategories)
                  ChoiceChip(
                    label: Text(c),
                    selected: _category == c,
                    onSelected: (bool sel) =>
                        setState(() => _category = sel ? c : null),
                  ),
              ],
            ),
            SizedBox(height: spacing.sm),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_rounded),
              title: Text(_formatDateTime(_eventAt)),
              subtitle: const Text('날짜 및 시간'),
              onTap: _pickDate,
            ),
            const Divider(),
            _BookPickerTile(
              selected: _selectedBook,
              onPick: _pickBook,
              onClear: () => setState(() => _selectedBook = null),
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
                    : const Text('만들기'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _eventAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_eventAt),
    );
    if (time == null || !mounted) return;
    setState(
      () => _eventAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  Future<void> _pickBook() async {
    final Book? book = await showModalBottomSheet<Book>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _BookSearchSheet(),
    );
    if (book != null && mounted) {
      setState(() => _selectedBook = book);
    }
  }

  Future<void> _create() async {
    final String title = _titleCtrl.text.trim();
    if (title.isEmpty) return;
    setState(() => _saving = true);
    final String place = _placeCtrl.text.trim();
    final String desc = _descCtrl.text.trim();
    final int? capacity = int.tryParse(_capacityCtrl.text.trim());
    try {
      await ref.read(eventRepositoryProvider).createEvent(
            EventCreateInput(
              title: title,
              eventAt: _eventAt,
              address: place.isEmpty ? null : place,
              description: desc.isEmpty ? null : desc,
              maxAttendees: capacity,
              category: _category,
              bookId: _selectedBook?.id,
            ),
          );
      if (!mounted) return;
      ref.read(nearbyEventsProvider.notifier).load();
      Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('모임 생성에 실패했습니다.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _formatDateTime(DateTime dt) =>
      '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

class _BookPickerTile extends StatelessWidget {
  const _BookPickerTile({
    required this.selected,
    required this.onPick,
    required this.onClear,
  });

  final Book? selected;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final Book? book = selected;
    if (book == null) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.menu_book_outlined),
        title: const Text('함께 읽을 책 (선택)'),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onPick,
      );
    }
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.menu_book_rounded),
      title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(book.author, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: IconButton(
        icon: const Icon(Icons.close_rounded),
        tooltip: '선택 해제',
        onPressed: onClear,
      ),
      onTap: onPick,
    );
  }
}

/// Reuses the existing book search notifier to let the user pick a [Book].
/// Returns the chosen book via [Navigator.pop].
class _BookSearchSheet extends ConsumerStatefulWidget {
  const _BookSearchSheet();

  @override
  ConsumerState<_BookSearchSheet> createState() => _BookSearchSheetState();
}

class _BookSearchSheetState extends ConsumerState<_BookSearchSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final double bottom = MediaQuery.of(context).viewInsets.bottom;
    final BookSearchState state = ref.watch(bookSearchNotifierProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.lg + bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('책 검색', style: theme.textTheme.titleLarge),
          SizedBox(height: spacing.md),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onChanged: (String v) =>
                ref.read(bookSearchNotifierProvider.notifier).queryChanged(v),
            decoration: const InputDecoration(
              hintText: '제목, 저자, ISBN 으로 검색',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          SizedBox(height: spacing.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 360),
            child: _SearchResults(state: state),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.state});

  final BookSearchState state;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case BookSearchIdle():
        return const _Hint(text: '책 제목이나 저자를 입력하세요.');
      case BookSearchLoading():
        return const Center(child: CircularProgressIndicator());
      case BookSearchError(:final String message):
        return _Hint(text: message);
      case BookSearchLoaded(:final List<Book> items):
        if (items.isEmpty) {
          return const _Hint(text: '검색 결과가 없어요.');
        }
        return ListView.separated(
          shrinkWrap: true,
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 0.5),
          itemBuilder: (BuildContext context, int i) {
            final Book book = items[i];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.menu_book_outlined),
              title: Text(
                book.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                book.author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => Navigator.of(context).pop(book),
            );
          },
        );
    }
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
