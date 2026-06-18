import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../feed/application/book_feed_notifier.dart';
import '../../feed/application/highlight_notifier.dart';
import '../../feed/application/highlight_state.dart';
import '../../feed/domain/highlight.dart';
import '../../feed/presentation/book_feed_section.dart';
import '../../feed/presentation/widgets/add_highlight_sheet.dart';
import '../application/book_detail_notifier.dart';
import '../application/book_detail_state.dart';
import '../application/book_providers.dart';
import '../application/library_notifier.dart';
import '../application/library_state.dart';
import '../domain/book.dart';
import '../domain/book_status.dart';
import '../domain/user_book.dart';
import '../../reading/application/reading_providers.dart';
import 'widgets/book_cover.dart';
import 'widgets/review_modal.dart';
import 'widgets/review_section.dart';

/// Two-pane Airbnb-toned book detail:
///   * Hero cover with a three-layer shadow (AppShadows.elevated).
///   * Serif title (Playfair displaySmall) + Inter author row + publisher chip.
///   * Description collapses to ~6 lines with a "더 보기" toggle.
///   * Primary CTA "내 서재에 담기" — Rausch FilledButton with loading / added
///     / duplicate machine bound to BookDetailNotifier.libraryState.
class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({super.key, required this.bookId, this.userBookId});

  final String bookId;

  /// Pre-known userBookId passed from the library grid when the user taps a
  /// book that is already in the library. Lets the CTA start in "duplicate"
  /// state before the network call resolves, avoiding the brief flicker where
  /// the primary "담기" button is shown for an already-added book.
  final String? userBookId;

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
            initialUserBookId: userBookId,
            spacing: spacing,
            userBookId: switch (libraryState) {
              LibraryCtaAdded(:final userBook) => userBook.id,
              LibraryCtaDuplicate(:final duplicateUserBookId) =>
                duplicateUserBookId ?? userBookId,
              _ => userBookId,
            },
            onAdd: () async {
              final messenger = ScaffoldMessenger.of(context);
              final userBook = await ref
                  .read(bookDetailNotifierProvider(bookId).notifier)
                  .addToLibrary();
              if (userBook != null) {
                ref.read(libraryNotifierProvider.notifier).upsert(userBook);
                messenger.showSnackBar(
                  const SnackBar(content: Text('서재에 담겼어요')),
                );
              }
            },
            onAddWishlist: () async {
              final messenger = ScaffoldMessenger.of(context);
              final userBook = await ref
                  .read(bookDetailNotifierProvider(bookId).notifier)
                  .addToWishlist();
              if (userBook != null) {
                ref.read(libraryNotifierProvider.notifier).upsert(userBook);
                messenger.showSnackBar(
                  const SnackBar(content: Text('읽고 싶어요 목록에 추가됐어요')),
                );
              }
            },
            onGoToLibrary: () {
              final (String? id, String? pendingTab) = switch (libraryState) {
                LibraryCtaAdded(:final userBook) => (
                    userBook.id,
                    userBook.status.wire
                  ),
                LibraryCtaDuplicate(:final duplicateUserBookId) => (
                    duplicateUserBookId,
                    null
                  ),
                _ => (null, null),
              };
              if (pendingTab != null) {
                ref
                    .read(libraryPendingTabProvider.notifier)
                    .set(BookStatus.fromWire(pendingTab));
              }
              final String uri =
                  id != null ? '/library?highlight=$id' : '/library';
              context.go(uri);
            },
          ),
      },
    );
  }
}

enum _DetailTab { highlights, reviews, feed }

class _Content extends ConsumerStatefulWidget {
  const _Content({
    required this.book,
    required this.libraryState,
    required this.spacing,
    required this.onAdd,
    required this.onAddWishlist,
    required this.onGoToLibrary,
    this.userBookId,
    this.initialUserBookId,
  });

  final Book book;
  final LibraryCtaState libraryState;
  final AppSpacing spacing;
  final VoidCallback onAdd;
  final VoidCallback onAddWishlist;
  final VoidCallback onGoToLibrary;
  final String? userBookId;

  /// If non-null, this book is already in the library under this ID.
  /// Used to override the CTA to "duplicate" state before the async check
  /// resolves so the button never briefly shows "담기" for an owned book.
  final String? initialUserBookId;

  @override
  ConsumerState<_Content> createState() => _ContentState();
}

