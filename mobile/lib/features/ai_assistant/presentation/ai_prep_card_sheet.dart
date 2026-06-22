import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/widgets/skeleton.dart';
import '../application/ai_providers.dart';
import '../data/ai_repository.dart';
import '../domain/ai_models.dart';

/// SharedPreferences flag marking that the reader has picked a prep-card style
/// at least once. The backend always returns a default style, so "never chosen"
/// can't be inferred from the API alone — this local flag gates the one-time
/// onboarding picker.
const String _styleChosenKey = 'ai_card_style_chosen';

/// The three prep-card personas the reader can pick from (M67).
const List<({String value, String label, String description})> _cardStyles = [
  (value: 'motivational', label: '동기부여형', description: '읽고 싶어지게 만드는 힘 있는 어조'),
  (value: 'analytical', label: '분석형', description: '구조와 핵심 논점을 또렷하게'),
  (value: 'reflective', label: '성찰형', description: '내 삶과 연결해 잔잔하게 사색'),
];

/// Bottom sheet shown before a reading session: an AI "prep card" with an
/// author intro, three theme keywords, and two pre-reading questions.
///
/// Free feature (server enforces a daily cap). Failures degrade gracefully —
/// "AI 연결 안 됨" when the server has no Claude key wired, a rate-limit notice
/// when the daily cap is hit, otherwise a generic retry.
class AiPrepCardSheet extends ConsumerWidget {
  const AiPrepCardSheet({super.key, required this.bookId});

  final String bookId;

  /// Opens the prep-card sheet. On the reader's first ever use this first runs
  /// a one-time style picker and persists the choice (PATCH /me/ai-preferences)
  /// so the generated card matches their chosen persona.
  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    required String bookId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final bool chosen = prefs.getBool(_styleChosenKey) ?? false;
    if (!chosen && context.mounted) {
      final String? picked = await _showStylePicker(context);
      if (picked != null) {
        try {
          await ref.read(aiRepositoryProvider).updatePreferences(picked);
          ref.invalidate(userAiPreferencesProvider);
          await prefs.setBool(_styleChosenKey, true);
        } on AiRepositoryException {
          // Non-fatal: fall through to the card with the server default style.
        }
      }
    }
    if (!context.mounted) return;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => AiPrepCardSheet(bookId: bookId),
    );
  }

  static Future<String?> _showStylePicker(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return AlertDialog(
          title: const Text('AI 준비카드 스타일'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '어떤 어조로 책을 소개해드릴까요?',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              for (final style in _cardStyles)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(style.value),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(style.label, style: theme.textTheme.titleSmall),
                        const SizedBox(height: 2),
                        Text(
                          style.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = ref.watch(aiPrepCardProvider(bookId: bookId));
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: card.when(
          loading: () => const _PrepSkeleton(),
          error: (err, _) => _PrepError(
            error: err,
            onRetry: () => ref.invalidate(aiPrepCardProvider(bookId: bookId)),
          ),
          data: (data) => _PrepContent(card: data),
        ),
      ),
    );
  }
}

class _PrepContent extends StatelessWidget {
  const _PrepContent({required this.card});

  final AiPrepCard card;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text('AI 독서 준비', style: theme.textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 16),
        const _SectionLabel('저자 & 배경'),
        const SizedBox(height: 6),
        Text(card.authorIntro, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 18),
        const _SectionLabel('핵심 테마'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final keyword in card.themeKeywords)
              Chip(
                label: Text(keyword),
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
        const SizedBox(height: 18),
        const _SectionLabel('읽기 전 질문'),
        const SizedBox(height: 8),
        for (final q in card.prereadingQuestions)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: theme.textTheme.bodyMedium),
                Expanded(child: Text(q, style: theme.textTheme.bodyMedium)),
              ],
            ),
          ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.labelLarge?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _PrepSkeleton extends StatelessWidget {
  const _PrepSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Shimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SkeletonBox(width: 120, height: 20),
          SizedBox(height: 16),
          SkeletonBox(width: double.infinity, height: 14),
          SizedBox(height: 8),
          SkeletonBox(width: double.infinity, height: 14),
          SizedBox(height: 8),
          SkeletonBox(width: 200, height: 14),
          SizedBox(height: 20),
          SkeletonBox(width: double.infinity, height: 32),
          SizedBox(height: 16),
          SkeletonBox(width: double.infinity, height: 14),
          SizedBox(height: 8),
          SkeletonBox(width: 240, height: 14),
        ],
      ),
    );
  }
}

class _PrepError extends StatelessWidget {
  const _PrepError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool unavailable =
        error is AiRepositoryException && (error as AiRepositoryException).isUnavailable;
    final bool rateLimited =
        error is AiRepositoryException && (error as AiRepositoryException).isRateLimited;

    final String message;
    if (unavailable) {
      message = 'AI 연결 안 됨\n잠시 후 다시 시도해주세요.';
    } else if (rateLimited) {
      message = '오늘의 AI 준비카드를 모두 사용했어요.\n내일 다시 만나요!';
    } else if (error is AiRepositoryException) {
      message = (error as AiRepositoryException).message;
    } else {
      message = '준비카드를 불러오지 못했어요.';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Icon(Icons.cloud_off, color: theme.colorScheme.outline, size: 40),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        if (!rateLimited)
          OutlinedButton(onPressed: onRetry, child: const Text('다시 시도')),
      ],
    );
  }
}
