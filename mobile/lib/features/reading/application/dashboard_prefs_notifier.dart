import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/dashboard_prefs.dart';

/// Persists and restores which dashboard sections the user wants visible.
///
/// State is loaded once at construction from SharedPreferences; subsequent
/// calls to [update] write through so the choice survives cold restarts.
class DashboardPrefsNotifier extends StateNotifier<DashboardPrefs> {
  static const _key = 'dashboard_prefs';

  DashboardPrefsNotifier() : super(const DashboardPrefs()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        state = DashboardPrefs.fromJson(map);
      } catch (_) {
        // Corrupt stored value — silently fall back to defaults.
      }
    }
  }

  Future<void> update(DashboardPrefs newPrefs) async {
    state = newPrefs;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(newPrefs.toJson()));
  }
}

final dashboardPrefsProvider =
    StateNotifierProvider<DashboardPrefsNotifier, DashboardPrefs>(
  (ref) => DashboardPrefsNotifier(),
);
