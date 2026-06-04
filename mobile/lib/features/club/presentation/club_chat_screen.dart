import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/club_chat_notifier.dart';
import '../domain/club.dart';

/// Entry point for the club chat tab.
///
/// Full bubble polish and media attachments are deferred to M24; this
/// skeleton wires up [ClubChatNotifier] and provides the minimal interactive
/// surface: message list + input bar.
class ClubChatScreen extends ConsumerStatefulWidget {
  const ClubChatScreen({super.key, required this.club});

  final Club club;

  @override
  ConsumerState<ClubChatScreen> createState() => _ClubChatScreenState();
}

class _ClubChatScreenState extends ConsumerState<ClubChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  // TODO(sy): obtain token from authNotifierProvider once the auth bridge
  // exposes a synchronous accessor (tracked in M24). Placeholder empty string
  // connects without auth during local development only.
  String get _token => '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(clubChatNotifierProvider(widget.club.id).notifier)
          .connect(_token);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref
        .read(clubChatNotifierProvider(widget.club.id).notifier)
        .send(text);
    _controller.clear();
    // Scroll to bottom after the new message renders.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final chatState =
        ref.watch(clubChatNotifierProvider(widget.club.id));

    return Column(
      children: [
        Expanded(child: _buildBody(chatState, theme, spacing)),
        _InputBar(
          controller: _controller,
          onSend: _send,
          enabled: chatState is ClubChatConnected,
        ),
      ],
    );
  }

  Widget _buildBody(
    ClubChatState state,
    ThemeData theme,
    AppSpacing spacing,
  ) {
    return switch (state) {
      ClubChatConnecting() => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ClubChatError(:final message) => Center(
          child: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 48,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                SizedBox(height: spacing.md),
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.md),
                FilledButton.tonal(
                  onPressed: () => ref
                      .read(
                        clubChatNotifierProvider(widget.club.id).notifier,
                      )
                      .connect(_token),
                  child: const Text('다시 연결'),
                ),
              ],
            ),
          ),
        ),
      ClubChatConnected(:final messages) => messages.isEmpty
          ? Center(
              child: Text(
                '아직 대화가 없어요.\n첫 메시지를 보내 보세요!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              // Display newest message at the bottom by reversing the list.
              reverse: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              itemCount: messages.length,
              itemBuilder: (_, index) {
                // Reversed index: index 0 = last message.
                final msg = messages[messages.length - 1 - index];
                return _MessageBubble(
                  message: msg,
                  // Placeholder: no current-user context yet — M24 wires
                  // the auth user id properly.
                  isMe: false,
                );
              },
            ),
    };
  }
}

// ---------------------------------------------------------------------------
// Message bubble
// ---------------------------------------------------------------------------

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isMe,
  });

  final ChatMessage message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.72,
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 2),
                child: Text(
                  message.authorNickname,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isMe
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
              ),
              child: Text(
                message.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isMe
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
              child: Text(
                _formatTime(message.createdAt),
                style: theme.textTheme.labelSmall?.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.45),
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

// ---------------------------------------------------------------------------
// Input bar
// ---------------------------------------------------------------------------

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.enabled,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: enabled,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: enabled ? (_) => onSend() : null,
                decoration: InputDecoration(
                  hintText: enabled ? '메시지를 입력하세요' : '연결 중...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 6),
            IconButton.filled(
              onPressed: enabled ? onSend : null,
              icon: const Icon(Icons.send_rounded, size: 20),
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(10),
                minimumSize: const Size(40, 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
