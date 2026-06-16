import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/club_providers.dart';

// M48: category options matching PublicClubsScreen filter chips
const _kCategoryOptions = ['소설', '자기계발', '인문학', '과학', '기타'];

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
  final _tagsCtrl = TextEditingController();
  bool _saving = false;
  bool _isPublic = false;
  String? _selectedCategory;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  List<String> _parseTags() {
    return _tagsCtrl.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
          spacing.lg, spacing.lg, spacing.lg, spacing.lg + bottom),
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
          SizedBox(height: spacing.sm),
          // M48: category selector
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(labelText: '카테고리 (선택)'),
            items: [
              const DropdownMenuItem(value: null, child: Text('선택 안함')),
              ..._kCategoryOptions.map(
                (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
              ),
            ],
            onChanged: (val) => setState(() => _selectedCategory = val),
          ),
          SizedBox(height: spacing.sm),
          // M48: tags input (comma-separated)
          TextField(
            controller: _tagsCtrl,
            decoration: const InputDecoration(
              labelText: '태그 (선택)',
              hintText: '예: 한국소설, 2024, SF',
              helperText: '쉼표로 구분해서 입력하세요',
            ),
          ),
          SizedBox(height: spacing.sm),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('공개 클럽'),
            subtitle: const Text('누구나 검색하고 가입할 수 있어요'),
            value: _isPublic,
            onChanged: (v) => setState(() => _isPublic = v),
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
            isPublic: _isPublic,
            category: _selectedCategory,
            tags: _parseTags(),
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
