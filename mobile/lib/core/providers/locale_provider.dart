import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Languages the app ships translations for (M72). Kept in sync with the ARB
/// files under `lib/l10n/` and with `AppLocalizations.supportedLocales`.
const List<Locale> kSupportedLocales = <Locale>[
  Locale('ko'),
  Locale('en'),
  Locale('ja'),
];

const String _prefsKey = 'locale';

/// Holds the active UI [Locale] and persists the user's choice across cold
/// restarts via [SharedPreferences].
///
/// Implemented as a hand-written [Notifier] (not riverpod codegen) so it does
/// not depend on a `build_runner` pass — the l10n delegates are produced by
/// `gen-l10n` instead, keeping this milestone's codegen surface to ARB only.
class LocalePod extends Notifier<Locale> {
  @override
  Locale build() {
    // Default to Korean for the first frame, then asynchronously promote to the
    // stored preference. The brief ko→stored transition is invisible in
    // practice because the restore resolves before the first navigation tick.
    unawaitedRestore();
    return const Locale('ko');
  }

  /// Loads the persisted language code and applies it when valid. Exposed only
  /// for the [build] kick-off; callers should use [setLocale].
  @visibleForTesting
  Future<void> unawaitedRestore() async {
    final prefs = await SharedPreferences.getInstance();
    final String? code = prefs.getString(_prefsKey);
    if (code != null && kSupportedLocales.any((l) => l.languageCode == code)) {
      state = Locale(code);
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!kSupportedLocales.any((l) => l.languageCode == locale.languageCode)) {
      return;
    }
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }
}

final localePodProvider = NotifierProvider<LocalePod, Locale>(LocalePod.new);
