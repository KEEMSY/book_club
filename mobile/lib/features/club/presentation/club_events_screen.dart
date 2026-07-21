import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/club_event_notifier.dart';
import '../application/club_providers.dart';
import '../domain/club_event.dart';

class ClubEventsScreen extends ConsumerWidget {
  const ClubEventsScreen({super.key, required this.clubId});

  final String clubId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(clubEventsProvider(clubId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('독서 모임'),
      ),
      body: eventsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (_, __) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                '모임 일정을 불러오지 못했어요',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => ref.invalidate(clubEventsProvider(clubId)),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (events) => events.isEmpty
            ? _EmptyEventsView(
                onRefresh: () => ref.invalidate(clubEventsProvider(clubId)),
              )
            : RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(clubEventsProvider(clubId)),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: events.length,
                  itemBuilder: (_, i) => _EventCard(
                    event: events[i],
                    clubId: clubId,
                    onRsvpChanged: () =>
                        ref.invalidate(clubEventsProvider(clubId)),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _CreateEventSheet.show(context, clubId: clubId);
          ref.invalidate(clubEventsProvider(clubId));
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('모임 추가'),
      ),
    );
  }
}

class _EmptyEventsView extends StatelessWidget {
  const _EmptyEventsView({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_note_rounded,
              size: 52,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
            ),
            const SizedBox(height: 16),
            Text(
              '아직 예정된 모임이 없어요',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '+ 버튼으로 첫 번째 모임을 만들어 보세요',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Event card
// ---------------------------------------------------------------------------

class _EventCard extends ConsumerStatefulWidget {
  const _EventCard({
    required this.event,
    required this.clubId,
    required this.onRsvpChanged,
  });

  final ClubEvent event;
  final String clubId;
  final VoidCallback onRsvpChanged;

  @override
  ConsumerState<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends ConsumerState<_EventCard> {
  // Optimistic local status — null means "use what the server returned".
  RsvpStatus? _pendingStatus;
  bool _submitting = false;

  RsvpStatus? get _effectiveStatus => _pendingStatus ?? widget.event.myStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final event = widget.event;

    return Card(
      margin: EdgeInsets.only(bottom: spacing.sm),
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date chip + title row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DateChip(date: event.eventAt),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: theme.textTheme.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (event.location != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.place_rounded,
                              size: 13,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                event.location!,
                                style: theme.textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: spacing.sm),

            // Attendee counts summary
            _AttendeeSummary(counts: event.attendeeCounts),

            SizedBox(height: spacing.sm),

            // RSVP toggle row
            _RsvpRow(
              selected: _effectiveStatus,
              submitting: _submitting,
              onSelected: _onRsvp,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRsvp(RsvpStatus status) async {
    if (_submitting) return;

    // Optimistic update
    setState(() {
      _pendingStatus = status;
      _submitting = true;
    });

    try {
      await ref.read(clubRepositoryProvider).rsvp(
            widget.clubId,
            widget.event.id,
            status.name == 'notGoing' ? 'not_going' : status.name,
          );
      widget.onRsvpChanged();
    } catch (_) {
      // Revert optimistic update on failure.
      if (mounted) {
        setState(() => _pendingStatus = null);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('참석 여부 변경에 실패했습니다.')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

// ---------------------------------------------------------------------------
// Date chip
// ---------------------------------------------------------------------------

class _DateChip extends StatelessWidget {
  const _DateChip({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final month = date.month.toString();
    final day = date.day.toString().padLeft(2, '0');

    return Container(
      width: 44,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          Text(
            '$month월',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            day,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Attendee summary
// ---------------------------------------------------------------------------

class _AttendeeSummary extends StatelessWidget {
  const _AttendeeSummary({required this.counts});

  final AttendeeCount counts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          Icons.people_alt_rounded,
          size: 14,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
        ),
        const SizedBox(width: 4),
        if (counts.going > 0)
          Text(
            '참석 ${counts.going}명',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        if (counts.going > 0 && counts.maybe > 0)
          Text(
            ' · ',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        if (counts.maybe > 0)
          Text(
            '미정 ${counts.maybe}명',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        if (counts.going == 0 && counts.maybe == 0)
          Text(
            '아직 응답 없음',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// RSVP row — 3 toggle buttons
// ---------------------------------------------------------------------------

class _RsvpRow extends StatelessWidget {
  const _RsvpRow({
    required this.selected,
    required this.submitting,
    required this.onSelected,
  });

  final RsvpStatus? selected;
  final bool submitting;
  final ValueChanged<RsvpStatus> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _RsvpButton(
          label: '참석',
          icon: Icons.check_circle_outline_rounded,
          status: RsvpStatus.going,
          selected: selected == RsvpStatus.going,
          enabled: !submitting,
          onTap: () => onSelected(RsvpStatus.going),
          selectedColor: theme.colorScheme.primary,
        ),
        const SizedBox(width: 6),
        _RsvpButton(
          label: '미정',
          icon: Icons.help_outline_rounded,
          status: RsvpStatus.maybe,
          selected: selected == RsvpStatus.maybe,
          enabled: !submitting,
          onTap: () => onSelected(RsvpStatus.maybe),
          selectedColor: theme.colorScheme.tertiary,
        ),
        const SizedBox(width: 6),
        _RsvpButton(
          label: '불참',
          icon: Icons.cancel_outlined,
          status: RsvpStatus.notGoing,
          selected: selected == RsvpStatus.notGoing,
          enabled: !submitting,
          onTap: () => onSelected(RsvpStatus.notGoing),
          selectedColor: theme.colorScheme.error,
        ),
        if (submitting) ...[
          const Spacer(),
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ],
    );
  }
}

class _RsvpButton extends StatelessWidget {
  const _RsvpButton({
    required this.label,
    required this.icon,
    required this.status,
    required this.selected,
    required this.enabled,
    required this.onTap,
    required this.selectedColor,
  });

  final String label;
  final IconData icon;
  final RsvpStatus status;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bgColor =
        selected ? selectedColor : theme.colorScheme.surfaceContainerHighest;
    final fgColor = selected
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface.withValues(alpha: 0.7);

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: selected
              ? null
              : Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: fgColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(color: fgColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Create event bottom sheet (M30 version — uses new fields)
// ---------------------------------------------------------------------------

class _CreateEventSheet extends ConsumerStatefulWidget {
  const _CreateEventSheet({required this.clubId});

  final String clubId;

  static Future<void> show(BuildContext context, {required String clubId}) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => _CreateEventSheet(clubId: clubId),
      );

  @override
  ConsumerState<_CreateEventSheet> createState() => _CreateEventSheetState();
}

class _CreateEventSheetState extends ConsumerState<_CreateEventSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _maxAttendeesCtrl = TextEditingController();

  DateTime _eventAt = DateTime.now().add(const Duration(days: 7));
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _locationCtrl.dispose();
    _maxAttendeesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.lg + bottom,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: EdgeInsets.only(bottom: spacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Text('모임 만들기', style: theme.textTheme.titleLarge),
              SizedBox(height: spacing.lg),

              // Title field
              TextFormField(
                controller: _titleCtrl,
                maxLength: 200,
                decoration: const InputDecoration(
                  labelText: '제목 *',
                  hintText: '예: 2장 독서 토론',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? '제목을 입력해 주세요' : null,
              ),
              SizedBox(height: spacing.sm),

              // Date + time picker
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.calendar_month_rounded,
                  color: theme.colorScheme.primary,
                ),
                title: Text(
                  _formatDateTime(_eventAt),
                  style: theme.textTheme.bodyMedium,
                ),
                subtitle: Text(
                  '날짜 및 시간',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                onTap: _pickDateTime,
              ),
              Divider(
                  height: 1,
                  color: theme.colorScheme.outline.withValues(alpha: 0.3)),
              SizedBox(height: spacing.sm),

              // Location field (optional)
              TextFormField(
                controller: _locationCtrl,
                decoration: const InputDecoration(
                  labelText: '장소 (선택)',
                  hintText: '예: 강남구 카페 혹은 링크',
                  prefixIcon: Icon(Icons.place_rounded),
                ),
              ),
              SizedBox(height: spacing.sm),

              // Max attendees field (optional)
              TextFormField(
                controller: _maxAttendeesCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '최대 인원 (선택)',
                  hintText: '예: 10',
                  prefixIcon: Icon(Icons.people_alt_rounded),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final n = int.tryParse(v.trim());
                  if (n == null || n < 1) return '1 이상의 숫자를 입력해 주세요';
                  return null;
                },
              ),
              SizedBox(height: spacing.lg),

              // Save button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _submit,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('저장'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _eventAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_eventAt),
    );
    if (time == null || !mounted) return;
    setState(
      () => _eventAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${dt.year}.$month.$day $hour:$minute';
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);

    try {
      final maxAttendeesText = _maxAttendeesCtrl.text.trim();
      final maxAttendees =
          maxAttendeesText.isNotEmpty ? int.tryParse(maxAttendeesText) : null;

      await ref.read(clubRepositoryProvider).createEventV2(
            widget.clubId,
            title: _titleCtrl.text.trim(),
            description: _descriptionCtrl.text.trim().isEmpty
                ? null
                : _descriptionCtrl.text.trim(),
            location: _locationCtrl.text.trim().isEmpty
                ? null
                : _locationCtrl.text.trim(),
            eventAt: _eventAt,
            maxAttendees: maxAttendees,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('모임 생성에 실패했습니다.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
