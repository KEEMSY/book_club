import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/storage/secure_storage.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/domain/auth_state.dart';
import '../../feed/data/image_uploader.dart';
import '../application/club_chat_notifier.dart';
import '../application/club_providers.dart';

/// Full-screen chat view for a chapter-gated room.
///
/// Functionally mirrors [ClubChatScreen] but connects to the room-specific
/// WebSocket endpoint via [ClubRoomChatNotifier].
class ClubRoomChatScreen extends ConsumerStatefulWidget {
  const ClubRoomChatScreen({
    super.key,
    required this.clubId,
    required this.roomId,
    required this.roomName,
  });

  final String clubId;
  final String roomId;
  final String roomName;

  @override
  ConsumerState<ClubRoomChatScreen> createState() =>
      _ClubRoomChatScreenState();
}

class _ClubRoomChatScreenState extends ConsumerState<ClubRoomChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  ChatMessage? _replyTarget;
  bool _isUploadingImage = false;

  String get _currentUserId {
    final auth = ref.read(authNotifierProvider);
    return switch (auth) {
      Authenticated(:final user) => user.id,
      _ => '',
    };
  }

  Future<void> _connectWithToken() async {
    final token = await ref.read(secureStorageProvider).readAccessToken();
    if (!mounted) return;
    ref
        .read(
          clubRoomChatNotifierProvider(widget.clubId, widget.roomId).notifier,
        )
        .connect(token ?? '');
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _connectWithToken());
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final chatState = ref.read(
        clubRoomChatNotifierProvider(widget.clubId, widget.roomId),
      );
      if (chatState is ClubChatConnected && !chatState.isLoadingHistory) {
        ref
            .read(
              clubRoomChatNotifierProvider(
                widget.clubId,
                widget.roomId,
              ).notifier,
            )
            .loadHistory();
      }
    }
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final notifier = ref.read(
      clubRoomChatNotifierProvider(widget.clubId, widget.roomId).notifier,
    );

    if (_replyTarget != null) {
      notifier.sendWithReply(
        content: text,
        replyToId: _replyTarget!.id,
        replyToContent: _replyTarget!.content,
        replyToAuthor: _replyTarget!.authorNickname,
      );
    } else {
      notifier.send(text);
    }

    _controller.clear();
    setState(() => _replyTarget = null);
    _scrollToBottom();
  }

  void _scrollToBottom() {
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

  void _onReply(ChatMessage message) {
    setState(() => _replyTarget = message);
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _onCopy(ChatMessage message) {
    Clipboard.setData(ClipboardData(text: message.content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('클립보드에 복사했어요.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _onDelete(ChatMessage message) async {
    await ref
        .read(
          clubRoomChatNotifierProvider(widget.clubId, widget.roomId).notifier,
        )
        .deleteMessage(message.id);
  }

  void _showMessageMenu(BuildContext context, ChatMessage message) {
    final isMe = message.userId == _currentUserId;

    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.reply_rounded),
              title: const Text('답장'),
              onTap: () {
                Navigator.pop(context);
                _onReply(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy_rounded),
              title: const Text('복사'),
              onTap: () {
                Navigator.pop(context);
                _onCopy(message);
              },
            ),
            if (isMe)
              ListTile(
                leading: Icon(
                  Icons.delete_outline_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  '삭제',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _onDelete(message);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    setState(() => _isUploadingImage = true);

    try {
      final bytes = await picked.readAsBytes();
      final mimeType = _mimeTypeFromPath(picked.path);
      final image = PickedImage(
        bytes: bytes,
        contentType: mimeType,
        filename: picked.name,
      );

      final uploader = ref.read(chatImageUploaderProvider);
      final key = await uploader.upload(image);

      if (!mounted) return;
      ref
          .read(
            clubRoomChatNotifierProvider(widget.clubId, widget.roomId).notifier,
          )
          .sendWithMedia(mediaUrl: key);

      _scrollToBottom();
    } on ImageUploadException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이미지를 전송하지 못했어요. 다시 시도해주세요.'),
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) setState(() => _isUploadingImage = false);
    }
  }

  String _mimeTypeFromPath(String path) {
    final ext = path.split('.').last.toLowerCase();
    return switch (ext) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final chatState = ref.watch(
      clubRoomChatNotifierProvider(widget.clubId, widget.roomId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName),
      ),
      body: Column(
        children: [
          _ConnectionBanner(
            state: chatState,
            onRetry: _connectWithToken,
          ),
          Expanded(child: _buildBody(chatState, theme, spacing)),
          if (_replyTarget != null)
            _ReplyPreview(
              message: _replyTarget!,
              onDismiss: () => setState(() => _replyTarget = null),
            ),
          _InputBar(
            controller: _controller,
            onSend: _send,
            onPickImage: _onPickImage,
            enabled: chatState is ClubChatConnected && !_isUploadingImage,
            isUploadingImage: _isUploadingImage,
          ),
        ],
      ),
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
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.md),
                FilledButton.tonal(
                  onPressed: _connectWithToken,
                  child: const Text('다시 연결'),
                ),
              ],
            ),
          ),
        ),
      ClubChatConnected(:final messages, :final isLoadingHistory) =>
        messages.isEmpty
            ? Center(
                child: Text(
                  '아직 대화가 없어요.\n첫 메시지를 보내 보세요!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: messages.length + (isLoadingHistory ? 1 : 0),
                itemBuilder: (_, index) {
                  if (isLoadingHistory && index == messages.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  }
                  final msg = messages[messages.length - 1 - index];
                  final isMe = msg.userId == _currentUserId;
                  return _ChatBubble(
                    message: msg,
                    isMe: isMe,
                    onLongPress: () => _showMessageMenu(context, msg),
                  );
                },
              ),
    };
  }
}

