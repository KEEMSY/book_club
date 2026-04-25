import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_theme.dart';
import '../application/book_feed_notifier.dart';
import '../application/post_compose_notifier.dart';
import '../application/post_compose_state.dart';
import '../data/image_uploader.dart';
import '../domain/post.dart';
import '../domain/post_type.dart';
import 'widgets/image_picker_row.dart';
import 'widgets/post_type_pill.dart';

/// Full-screen compose surface mounted at `/books/:id/posts/new`.
///
/// State machine:
///   Editing → Uploading(N) → Posting → Success | Failure(retry)
///
/// On Success the route pops, the parent feed is refreshed, and a
/// confirmation SnackBar fires. On Failure typed content + picked images
/// stay intact; the user can retry without re-selecting the gallery.
class PostComposeScreen extends ConsumerStatefulWidget {
  const PostComposeScreen({super.key, required this.bookId});

  final String bookId;

  @override
  ConsumerState<PostComposeScreen> createState() => _PostComposeScreenState();
}

class _PostComposeScreenState extends ConsumerState<PostComposeScreen> {
  late final TextEditingController _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  PostType _activeType(PostComposeState s) {
    return switch (s) {
      PostComposeEditing(:final postType) => postType,
      PostComposeUploading(:final postType) => postType,
      PostComposePosting(:final postType) => postType,
      PostComposeFailure(:final postType) => postType,
      _ => PostType.thought,
    };
  }

  List<PickedImage> _activeImages(PostComposeState s) {
    return switch (s) {
      PostComposeEditing(:final images) => images,
      PostComposeUploading(:final images) => images,
      PostComposePosting(:final images) => images,
      PostComposeFailure(:final images) => images,
      _ => const <PickedImage>[],
    };
  }

  bool _isBusy(PostComposeState s) =>
      s is PostComposeUploading || s is PostComposePosting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final state = ref.watch(postComposeNotifierProvider(widget.bookId));
    final PostType activeType = _activeType(state);
    final List<PickedImage> images = _activeImages(state);
    final bool busy = _isBusy(state);
    final String content = _contentController.text;
    final bool canSubmit = content.trim().isNotEmpty && !busy;

    // React to success state — pop, refresh, and snack.
    ref.listen<PostComposeState>(
      postComposeNotifierProvider(widget.bookId),
      (previous, next) {
        if (next is PostComposeSuccess && previous is! PostComposeSuccess) {
          // Refresh the feed so the new post appears at the top, then pop.
          ref.read(bookFeedNotifierProvider(widget.bookId).notifier).refresh();
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('글이 올라갔어요')),
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            if (busy) return;
            if (context.canPop()) context.pop();
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FilledButton(
              onPressed: canSubmit ? _onSubmit : null,
              style: FilledButton.styleFrom(
                shape: const StadiumBorder(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              ),
              child: state is PostComposeUploading
                  ? Text(
                      '업로드 ${state.uploadedCount}/${state.images.length}',
                    )
                  : state is PostComposePosting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('공유'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: spacing.md),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.lg),
              child: _TypeChips(
                active: activeType,
                onChanged: (PostType next) {
                  ref
                      .read(postComposeNotifierProvider(widget.bookId).notifier)
                      .changeType(next);
                },
              ),
            ),
            SizedBox(height: spacing.md),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.lg),
              child: TextField(
                controller: _contentController,
                maxLength: PostComposeNotifier.maxContentLength,
                minLines: 6,
                maxLines: 16,
                onChanged: (String value) {
                  ref
                      .read(postComposeNotifierProvider(widget.bookId).notifier)
                      .changeContent(value);
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: activeType.composerHint,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  counterStyle: theme.textTheme.bodySmall,
                ),
                style: theme.textTheme.bodyLarge,
              ),
            ),
            SizedBox(height: spacing.sm),
            ImagePickerRow(
              images: images,
              onPick: _pickImage,
              onRemove: (int index) {
                ref
                    .read(postComposeNotifierProvider(widget.bookId).notifier)
                    .removeImage(index);
              },
            ),
            if (state is PostComposeFailure) ...<Widget>[
              SizedBox(height: spacing.md),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                child: _FailureBanner(
                  message: state.message,
                  onRetry: _onSubmit,
                ),
              ),
            ],
            if (state is PostComposeUploading) ...<Widget>[
              SizedBox(height: spacing.md),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                child: LinearProgressIndicator(
                  value: state.images.isEmpty
                      ? null
                      : state.uploadedCount / state.images.length,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null) return;
      final Uint8List bytes = await picked.readAsBytes();
      final String contentType =
          picked.mimeType ?? _guessContentType(picked.name);
      final ok = ref
          .read(postComposeNotifierProvider(widget.bookId).notifier)
          .addImage(
            PickedImage(
              bytes: bytes,
              contentType: contentType,
              filename: picked.name,
            ),
          );
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지는 4장까지 첨부할 수 있어요')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지를 불러오지 못했어요')),
        );
      }
    }
  }

  Future<void> _onSubmit() async {
    final Post? created = await ref
        .read(postComposeNotifierProvider(widget.bookId).notifier)
        .submit();
    if (created != null && mounted) {
      // Insert immediately so the user sees the post even before refresh
      // returns. The ref.listen above also triggers a refresh — both paths
      // are idempotent because feed cards are keyed by post id.
      ref
          .read(bookFeedNotifierProvider(widget.bookId).notifier)
          .prependPost(created);
    }
  }
}

class _TypeChips extends StatelessWidget {
  const _TypeChips({required this.active, required this.onChanged});

  final PostType active;
  final ValueChanged<PostType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (final PostType type in PostType.values)
          _SelectableChip(
            type: type,
            selected: type == active,
            onTap: () => onChanged(type),
          ),
      ],
    );
  }
}

class _SelectableChip extends StatelessWidget {
  const _SelectableChip({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final PostType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(1000),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(1000)),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: selected ? 2 : 1,
          ),
        ),
        padding: EdgeInsets.zero,
        child: PostTypePill(type: type),
      ),
    );
  }
}

class _FailureBanner extends StatelessWidget {
  const _FailureBanner({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.all(Radius.circular(radii.md)),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.error_outline, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.error),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}

String _guessContentType(String filename) {
  final String lower = filename.toLowerCase();
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.webp')) return 'image/webp';
  return 'image/jpeg';
}
