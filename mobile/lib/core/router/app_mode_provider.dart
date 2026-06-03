import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_mode_provider.g.dart';

enum AppMode { personal, community }

/// Top-level mode toggle: 개인 reading context vs. 커뮤니티 social context.
///
/// Persists only for the current session — no disk storage needed because
/// the app always opens in personal mode on cold start.
@riverpod
class AppModeNotifier extends _$AppModeNotifier {
  @override
  AppMode build() => AppMode.personal;

  void setMode(AppMode mode) => state = mode;
}
