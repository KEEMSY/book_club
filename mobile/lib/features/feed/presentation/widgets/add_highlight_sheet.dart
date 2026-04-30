import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/highlight_notifier.dart';
import '../../domain/highlight.dart';
import '../../../../core/theme/app_theme.dart';

/// Bottom sheet for adding a highlight to a user book.
///
/// Shows a quote text field (max 500 chars) and optional page number field.
/// On success, snackbar confirms save and sheet closes.
class AddHighlightSheet extends ConsumerStatefulWidget {
  const AddHighlightSheet({super.key, required this.userBookId});

  final String userBookId;

  @override
  ConsumerState<AddHighlightSheet> createState() => _AddHighlightSheetState();
}

class _AddHighlightSheetState extends ConsumerState<AddHighlightSheet> {
  final TextEditingController _quoteController = TextEditingController();
  final TextEditingController _pageController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _quoteController.dispose();
    _pageController.dispose();
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
          Text('하이라이트 추가', style: theme.textTheme.headlineMedium),
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
    setState(() => _saving = true);
    final Highlight? h = await ref
        .read(highlightNotifierProvider(widget.userBookId).notifier)
        .add(quoteText: quote, pageNumber: page);
    if (!mounted) return;
    setState(() => _saving = false);
    if (h != null) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('하이라이트가 저장됐어요')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장에 실패했어요. 다시 시도해주세요.')),
      );
    }
  }
}
