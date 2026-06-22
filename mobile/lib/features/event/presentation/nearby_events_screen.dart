import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../application/event_notifier.dart';
import '../domain/event.dart';
import 'event_create_sheet.dart';

/// Location-based meetup discovery (M64). Defaults to a list driven by a
/// device-resolved origin (Seoul City Hall fallback); M68 adds a map-view
/// toggle (placeholder until the Kakao Map SDK lands — CLAUDE.md §2).
class NearbyEventsScreen extends ConsumerStatefulWidget {
  const NearbyEventsScreen({super.key});

  @override
  ConsumerState<NearbyEventsScreen> createState() => _NearbyEventsScreenState();
}

class _NearbyEventsScreenState extends ConsumerState<NearbyEventsScreen> {
  bool _mapView = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final NearbyEventsState state = ref.watch(nearbyEventsProvider);
    final NearbyEventsNotifier notifier =
        ref.read(nearbyEventsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('근처 모임', style: theme.textTheme.titleLarge),
        actions: <Widget>[
          IconButton(
            tooltip: _mapView ? '목록 보기' : '지도 보기',
            icon: Icon(_mapView ? Icons.view_list_rounded : Icons.map_rounded),
            onPressed: () => setState(() => _mapView = !_mapView),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => EventCreateSheet.show(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('모임 만들기'),
      ),
      body: Column(
        children: <Widget>[
          _FilterBar(
            radiusKm: state.radiusKm,
            category: state.category,
            onDate: state.onDate,
            onRadiusChanged: notifier.setRadius,
            onCategoryChanged: notifier.setCategory,
            onDateChanged: notifier.setDate,
          ),
          const Divider(height: 0.5),
          Expanded(
            child: _mapView
                ? _MapPlaceholder(spacing: spacing)
                : RefreshIndicator(
                    onRefresh: notifier.load,
                    child: _Body(events: state.events, spacing: spacing),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Stand-in for the map view until the Kakao Map Flutter SDK is approved and
/// wired (no new map package added — CLAUDE.md §2 / team decision).
class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.spacing});

  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      padding: EdgeInsets.all(spacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.map_outlined,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: spacing.md),
          Text(
            '지도 뷰 (카카오맵 SDK 연동 예정)',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.radiusKm,
    required this.category,
    required this.onDate,
    required this.onRadiusChanged,
    required this.onCategoryChanged,
    required this.onDateChanged,
  });

  final double radiusKm;
  final String? category;
  final DateTime? onDate;
  final ValueChanged<double> onRadiusChanged;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<DateTime?> onDateChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SegmentedButton<double>(
            segments: <ButtonSegment<double>>[
              for (final double r in kEventRadiusOptions)
                ButtonSegment<double>(
                  value: r,
                  label: Text('${r.toStringAsFixed(0)}km'),
                ),
            ],
            selected: <double>{radiusKm},
            onSelectionChanged: (Set<double> s) => onRadiusChanged(s.first),
          ),
          SizedBox(height: spacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                FilterChip(
                  label: const Text('전체'),
                  selected: category == null,
                  onSelected: (_) => onCategoryChanged(null),
                ),
                for (final String c in kEventCategories) ...<Widget>[
                  SizedBox(width: spacing.xs),
                  FilterChip(
                    label: Text(c),
                    selected: category == c,
                    onSelected: (bool sel) => onCategoryChanged(sel ? c : null),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: spacing.xs),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today_rounded, size: 18),
                  label: Text(
                    onDate == null ? '날짜 전체' : _formatDay(onDate!),
                  ),
                  onPressed: () => _pickDate(context),
                ),
              ),
              if (onDate != null) ...<Widget>[
                SizedBox(width: spacing.xs),
                IconButton(
                  tooltip: '날짜 필터 해제',
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => onDateChanged(null),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: onDate ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      onDateChanged(picked);
    }
  }

  String _formatDay(DateTime dt) =>
      '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')}';
}

class _Body extends StatelessWidget {
  const _Body({required this.events, required this.spacing});

  final AsyncValue<List<Event>> events;
  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    return switch (events) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError() => const _MessageView(
          icon: Icons.cloud_off_rounded,
          title: '모임을 불러오지 못했어요',
          subtitle: '다시 시도해 주세요.',
        ),
      AsyncData(:final List<Event> value) when value.isEmpty =>
        const _MessageView(
          icon: Icons.location_off_rounded,
          title: '주변에 모임이 없어요',
          subtitle: '첫 번째 모임을 만들어보세요!',
        ),
      AsyncData(:final List<Event> value) => ListView.separated(
          padding: EdgeInsets.symmetric(vertical: spacing.sm),
          itemCount: value.length,
          separatorBuilder: (_, __) => const Divider(height: 0.5),
          itemBuilder: (_, int i) => _EventRow(event: value[i]),
        ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return InkWell(
      onTap: () => context.push(AppRoutes.eventDetail(event.id)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    event.title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: spacing.sm),
                Text(
                  '${event.distanceKm.toStringAsFixed(1)}km',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.xs),
            if (event.address != null && event.address!.isNotEmpty)
              _IconLine(icon: Icons.place_outlined, text: event.address!),
            _IconLine(
              icon: Icons.schedule_rounded,
              text: _formatDateTime(event.eventAt),
            ),
            _IconLine(
              icon: Icons.group_outlined,
              text: event.maxAttendees == null
                  ? '${event.joinedCount}명 참여'
                  : '${event.joinedCount}/${event.maxAttendees}명',
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final DateTime l = dt.toLocal();
    return '${l.year}.${l.month.toString().padLeft(2, '0')}.${l.day.toString().padLeft(2, '0')} '
        '${l.hour.toString().padLeft(2, '0')}:${l.minute.toString().padLeft(2, '0')}';
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Padding(
      padding: EdgeInsets.only(top: spacing.xs / 2),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: spacing.xs),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    // ListView so RefreshIndicator can pull even when the message fills the
    // viewport.
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.xl,
        vertical: spacing.xl * 2,
      ),
      children: <Widget>[
        Icon(icon, size: 48, color: theme.colorScheme.onSurfaceVariant),
        SizedBox(height: spacing.md),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge,
        ),
        SizedBox(height: spacing.xs),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
