import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/domain/auth_state.dart';
import '../application/club_providers.dart';
import '../application/club_room_notifier.dart';
import '../domain/club.dart';
import '../domain/club_room.dart';

/// Standalone screen wrapper — shown when navigated via the router.
///
/// The actual content lives in [ClubRoomsBody] so it can also be embedded
/// as a tab inside [ClubDetailScreen] without a double Scaffold.
class ClubRoomsScreen extends ConsumerWidget {
  const ClubRoomsScreen({super.key, required this.club});

  final Club club;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ClubRoomsBody(club: club),
    );
  }
}

/// The chapter-gated chat room list body.
///
/// Can be used as a standalone [Scaffold] body via [ClubRoomsScreen] or
/// directly inside a [TabBarView] tab.
class ClubRoomsBody extends ConsumerStatefulWidget {
  const ClubRoomsBody({super.key, required this.club});

  final Club club;

  @override
  ConsumerState<ClubRoomsBody> createState() => _ClubRoomsBodyState();
}

class _ClubRoomsBodyState extends ConsumerState<ClubRoomsBody> {
  String get _currentUserId {
    final auth = ref.read(authNotifierProvider);
    return switch (auth) {
      Authenticated(:final user) => user.id,
      _ => '',
    };
  }

  bool get _isOwner => widget.club.ownerId == _currentUserId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final roomsAsync = ref.watch(clubRoomsProvider(widget.club.id));

    return Stack(
      children: [
        roomsAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (_, __) => Center(
            child: Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  SizedBox(height: spacing.md),
                  Text(
                    '채팅방 목록을 불러오지 못했어요',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: spacing.md),
                  FilledButton.tonal(
                    onPressed: () =>
                        ref.invalidate(clubRoomsProvider(widget.club.id)),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          ),
          data: (rooms) => rooms.isEmpty
              ? _EmptyState(spacing: spacing, theme: theme)
              : ListView.builder(
                  // Extra bottom padding so the last card is not hidden by FAB.
                  padding: EdgeInsets.only(
                    left: spacing.md,
                    right: spacing.md,
                    top: spacing.sm,
                    bottom: _isOwner ? 80 : spacing.sm,
                  ),
                  itemCount: rooms.length,
                  itemBuilder: (_, i) => _RoomCard(
                    room: rooms[i],
                    clubId: widget.club.id,
                    onDeleteRequested: _isOwner
                        ? () => _confirmDelete(context, rooms[i])
                        : null,
                  ),
                ),
        ),
        // FAB for owner — positioned in the bottom-right corner.
        if (_isOwner)
          Positioned(
            right: spacing.md,
            bottom: spacing.md,
            child: FloatingActionButton(
              heroTag: 'club_rooms_fab',
              onPressed: () => _showCreateDialog(context),
              tooltip: '채팅방 만들기',
              child: const Icon(Icons.add_rounded),
            ),
          ),
      ],
    );
  }

  Future<void> _showCreateDialog(BuildContext dialogContext) async {
    final result = await showDialog<_RoomCreationResult>(
      context: dialogContext,
      builder: (_) => const _CreateRoomDialog(),
    );
    if (result == null || !mounted) return;

    try {
      await ref.read(clubRepositoryProvider).createRoom(
            widget.club.id,
            name: result.name,
            progressGate: result.progressGate,
          );
      ref.invalidate(clubRoomsProvider(widget.club.id));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(content: Text('채팅방을 만들지 못했어요. 다시 시도해 주세요.')),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext dialogContext, ClubRoom room) async {
    final confirmed = await showDialog<bool>(
      context: dialogContext,
      builder: (_) => AlertDialog(
        title: const Text('채팅방 삭제'),
        content: Text('"${room.name}" 채팅방을 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              '삭제',
              style: TextStyle(
                color: Theme.of(dialogContext).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref
          .read(clubRepositoryProvider)
          .deleteRoom(widget.club.id, room.id);
      ref.invalidate(clubRoomsProvider(widget.club.id));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(content: Text('채팅방 삭제에 실패했어요. 다시 시도해 주세요.')),
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.spacing, required this.theme});

  final AppSpacing spacing;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 52,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: spacing.md),
            Text(
              '아직 채팅방이 없어요',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              '+ 버튼으로 첫 채팅방을 만들어 보세요',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
// Room card
// ---------------------------------------------------------------------------

class _RoomCard extends ConsumerWidget {
  const _RoomCard({
    required this.room,
    required this.clubId,
    this.onDeleteRequested,
  });

  final ClubRoom room;
  final String clubId;

  /// Non-null only for owners/managers — shows a delete trailing action.
  final VoidCallback? onDeleteRequested;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final isLocked = !room.canEnter;

    return Card(
      margin: EdgeInsets.only(bottom: spacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (isLocked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${room.progressGate}장 이상 읽어야 입장 가능해요',
                ),
                duration: const Duration(seconds: 3),
              ),
            );
            return;
          }
          context.push(
            '/clubs/$clubId/rooms/${room.id}/chat',
            extra: room.name,
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.sm + 2,
          ),
          child: Row(
            children: [
              // Icon container — lock vs chat bubble
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isLocked
                      ? theme.colorScheme.surfaceContainerHighest
                      : theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isLocked
                      ? Icons.lock_outline_rounded
                      : Icons.chat_rounded,
                  size: 22,
                  color: isLocked
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                      : theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: isLocked
                            ? theme.colorScheme.onSurface
                                .withValues(alpha: 0.5)
                            : null,
                      ),
                    ),
                    if (room.progressGate > 0) ...[
                      const SizedBox(height: 2),
                      Text(
                        isLocked
                            ? '${room.progressGate}장 이상 읽어야 입장 가능'
                            : '${room.progressGate}장 이상 읽은 멤버 전용',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isLocked
                              ? theme.colorScheme.error
                                  .withValues(alpha: 0.75)
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onDeleteRequested != null)
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: theme.colorScheme.error,
                    size: 20,
                  ),
                  onPressed: onDeleteRequested,
                  visualDensity: VisualDensity.compact,
                  tooltip: '삭제',
                )
              else if (!isLocked)
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Create room dialog
// ---------------------------------------------------------------------------

class _RoomCreationResult {
  const _RoomCreationResult({required this.name, required this.progressGate});

  final String name;
  final int progressGate;
}

class _CreateRoomDialog extends StatefulWidget {
  const _CreateRoomDialog();

  @override
  State<_CreateRoomDialog> createState() => _CreateRoomDialogState();
}

class _CreateRoomDialogState extends State<_CreateRoomDialog> {
  final _nameController = TextEditingController();
  double _progressGate = 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('새 채팅방 만들기'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: '채팅방 이름',
              hintText: '예) 1-3장 스포 가능',
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          Text(
            '입장 조건: ${_progressGate.toInt()}장 이상 읽어야 입장',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Slider(
            value: _progressGate,
            min: 0,
            max: 100,
            divisions: 20,
            label: '${_progressGate.toInt()}장',
            onChanged: (v) => setState(() => _progressGate = v),
          ),
          Text(
            _progressGate == 0
                ? '모든 멤버가 입장할 수 있어요'
                : '${_progressGate.toInt()}장 이상 읽은 멤버만 입장 가능해요',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isEmpty) return;
            Navigator.pop(
              context,
              _RoomCreationResult(
                name: name,
                progressGate: _progressGate.toInt(),
              ),
            );
          },
          child: const Text('만들기'),
        ),
      ],
    );
  }
}
