import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/club_providers.dart';

class CreateClubSheet extends ConsumerStatefulWidget {
  const CreateClubSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => const CreateClubSheet(),
      );

  @override
  ConsumerState<CreateClubSheet> createState() => _CreateClubSheetState();
}

class _CreateClubSheetState extends ConsumerState<CreateClubSheet> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding:
          EdgeInsets.fromLTRB(spacing.lg, spacing.lg, spacing.lg, spacing.lg + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('새 독서 그룹', style: theme.textTheme.titleLarge),
          SizedBox(height: spacing.lg),
          TextField(
            controller: _nameCtrl,
            maxLength: 100,
            decoration: const InputDecoration(labelText: '그룹 이름 *'),
          ),
          SizedBox(height: spacing.sm),
          TextField(
            controller: _descCtrl,
            maxLength: 500,
            maxLines: 3,
            decoration: const InputDecoration(labelText: '소개글 (선택)'),
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
                  : const Text('만들기'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _create() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    try {
      await ref.read(clubRepositoryProvider).createClub(
            name: name,
            description:
                _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
          );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('그룹 생성에 실패했습니다.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