class _ContentState extends ConsumerState<_Content> {
  bool _descExpanded = false;
  _DetailTab _activeTab = _DetailTab.highlights;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Returns the UserBook for the current user if available, preferring the
  /// fresh library cache (reactive after review submit) over the detail state.
  UserBook? _resolveUserBook() {
    final String? ubId = widget.userBookId;
    if (ubId == null) return null;

    final lib = ref.read(libraryNotifierProvider);
    for (final listState in lib.values) {
      if (listState is LibraryListLoaded) {
        final int idx = listState.items.indexWhere((b) => b.id == ubId);
        if (idx != -1) return listState.items[idx];
      }
    }
    // Fall back to the state that was passed at construction (e.g. just-added).
    final ls = widget.libraryState;
    if (ls is LibraryCtaAdded) return ls.userBook;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shadows = theme.extension<AppShadows>()!;
    final radii = theme.extension<AppRadius>()!;
    final spacing = widget.spacing;
    final Book book = widget.book;

    // Keep the feed provider alive while this screen is open so switching
    // between highlights / feed tabs does not dispose and re-fetch the feed.
    ref.listen(bookFeedNotifierProvider(book.id), (_, __) {});

    final String? description = book.description;
    final bool hasDescription =
        description != null && description.trim().isNotEmpty;

    final LibraryCtaState effectiveLibraryState =
        (widget.libraryState is LibraryCtaIdle &&
                widget.initialUserBookId != null)
            ? LibraryCtaState.duplicate(
                duplicateUserBookId: widget.initialUserBookId,
              )
            : widget.libraryState;

    final bool inLibrary = widget.userBookId != null;

    return SafeArea(
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(
          spacing.lg,
          spacing.sm,
          spacing.lg,
          spacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Hero cover
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
                expanded: _descExpanded,
                onToggle: () => setState(() => _descExpanded = !_descExpanded),
              ),
            ],
            SizedBox(height: spacing.xl),
            _LibraryCta(
              state: effectiveLibraryState,
              onAdd: widget.onAdd,
              onAddWishlist: widget.onAddWishlist,
              onGoToLibrary: widget.onGoToLibrary,
              onStartReading: widget.userBookId != null
                  ? () => context.push(
                        '/reading/timer'
                        '?user_book_id=${widget.userBookId}'
                        '&auto_start=true',
                      )
                  : null,
            ),
            Builder(builder: (ctx) {
              final ub = _resolveUserBook();
              if (ub == null || ub.status != BookStatus.reading) {
                return const SizedBox.shrink();
              }
              return _ChapterUpdateRow(
                userBook: ub,
                onUpdated: (updated) {
                  ref.read(libraryNotifierProvider.notifier).upsert(updated);
                },
              );
            },),
            SizedBox(height: spacing.xl),
            const Divider(height: 1),
            SizedBox(height: spacing.lg),
            // ── Content area: highlights / reviews / community feed ──
            if (inLibrary) ...<Widget>[
              _ContentToggle(
                active: _activeTab,
                onChanged: (tab) => setState(() => _activeTab = tab),
              ),
              SizedBox(height: spacing.lg),
              if (_activeTab == _DetailTab.highlights)
                _HighlightSection(
                  userBookId: widget.userBookId!,
                  bookId: book.id,
                )
              else if (_activeTab == _DetailTab.reviews)
                _ReviewsSection(
                  bookId: book.id,
                  userBookId: widget.userBookId,
                  initialUserBook: _resolveUserBook(),
                )
              else
                BookFeedSection(
                  bookId: book.id,
                  scrollController: _scrollController,
                ),
            ] else
              BookFeedSection(
                bookId: book.id,
                scrollController: _scrollController,
              ),
          ],
        ),
      ),
    );
  }
}

/// Pill-track style toggle — visually consistent with the app's chip language.
/// Shown only when the book is in the user's library.
class _ContentToggle extends StatelessWidget {
  const _ContentToggle({required this.active, required this.onChanged});

  final _DetailTab active;
  final ValueChanged<_DetailTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
      ),
      child: Row(
        children: <Widget>[
          _ToggleSegment(
            icon: Icons.bookmark_outline_rounded,
            label: '하이라이트',
            selected: active == _DetailTab.highlights,
            onTap: () => onChanged(_DetailTab.highlights),
          ),
          _ToggleSegment(
            icon: Icons.star_outline_rounded,
            label: '리뷰',
            selected: active == _DetailTab.reviews,
            onTap: () => onChanged(_DetailTab.reviews),
          ),
          _ToggleSegment(
            icon: Icons.people_outline_rounded,
            label: '피드',
            selected: active == _DetailTab.feed,
            onTap: () => onChanged(_DetailTab.feed),
          ),
        ],
      ),
    );
  }
}

