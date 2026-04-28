import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppMode { personal, community }

/// Top-level mode toggle: 개인 reading context vs. 커뮤니티 social context.
///
/// Persists only for the current session — no disk storage needed because
/// the app always opens in personal mode on cold start.
final appModeProvider = StateProvider<AppMode>((ref) => AppMode.personal);
