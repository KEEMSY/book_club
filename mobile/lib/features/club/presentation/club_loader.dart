import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/club_providers.dart';
import '../domain/club.dart';

/// Resolves a [Club] by id and hands it to [builder].
///
/// Deeplinks and push notifications only carry a club id, so the detail/chat
/// routes can land here without the full [Club] object their screens need.
/// This loader fetches the club once and renders loading/error scaffolds in
/// the meantime so those routes stay navigable from any entry point.
class ClubLoader extends ConsumerWidget {
  const ClubLoader({super.key, required this.clubId, required this.builder});

  final String clubId;
  final Widget Function(Club club) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(clubByIdProvider(clubId)).when(
          data: builder,
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('클럽을 불러오지 못했어요')),
          ),
        );
  }
}
