import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  const ClubChatConnected({required this.messages});

  final List<ChatMessage> messages;

  ClubChatConnected copyWith({List<ChatMessage>? messages}) =>
      ClubChatConnected(messages: messages ?? this.messages);
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
  const fromDefine =
      String.fromEnvironment('API_WS_URL', defaultValue: '');
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

  @override
  ClubChatState build(String clubId) {
    ref.onDispose(_cleanup);
    return const ClubChatConnecting();
  }

  // -------------------------------------------------------------------------
  // Public API
  // -------------------------------------------------------------------------

  /// Opens the WebSocket connection authenticated with [token].
  void connect(String token) {
    _token = token;
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

  // -------------------------------------------------------------------------
  // Connection lifecycle
  // -------------------------------------------------------------------------

  void _doConnect() {
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
      state = const ClubChatConnected(messages: []);
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
          state = ClubChatConnected(messages: msgs);
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
