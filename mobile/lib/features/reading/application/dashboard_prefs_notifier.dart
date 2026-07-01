import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/dashboard_prefs.dart';

part 'dashboard_prefs_notifier.g.dart';

/// Persists and restores which dashboard sections the user wants visible.
///
/// State is loaded once at construction from SharedPreferences; subsequent
/// calls to [update] write through so the choice survives cold restarts.
@riverpod
class DashboardPrefsNotifier extends _$DashboardPrefsNotifier {
  static const _key = 'dashboard_prefs';

  @override
  DashboardPrefs build() {
    // Kick an async load; state starts at defaults until it resolves.
    Future.microtask(_load);
    return const DashboardPrefs();
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

  /// Reorders sections when the user drags a row in the settings sheet.
  /// [ReorderableListView] passes (oldIndex, newIndex) where newIndex is
  /// the position AFTER the item has been removed — standard Flutter convention.
  Future<void> reorder(int oldIndex, int newIndex) async {
    final List<String> order = List<String>.from(state.sectionOrder);
    if (newIndex > oldIndex) newIndex -= 1;
    final String item = order.removeAt(oldIndex);
    order.insert(newIndex, item);
    await update(state.copyWith(sectionOrder: order));
  }
}
