import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../reading/application/reading_providers.dart';
import '../../application/review_providers.dart';
import '../../data/book_repository.dart' show BookRepositoryException;

/// Modal bottom sheet for writing or editing the user's book review (M54).
///
///   * Half-step star picker (0.5 .. 5.0) driven by tap position.
///   * Optional body TextField, max 500 chars with a live counter.
///   * Submits through [ReviewNotifier]; on success the sheet pops with `true`.
class WriteReviewSheet extends ConsumerStatefulWidget {
  const WriteReviewSheet({
    super.key,
    required this.bookId,
    this.bookTitle,
    this.initialRating,
    this.initialBody,
    this.isEdit = false,
  });

  final String bookId;
  final String? bookTitle;
  final double? initialRating;
  final String? initialBody;
  final bool isEdit;

  /// Shows the sheet rounded to 16px top. Returns `true` when a review was
  /// saved, or null when dismissed.
  static Future<bool?> show(
    BuildContext context, {
    required String bookId,
    String? bookTitle,
    double? initialRating,
    String? initialBody,
    bool isEdit = false,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => WriteReviewSheet(
        bookId: bookId,
        bookTitle: bookTitle,
        initialRating: initialRating,
        initialBody: initialBody,
        isEdit: isEdit,
      ),
    );
  }

  @override
  ConsumerState<WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends ConsumerState<WriteReviewSheet> {
  static const int _maxLength = 500;

  late double _rating = widget.initialRating ?? 0;
  late final TextEditingController _bodyController =
      TextEditingController(text: widget.initialBody ?? '');
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_rating < 0.5) {
      setState(() => _errorMessage = '별점을 먼저 매겨주세요');
      return;
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    final String text = _bodyController.text.trim();
    final String? body = text.isEmpty ? null : text;
    final notifier = ref.read(reviewNotifierProvider.notifier);

    final bool ok = widget.isEdit
        ? await notifier.updateReview(widget.bookId, rating: _rating, body: body)
        : await notifier.create(widget.bookId, _rating, body);

    if (!mounted) return;
    if (ok) {
      HapticFeedback.mediumImpact();
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _submitting = false;
      _errorMessage = _readError();
    });
  }

  String _readError() {
    final Object? error = ref.read(reviewNotifierProvider).error;
    if (error is BookRepositoryException) return error.message;
    return '저장에 실패했어요. 잠시 후 다시 시도해주세요.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final Color accent = ref.watch(gradePrimaryProvider);
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.sm,
        spacing.lg,
        spacing.lg + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.isEdit ? '리뷰 수정' : '리뷰 작성',
            style: theme.textTheme.headlineMedium,
          ),
          if (widget.bookTitle != null) ...<Widget>[
            SizedBox(height: spacing.xs),
            Text(
              widget.bookTitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          SizedBox(height: spacing.lg),
          Center(
            child: _HalfStarPicker(
              value: _rating,
              color: accent,
              onChanged: (double next) => setState(() {
                _rating = next;
                _errorMessage = null;
              }),
            ),
          ),
          SizedBox(height: spacing.xs),
          Center(
            child: Text(
              _rating == 0 ? '별점을 선택해주세요' : '${_rating.toStringAsFixed(1)} / 5.0',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(height: spacing.lg),
          TextField(
            controller: _bodyController,
            maxLength: _maxLength,
            maxLines: 4,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              hintText: '이 책에 대한 감상을 남겨보세요 (선택)',
              counterText: '',
            ),
            onChanged: (_) => setState(() {}),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_bodyController.text.characters.length}/$_maxLength',
              style: theme.textTheme.bodySmall,
            ),
          ),
          if (_errorMessage != null) ...<Widget>[
            SizedBox(height: spacing.sm),
            Text(
              _errorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          SizedBox(height: spacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submitting ? null : _save,
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(widget.isEdit ? '수정하기' : '리뷰 남기기'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Five-star picker supporting half-step selection. Tapping the left half of a
/// star selects `n - 0.5`; the right half selects `n`.
class _HalfStarPicker extends StatelessWidget {
  const _HalfStarPicker({
    required this.value,
    required this.color,
    required this.onChanged,
  });

  static const double size = 40;

  final double value;
  final Color color;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < 5; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: 6),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (TapDownDetails details) {
              final bool isLeft = details.localPosition.dx < size / 2;
              onChanged(isLeft ? i + 0.5 : i + 1.0);
            },
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(
                _iconFor(i + 1),
                size: size,
                color: value >= i + 0.5 ? color : theme.colorScheme.outline,
              ),
            ),
          ),
        ],
      ],
    );
  }

  IconData _iconFor(int starValue) {
    if (value >= starValue) return Icons.star_rounded;
    if (value >= starValue - 0.5) return Icons.star_half_rounded;
    return Icons.star_outline_rounded;
  }
}
