import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/highlight_notifier.dart';
import '../../domain/highlight.dart';
import '../../../../core/theme/app_theme.dart';

/// Bottom sheet for adding or editing a highlight.
///
/// Pass [initialHighlight] to open in edit mode — fields are pre-filled and
/// save calls update instead of create.
class AddHighlightSheet extends ConsumerStatefulWidget {
  const AddHighlightSheet({
    super.key,
    required this.userBookId,
    this.initialHighlight,
  });

  final String userBookId;

  /// When set, the sheet opens in edit mode with pre-filled values.
  final Highlight? initialHighlight;

  @override
  ConsumerState<AddHighlightSheet> createState() => _AddHighlightSheetState();
}

class _AddHighlightSheetState extends ConsumerState<AddHighlightSheet> {
  late final TextEditingController _quoteController;
  late final TextEditingController _pageController;
  late final TextEditingController _noteController;
  bool _saving = false;

  bool get _isEditMode => widget.initialHighlight != null;

  @override
  void initState() {
    super.initState();
    final h = widget.initialHighlight;
    _quoteController = TextEditingController(text: h?.quoteText ?? '');
    _pageController =
        TextEditingController(text: h?.pageNumber?.toString() ?? '');
    _noteController = TextEditingController(text: h?.noteText ?? '');
  }

  @override
  void dispose() {
    _quoteController.dispose();
    _pageController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.sm,
        spacing.lg,
        spacing.lg + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            _isEditMode ? '하이라이트 수정' : '하이라이트 추가',
            style: theme.textTheme.headlineMedium,
          ),
          SizedBox(height: spacing.md),
          TextField(
            controller: _quoteController,
            maxLength: 500,
            maxLines: 5,
            minLines: 3,
            decoration: const InputDecoration(
              hintText: '기억하고 싶은 문장을 입력하세요',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: spacing.sm),
          TextField(
            controller: _pageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: '페이지 번호 (선택)',
              border: OutlineInputBorder(),
              prefixText: 'p.',
            ),
          ),
          SizedBox(height: spacing.sm),
          TextField(
            controller: _noteController,
            maxLength: 300,
            maxLines: 3,
            minLines: 2,
            decoration: const InputDecoration(
              hintText: '내 생각 (선택)',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: spacing.lg),
          FilledButton(
            onPressed: _saving ? null : _save,
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

  Future<void> _save() async {
    final String quote = _quoteController.text.trim();
    if (quote.isEmpty) return;
    final int? page = int.tryParse(_pageController.text.trim());
    final String? note = _noteController.text.trim().isEmpty
        ? null
        : _noteController.text.trim();
    setState(() => _saving = true);
    try {
      final notifier =
          ref.read(highlightNotifierProvider(widget.userBookId).notifier);
      final Highlight? h = _isEditMode
          ? await notifier.update(
              highlightId: widget.initialHighlight!.id,
              quoteText: quote,
              pageNumber: page,
              noteText: note,
            )
          : await notifier.add(
              quoteText: quote,
              pageNumber: page,
              noteText: note,
            );
      if (!mounted) return;
      setState(() => _saving = false);
      if (h != null) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode ? '하이라이트가 수정됐어요' : '하이라이트가 저장됐어요'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('저장에 실패했어요. 다시 시도해주세요.')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장에 실패했어요. 다시 시도해주세요.')),
      );
    }
  }
}
