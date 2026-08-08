import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/profile_theme_palette.dart';
import '../../auth/application/auth_providers.dart';
import '../../book/application/book_providers.dart';
import '../../book/data/book_repository.dart' show LibraryPage;
import '../../book/domain/book.dart';
import '../../book/presentation/widgets/book_cover.dart';
import '../../social/domain/user_summary.dart';
import '../application/community_providers.dart';

/// Screen for editing the authenticated user's own profile.
///
/// Calls `PATCH /me` with only the changed fields; on success the upstream
/// [userProfileProvider] is invalidated so the profile screen reflects the
/// new values immediately on pop.
///
/// BC-84 adds the profile-expressiveness fields (cover image URL, theme,
/// featured book, featured quote) from BC-81's backend contract. Per the
/// backend's `UpdateProfileRequest`, these four fields can be *set* but not
/// cleared back to null through this endpoint — submitting an empty value
/// simply leaves the current one unchanged, so the picker/text fields below
/// never offer a destructive "제거" action that would silently no-op.
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key, required this.profile});

  final UserProfile profile;

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late final TextEditingController _nickCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _coverUrlCtrl;
  late final TextEditingController _quoteCtrl;
  late ProfileTheme _theme;
  String? _featuredBookId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nickCtrl = TextEditingController(text: widget.profile.nickname);
    _bioCtrl = TextEditingController(text: widget.profile.bio ?? '');
    _coverUrlCtrl =
        TextEditingController(text: widget.profile.coverImageUrl ?? '');
    _quoteCtrl =
        TextEditingController(text: widget.profile.featuredQuote ?? '');
    _theme = ProfileTheme.fromWire(widget.profile.theme);
    _featuredBookId = widget.profile.featuredBookId;
  }

  @override
  void dispose() {
    _nickCtrl.dispose();
    _bioCtrl.dispose();
    _coverUrlCtrl.dispose();
    _quoteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 편집'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('저장'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('닉네임', style: theme.textTheme.labelLarge),
            SizedBox(height: spacing.sm),
            TextField(
              controller: _nickCtrl,
              maxLength: 64,
              decoration: const InputDecoration(hintText: '닉네임'),
            ),
            SizedBox(height: spacing.lg),
            Text('소개글', style: theme.textTheme.labelLarge),
            SizedBox(height: spacing.sm),
            TextField(
              controller: _bioCtrl,
              maxLength: 200,
              maxLines: 4,
              decoration: const InputDecoration(hintText: '독서 취향이나 소개를 적어보세요'),
            ),
            SizedBox(height: spacing.lg),
            Text('커버 이미지 URL', style: theme.textTheme.labelLarge),
            SizedBox(height: spacing.sm),
            TextField(
              controller: _coverUrlCtrl,
              maxLength: 1024,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(hintText: 'https://...'),
            ),
            SizedBox(height: spacing.lg),
            Text('테마', style: theme.textTheme.labelLarge),
            SizedBox(height: spacing.sm),
            _ThemePicker(
              selected: _theme,
              onSelected: (next) => setState(() => _theme = next),
            ),
            SizedBox(height: spacing.lg),
            Text('대표 책', style: theme.textTheme.labelLarge),
            SizedBox(height: spacing.sm),
            _FeaturedBookPicker(
              bookId: _featuredBookId,
              onPick: () async {
                final Book? picked =
                    await _FeaturedBookPickerSheet.show(context);
                if (picked != null) {
                  setState(() => _featuredBookId = picked.id);
                }
              },
            ),
            SizedBox(height: spacing.lg),
            Text('대표 인용구', style: theme.textTheme.labelLarge),
            SizedBox(height: spacing.sm),
            TextField(
              controller: _quoteCtrl,
              maxLength: 300,
              maxLines: 3,
              decoration: const InputDecoration(hintText: '마음에 남은 문장을 남겨보세요'),
            ),
            SizedBox(height: spacing.sm),
            Text(
              '커버·대표 책·인용구는 비워서 저장해도 기존 값이 지워지지 않아요.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final repo = ref.read(authRepositoryProvider);
      final nick = _nickCtrl.text.trim();
      final bio = _bioCtrl.text.trim();
      final coverUrl = _coverUrlCtrl.text.trim();
      final quote = _quoteCtrl.text.trim();
      await repo.updateProfile(
        nickname: nick.isEmpty ? null : nick,
        bio: bio.isEmpty ? null : bio,
        coverImageUrl: coverUrl.isEmpty ? null : coverUrl,
        theme: _theme.wire,
        featuredBookId: _featuredBookId,
        featuredQuote: quote.isEmpty ? null : quote,
      );
      if (!mounted) return;
      ref.invalidate(userProfileProvider(widget.profile.id));
      context.pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장에 실패했습니다. 다시 시도해주세요.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

// ---------------------------------------------------------------------------
// Theme picker — 6 swatches (BC-81 ProfileTheme)
// ---------------------------------------------------------------------------

class _ThemePicker extends StatelessWidget {
  const _ThemePicker({required this.selected, required this.onSelected});

  final ProfileTheme selected;
  final ValueChanged<ProfileTheme> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final ProfileTheme t in ProfileTheme.values)
          _ThemeSwatch(
            profileTheme: t,
            selected: t == selected,
            onTap: () => onSelected(t),
          ),
      ],
    );
  }
}

