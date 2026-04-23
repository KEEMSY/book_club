/// Formats a running-timer [Duration] for large HH:MM:SS (or MM:SS) display.
///
/// Sessions shorter than one hour render as `MM:SS`; anything longer prints
/// the full `HH:MM:SS`. Kept top-level so both the TimerScreen and the
/// SummaryScreen can share the same text shape.
String formatElapsed(Duration d) {
  final int totalSec = d.inSeconds.abs();
  final int hours = totalSec ~/ 3600;
  final int minutes = (totalSec % 3600) ~/ 60;
  final int seconds = totalSec % 60;
  final String mm = minutes.toString().padLeft(2, '0');
  final String ss = seconds.toString().padLeft(2, '0');
  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:$mm:$ss';
  }
  return '$mm:$ss';
}

/// Formats a total-seconds count as "NN시간 MM분" / "MM분 SS초" for summary
/// cards — used by the goal progress bar and grade totals.
String formatDurationKorean(int totalSeconds) {
  if (totalSeconds <= 0) return '0분';
  final int hours = totalSeconds ~/ 3600;
  final int minutes = (totalSeconds % 3600) ~/ 60;
  if (hours > 0) {
    if (minutes == 0) return '$hours시간';
    return '$hours시간 $minutes분';
  }
  if (minutes > 0) return '$minutes분';
  return '$totalSeconds초';
}
