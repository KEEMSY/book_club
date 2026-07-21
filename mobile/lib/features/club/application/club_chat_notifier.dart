import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../data/club_repository.dart';
import 'club_providers.dart';

part 'club_chat_notifier.g.dart';

// ---------------------------------------------------------------------------
// Domain model
// ---------------------------------------------------------------------------

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.clubId,
    required this.userId,
    required this.authorNickname,
    this.authorProfileImageUrl,
    required this.content,
    this.mediaUrl,
    required this.createdAt,
    this.editedAt,
    required this.readCount,
    this.replyToId,
    this.replyToContent,
    this.replyToAuthor,
    this.highlightId,
    this.highlightQuote,
    this.isDeleted = false,
  });

  final String id;
  final String clubId;
  final String userId;
  final String authorNickname;
  final String? authorProfileImageUrl;
  final String content;
  final String? mediaUrl;
  final DateTime createdAt;
  final DateTime? editedAt;
  final int readCount;

  // Reply / quote fields
  final String? replyToId;
  final String? replyToContent;
  final String? replyToAuthor;

  // Highlight citation fields
  final String? highlightId;
  final String? highlightQuote;

  final bool isDeleted;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        clubId: json['club_id'] as String,
        userId: json['user_id'] as String,
        authorNickname: json['author_nickname'] as String,
        authorProfileImageUrl: json['author_profile_image_url'] as String?,
        content: json['content'] as String,
        mediaUrl: json['media_url'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        editedAt: json['edited_at'] != null
            ? DateTime.parse(json['edited_at'] as String)
            : null,
        readCount: json['read_count'] as int? ?? 0,
        replyToId: json['reply_to_id'] as String?,
        replyToContent: json['reply_to_content'] as String?,
        replyToAuthor: json['reply_to_author'] as String?,
        highlightId: json['highlight_id'] as String?,
        highlightQuote: json['highlight_quote'] as String?,
        isDeleted: json['is_deleted'] as bool? ?? false,
      );
}

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

sealed class ClubChatState {
  const ClubChatState();
}

class ClubChatConnecting extends ClubChatState {
  const ClubChatConnecting();
}

class ClubChatConnected extends ClubChatState {
  const ClubChatConnected({
    required this.messages,
    this.hasMoreHistory = false,
    this.isLoadingHistory = false,
    this.oldestCursor,
  });

  final List<ChatMessage> messages;

  /// True while a REST history fetch is in flight.
  final bool isLoadingHistory;

  /// True when the server indicated more older pages exist.
  final bool hasMoreHistory;

  /// Cursor for the next older page.
  final String? oldestCursor;

  ClubChatConnected copyWith({
    List<ChatMessage>? messages,
    bool? isLoadingHistory,
    bool? hasMoreHistory,
    String? oldestCursor,
  }) =>
      ClubChatConnected(
        messages: messages ?? this.messages,
        isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
        hasMoreHistory: hasMoreHistory ?? this.hasMoreHistory,
        oldestCursor: oldestCursor ?? this.oldestCursor,
      );
}

class ClubChatError extends ClubChatState {
  const ClubChatError({required this.message});

  final String message;
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

/// Resolves the WebSocket base URL using the same dart-define pattern as the
/// HTTP layer (see `dio_provider.dart`). Falls back to localhost:8000.
String _resolveWsBaseUrl() {
  const fromDefine = String.fromEnvironment('API_WS_URL', defaultValue: '');
  if (fromDefine.isNotEmpty) return fromDefine;
  // Mirror the HTTP fallback: Android emulator uses 10.0.2.2 while iOS/desktop
  // uses 127.0.0.1. We read the same dart-define that dio_provider checks but
  // we can't import Platform in annotation-processed code easily, so default
  // to 127.0.0.1 here. Override via --dart-define=API_WS_URL for other envs.
  return 'ws://127.0.0.1:8000';
}

const _maxRetries = 5;
const _pingIntervalSeconds = 30;

@Riverpod(keepAlive: true)
class ClubChatNotifier extends _$ClubChatNotifier {
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  int _retryCount = 0;
  String? _token;

  ClubRepository get _repository => ref.read(clubRepositoryProvider);

  @override
  ClubChatState build(String clubId) {
    ref.onDispose(_cleanup);
    return const ClubChatConnecting();
  }

  // -------------------------------------------------------------------------
  // Public API
  // -------------------------------------------------------------------------

