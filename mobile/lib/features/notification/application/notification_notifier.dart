import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/storage/secure_storage.dart';
import '../data/notification_models.dart';
import '../data/notification_repository.dart';
import 'notification_state.dart';

part 'notification_notifier.g.dart';

/// Resolves the WebSocket base URL. Mirrors the pattern in club_chat_notifier.
String _resolveWsBaseUrl() {
  const fromDefine = String.fromEnvironment('API_WS_URL', defaultValue: '');
  if (fromDefine.isNotEmpty) return fromDefine;
  return 'ws://127.0.0.1:8000';
}

const _notifMaxRetries = 5;
const _notifPingIntervalSeconds = 30;

/// Manages the notification list with cursor-based pagination and a
/// persistent WebSocket connection for real-time delivery.
///
/// Lifecycle:
///   • [build] opens /ws/me immediately so the badge stays live without
///     requiring the full notification screen to be mounted.
///   • WS events of type `notification` are prepended to [items] and
///     increment [unreadCount] so the bell badge updates instantly.
///   • [load] / [loadMore] back-fill from the REST endpoint.
///   • [markRead] / [markAllRead] optimistically patch local state.
///   • [ref.onDispose] tears down the WS cleanly.
@Riverpod(keepAlive: true)
class NotificationNotifier extends _$NotificationNotifier {
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  int _retryCount = 0;

  @override
  NotificationState build() {
    ref.onDispose(_cleanup);
    // Kick off the WebSocket after the first frame so the provider graph
    // is fully initialised before we access secureStorageProvider.
    Future.microtask(_connectWs);
    return const NotificationState();
  }

  // ---------------------------------------------------------------------------
  // REST pagination
  // ---------------------------------------------------------------------------

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final resp = await ref
          .read(notificationRepositoryProvider)
          .getNotifications(limit: 20);
      state = NotificationState(
        items: resp.items,
        nextCursor: resp.nextCursor,
        unreadCount: resp.unreadCount,
        hasMore: resp.nextCursor != null,
        wsConnected: state.wsConnected,
      );
    } on NotificationRepositoryException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      final resp =
          await ref.read(notificationRepositoryProvider).getNotifications(
                cursor: state.nextCursor,
                limit: 20,
              );
      state = state.copyWith(
        items: [...state.items, ...resp.items],
        nextCursor: resp.nextCursor,
        unreadCount: resp.unreadCount,
        hasMore: resp.nextCursor != null,
        isLoading: false,
      );
    } on NotificationRepositoryException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  // ---------------------------------------------------------------------------
  // Read / mark actions
  // ---------------------------------------------------------------------------

  /// Marks a notification as read locally first (optimistic update), then
  /// syncs to the backend. On failure the item stays read locally — a
  /// subsequent [load] will reconcile from the server.
  Future<void> markRead(String id) async {
    final now = DateTime.now();
    state = state.copyWith(
      items: state.items.map((n) {
        if (n.id == id && n.readAt == null) {
          return n.copyWith(readAt: now);
        }
        return n;
      }).toList(),
      unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
    );
    try {
      await ref.read(notificationRepositoryProvider).markRead(id);
    } on NotificationRepositoryException {
      // Silent — optimistic state is good enough for UX continuity.
    }
  }

  /// Marks every visible notification as read in a single PATCH call.
  /// Badge drops to 0 immediately; a background REST call confirms with server.
  Future<void> markAllRead() async {
    final now = DateTime.now();
    state = state.copyWith(
      items: state.items
          .map((n) => n.readAt == null ? n.copyWith(readAt: now) : n)
          .toList(),
      unreadCount: 0,
    );
    try {
      await ref.read(notificationRepositoryProvider).markAllRead();
    } on NotificationRepositoryException {
      // Silent — same rationale as markRead.
    }
  }

  /// Refreshes only the unread count badge — called periodically from
  /// [NotificationBell] without triggering a full list reload.
  Future<void> refreshUnreadCount() async {
    try {
      final count =
          await ref.read(notificationRepositoryProvider).getUnreadCount();
      state = state.copyWith(unreadCount: count);
    } on NotificationRepositoryException {
      // Badge failure is non-critical — keep the stale value shown.
    }
  }

  // ---------------------------------------------------------------------------
  // WebSocket lifecycle
  // ---------------------------------------------------------------------------

  Future<void> _connectWs() async {
    final token = await ref.read(secureStorageProvider).readAccessToken();
    if (token == null) return; // not authenticated yet
    _doConnect(token);
  }

  void _doConnect(String token) {
    final uri = Uri.parse(
      '${_resolveWsBaseUrl()}/ws/me?token=${Uri.encodeComponent(token)}',
    );

    try {
      _channel = WebSocketChannel.connect(uri);
      _subscription = _channel!.stream.listen(
        _onWsMessage,
        onError: (_) => _scheduleReconnect(),
        onDone: () => _scheduleReconnect(),
        cancelOnError: false,
      );
      _retryCount = 0;
      state = state.copyWith(wsConnected: true);
      _startPing();
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void _onWsMessage(dynamic raw) {
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

      case 'notification':
        // Real-time notification pushed by the server.
        final data = envelope['data'];
        if (data is Map<String, dynamic>) {
          _prependNotification(NotificationDto.fromJson(data));
        }

      default:
        // Forward-compatible: ignore unknown frames.
        break;
    }
  }

  void _prependNotification(NotificationDto dto) {
    // Deduplicate: WS may replay items already fetched via REST.
    final alreadyExists = state.items.any((n) => n.id == dto.id);
    if (alreadyExists) return;
    state = state.copyWith(
      items: [dto, ...state.items],
      unreadCount:
          dto.readAt == null ? state.unreadCount + 1 : state.unreadCount,
    );
  }

  void _scheduleReconnect() {
    if (_retryCount >= _notifMaxRetries) {
      state = state.copyWith(wsConnected: false);
      return;
    }
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();

    final delaySeconds = min(30, pow(2, _retryCount).toInt());
    _retryCount++;

    // Re-read the access token via _connectWs on every reconnect rather than
    // reusing the token captured at first connect. The REST refresh interceptor
    // rotates the access token; a stale token would keep failing the /ws/me
    // handshake with 403 after it expires (BC-25).
    _reconnectTimer = Timer(Duration(seconds: delaySeconds), _connectWs);
  }

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(
      const Duration(seconds: _notifPingIntervalSeconds),
      (_) => _channel?.sink.add(jsonEncode({'type': 'ping'})),
    );
  }

  void _cleanup() {
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;
  }
}