class _ThemeSwatch extends StatelessWidget {
  const _ThemeSwatch({
    required this.profileTheme,
    required this.selected,
    required this.onTap,
  });

  final ProfileTheme profileTheme;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String label = ProfileThemePalette.labelOf(profileTheme);
    return Semantics(
      button: true,
      selected: selected,
      label: '$label 테마',
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: ProfileThemePalette.gradientOf(profileTheme),
                ),
                border: Border.all(
                  color:
                      selected ? theme.colorScheme.primary : Colors.transparent,
                  width: 3,
                ),
              ),
              child: selected
                  ? Icon(
                      Icons.check_rounded,
                      color: ProfileThemePalette.onColorOf(profileTheme),
                      size: 20,
                    )
                  : null,
            ),
            const SizedBox(height: 4),
            Text(label, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Featured book picker — preview + "책 선택" bottom sheet
// ---------------------------------------------------------------------------

class _FeaturedBookPicker extends ConsumerWidget {
  const _FeaturedBookPicker({required this.bookId, required this.onPick});

  final String? bookId;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final String? id = bookId;

    final Widget preview;
    if (id == null || id.isEmpty) {
      preview = Text(
        '선택된 책이 없어요',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      );
    } else {
      final async = ref.watch(featuredBookProvider(id));
      preview = async.when(
        loading: () => const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (_, __) => Text(
          '책 정보를 불러오지 못했어요',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
        data: (book) => Row(
          children: [
            BookCover(
              coverUrl: book.coverUrl,
              width: 32,
              height: 48,
              borderRadius: BorderRadius.circular(4),
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Text(
                book.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: preview),
          TextButton(onPressed: onPick, child: const Text('책 선택')),
        ],
      ),
    );
  }
}

/// Bottom sheet listing the user's library so they can pick a featured book.
///
/// Scoped to the library (not full catalog search) — the featured book is
/// meant to showcase something the user has actually read/added, and reusing
/// `listLibrary` avoids standing up a second book-search UI just for this.
class _FeaturedBookPickerSheet extends ConsumerStatefulWidget {
  const _FeaturedBookPickerSheet();

  static Future<Book?> show(BuildContext context) {
    return showModalBottomSheet<Book>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const _FeaturedBookPickerSheet(),
    );
  }

  @override
  ConsumerState<_FeaturedBookPickerSheet> createState() =>
      _FeaturedBookPickerSheetState();
}

class _FeaturedBookPickerSheetState
    extends ConsumerState<_FeaturedBookPickerSheet> {
  late final Future<LibraryPage> _future =
      ref.read(bookRepositoryProvider).listLibrary(limit: 100);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(spacing.lg, spacing.sm, spacing.lg, spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('대표 책 선택', style: theme.textTheme.headlineMedium),
            SizedBox(height: spacing.sm),
            Expanded(
              child: FutureBuilder<LibraryPage>(
                future: _future,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('서재를 불러오지 못했어요.'));
                    }
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  }
                  final items = snapshot.data!.items;
                  if (items.isEmpty) {
                    return const Center(
                      child: Text('서재에 책이 없어요. 먼저 책을 추가해보세요.'),
                    );
                  }
                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
                    itemBuilder: (context, i) {
                      final book = items[i].book;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: BookCover(
                          coverUrl: book.coverUrl,
                          width: 40,
                          height: 60,
                          borderRadius: BorderRadius.circular(6),
                        ),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
