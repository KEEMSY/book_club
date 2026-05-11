import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/heatmap_day.dart';

/// GitHub-style 독서 캘린더 heatmap anchored to a calendar year.
///
/// (Class and file names keep the `JanDee` / `jan_dee_grid` identifier to
/// avoid cross-file rename churn — user-facing strings all render as
/// "독서 캘린더" instead of the earlier slang "독서 잔디".)
///
/// Unlike the earlier rolling 52-week window this widget is year-anchored:
///   * [year] determines the date range displayed.
///   * Columns run from the Sunday of the week that contains Jan 1 of [year]
///     to the Sunday of the week that contains Dec 31 (past years) or today
///     (current year). This aligns month boundaries cleanly at January.
///   * Current year: future weeks are omitted so the grid grows as the year
///     progresses — early in the year cells are large and easy to read; by
///     year-end the grid is full-width, same density as before.
///   * Past years: the full 52–53-week span is shown, using horizontal scroll
///     when cells would fall below the 8dp minimum legible size.
class JanDeeGrid extends StatelessWidget {
  const JanDeeGrid({
    super.key,
    required this.days,
    required this.primaryColor,
    required this.year,
    this.onDayTap,
  });

  final List<HeatmapDay> days;
  final Color primaryColor;
  final int year;
  final void Function(HeatmapDay day)? onDayTap;

  static const int _rows = 7;

  static const double _dayLabelWidth = 24;
  static const double _cellGap = 2;
  static const double _minCellSize = 8;
  static const double _maxCellSize = 16;