// ---------------------------------------------------------------------------
// Widgets — reused from ClubChatScreen (private copies kept in sync)
// ---------------------------------------------------------------------------

class _ConnectionBanner extends StatelessWidget {
  const _ConnectionBanner({required this.state, required this.onRetry});

  final ClubChatState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ClubChatConnecting() => Material(
          color: Colors.amber.shade700,
          child: const SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '연결 중...',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ClubChatError() => GestureDetector(
          onTap: onRetry,
          child: Material(
            color: Theme.of(context).colorScheme.error,
            child: const SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    Icon(Icons.wifi_off_rounded, size: 14, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      '연결 오류 — 재시도',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ClubChatConnected() => const SizedBox.shrink(),
    };
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.message,
    required this.isMe,
    required this.onLongPress,
  });

  final ChatMessage message;
  final bool isMe;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bubbleColor = isMe
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceContainerHighest;
    final textColor =
        isMe ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 3),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.72,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isMe) ...[
                _Avatar(
                  imageUrl: message.authorProfileImageUrl,
                  nickname: message.authorNickname,
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
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
                        color: bubbleColor,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMe ? 16 : 4),
                          bottomRight: Radius.circular(isMe ? 4 : 16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (message.replyToId != null)
                            _ReplyChip(
                              author: message.replyToAuthor ?? '',
                              content: message.replyToContent ?? '',
                              isMe: isMe,
                            ),
                          if (message.mediaUrl != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: message.mediaUrl!,
                                  width: 200,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(
                                    width: 200,
                                    height: 120,
                                    color: theme.colorScheme.surfaceContainerHigh,
                                  ),
                                  errorWidget: (_, __, ___) =>
                                      const Icon(Icons.broken_image_rounded),
                                ),
                              ),
                            ),
                          if (message.content.isNotEmpty)
                            Text(
                              message.content,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: textColor),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 2, left: 4, right: 4),
                      child: Text(
                        _formatTime(message.createdAt),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.45),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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

class _Avatar extends StatelessWidget {
  const _Avatar({required this.imageUrl, required this.nickname});

  final String? imageUrl;
  final String nickname;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (imageUrl != null) {
      return CircleAvatar(
        radius: 16,
        backgroundImage: CachedNetworkImageProvider(imageUrl!),
      );
    }
    return CircleAvatar(
      radius: 16,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Text(
        nickname.isNotEmpty ? nickname[0] : '?',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ReplyChip extends StatelessWidget {
  const _ReplyChip({
    required this.author,
    required this.content,
    required this.isMe,
  });

  final String author;
  final String content;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = isMe
        ? theme.colorScheme.onPrimary.withValues(alpha: 0.4)
        : theme.colorScheme.primary.withValues(alpha: 0.5);
    final textColor = isMe
        ? theme.colorScheme.onPrimary.withValues(alpha: 0.85)
        : theme.colorScheme.onSurface.withValues(alpha: 0.75);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: borderColor, width: 3)),
        color: isMe
            ? Colors.white.withValues(alpha: 0.10)
            : theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            author,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isMe
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}

class _ReplyPreview extends StatelessWidget {
  const _ReplyPreview({required this.message, required this.onDismiss});

  final ChatMessage message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.4),
          ),
          left: BorderSide(color: theme.colorScheme.primary, width: 3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.authorNickname,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            onPressed: onDismiss,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.onPickImage,
    required this.enabled,
    this.isUploadingImage = false,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onPickImage;
  final bool enabled;
  final bool isUploadingImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
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
            SizedBox(
              width: 40,
              height: 40,
              child: isUploadingImage
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(Icons.image_outlined, size: 20),
                      onPressed: enabled ? onPickImage : null,
                      tooltip: '이미지 첨부',
                      visualDensity: VisualDensity.compact,
                    ),
            ),
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
            const SizedBox(width: 4),
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
