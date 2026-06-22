import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../ai_assistant/application/ai_providers.dart';
import '../../ai_assistant/data/ai_repository.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/domain/auth_state.dart';
import '../../book/application/book_providers.dart';
import '../../book/domain/book.dart';
import '../../subscription/application/subscription_notifier.dart';
import '../application/club_providers.dart';
import '../domain/club.dart';
import 'club_chat_screen.dart';
import 'club_rooms_screen.dart';
import 'create_event_sheet.dart';
import 'reading_plan_tab.dart';

// Club events provider — keyed by club id (uses legacy ClubEvent from club.dart).
final _clubEventsProvider =
    FutureProvider.autoDispose.family<List<ClubEvent>, String>(
  (ref, clubId) => ref.watch(clubRepositoryProvider).listEventsFull(clubId),
);

class ClubDetailScreen extends ConsumerStatefulWidget {
  const ClubDetailScreen({super.key, required this.club});

  final Club club;

  @override
  ConsumerState<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends ConsumerState<ClubDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.club.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('초대 코드: ${widget.club.inviteCode}')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '모임'),
            Tab(text: '독서 계획'),
            Tab(text: '채팅'),
            Tab(text: '채팅방'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ClubEventsTab(club: widget.club),
          ReadingPlanTab(club: widget.club),
          ClubChatScreen(club: widget.club),
          ClubRoomsBody(club: widget.club),
        ],
      ),
    );
  }
}

/// The original events content, extracted into its own widget so the tab
/// structure stays clean and [ClubChatScreen] gets an equally sized sibling.
class _ClubEventsTab extends ConsumerWidget {
  const _ClubEventsTab({required this.club});

  final Club club;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final eventsAsync = ref.watch(_clubEventsProvider(club.id));

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (club.description != null) ...[
                  Text(club.description!, style: theme.textTheme.bodyMedium),
                  SizedBox(height: spacing.md),
                ],
                Text(
                  '${club.memberCount}/${club.maxMembers}명 참여 중',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(height: spacing.md),
                _ClubBookCard(
                  club: club,
                  onChanged: (updated) {
                    // Refresh events tab to pick up updated club data.
                    ref.invalidate(_clubEventsProvider(club.id));
                  },
                ),
                SizedBox(height: spacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '모임 일정',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () =>
                              context.push(AppRoutes.clubEvents(club.id)),
                          child: const Text('전체 보기'),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            await CreateEventSheet.show(
                              context,
                              clubId: club.id,
                            );
                            ref.invalidate(_clubEventsProvider(club.id));
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('추가'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        eventsAsync.when(
          loading: () => const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (_, __) => SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: Text(
                '모임을 불러오지 못했어요',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
          data: (events) => events.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(spacing.lg),
                    child: Text(
                      '아직 예정된 모임이 없어요',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: spacing.md),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _EventCard(
                        event: events[i],
                        clubId: club.id,
                      ),
                      childCount: events.length,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _EventCard extends ConsumerWidget {
  const _EventCard({required this.event, required this.clubId});

  final ClubEvent event;
  final String clubId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final isOnline = event.eventType == 'online';

    return Card(
      margin: EdgeInsets.only(bottom: spacing.sm),
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isOnline ? Icons.videocam_rounded : Icons.place_rounded,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  isOnline ? '온라인' : '오프라인',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.primary),
                ),
              ],
            ),
            SizedBox(height: spacing.xs),
            Text(event.title, style: theme.textTheme.titleSmall),
            if (event.location != null) ...[
              SizedBox(height: spacing.xs),
              Text(
                event.location!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
            SizedBox(height: spacing.xs),
            Text(
              _formatDate(event.scheduledAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: spacing.sm),
            _RsvpButtons(event: event, clubId: clubId),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

class _RsvpButtons extends ConsumerWidget {
  const _RsvpButtons({required this.event, required this.clubId});

  final ClubEvent event;
  final String clubId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          '${event.goingCount}명 참석',
          style: theme.textTheme.labelSmall,
        ),
        if (event.maybeCount > 0) ...[
          const SizedBox(width: 8),
          Text(
            '${event.maybeCount}명 미정',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
        const Spacer(),
        _RsvpChip(
          label: '갈게요',
          value: 'going',
          selected: event.myRsvp == 'going',
          onTap: () => _rsvp(ref, context, 'going'),
        ),
        const SizedBox(width: 4),
        _RsvpChip(
          label: '미정',
          value: 'maybe',
          selected: event.myRsvp == 'maybe',
          onTap: () => _rsvp(ref, context, 'maybe'),
        ),
      ],
    );
  }

  Future<void> _rsvp(WidgetRef ref, BuildContext context, String status) async {
    try {
      await ref.read(clubRepositoryProvider).rsvp(clubId, event.id, status);
      ref.invalidate(_clubEventsProvider(clubId));
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('RSVP 처리에 실패했습니다.')),
        );
      }
    }
  }
}

class _RsvpChip extends StatelessWidget {
  const _RsvpChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: selected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Club book card
// ---------------------------------------------------------------------------

class _ClubBookCard extends ConsumerStatefulWidget {
  const _ClubBookCard({required this.club, required this.onChanged});

  final Club club;
  final void Function(Club updated) onChanged;

  @override
  ConsumerState<_ClubBookCard> createState() => _ClubBookCardState();
}

class _ClubBookCardState extends ConsumerState<_ClubBookCard> {
  bool get _isOwner {
    final auth = ref.read(authNotifierProvider);
    return switch (auth) {
      Authenticated(:final user) => user.id == widget.club.ownerId,
      _ => false,
    };
  }

  Future<void> _openPicker() async {
    final book = await _SetBookSheet.show(context);
    if (book == null || !mounted) return;
    try {
      final updated = await ref
          .read(clubRepositoryProvider)
          .setClubBook(widget.club.id, bookId: book.id);
      widget.onChanged(updated);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('책 설정에 실패했어요. 다시 시도해 주세요.')),
      );
    }
  }

  Future<void> _clearBook() async {
    try {
      final updated =
          await ref.read(clubRepositoryProvider).setClubBook(widget.club.id);
      widget.onChanged(updated);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('책 해제에 실패했어요. 다시 시도해 주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radii = theme.extension<AppRadius>()!;
    final hasBook = widget.club.bookId != null;
    // AI discussion topics are a Pro-club-owner feature; only show the entry
    // point when both hold (the backend re-checks both).
    final bool isPro = ref.watch(subscriptionNotifierProvider).maybeWhen(
          data: (s) => s.isPro,
          orElse: () => false,
        );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.all(Radius.circular(radii.md)),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                size: 20,
                color: hasBook
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Text(
                  hasBook ? '현재 책 설정됨' : '읽는 책 없음',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: hasBook
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
              if (_isOwner) ...[
                TextButton(
                  onPressed: _openPicker,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.sm,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(hasBook ? '변경' : '책 설정'),
                ),
                if (hasBook)
                  TextButton(
                    onPressed: _clearBook,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.sm,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: theme.colorScheme.error,
                    ),
                    child: const Text('해제'),
                  ),
              ],
            ],
          ),
          if (_isOwner && hasBook && isPro) ...[
            SizedBox(height: spacing.sm),
            OutlinedButton.icon(
              onPressed: _generateAiTopics,
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: const Text('AI 토론 주제 생성'),
            ),
          ],
        ],
      ),
    );
  }

  /// Prompts for this week's page range, generates AI discussion topics via
  /// `POST /clubs/{id}/ai-discussion-topics`, and shows the result. On success
  /// the backend also pins the topics into the club chat.
  Future<void> _generateAiTopics() async {
    final range = await _PageRangeDialog.show(context);
    if (range == null || !mounted) return;
    final (int start, int end) = range;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final topics = await ref.read(aiRepositoryProvider).getClubTopics(
            widget.club.id,
            pageStart: start,
            pageEnd: end,
          );
      if (!mounted) return;
      Navigator.of(context).pop(); // dismiss loader
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('이번 주 토론 주제'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < topics.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('${i + 1}. ${topics[i]}'),
                ),
              const SizedBox(height: 4),
              Text(
                '채팅방에 고정 메시지로 게시했어요.',
                style: Theme.of(ctx).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    } on AiRepositoryException {
      if (!mounted) return;
      Navigator.of(context).pop(); // dismiss loader
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('AI 토론 주제 생성에 실패했어요. 잠시 후 다시 시도해 주세요.'),
        ),
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Book picker bottom sheet
// ---------------------------------------------------------------------------

class _SetBookSheet extends ConsumerStatefulWidget {
  const _SetBookSheet();

  static Future<Book?> show(BuildContext context) => showModalBottomSheet<Book>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => const _SetBookSheet(),
      );

  @override
  ConsumerState<_SetBookSheet> createState() => _SetBookSheetState();
}

