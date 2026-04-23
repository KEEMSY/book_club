import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/heatmap_day.dart';

/// GitHub-style 52-week × 7-day heatmap ("잔디" — literally "grass").
///
/// The cells run left-to-right, oldest to newest; the rightmost column is
/// the current week. Each cell is a [cellSize] square with [cellGap] spacing
/// so a full 52×7 grid fits comfortably on a 375px-wide phone screen
/// (14px cell × 52 columns + 2px gap × 51 ≈ 830px — we let it scroll
/// horizontally rather than squeeze).
class JanDeeGrid extends StatelessWidget {
  const JanDeeGrid({
    super.key,
    required this.days,
    required this.primaryColor,
    this.cellSize = 12,
    this.cellGap = 2,
    this.onDayTap,
  });

  final List<HeatmapDay> days;
  final Color primaryColor;
  final double cellSize;
  final double cellGap;
  final void Function(HeatmapDay day)? onDayTap;

  static const int _rows = 7;
  static const int _columns = 52;

  @override
  Widget build(BuildContext context) {
    final Map<String, HeatmapDay> byDate = <String, HeatmapDay>{
      for (final HeatmapDay d in days) _dateKey(d.date): d,
    };
    final keyFmt = DateFormat('yyyy-MM-dd');

    // Anchor: the most recent Sunday (rightmost column, row 6).
    final DateTime today = _truncateDay(DateTime.now());
    final int weekdayIndex = today.weekday % 7; // Sunday = 0
    final DateTime currentWeekSunday =
        today.subtract(Duration(days: weekdayIndex));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _MonthLabelsRow(
            startColumnDate: currentWeekSunday
                .subtract(const Duration(days: 7 * (_columns - 1))),
            cellSize: cellSize,
            cellGap: cellGap,
            columns: _columns,
          ),
          Row(
            children: <Widget>[
              _DayLabelsColumn(cellSize: cellSize, cellGap: cellGap),
              for (int col = 0; col < _columns; col++) ...<Widget>[
                Column(
                  children: <Widget>[
                    for (int row = 0; row < _rows; row++) ...<Widget>[
                      _buildCell(
                        col: col,
                        row: row,
                        today: today,
                        currentWeekSunday: currentWeekSunday,
                        byDate: byDate,
                        keyFmt: keyFmt,
                      ),
                      if (row < _rows - 1) SizedBox(height: cellGap),
                    ],
                  ],
                ),
                if (col < _columns - 1) SizedBox(width: cellGap),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCell({
    required int col,
    required int row,
    required DateTime today,
    required DateTime currentWeekSunday,
    required Map<String, HeatmapDay> byDate,
    required DateFormat keyFmt,
  }) {
    // Column index increases oldest → newest (left → right). Current week
    // sits at col == _columns - 1.
    final int weeksAgo = (_columns - 1) - col;
    final DateTime weekStart =
        currentWeekSunday.subtract(Duration(days: weeksAgo * 7));
    final DateTime cellDate = weekStart.add(Duration(days: row));

    if (cellDate.isAfter(today)) {
      return SizedBox(width: cellSize, height: cellSize);
    }

    final HeatmapDay? day = byDate[keyFmt.format(cellDate)];
    final int seconds = day?.totalSeconds ?? 0;
    final Color color = _bucketColor(seconds);

    return GestureDetector(
      onTap: onDayTap != null && day != null ? () => onDayTap!(day) : null,
      child: Container(
        width: cellSize,
        height: cellSize,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  /// Maps a seconds total onto one of 5 opacity buckets. Matches the task
  /// contract: 0 / 1–15m / 16–45m / 46–90m / 91–180m / >180m.
  Color _bucketColor(int seconds) {
    if (seconds == 0) {
      return AppPalette.borderGray.withValues(alpha: 0.35);
    }
    final int minutes = seconds ~/ 60;
    if (minutes <= 15) {
      return primaryColor.withValues(alpha: 0.15);
    }
    if (minutes <= 45) {
      return primaryColor.withValues(alpha: 0.35);
    }
    if (minutes <= 90) {
      return primaryColor.withValues(alpha: 0.60);
    }
    if (minutes <= 180) {
      return primaryColor.withValues(alpha: 0.85);
    }
    return primaryColor;
  }

  static DateTime _truncateDay(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  static String _dateKey(DateTime dt) {
    final DateTime t = _truncateDay(dt);
    return '${t.year.toString().padLeft(4, '0')}-'
        '${t.month.toString().padLeft(2, '0')}-'
        '${t.day.toString().padLeft(2, '0')}';
  }
}

/// Renders month abbreviations across the top of the grid, aligned to the
/// week-column where the 1st of that month falls.
class _MonthLabelsRow extends StatelessWidget {
  const _MonthLabelsRow({
    required this.startColumnDate,
    required this.cellSize,
    required this.cellGap,
    required this.columns,
  });

  final DateTime startColumnDate;
  final double cellSize;
  final double cellGap;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final DateFormat fmt = DateFormat.MMM();

    // Determine which column each month "starts" on (= column that contains
    // the 1st of the month). Render the Korean-localised month abbreviation
    // at that x offset. 좌상단 30dp 는 day-label 열 여백.
    const double leftPadding = 30;

    final List<Widget> stack = <Widget>[];
    int? lastMonth;
    for (int col = 0; col < columns; col++) {
      final DateTime colStart = startColumnDate.add(Duration(days: col * 7));
      final int month = colStart.month;
      if (month != lastMonth && colStart.day <= 7) {
        stack.add(
          Positioned(
            left: leftPadding + col * (cellSize + cellGap),
            child: Text(
              fmt.format(colStart),
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppPalette.secondaryGray,
              ),
            ),
          ),
        );
        lastMonth = month;
      }
    }

    return SizedBox(
      height: 18,
      width: leftPadding + columns * (cellSize + cellGap),
      child: Stack(children: stack),
    );
  }
}

/// Left-hand day-of-week labels (월 · 수 · 금 — odd rows to avoid crowding).
class _DayLabelsColumn extends StatelessWidget {
  const _DayLabelsColumn({required this.cellSize, required this.cellGap});

  final double cellSize;
  final double cellGap;

  static const List<String> _labels = <String>[
    '일',
    '월',
    '화',
    '수',
    '목',
    '금',
    '토',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 30,
      child: Column(
        children: <Widget>[
          for (int row = 0; row < 7; row++) ...<Widget>[
            SizedBox(
              height: cellSize,
              child: row.isOdd
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _labels[row],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppPalette.secondaryGray,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            if (row < 6) SizedBox(height: cellGap),
          ],
        ],
      ),
    );
  }
}