  /// Opens the WebSocket connection authenticated with [token].
  ///
  /// No-ops when already in [ClubChatConnected] to prevent message list reset
  /// on tab re-enter. Always updates the stored token for future reconnects.
  void connect(String token) {
    _token = token;
    if (state is ClubChatConnected) return;
    _retryCount = 0;
    _doConnect();
  }

  /// Sends a plain-text chat message to the server.
  void send(String content) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    if (_channel == null) return;

    final payload = jsonEncode({
      'type': 'chat.send',
      'club_id': clubId,
      'content': trimmed,
    });
    _channel!.sink.add(payload);
  }

  /// Sends a message quoting [replyToId].
  void sendWithReply({
    required String content,
    required String replyToId,
    required String replyToContent,
    required String replyToAuthor,
  }) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    if (_channel == null) return;

    final payload = jsonEncode({
      'type': 'chat.send',
      'club_id': clubId,
      'content': trimmed,
      'reply_to_id': replyToId,
      'reply_to_content': replyToContent,
      'reply_to_author': replyToAuthor,
    });
    _channel!.sink.add(payload);
  }

  /// Sends a message that includes an uploaded media URL.
  ///
  /// [content] may be empty when the user sends an image-only message.
  void sendWithMedia({
    required String mediaUrl,
    String content = '',
  }) {
    if (_channel == null) return;

    final payload = jsonEncode({
      'type': 'chat.send',
      'club_id': clubId,
      'content': content.trim(),
      'media_url': mediaUrl,
    });
    _channel!.sink.add(payload);
  }

  /// Sends a highlight citation card.
  void sendWithHighlight({
    required String highlightId,
    required String highlightQuote,
  }) {
    if (_channel == null) return;

    final payload = jsonEncode({
      'type': 'chat.send',
      'club_id': clubId,
      'content': '',
      'highlight_id': highlightId,
      'highlight_quote': highlightQuote,
    });
    _channel!.sink.add(payload);
  }

  /// Soft-deletes a message via the REST API. Removes it optimistically from
  /// local state; the WS broadcast will confirm shortly.
  Future<void> deleteMessage(String messageId) async {
    _removeMessageOptimistically(messageId);
    await _repository.deleteMessage(clubId, messageId);
  }

  /// Loads older messages from the REST history endpoint.
  ///
  /// No-ops when already loading or there is no more history.
  Future<void> loadHistory() async {
    final current = state;
    if (current is! ClubChatConnected) return;
    if (current.isLoadingHistory) return;
    if (current.messages.isNotEmpty && !current.hasMoreHistory) return;

    state = current.copyWith(isLoadingHistory: true);

    try {
      final result = await _repository.listMessages(
        clubId,
        cursor: current.oldestCursor,
      );

      final connected = state;
      if (connected is! ClubChatConnected) return;

      // Prepend older messages, deduplicating by id.
      final existingIds = connected.messages.map((m) => m.id).toSet();
      final older =
          result.messages.where((m) => !existingIds.contains(m.id)).toList();

      state = connected.copyWith(
        messages: [...older, ...connected.messages],
        isLoadingHistory: false,
        hasMoreHistory: result.nextCursor != null,
        oldestCursor: result.nextCursor ?? connected.oldestCursor,
      );
    } catch (_) {
      final connected = state;
      if (connected is ClubChatConnected) {
        state = connected.copyWith(isLoadingHistory: false);
      }
    }
  }

  // -------------------------------------------------------------------------
  // Connection lifecycle
  // -------------------------------------------------------------------------

  void _doConnect() {
    // Cancel previous subscription and channel before creating a new one to
    // prevent duplicate _onMessage handlers on reconnect.
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;

    state = const ClubChatConnecting();

    final uri = Uri.parse(
      '${_resolveWsBaseUrl()}/ws/clubs/$clubId/chat'
      '?token=${Uri.encodeComponent(_token ?? '')}',
    );

    try {
      _channel = WebSocketChannel.connect(uri);
      _subscription = _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
      _retryCount = 0;
      _startPing();
      state = const ClubChatConnected(messages: [], hasMoreHistory: true);
    } catch (e) {
      _scheduleReconnect();
    }
  }

  void _onMessage(dynamic raw) {
    final Map<String, dynamic> envelope;
    try {
      envelope = jsonDecode(raw as String) as Map<String, dynamic>;
    } catch (_) {
      return;
    }

    final type = envelope['type'] as String?;

    switch (type) {
      case 'pong':
        // Server acknowledged our ping — nothing to do.
        break;

      case 'chat.message':
        final data = envelope['data'];
        if (data is Map<String, dynamic>) {
          _appendMessage(ChatMessage.fromJson(data));
        }

      case 'chat.history':
        // Optional: server may push recent history on connect.
        final items = envelope['data'];
        if (items is List) {
          final msgs = items
              .whereType<Map<String, dynamic>>()
              .map(ChatMessage.fromJson)
              .toList();
          state = ClubChatConnected(messages: msgs, hasMoreHistory: true);
        }

      case 'chat.deleted':
        final data = envelope['data'];
        if (data is Map<String, dynamic>) {
          final id = data['id'] as String?;
          if (id != null) _removeMessageOptimistically(id);
        }

      default:
        // Unknown frame — silently ignore to stay forward-compatible.
        break;
    }
  }

  void _appendMessage(ChatMessage msg) {
    final current = state;
    if (current is ClubChatConnected) {
      state = current.copyWith(messages: [...current.messages, msg]);
    } else {
      state = ClubChatConnected(messages: [msg]);
    }
  }

  void _removeMessageOptimistically(String messageId) {
    final current = state;
    if (current is! ClubChatConnected) return;
    state = current.copyWith(
      messages: current.messages.where((m) => m.id != messageId).toList(),
    );
  }

  void _onError(Object error) {
    state = ClubChatError(message: error.toString());
    _scheduleReconnect();
  }

  void _onDone() {
    _scheduleReconnect();
  }

  // -------------------------------------------------------------------------
  // Reconnect with exponential backoff
  // -------------------------------------------------------------------------

  void _scheduleReconnect() {
    if (_retryCount >= _maxRetries) {
      state = const ClubChatError(
        message: '연결에 실패했어요. 잠시 후 다시 시도해 주세요.',
      );
      return;
    }

    _pingTimer?.cancel();
    _reconnectTimer?.cancel();

    final delaySeconds = min(30, pow(2, _retryCount).toInt());
    _retryCount++;

    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      if (_token != null) _doConnect();
    });
  }

  // -------------------------------------------------------------------------
  // Ping / pong
  // -------------------------------------------------------------------------

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer =
        Timer.periodic(const Duration(seconds: _pingIntervalSeconds), (_) {
      _channel?.sink.add(jsonEncode({'type': 'ping'}));
    });
  }

  // -------------------------------------------------------------------------
  // Cleanup
  // -------------------------------------------------------------------------

  void _cleanup() {
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;
  }
}

