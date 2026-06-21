import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/widgets/skeleton.dart';
import '../application/ai_providers.dart';
import '../data/ai_repository.dart';
import '../domain/ai_models.dart';

/// Full-screen completion reflection guide, opened right after a book is
/// finished. Pro feature with a one-per-month free trial enforced server-side;
/// when the trial is spent the screen swaps to an upgrade CTA.
class AiReflectionScreen extends ConsumerWidget {
  const AiReflectionScreen({super.key, required this.userBookId});

  final String userBookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reflection = ref.watch(aiReflectionProvider(userBookId: userBookId));
    return Scaffold(
      appBar: AppBar(title: const Text('AI 성찰 가이드')),
      body: reflection.when(
        loading: () => const _ReflectionSkeleton(),
        error: (err, _) => _ReflectionError(
          error: err,
          onRetry: () =>
              ref.invalidate(aiReflectionProvider(userBookId: userBookId)),
        ),
        data: (data) => _ReflectionContent(reflection: data),
      ),
    );
  }
}

class _ReflectionContent extends StatelessWidget {
  const _ReflectionContent({required this.reflection});

  final AiReflection reflection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        const _Heading(icon: Icons.lightbulb_outline, label: '핵심 인사이트'),
        const SizedBox(height: 10),
        for (var i = 0; i < reflection.insights.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    '${i + 1}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(reflection.insights[i],
                      style: theme.textTheme.bodyMedium,),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        const _Heading(icon: Icons.flag_outlined, label: '실천 포인트'),
        const SizedBox(height: 10),
        Card(
          color: theme.colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              reflection.actionPoint,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const _Heading(icon: Icons.menu_book_outlined, label: '다음에 읽으면 좋은 책'),
        const SizedBox(height: 10),
        for (final book in reflection.nextBooks)
          Card(
            child: ListTile(
              leading: const Icon(Icons.book_outlined),
              title: Text(book.title),
              subtitle: Text(book.reason),
            ),
          ),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(label, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

class _ReflectionSkeleton extends StatelessWidget {
  const _ReflectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(width: 140, height: 20),
            SizedBox(height: 16),
            SkeletonBox(width: double.infinity, height: 14),
            SizedBox(height: 8),
            SkeletonBox(width: double.infinity, height: 14),
            SizedBox(height: 24),
            SkeletonBox(width: double.infinity, height: 60),
            SizedBox(height: 24),
            SkeletonBox(width: double.infinity, height: 64),
            SizedBox(height: 12),
            SkeletonBox(width: double.infinity, height: 64),
          ],
        ),
      ),
    );
  }
}

/// Error view — branches to a Pro upgrade CTA when the free trial is spent,
/// otherwise a graceful "AI 연결 안 됨" / retry.
class _ReflectionError extends StatelessWidget {
  const _ReflectionError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final aiError = error is AiRepositoryException ? error as AiRepositoryException : null;

    if (aiError != null && aiError.isProRequired) {
      return _ProGate(theme: theme);
    }

    final String message;
    if (aiError != null && aiError.isUnavailable) {
      message = 'AI 연결 안 됨\n잠시 후 다시 시도해주세요.';
    } else if (aiError != null) {
      message = aiError.message;
    } else {
      message = '성찰 가이드를 불러오지 못했어요.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 44, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center, style: theme.textTheme.bodyMedium,),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}

class _ProGate extends StatelessWidget {
  const _ProGate({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.workspace_premium,
                size: 48, color: theme.colorScheme.primary,),
            const SizedBox(height: 16),
            Text('AI 성찰 가이드는 Pro 전용이에요',
                textAlign: TextAlign.center, style: theme.textTheme.titleMedium,),
            const SizedBox(height: 8),
            Text(
              '완독한 책을 내 삶과 연결해주는 깊이 있는 성찰 가이드를\nPro로 무제한 받아보세요.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => context.push(AppRoutes.paywall),
              child: const Text('Pro 알아보기'),
            ),
          ],
        ),
      ),
    );
  }
}
