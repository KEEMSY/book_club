/// Reading goal period — matches the backend `GoalPeriod` enum exactly.
///
/// Wire values stay snake_case (`weekly` / `monthly` / `yearly`); Korean
/// labels are exposed for UI surfaces (bottom-nav-less goal tabs).
enum GoalPeriod {
  weekly,
  monthly,
  yearly;

  static GoalPeriod fromWire(String value) {
    switch (value) {
      case 'weekly':
        return GoalPeriod.weekly;
      case 'monthly':
        return GoalPeriod.monthly;
      case 'yearly':
        return GoalPeriod.yearly;
      default:
        return GoalPeriod.weekly;
    }
  }

  String get wire {
    switch (this) {
      case GoalPeriod.weekly:
        return 'weekly';
      case GoalPeriod.monthly:
        return 'monthly';
      case GoalPeriod.yearly:
        return 'yearly';
    }
  }

  String get label {
    switch (this) {
      case GoalPeriod.weekly:
        return '주간';
      case GoalPeriod.monthly:
        return '월간';
      case GoalPeriod.yearly:
        return '연간';
    }
  }
}
