import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/club_providers.dart';

class CreateEventSheet extends ConsumerStatefulWidget {
  const CreateEventSheet({super.key, required this.clubId});

  final String clubId;

  static Future<void> show(BuildContext context, {required String clubId}) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => CreateEventSheet(clubId: clubId),
      );

  @override
  ConsumerState<CreateEventSheet> createState() => _CreateEventSheetState();
}

class _CreateEventSheetState extends ConsumerState<CreateEventSheet> {
  final _titleCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  String _eventType = 'offline';
  DateTime _scheduledAt = DateTime.now().add(const Duration(days: 7));
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('모임 일정 추가', style: theme.textTheme.titleLarge),
          SizedBox(height: spacing.lg),
          TextField(
            controller: _titleCtrl,
            maxLength: 200,
            decoration: const InputDecoration(labelText: '모임 제목 *'),
          ),
          SizedBox(height: spacing.sm),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'offline', label: Text('오프라인')),
              ButtonSegment(value: 'online', label: Text('온라인')),
            ],
            selected: {_eventType},
            onSelectionChanged: (s) => setState(() => _eventType = s.first),
          ),
          SizedBox(height: spacing.sm),
          TextField(
            controller: _locationCtrl,
            decoration: InputDecoration(
              labelText: _eventType == 'offline' ? '장소' : '링크 (선택)',
            ),
          ),
          SizedBox(height: spacing.md),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today_rounded),
            title: Text(_formatDate(_scheduledAt)),
            subtitle: const Text('날짜 및 시간'),
            onTap: _pickDate,
          ),
          SizedBox(height: spacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving ? null : _create,
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
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt),
    );
    if (time == null || !mounted) return;
    setState(
      () => _scheduledAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  Future<void> _create() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;
    setState(() => _saving = true);
    try {
      await ref.read(clubRepositoryProvider).createEvent(
            widget.clubId,
            title: title,
            eventType: _eventType,
            location: _locationCtrl.text.trim().isEmpty
                ? null
                : _locationCtrl.text.trim(),
            scheduledAt: _scheduledAt,
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