class _ToggleSegment extends StatelessWidget {
  const _ToggleSegment({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    final Color fg = selected
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurfaceVariant;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: fg,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
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
    required this.onAddWishlist,
    required this.onGoToLibrary,
    this.onStartReading,
  });

  final LibraryCtaState state;
  final VoidCallback onAdd;
  final VoidCallback onAddWishlist;
  final VoidCallback onGoToLibrary;
  final VoidCallback? onStartReading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;

    final ButtonStyle pillStyle = FilledButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
      ),
      minimumSize: const Size.fromHeight(52),
    );
    final ButtonStyle outlinePillStyle = OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
      ),
      minimumSize: const Size.fromHeight(52),
    );

    return switch (state) {
      LibraryCtaIdle() => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FilledButton(
              style: pillStyle,
              onPressed: onAdd,
              child: const Text('내 서재에 담기'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              style: outlinePillStyle,
              onPressed: onAddWishlist,
              child: const Text('읽고 싶어요'),
            ),
          ],
        ),
      LibraryCtaAdding() => FilledButton(
          style: pillStyle,
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
      LibraryCtaAdded() => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (onStartReading != null) ...<Widget>[
              FilledButton.icon(
                style: pillStyle,
                onPressed: onStartReading,
                icon: const Icon(Icons.play_circle_outline_rounded),
                label: const Text('읽기 시작'),
              ),
              const SizedBox(height: 8),
            ],
            OutlinedButton(
              style: outlinePillStyle,
              onPressed: onGoToLibrary,
              child: const Text('서재에서 보기'),
            ),
          ],
        ),
      LibraryCtaDuplicate() => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (onStartReading != null) ...<Widget>[
              FilledButton.icon(
                style: pillStyle,
                onPressed: onStartReading,
                icon: const Icon(Icons.play_circle_outline_rounded),
                label: const Text('읽기 시작'),
              ),
              const SizedBox(height: 8),
            ],
            OutlinedButton(
              style: outlinePillStyle,
              onPressed: onGoToLibrary,
              child: const Text('서재에서 보기'),
            ),
          ],
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
              style: pillStyle,
              onPressed: onAdd,
              child: const Text('다시 시도'),
            ),
          ],
        ),
    };
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

// ---------------------------------------------------------------------------
// Reviews section
// ---------------------------------------------------------------------------

class _ReviewsSection extends ConsumerWidget {
  const _ReviewsSection({
    required this.bookId,
    this.userBookId,
    this.initialUserBook,
  });

  final String bookId;
  final String? userBookId;
  final UserBook? initialUserBook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    // Prefer the live library cache so the section updates immediately after
    // a review is saved without requiring a full screen reload.
    UserBook? myUserBook = initialUserBook;
    if (userBookId != null) {
      final lib = ref.watch(libraryNotifierProvider);
      for (final listState in lib.values) {
        if (listState is LibraryListLoaded) {
          final int idx =
              listState.items.indexWhere((b) => b.id == userBookId);
          if (idx != -1) {
            myUserBook = listState.items[idx];
            break;
          }
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (myUserBook != null) ...<Widget>[
          _MyReviewCard(userBook: myUserBook),
          SizedBox(height: spacing.xl),
        ],
        ReviewSection(
          bookId: bookId,
          bookTitle: myUserBook?.book.title,
          canWrite: myUserBook?.status == BookStatus.completed,
        ),
      ],
    );
  }
}

class _MyReviewCard extends ConsumerWidget {
  const _MyReviewCard({required this.userBook});

  final UserBook userBook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radii = theme.extension<AppRadius>()!;