  @override
  Widget build(BuildContext context) {
    final Map<String, HeatmapDay> byDate = <String, HeatmapDay>{
      for (final HeatmapDay d in days) _dateKey(d.date): d,
    };
    final DateFormat keyFmt = DateFormat('yyyy-MM-dd');

    final DateTime today = _truncateDay(DateTime.now());
    final int thisYear = DateTime.now().year;

    final DateTime startColumnDate;
    final int columns;

    if (year == thisYear) {
      // GitHub-style: 52-week rolling window ending at today's Sunday.
      final DateTime endColumnSunday =
          today.subtract(Duration(days: today.weekday % 7));
      startColumnDate = endColumnSunday.subtract(const Duration(days: 7 * 51));
      columns = 52;
    } else {
      // Full calendar year for past years.
      final DateTime jan1 = DateTime(year, 1, 1);
      startColumnDate = jan1.subtract(Duration(days: jan1.weekday % 7));
      final DateTime dec31 = DateTime(year, 12, 31);
      final DateTime endColumnSunday =
          dec31.subtract(Duration(days: dec31.weekday % 7));
      columns = endColumnSunday.difference(startColumnDate).inDays ~/ 7 + 1;
    }

    final ThemeData theme = Theme.of(context);
    final Color emptyCellBase = Color.alphaBlend(
      theme.colorScheme.onSurface.withValues(alpha: 0.08),
      theme.colorScheme.surfaceContainerHighest,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double available = constraints.maxWidth - _dayLabelWidth;
        final double rawCellSize =
            (available - (columns - 1) * _cellGap) / columns;
        final double cellSize =
            rawCellSize.clamp(_minCellSize, _maxCellSize).toDouble();

        final double gridWidth = columns * cellSize + (columns - 1) * _cellGap;
        final bool needsScroll = rawCellSize < _minCellSize;

        final Widget gridBody = _GridBody(
          cellSize: cellSize,
          cellGap: _cellGap,
          today: today,
          year: year,
          thisYear: thisYear,
          startColumnDate: startColumnDate,
          columns: columns,
          byDate: byDate,
          keyFmt: keyFmt,
          primaryColor: primaryColor,
          emptyCellColor: emptyCellBase,
          onDayTap: onDayTap,
        );

        if (!needsScroll) {
          return SizedBox(
            width: _dayLabelWidth + gridWidth,
            child: gridBody,
          );
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: SizedBox(
            width: _dayLabelWidth + gridWidth,
            child: gridBody,
          ),
        );
      },
    );
  }

  static Color _bucketColor(int seconds, Color primary, Color emptyBase) {
    if (seconds == 0) return emptyBase;
    final int minutes = seconds ~/ 60;
    if (minutes <= 15) {
      return Color.alphaBlend(primary.withValues(alpha: 0.22), emptyBase);
    }
    if (minutes <= 45) {
      return Color.alphaBlend(primary.withValues(alpha: 0.45), emptyBase);
    }
    if (minutes <= 90) {
      return Color.alphaBlend(primary.withValues(alpha: 0.70), emptyBase);
    }
    if (minutes <= 180) {
      return Color.alphaBlend(primary.withValues(alpha: 0.90), emptyBase);
    }
    return primary;
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

class _GridBody extends StatelessWidget {
  const _GridBody({
    required this.cellSize,
    required this.cellGap,
    required this.today,
    required this.year,
    required this.thisYear,
    required this.startColumnDate,
    required this.columns,
    required this.byDate,
    required this.keyFmt,
    required this.primaryColor,
    required this.emptyCellColor,
    required this.onDayTap,
  });

  final double cellSize;
  final double cellGap;
  final DateTime today;
  final int year;
  final int thisYear;
  final DateTime startColumnDate;
  final int columns;
  final Map<String, HeatmapDay> byDate;
  final DateFormat keyFmt;
  final Color primaryColor;
  final Color emptyCellColor;
  final void Function(HeatmapDay day)? onDayTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _MonthLabelsRow(
          startColumnDate: startColumnDate,
          cellSize: cellSize,
          cellGap: cellGap,
          columns: columns,
          leftPadding: JanDeeGrid._dayLabelWidth,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _DayLabelsColumn(
              cellSize: cellSize,
              cellGap: cellGap,
              width: JanDeeGrid._dayLabelWidth,
            ),
            for (int col = 0; col < columns; col++) ...<Widget>[
              Column(
                children: <Widget>[
                  for (int row = 0; row < JanDeeGrid._rows; row++) ...<Widget>[
                    _buildCell(col: col, row: row),
                    if (row < JanDeeGrid._rows - 1) SizedBox(height: cellGap),
                  ],
                ],
              ),
              if (col < columns - 1) SizedBox(width: cellGap),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildCell({required int col, required int row}) {
    final DateTime cellDate =
        startColumnDate.add(Duration(days: col * 7 + row));

    // Hide future cells in the current year.
    if (year == thisYear && cellDate.isAfter(today)) {
      return SizedBox(width: cellSize, height: cellSize);
    }

    final HeatmapDay? day = byDate[keyFmt.format(cellDate)];
    final int seconds = day?.totalSeconds ?? 0;
    final Color color =
        JanDeeGrid._bucketColor(seconds, primaryColor, emptyCellColor);

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
}

/// Month abbreviations in Korean (e.g. "1월", "3월") aligned to the column
/// where each month's 1st falls.
class _MonthLabelsRow extends StatelessWidget {
  const _MonthLabelsRow({
    required this.startColumnDate,
    required this.cellSize,
    required this.cellGap,
    required this.columns,
    required this.leftPadding,
  });

  final DateTime startColumnDate;
  final double cellSize;
  final double cellGap;
  final int columns;
  final double leftPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // "M월" produces "1월", "2월", …, "12월" — consistent Korean month labels.
    final DateFormat fmt = DateFormat('M월');

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
                color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
          ),
        );
        lastMonth = month;
      }
    }

    return SizedBox(
      height: 18,
      width: leftPadding + columns * cellSize + (columns - 1) * cellGap,
      child: Stack(children: stack),
    );
  }
}

/// Left-hand day-of-week labels (월 · 수 · 금 — odd rows only to avoid crowding).
class _DayLabelsColumn extends StatelessWidget {
  const _DayLabelsColumn({
    required this.cellSize,
    required this.cellGap,
    required this.width,
  });

  final double cellSize;
  final double cellGap;
  final double width;

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
      width: width,
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
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.72),
                          fontWeight: FontWeight.w500,
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
