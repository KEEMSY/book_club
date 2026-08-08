import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/feature_flags.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/domain/auth_state.dart';

/// Settings hub (BC-82) — single entry point that replaced the scattered
/// own-profile overflow menu.
///
/// Groups every account-level surface behind one screen: profile overflow
/// menu items that used to live directly on [UserProfileScreen] (언어,
/// 개인정보처리방침, 이용약관, 관리자, 로그아웃) plus new entries that reuse
/// existing feature screens (구독·결제 관리, 알림, 차단 목록, 계정 관리).
/// Every entry re-uses an existing route/screen — nothing here owns
/// business logic of its own.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final auth = ref.watch(authNotifierProvider);
    final bool isAdmin = auth is Authenticated && auth.user.isAdmin;

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: <Widget>[
          _SectionHeader(label: '이용', spacing: spacing),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('알림'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(AppRoutes.notifications),
          ),
          // Subscription deferred (BC-41): hide the entry when the feature
          // flag is off, matching the paywall CTA gating already used on
          // UserProfileScreen's own-profile action button.
          if (FeatureFlags.subscription)
            ListTile(
              leading: const Icon(Icons.workspace_premium_outlined),
              title: const Text('구독·결제 관리'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(AppRoutes.paywall),
            ),
          const Divider(height: 1),
          _SectionHeader(label: '개인정보 및 보안', spacing: spacing),
          ListTile(
            leading: const Icon(Icons.block_outlined),
            title: const Text('차단 목록'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(AppRoutes.blockedUsers),
          ),
          ListTile(
            leading: const Icon(Icons.manage_accounts_outlined),
            title: const Text('계정 관리'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(AppRoutes.account),
          ),
          const Divider(height: 1),
          _SectionHeader(label: '일반', spacing: spacing),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(AppLocalizations.of(context).settingsLanguage),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _showLanguagePicker(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('개인정보처리방침'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(AppRoutes.settingsPrivacy),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('이용약관'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(AppRoutes.settingsTerms),
          ),
          // BC-87: admin console entry, gated the same way the old
          // own-profile overflow menu gated it — is_admin only. Every
          // backing endpoint independently re-checks is_admin server-side.
          if (isAdmin)
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined),
              title: const Text('관리자'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(AppRoutes.admin),
            ),
          const Divider(height: 1),
          SizedBox(height: spacing.sm),
          ListTile(
            leading: Icon(
              Icons.logout_outlined,
              color: theme.colorScheme.error,
            ),
            title: Text(
              '로그아웃',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () => _confirmAndLogout(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAndLogout(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃할까요?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              '로그아웃',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(authNotifierProvider.notifier).logout();
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.spacing});

  final String label;
  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding:
          EdgeInsets.fromLTRB(spacing.md, spacing.md, spacing.md, spacing.xs),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Lets the signed-in user switch the app language (M72 · i18n). Moved here
/// from `UserProfileScreen`'s overflow menu when the settings hub absorbed
/// it (BC-82); the choice is persisted by [LocalePod] so it survives cold
/// restarts.
Future<void> _showLanguagePicker(BuildContext context, WidgetRef ref) async {
  final Locale current = ref.read(localePodProvider);
  final Locale? picked = await showDialog<Locale>(
    context: context,
    builder: (ctx) => SimpleDialog(
      title: Text(AppLocalizations.of(ctx).settingsLanguage),
      children: <Widget>[
        for (final ({Locale locale, String label}) option in _languageOptions)
          ListTile(
            title: Text(option.label),
            trailing: option.locale.languageCode == current.languageCode
                ? const Icon(Icons.check_rounded)
                : null,
            onTap: () => Navigator.of(ctx).pop(option.locale),
          ),
      ],
    ),
  );
  if (picked != null) {
    await ref.read(localePodProvider.notifier).setLocale(picked);
  }
}

/// Endonyms (each language named in itself) so the list is legible regardless
/// of the currently active locale.
const List<({Locale locale, String label})> _languageOptions =
    <({Locale locale, String label})>[
  (locale: Locale('ko'), label: '한국어'),
  (locale: Locale('en'), label: 'English'),
  (locale: Locale('ja'), label: '日本語'),
];
