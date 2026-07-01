/// User preference for which dashboard sections are visible and in what order.
///
/// Persisted via SharedPreferences so the layout survives app restarts.
/// Each bool field defaults to [true] — the first launch shows all sections.
/// [sectionOrder] defaults to [defaultOrder] — stable insertion order.
class DashboardPrefs {
  const DashboardPrefs({
    this.showStreak = true,
    this.showGoal = true,
    this.showGrade = true,
    this.showHeatmap = true,
    List<String>? sectionOrder,
  }) : sectionOrder = sectionOrder ?? defaultOrder;

  final bool showStreak;
  final bool showGoal;
  final bool showGrade;
  final bool showHeatmap;

  /// Ordered list of section IDs. Valid IDs: 'streak', 'goal', 'grade', 'heatmap'.
  /// Order determines render sequence in the dashboard.
  final List<String> sectionOrder;

  static const List<String> defaultOrder = <String>[
    'streak',
    'goal',
    'grade',
    'heatmap',
  ];

  DashboardPrefs copyWith({
    bool? showStreak,
    bool? showGoal,
    bool? showGrade,
    bool? showHeatmap,
    List<String>? sectionOrder,
  }) {
    return DashboardPrefs(
      showStreak: showStreak ?? this.showStreak,
      showGoal: showGoal ?? this.showGoal,
      showGrade: showGrade ?? this.showGrade,
      showHeatmap: showHeatmap ?? this.showHeatmap,
      sectionOrder: sectionOrder ?? this.sectionOrder,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'showStreak': showStreak,
        'showGoal': showGoal,
        'showGrade': showGrade,
        'showHeatmap': showHeatmap,
        'sectionOrder': sectionOrder,
      };

  factory DashboardPrefs.fromJson(Map<String, dynamic> json) {
    final dynamic rawOrder = json['sectionOrder'];
    final List<String> order;
    if (rawOrder is List) {
      order = rawOrder.cast<String>();
    } else {
      order = defaultOrder;
    }
    return DashboardPrefs(
      showStreak: json['showStreak'] as bool? ?? true,
      showGoal: json['showGoal'] as bool? ?? true,
      showGrade: json['showGrade'] as bool? ?? true,
      showHeatmap: json['showHeatmap'] as bool? ?? true,
      sectionOrder: order,
    );
  }
}
