import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/session_providers.dart';
import '../domain/club_session.dart';

/// Resolves a [ClubSession] by id and hands it to [builder].
///
/// Mirrors [ClubLoader] (`club_loader.dart`) — feed-card taps (BC-52) and
/// push-notification deep links only carry a session id, so the session
/// detail route can land here without the full [ClubSession] object the
/// screen otherwise expects via router `extra`.
class SessionLoader extends ConsumerWidget {
  const SessionLoader({
    super.key,
    required this.sessionId,
    required this.builder,
  });

  final String sessionId;
  final Widget Function(ClubSession session) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(sessionByIdProvider(sessionId)).when(
          data: builder,
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (_, __) => Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('회차를 불러오지 못했어요')),
          ),
        );
  }
}