// ---------------------------------------------------------------------------
// Room-specific chat notifier (M29)
// ---------------------------------------------------------------------------

/// Real-time chat notifier scoped to a single chapter-gated room.
///
/// Mirrors [ClubChatNotifier] but connects to the room-specific WebSocket
/// endpoint: `/ws/clubs/{clubId}/rooms/{roomId}/chat`.
@Riverpod(keepAlive: true)
class ClubRoomChatNotifier extends _$ClubRoomChatNotifier {
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  int _retryCount = 0;
  String? _token;

  ClubRepository get _repository => ref.read(clubRepositoryProvider);

  @override
  ClubChatState build(String clubId, String roomId) {
    ref.onDispose(_cleanup);
    return const ClubChatConnecting();
  }

  void connect(String token) {
    _token = token;
    if (state is ClubChatConnected) return;
    _retryCount = 0;
    _doConnect();
  }

  void send(String content) {
    final trimmed = content.trim();
    if (trimmed.isEmpty || _channel == null) return;
    final payload = jsonEncode({
      'type': 'chat.send',
      'club_id': clubId,
      'room_id': roomId,
      'content': trimmed,
    });
    _channel!.sink.add(payload);
  }

  void sendWithReply({
    required String content,
    required String replyToId,
    required String replyToContent,
    required String replyToAuthor,
  }) {
    final trimmed = content.trim();
    if (trimmed.isEmpty || _channel == null) return;
    final payload = jsonEncode({
      'type': 'chat.send',
      'club_id': clubId,
      'room_id': roomId,
      'content': trimmed,
      'reply_to_id': replyToId,
      'reply_to_content': replyToContent,
      'reply_to_author': replyToAuthor,
    });
    _channel!.sink.add(payload);
  }

  void sendWithMedia({required String mediaUrl, String content = ''}) {
    if (_channel == null) return;
    final payload = jsonEncode({
      'type': 'chat.send',
      'club_id': clubId,
      'room_id': roomId,
      'content': content.trim(),
      'media_url': mediaUrl,
    });
    _channel!.sink.add(payload);
  }

