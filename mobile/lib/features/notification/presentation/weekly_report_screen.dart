import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../data/notification_models.dart';
import '../data/notification_repository.dart';

/// Weekly reading report screen reachable via `AppRoutes.weeklyReport`.
///
/// Defaults to the current week's Monday when [weekStart] is null.
/// The report is fetched fresh each time the selected week changes — no local
/// caching because weekly reports are small and generated server-side.
class WeeklyReportScreen extends ConsumerStatefulWidget {
  const WeeklyReportScreen({super.key, this.weekStart});

  /// ISO date string of the Monday of the desired week, e.g. `"2026-04-21"`.
  final String? weekStart;

  @override
  ConsumerState<WeeklyReportScreen> createState() =>
      _WeeklyReportScreenState();
}

class _WeeklyReportScreenState extends ConsumerState<WeeklyReportScreen> {
  late DateTime _selectedMonday;
  WeeklyReportResponse? _report;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedMonday = widget.weekStart != null
        ? _parseMonday(widget.weekStart!)
        : _currentMonday();
    _load();
  }

  DateTime _currentMonday() {
    final now = DateTime.now();
    return now.subtract(Duration(days: now.weekday - 1));
  }

  DateTime _parseMonday(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return dt.subtract(Duration(days: dt.weekday - 1));
    } catch (_) {
      return _currentMonday();
    }
  }

  String _toIso(DateTime dt) => DateFormat('yyyy-MM-dd').format(dt);

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(notificationRepositoryProvider);
      final result = await repo.getWeeklyReport(_toIso(_selectedMonday));
      setState(() {
        _report = result;
        _loading = false;
      });
    } on NotificationRepositoryException catch (e) {
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  bool get _isFutureWeek {
    final nowMonday = _currentMonday();
    return _selectedMonday.isAfter(nowMonday);
  }

  void _goBack() {
    setState(() {
      _selectedMonday =
          _selectedMonday.subtract(const Duration(days: 7));
      _report = null;
    });
    _load();
  }

  void _goForward() {
    if (_isFutureWeek) {
      return;
    }
    final next = _selectedMonday.add(const Duration(days: 7));
    final nowMonday = _currentMonday();
    if (next.isAfter(nowMonday)) {
      return;
    }
    setState(() {
      _selectedMonday = next;
      _report = null;
    });
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    final bool isThisWeek =
        _toIso(_selectedMonday) == _toIso(_currentMonday());
    final sunday = _selectedMonday.add(const Duration(days: 6));
    final weekLabel = isThisWeek
        ? '이번 주'
        : '${DateFormat('M.d', 'ko').format(_selectedMonday)} – '
            '${DateFormat('M.d', 'ko').format(sunday)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('주간 독서 리포트'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            tooltip: '이전 주',
            onPressed: _goBack,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            tooltip: '다음 주',
            onPressed: _isFutureWeek ? null : _goForward,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero heading.
                  Text(
                    weekLabel,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '이번 주 독서 리포트',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                      height: 1.28,
                    ),
                  ),
                  SizedBox(height: spacing.xl),
                  if (_error != null)
                    _ErrorCard(message: _error!)
                  else if (_report == null)
                    _EmptyCard(isThisWeek: isThisWeek)
                  else
                    _ReportCards(
                      report: _report!,
                      spacing: spacing,
                    ),
                ],
              ),
            ),
    );
  }
}

class _ReportCards extends StatelessWidget {
  const _ReportCards({
    required this.report,
    required this.spacing,
  });

  final WeeklyReportResponse report;
  final AppSpacing spacing;

  String _formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    if (h == 0) {
      return '$m분';
    }
    if (m == 0) {
      return '$h시간';
    }
    return '$h시간 $m분';
  }

  String _weekdayName(String? isoDate) {
    if (isoDate == null) {
      return '—';
    }
    try {
      final dt = DateTime.parse(isoDate);
      const names = ['월', '화', '수', '목', '금', '토', '일'];
      return '${names[dt.weekday - 1]}요일';
    } catch (_) {
      return '—';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StatCard(
          emoji: '📚',
          label: '총 독서 시간',
          value: _formatDuration(report.totalSeconds),
        ),
        SizedBox(height: spacing.md),
        _StatCard(
          emoji: '📖',
          label: '독서 세션 수',
          value: '${report.sessionCount}회',
        ),
        SizedBox(height: spacing.md),
        _StatCard(
          emoji: '🌟',
          label: '가장 많이 읽은 날',
          value: _weekdayName(report.bestDay),
        ),
        SizedBox(height: spacing.md),
        _StatCard(
          emoji: '⏱',
          label: '최장 세션',
          value: _formatDuration(report.longestSessionSec),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.emoji,
    required this.label,
    required this.value,
  });

  final String emoji;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shadows = theme.extension<AppShadows>();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: shadows?.elevated,
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.isThisWeek});

  final bool isThisWeek;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 48),
          const Text('📖', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            '이번 주 기록된 독서가 없어요',
            style: theme.textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          if (isThisWeek) ...[
            const SizedBox(height: 8),
            Text(
              '독서 타이머를 사용해 습관을 만들어보세요',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 48),
          Icon(
            Icons.error_outline,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
