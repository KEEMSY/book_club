/// User preference for which dashboard sections are visible.
///
/// Persisted via SharedPreferences so the layout survives app restarts.
/// Each field defaults to [true] — the first launch shows all sections.
class DashboardPrefs {
  const DashboardPrefs({
    this.showStreak = true,
    this.showGoal = true,
    this.showGrade = true,
    this.showHeatmap = true,
  });

  final bool showStreak;
  final bool showGoal;
  final bool showGrade;
  final bool showHeatmap;

  DashboardPrefs copyWith({
    bool? showStreak,
    bool? showGoal,
    bool? showGrade,
    bool? showHeatmap,
  }) {
    return DashboardPrefs(
      showStreak: showStreak ?? this.showStreak,
      showGoal: showGoal ?? this.showGoal,
      showGrade: showGrade ?? this.showGrade,
      showHeatmap: showHeatmap ?? this.showHeatmap,
    );
  }

  Map<String, bool> toJson() => <String, bool>{
        'showStreak': showStreak,
        'showGoal': showGoal,
        'showGrade': showGrade,
        'showHeatmap': showHeatmap,
      };

  factory DashboardPrefs.fromJson(Map<String, dynamic> json) => DashboardPrefs(
        showStreak: json['showStreak'] as bool? ?? true,
        showGoal: json['showGoal'] as bool? ?? true,
        showGrade: json['showGrade'] as bool? ?? true,
        showHeatmap: json['showHeatmap'] as bool? ?? true,
      );
}