class _SetBookSheetState extends ConsumerState<_SetBookSheet> {
  final _controller = TextEditingController();
  List<Book> _results = [];
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String q) async {
    if (q.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _loading = true);
    try {
      final result = await ref
          .read(bookRepositoryProvider)
          .search(query: q.trim(), size: 10);
      if (mounted) setState(() => _results = result.items);
    } catch (_) {
      if (mounted) setState(() => _results = []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.md,
        spacing.sm,
        spacing.md,
        spacing.md + bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('읽는 책 설정', style: theme.textTheme.titleMedium),
          SizedBox(height: spacing.md),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: '책 제목이나 저자를 검색하세요',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: _search,
            onChanged: (v) {
              if (v.isEmpty) setState(() => _results = []);
            },
          ),
          if (_results.isNotEmpty) ...[
            SizedBox(height: spacing.sm),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _results.length,
                itemBuilder: (_, i) {
                  final book = _results[i];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: spacing.sm,
                    ),
                    leading: book.coverUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              book.coverUrl!,
                              width: 36,
                              height: 52,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox(
                                width: 36,
                                height: 52,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 36,
                            height: 52,
                            child: Icon(
                              Icons.book_outlined,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                    title: Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall,
                    ),
                    onTap: () => Navigator.pop(context, book),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Small dialog collecting this week's reading page range for AI topic
/// generation. Returns `(pageStart, pageEnd)` or null when cancelled.
class _PageRangeDialog extends StatefulWidget {
  const _PageRangeDialog();

  static Future<(int, int)?> show(BuildContext context) {
    return showDialog<(int, int)>(
      context: context,
      builder: (_) => const _PageRangeDialog(),
    );
  }

  @override
  State<_PageRangeDialog> createState() => _PageRangeDialogState();
}

class _PageRangeDialogState extends State<_PageRangeDialog> {
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  void _submit() {
    final start = int.tryParse(_startController.text.trim());
    final end = int.tryParse(_endController.text.trim());
    if (start == null || end == null || start < 0 || end < start) {
      setState(() => _error = '올바른 페이지 범위를 입력해 주세요.');
      return;
    }
    Navigator.of(context).pop((start, end));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('이번 주 읽기 범위'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _startController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '시작 쪽'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _endController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '끝 쪽'),
                ),
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(onPressed: _submit, child: const Text('생성')),
      ],
    );
  }
}
