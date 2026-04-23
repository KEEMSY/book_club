import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../application/book_detail_notifier.dart';
import '../application/book_detail_state.dart';
import '../domain/book.dart';
import 'widgets/book_cover.dart';

/// Two-pane Airbnb-toned book detail:
///   * Hero cover with a three-layer shadow (AppShadows.elevated).
///   * Serif title (Playfair displaySmall) + Inter author row + publisher chip.
///   * Description collapses to ~6 lines with a "더 보기" toggle.
///   * Primary CTA "내 서재에 담기" — Rausch FilledButton with loading / added
///     / duplicate machine bound to BookDetailNotifier.libraryState.
class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({super.key, required this.bookId});

  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final BookDetailState state = ref.watch(bookDetailNotifierProvider(bookId));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
      ),
      body: switch (state) {
        BookDetailLoading() => const Center(child: CircularProgressIndicator()),
        BookDetailError(:final String message) => _ErrorView(
            message: message,
            onRetry: () =>
                ref.read(bookDetailNotifierProvider(bookId).notifier).load(),
          ),
        BookDetailLoaded(
          :final Book book,
          :final LibraryCtaState libraryState
        ) =>
          _Content(
            book: book,
            libraryState: libraryState,
            spacing: spacing,
            onAdd: () async {
              final messenger = ScaffoldMessenger.of(context);
              final userBook = await ref
                  .read(bookDetailNotifierProvider(bookId).notifier)
                  .addToLibrary();
              if (userBook != null) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('서재에 담겼어요')),
                );
              }
            },
            onGoToLibrary: () {
              final String? userBookId = switch (libraryState) {
                LibraryCtaAdded(:final userBook) => userBook.id,
                LibraryCtaDuplicate(:final duplicateUserBookId) =>
                  duplicateUserBookId,
                _ => null,
              };
              if (userBookId == null) {
                context.go('/library');
              } else {
                context.go('/library?highlight=$userBookId');
              }
            },
          ),
      },
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({
    required this.book,
    required this.libraryState,
    required this.spacing,
    required this.onAdd,
    required this.onGoToLibrary,
  });

  final Book book;
  final LibraryCtaState libraryState;
  final AppSpacing spacing;
  final VoidCallback onAdd;
  final VoidCallback onGoToLibrary;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shadows = theme.extension<AppShadows>()!;
    final radii = theme.extension<AppRadius>()!;
    final spacing = widget.spacing;

    final Book book = widget.book;
    final String? description = book.description;
    final bool hasDescription =
        description != null && description.trim().isNotEmpty;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          spacing.lg,
          spacing.sm,
          spacing.lg,
          spacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Hero cover: 160×240, centered, three-layer Airbnb shadow.
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(radii.md)),
                  boxShadow: shadows.elevated,
                ),
                child: BookCover(
                  coverUrl: book.coverUrl,
                  width: 160,
                  height: 240,
                  borderRadius: BorderRadius.all(Radius.circular(radii.md)),
                ),
              ),
            ),
            SizedBox(height: spacing.lg),
            Text(book.title, style: theme.textTheme.displaySmall),
            SizedBox(height: spacing.sm),
            Text(
              book.author,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (book.publisher.isNotEmpty) ...<Widget>[
              SizedBox(height: spacing.sm),
              _PublisherChip(publisher: book.publisher),
            ],
            if (hasDescription) ...<Widget>[
              SizedBox(height: spacing.lg),
              _Description(
                text: description.trim(),
                expanded: _expanded,
                onToggle: () => setState(() => _expanded = !_expanded),
              ),
            ],
            SizedBox(height: spacing.xl),
            _LibraryCta(
              state: widget.libraryState,
              onAdd: widget.onAdd,
              onGoToLibrary: widget.onGoToLibrary,
            ),
          ],
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({
    required this.text,
    required this.expanded,
    required this.onToggle,
  });

  final String text;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          text,
          maxLines: expanded ? null : 6,
          overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onToggle,
            child: Text(expanded ? '접기' : '더 보기'),
          ),
        ),
      ],
    );
  }
}

class _PublisherChip extends StatelessWidget {
  const _PublisherChip({required this.publisher});

  final String publisher;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.all(Radius.circular(radii.sm)),
      ),
      child: Text(
        publisher,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _LibraryCta extends StatelessWidget {
  const _LibraryCta({
    required this.state,
    required this.onAdd,
    required this.onGoToLibrary,
  });

  final LibraryCtaState state;
  final VoidCallback onAdd;
  final VoidCallback onGoToLibrary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;

    return SizedBox(
      width: double.infinity,
      child: switch (state) {
        LibraryCtaIdle() => FilledButton(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
              ),
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: onAdd,
            child: const Text('내 서재에 담기'),
          ),
        LibraryCtaAdding() => FilledButton(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
              ),
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: null,
            child: const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        LibraryCtaAdded() => FilledButton(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
              ),
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: onGoToLibrary,
            child: const Text('서재에서 보기'),
          ),
        // Duplicate: backend returned 409 but we do not know the user_book_id
        // yet — per the spec, disable the CTA and show a chip.
        LibraryCtaDuplicate(:final String? duplicateUserBookId) =>
          duplicateUserBookId == null
              ? OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(radii.pill)),
                    ),
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: null,
                  child: const Text('이미 서재에 있어요'),
                )
              : FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(radii.pill)),
                    ),
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: onGoToLibrary,
                  child: const Text('서재에서 보기'),
                ),
        LibraryCtaError(:final String message) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
                  ),
                  minimumSize: const Size.fromHeight(52),
                ),
                onPressed: onAdd,
                child: const Text('다시 시도'),
              ),
            ],
          ),
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.xl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline_rounded, size: 40),
            SizedBox(height: spacing.md),
            Text(message, style: theme.textTheme.titleLarge),
            SizedBox(height: spacing.lg),
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
