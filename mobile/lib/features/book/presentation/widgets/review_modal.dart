import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../application/book_providers.dart';
import '../../application/library_notifier.dart';
import '../../data/book_repository.dart';
import '../../domain/user_book.dart';
import 'rating_stars.dart';

/// Modal bottom sheet for rating + one-line review.
///
/// Spec (Task 2.11):
///   * 5-star picker (required 1..5)
///   * Optional TextField max 200 chars with a counter
///   * 저장 CTA hits `POST /me/library/{user_book_id}/review`, updates
///     LibraryNotifier with the fresh UserBook, and closes the sheet.
///
/// Preload [initialRating] / [initialReview] so opening the modal on an
/// already-reviewed UserBook shows the previous values — users typically
/// edit rather than reset.
class ReviewModal extends ConsumerStatefulWidget {
  const ReviewModal({
    super.key,
    required this.userBook,
  });

  final UserBook userBook;

  /// Shows the modal rounded to 16px top. Returns the updated UserBook when
  /// saved, or null when dismissed.
  static Future<UserBook?> show(
    BuildContext context, {
    required UserBook userBook,
  }) {
    return showModalBottomSheet<UserBook>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ReviewModal(userBook: userBook),
    );
  }

  @override
  ConsumerState<ReviewModal> createState() => _ReviewModalState();
}

class _ReviewModalState extends ConsumerState<ReviewModal> {
  late int _rating = widget.userBook.rating ?? 0;
  late final TextEditingController _reviewController =
      TextEditingController(text: widget.userBook.oneLineReview ?? '');
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_rating < 1) {
      setState(() => _errorMessage = '별점을 먼저 매겨주세요');
      return;
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    final repository = ref.read(bookRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final UserBook updated = await repository.submitReview(
        userBookId: widget.userBook.id,
        rating: _rating,
        oneLineReview: _reviewController.text.trim().isEmpty
            ? null
            : _reviewController.text.trim(),
      );
      ref.read(libraryNotifierProvider.notifier).upsert(updated);
      // Warm confirmation haptic — mirrors Airbnb's tactile language of
      // "reward on successful interaction" without a modal bounce.
      HapticFeedback.mediumImpact();
      if (mounted) {
        Navigator.of(context).pop(updated);
      }
      messenger.showSnackBar(
        const SnackBar(content: Text('리뷰가 저장되었어요')),
      );
    } on BookRepositoryException catch (e) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _errorMessage = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
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
          Text('리뷰 작성', style: theme.textTheme.headlineMedium),
          SizedBox(height: spacing.xs),
          Text(
            widget.userBook.book.title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: spacing.lg),
          Center(
            child: RatingStars(
              value: _rating,
              onChanged: (int next) => setState(() {
                _rating = next;
                _errorMessage = null;
              }),
            ),
          ),
          SizedBox(height: spacing.lg),
          TextField(
            controller: _reviewController,
            maxLength: 200,
            maxLines: 3,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              hintText: '한 줄 감상을 남겨보세요 (선택)',
              counterText: '',
            ),
            onChanged: (_) => setState(() {}),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_reviewController.text.characters.length}/200',
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
                  : const Text('저장'),
            ),
          ),
        ],
      ),
    );
  }
}