  void sendWithHighlight({
    required String highlightId,
    required String highlightQuote,
  }) {
    if (_channel == null) return;
    final payload = jsonEncode({
      'type': 'chat.send',
      'club_id': clubId,
      'room_id': roomId,
      'content': '',
      'highlight_id': highlightId,
      'highlight_quote': highlightQuote,
    });
    _channel!.sink.add(payload);
  }

  Future<void> deleteMessage(String messageId) async {
    _removeMessageOptimistically(messageId);
    await _repository.deleteMessage(clubId, messageId);
  }

  Future<void> loadHistory() async {
    final current = state;
    if (current is! ClubChatConnected) return;
    if (current.isLoadingHistory) return;
    if (current.messages.isNotEmpty && !current.hasMoreHistory) return;

    state = current.copyWith(isLoadingHistory: true);

    try {
      final result = await _repository.listMessages(
        clubId,
        cursor: current.oldestCursor,
      );

      final connected = state;
      if (connected is! ClubChatConnected) return;

      final existingIds = connected.messages.map((m) => m.id).toSet();
      final older =
          result.messages.where((m) => !existingIds.contains(m.id)).toList();

      state = connected.copyWith(
        messages: [...older, ...connected.messages],
        isLoadingHistory: false,
        hasMoreHistory: result.nextCursor != null,
        oldestCursor: result.nextCursor ?? connected.oldestCursor,
      );
    } catch (_) {
      final connected = state;
      if (connected is ClubChatConnected) {
        state = connected.copyWith(isLoadingHistory: false);
      }
    }
  }

  void _doConnect() {
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;

    state = const ClubChatConnecting();

    final uri = Uri.parse(
      '${_resolveWsBaseUrl()}/ws/clubs/$clubId/rooms/$roomId/chat'
      '?token=${Uri.encodeComponent(_token ?? '')}',
    );

    try {
      _channel = WebSocketChannel.connect(uri);
      _subscription = _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
      _retryCount = 0;
      _startPing();
      state = const ClubChatConnected(messages: [], hasMoreHistory: true);
    } catch (e) {
      _scheduleReconnect();
    }
  }

  void _onMessage(dynamic raw) {
    final Map<String, dynamic> envelope;
    try {
      envelope = jsonDecode(raw as String) as Map<String, dynamic>;
    } catch (_) {
      return;
    }

    final type = envelope['type'] as String?;

    switch (type) {
      case 'pong':
        break;

      case 'chat.message':
        final data = envelope['data'];
        if (data is Map<String, dynamic>) {
          _appendMessage(ChatMessage.fromJson(data));
        }

      case 'chat.history':
        final items = envelope['data'];
        if (items is List) {
          final msgs = items
              .whereType<Map<String, dynamic>>()
              .map(ChatMessage.fromJson)
              .toList();
          state = ClubChatConnected(messages: msgs, hasMoreHistory: true);
        }

      case 'chat.deleted':
        final data = envelope['data'];
        if (data is Map<String, dynamic>) {
          final id = data['id'] as String?;
          if (id != null) _removeMessageOptimistically(id);
        }

      default:
        break;
    }
  }

  void _appendMessage(ChatMessage msg) {
    final current = state;
    if (current is ClubChatConnected) {
      state = current.copyWith(messages: [...current.messages, msg]);
    } else {
      state = ClubChatConnected(messages: [msg]);
    }
  }

  void _removeMessageOptimistically(String messageId) {
    final current = state;
    if (current is! ClubChatConnected) return;
    state = current.copyWith(
      messages: current.messages.where((m) => m.id != messageId).toList(),
    );
  }

  void _onError(Object error) {
    state = ClubChatError(message: error.toString());
    _scheduleReconnect();
  }

  void _onDone() {
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_retryCount >= _maxRetries) {
      state = const ClubChatError(
        message: '연결에 실패했어요. 잠시 후 다시 시도해 주세요.',
      );
      return;
    }

    _pingTimer?.cancel();
    _reconnectTimer?.cancel();

    final delaySeconds = min(30, pow(2, _retryCount).toInt());
    _retryCount++;

    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      if (_token != null) _doConnect();
    });
  }

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer =
        Timer.periodic(const Duration(seconds: _pingIntervalSeconds), (_) {
      _channel?.sink.add(jsonEncode({'type': 'ping'}));
    });
  }

  void _cleanup() {
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;
  }
}