    final bool hasReview = userBook.rating != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text('내 리뷰', style: theme.textTheme.titleMedium),
            ),
            TextButton(
              onPressed: () => _openReviewModal(context, ref),
              child: Text(hasReview ? '수정' : '작성'),
            ),
          ],
        ),
        SizedBox(height: spacing.xs),
        if (!hasReview)
          Text(
            '아직 리뷰를 작성하지 않았어요.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          Container(
            padding: EdgeInsets.all(spacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.all(Radius.circular(radii.md)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ReadOnlyStars(
                  rating: userBook.rating!,
                  size: 20,
                  color: ref.watch(gradePrimaryProvider),
                ),
                if (userBook.oneLineReview != null &&
                    userBook.oneLineReview!.isNotEmpty) ...<Widget>[
                  SizedBox(height: spacing.sm),
                  Text(
                    userBook.oneLineReview!,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _openReviewModal(BuildContext context, WidgetRef ref) async {
    await ReviewModal.show(context, userBook: userBook);
  }
}

class _ReadOnlyStars extends StatelessWidget {
  const _ReadOnlyStars({required this.rating, this.size = 16, this.color});

  final int rating;
  final double size;
  // When null, falls back to theme.colorScheme.primary (community reviews use
  // the generic primary; _MyReviewCard passes the grade-specific accent).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filledColor = color ?? theme.colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(
        5,
        (int i) => Icon(
          i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size,
          color: i < rating ? filledColor : theme.colorScheme.outline,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Highlight section
// ---------------------------------------------------------------------------

class _HighlightSection extends ConsumerWidget {
  const _HighlightSection({required this.userBookId, required this.bookId});

  final String userBookId;
  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final HighlightState state =
        ref.watch(highlightNotifierProvider(userBookId));

    // Load on first build.
    ref.listen<HighlightState>(
      highlightNotifierProvider(userBookId),
      (_, __) {},
    );
    if (state is HighlightInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(highlightNotifierProvider(userBookId).notifier).load();
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text('내 하이라이트', style: theme.textTheme.titleMedium),
            ),
            TextButton.icon(
              onPressed: () => _showAddModal(context, ref),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('추가'),
            ),
          ],
        ),
        if (state is HighlightLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (state is HighlightLoaded && state.items.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: spacing.md),
            child: Text(
              '기억하고 싶은 문장을 저장해보세요.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else if (state is HighlightLoaded)
          ...state.items.map(
            (Highlight h) => _HighlightCard(highlight: h, userBookId: userBookId),
          ),
      ],
    );
  }

  Future<void> _showAddModal(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AddHighlightSheet(userBookId: userBookId),
    );
  }
}

// ---------------------------------------------------------------------------
// Chapter update row
// ---------------------------------------------------------------------------

class _ChapterUpdateRow extends ConsumerStatefulWidget {
  const _ChapterUpdateRow({required this.userBook, required this.onUpdated});

  final UserBook userBook;
  final void Function(UserBook updated) onUpdated;

  @override
  ConsumerState<_ChapterUpdateRow> createState() => _ChapterUpdateRowState();
}

class _ChapterUpdateRowState extends ConsumerState<_ChapterUpdateRow> {
  bool _loading = false;

  Future<void> _showDialog() async {
    final controller =
        TextEditingController(text: widget.userBook.currentChapter.toString());
    final result = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('현재 읽은 장'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '장',
            hintText: '예) 5',
            suffixText: '장',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              final n = int.tryParse(controller.text.trim());
              if (n != null && n >= 0) Navigator.pop(context, n);
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || !mounted) return;

    setState(() => _loading = true);
    try {
      final updated = await ref.read(bookRepositoryProvider).updateChapter(
            userBookId: widget.userBook.id,
            chapter: result,
          );
      widget.onUpdated(updated);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장에 실패했어요. 다시 시도해 주세요.')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Padding(
      padding: EdgeInsets.only(top: spacing.sm),
      child: Row(
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 18,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Text(
              widget.userBook.currentChapter == 0
                  ? '아직 읽은 장을 기록하지 않았어요'
                  : '${widget.userBook.currentChapter}장까지 읽었어요',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          _loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : TextButton(
                  onPressed: _showDialog,
                  child: const Text('장 수정'),
                ),
        ],
      ),
    );
  }
}

class _HighlightCard extends ConsumerWidget {
  const _HighlightCard({required this.highlight, required this.userBookId});

  final Highlight highlight;
  final String userBookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    final spacing = theme.extension<AppSpacing>()!;
    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border(
          left: BorderSide(
            color: theme.colorScheme.primary,
            width: 3,
          ),
        ),
        borderRadius: BorderRadius.all(Radius.circular(radii.sm)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '"${highlight.quoteText}"',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                ),
                if (highlight.pageNumber != null) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    'p.${highlight.pageNumber}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            onPressed: () => _showEditModal(context),
            color: theme.colorScheme.onSurfaceVariant,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            onPressed: () => ref
                .read(highlightNotifierProvider(userBookId).notifier)
                .delete(highlight.id),
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Future<void> _showEditModal(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AddHighlightSheet(
        userBookId: userBookId,
        initialHighlight: highlight,
      ),
    );
  }
}
