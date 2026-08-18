import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/notification_preferences_notifier.dart';
import '../data/notification_models.dart';
import '../data/notification_repository.dart';

/// Ordered (type, label) pairs for every notification type the reader may
/// see. Order here drives render order. Keep in sync with backend
/// `NotificationType` (BC-91 `models.py`) — an unknown type from the server
/// still renders (via [_labelFor]'s fallback) so a future type addition on
/// the backend never crashes this screen, it just shows the raw key until
/// mobile ships a label for it.
const List<String> _typeOrder = <String>[
  'reaction',
  'comment',
  'grade_up',
  'weekly_report',
  'follow_received',
  'badge_earned',
  'streak_warning',
  'agenda_published',
  'discussion_commented',
  'subscription_reminder',
];

const Map<String, String> _typeLabels = <String, String>{
  'reaction': '반응',
  'comment': '댓글',
  'grade_up': '등급 상승',
  'weekly_report': '주간 리포트',
  'follow_received': '팔로우',
  'badge_earned': '배지',
  'streak_warning': '연속기록 경고',
  'agenda_published': '발제문 게시',
  'discussion_commented': '토론 답글',
  'subscription_reminder': '구독 안내',
};

String _labelFor(String type) => _typeLabels[type] ?? type;

/// Notification-preferences toggle screen (BC-92).
///
/// Entry point: settings hub → "알림 설정" (distinct from "알림", the inbox).
/// Backend contract: `GET`/`PATCH /me/notification-preferences`
/// (BC-91) — `required_types` are always-on and rendered disabled.
class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(notificationPreferencesNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('알림 설정')),
      body: prefsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _ErrorBody(
          onRetry: () =>
              ref.invalidate(notificationPreferencesNotifierProvider),
        ),
        data: (prefs) => _PreferencesList(prefs: prefs),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '알림 설정을 불러오지 못했습니다.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.md),
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

class _PreferencesList extends ConsumerWidget {
  const _PreferencesList({required this.prefs});

  final NotificationPreferencesResponse prefs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final requiredSet = prefs.requiredTypes.toSet();

    // Forward-compat: append any type the server sent that mobile doesn't
    // know the display order for yet, instead of silently dropping it.
    final knownTypes = <String>{..._typeOrder};
    final extraTypes = <String>{
      ...prefs.preferences.keys,
      ...prefs.requiredTypes,
    }.difference(knownTypes);
    final orderedTypes = <String>[..._typeOrder, ...extraTypes];

    return ListView(
      padding: EdgeInsets.symmetric(vertical: spacing.sm),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              spacing.md, spacing.xs, spacing.md, spacing.sm),
          child: Text(
            '유형별로 알림 수신 여부를 설정할 수 있어요.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        for (final type in orderedTypes)
          _PreferenceTile(
            type: type,
            isRequired: requiredSet.contains(type),
            value: requiredSet.contains(type)
                ? true
                : (prefs.preferences[type] ?? true),
          ),
      ],
    );
  }
}

class _PreferenceTile extends ConsumerWidget {
  const _PreferenceTile({
    required this.type,
    required this.isRequired,
    required this.value,
  });

  final String type;
  final bool isRequired;
  final bool value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      title: Text(_labelFor(type)),
      subtitle: isRequired ? const Text('끌 수 없는 필수 알림입니다') : null,
      value: value,
      onChanged: isRequired
          ? null
          : (newValue) => _handleToggle(context, ref, newValue),
    );
  }

  Future<void> _handleToggle(
    BuildContext context,
    WidgetRef ref,
    bool newValue,
  ) async {
    try {
      await ref
          .read(notificationPreferencesNotifierProvider.notifier)
          .toggle(type, value: newValue);
    } on NotificationRepositoryException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }
}
