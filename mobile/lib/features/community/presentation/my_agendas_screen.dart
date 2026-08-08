import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../club/application/my_agendas_notifier.dart';
import '../../club/domain/club.dart';

/// "내 활동 > 내 발제문" 더보기 (BC-83) — `GET /clubs/me/agendas`, 최신순 오프셋
/// 페이지네이션.
///
/// Each row deep-links to the originating session ([AppRoutes.sessionDetail]).
class MyAgendasScreen extends ConsumerStatefulWidget {
  const MyAgendasScreen({super.key});

  @override
  ConsumerState<MyAgendasScreen> createState() => _MyAgendasScreenState();
}

class _MyAgendasScreenState extends ConsumerState<MyAgendasScreen> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(myAgendasNotifierProvider.notifier).fetchFirst(),
    );
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.maxScrollExtent - _scroll.position.pixels < 200) {
      ref.read(myAgendasNotifierProvider.notifier).fetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final MyAgendasState state = ref.watch(myAgendasNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text('내 발제문 (${state.total})')),
      body: _buildBody(context, theme, spacing, state),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ThemeData theme,
    AppSpacing spacing,
    MyAgendasState state,
  ) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('발제문을 불러오지 못했어요', style: theme.textTheme.bodyMedium),
              SizedBox(height: spacing.sm),
              FilledButton(
                onPressed: () =>
                    ref.read(myAgendasNotifierProvider.notifier).fetchFirst(),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }
    if (state.items.isEmpty) {
      return Center(
        child: Text(
          '작성한 발제문이 없어요',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      );
    }
    return ListView.separated(
      controller: _scroll,
      padding: EdgeInsets.all(spacing.lg),
      itemCount: state.items.length + (state.hasMore ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
      itemBuilder: (context, index) {
        if (index == state.items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        return _MyAgendaCard(item: state.items[index]);
      },
    );
  }
}

class _MyAgendaCard extends StatelessWidget {
  const _MyAgendaCard({required this.item});

  final MyAgendaItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(
          AppRoutes.sessionDetail(item.clubId, item.sessionId),
        ),
        child: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.clubName} · ${item.sessionTitle}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: spacing.xs),
              Text(
                item.body,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: spacing.xs),
              Text(
                item.status == 'published' ? '발행됨' : '초안',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
