import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/heatmap_day.dart';

/// GitHub-style 52-week × 7-day 독서 캘린더 heatmap.
///
/// (Class and file names keep the `JanDee` / `jan_dee_grid` identifier to
/// avoid cross-file rename churn — user-facing strings all render as
/// "독서 캘린더" instead of the earlier slang "독서 잔디".)
///
/// The cells run left-to-right, oldest to newest; the rightmost column is
/// the current week. Cell size is computed from the parent constraints via
/// [LayoutBuilder] so the grid always fills the card's inner width — the
/// trailing edge sits flush with the last week column, with no right-edge
/// whitespace. Falls back to horizontal scrolling only when the card is too
/// narrow to fit 52 weeks at the minimum legible cell size.
class JanDeeGrid extends StatelessWidget {
  const JanDeeGrid({
    super.key,
    required this.days,
    required this.primaryColor,
    this.onDayTap,
  });

  final List<HeatmapDay> days;
  final Color primaryColor;
  final void Function(HeatmapDay day)? onDayTap;

  static const int _rows = 7;
  static const int _columns = 52;

  // Layout constants. Width of the 월/수/금 day-label column, and the gap
  // between cells. The label column is snug (24dp) so cells claim as much
  // horizontal real estate as possible — the user-facing ask was "cells fill
  // the card edge to edge".
  static const double _dayLabelWidth = 24;
  static const double _cellGap = 2;

  // Minimum cell size under which the grid stops fitting statically and
  // must fall back to horizontal scrolling. 8dp still reads as a distinct
  // cell on high-DPI displays without touching AA contrast.
  static const double _minCellSize = 8;

  // Upper bound on cell size so the grid doesn't balloon on tablet widths —
  // Airbnb's listing cards cap visual density around the same 12–16dp tile.
  static const double _maxCellSize = 16;

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
    final DateTime startColumnDate =
        currentWeekSunday.subtract(const Duration(days: 7 * (_columns - 1)));

    final ThemeData theme = Theme.of(context);
    final Color emptyCellBase = Color.alphaBlend(
      theme.colorScheme.onSurface.withValues(alpha: 0.08),
      theme.colorScheme.surfaceContainerHighest,
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Available width inside the card = card inner width. Reserve the
        // day-label column on the left; the remainder is divided across
        // 52 columns with 51 inter-column gaps.
        //
        //   cellSize = (available - 51 * gap) / 52
        //
        // On a 375dp phone card with 24dp horizontal padding each side:
        //   card inner width   = 375 - 48      = 327dp
        //   available for grid = 327 - 24      = 303dp   (label column)
        //   cellSize           = (303 - 51*2)/52 = 201/52 ≈ 3.87dp  ← too small
        //
        // In practice the dashboard card has narrower padding (spacing.lg
        // = 24 inside the card) so the `_HeatmapCard` inner width lands
        // closer to 327dp. 3.87dp is below our 8dp minimum — the widget
        // falls back to horizontal scroll in that case. On a wider card
        // (tablet, desktop web) the cell size scales up cleanly to the
        // 16dp cap.
        final double available = constraints.maxWidth - _dayLabelWidth;
        final double rawCellSize =
            (available - (_columns - 1) * _cellGap) / _columns;
        final double cellSize =
            rawCellSize.clamp(_minCellSize, _maxCellSize).toDouble();

        // Total width the grid needs at this cell size. When the raw size
        // is below the minimum clamp, `gridWidth` exceeds `available` and
        // we flip to scroll mode (anchored at the trailing edge so "today"
        // remains visible). Otherwise the grid fills the card exactly.
        final double gridWidth =
            _columns * cellSize + (_columns - 1) * _cellGap;
        final bool needsScroll = rawCellSize < _minCellSize;

        final Widget gridBody = _GridBody(
          cellSize: cellSize,
          cellGap: _cellGap,
          today: today,
          currentWeekSunday: currentWeekSunday,
          startColumnDate: startColumnDate,
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
        // Fallback: card is too narrow for 52 weeks at the minimum cell
        // size — scroll horizontally with the trailing edge anchored so
        // the current week ("today") stays flush with the card's right
        // edge after layout.
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

  /// Maps a seconds total onto one of 5 opacity buckets. Matches the task
  /// contract: 0 / 1–15m / 16–45m / 46–90m / 91–180m / >180m.
  ///
  /// Active buckets blend the grade accent over the theme's surface container
  /// so the full opacity ladder stays visible on both the light parchment and
  /// the #161616 dark canvas — a plain `primary.withValues(alpha: 0.15)`
  /// vanishes on dark because the canvas eats the low-alpha coral.
  static Color _bucketColor(int seconds, Color primary, Color emptyBase) {
    if (seconds == 0) {
      return emptyBase;
    }
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

/// Month labels + day labels + cell matrix, composed vertically. Extracted
/// from [JanDeeGrid.build] so the scroll / no-scroll branches share the same
/// inner tree.
class _GridBody extends StatelessWidget {
  const _GridBody({
    required this.cellSize,
    required this.cellGap,
    required this.today,
    required this.currentWeekSunday,
    required this.startColumnDate,
    required this.byDate,
    required this.keyFmt,
    required this.primaryColor,
    required this.emptyCellColor,
    required this.onDayTap,
  });

  final double cellSize;
  final double cellGap;
  final DateTime today;
  final DateTime currentWeekSunday;
  final DateTime startColumnDate;
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
          columns: JanDeeGrid._columns,
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
            for (int col = 0; col < JanDeeGrid._columns; col++) ...<Widget>[
              Column(
                children: <Widget>[
                  for (int row = 0; row < JanDeeGrid._rows; row++) ...<Widget>[
                    _buildCell(col: col, row: row),
                    if (row < JanDeeGrid._rows - 1) SizedBox(height: cellGap),
                  ],
                ],
              ),
              if (col < JanDeeGrid._columns - 1) SizedBox(width: cellGap),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildCell({required int col, required int row}) {
    // Column index increases oldest → newest (left → right). Current week
    // sits at col == _columns - 1.
    final int weeksAgo = (JanDeeGrid._columns - 1) - col;
    final DateTime weekStart =
        currentWeekSunday.subtract(Duration(days: weeksAgo * 7));
    final DateTime cellDate = weekStart.add(Duration(days: row));

    if (cellDate.isAfter(today)) {
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

/// Renders month abbreviations across the top of the grid, aligned to the
/// week-column where the 1st of that month falls.
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
    final DateFormat fmt = DateFormat.MMM();

    // Determine which column each month "starts" on (= column that contains
    // the 1st of the month). Render the Korean-localised month abbreviation
    // at that x offset, flush with the aligned week column.
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

/// Left-hand day-of-week labels (월 · 수 · 금 — odd rows to avoid crowding).
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
