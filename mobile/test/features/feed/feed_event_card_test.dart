import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/feed/application/feed_providers.dart';
import 'package:book_club/features/feed/domain/feed_event.dart';
import 'package:book_club/features/feed/presentation/widgets/feed_event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  FeedEvent buildEvent({
    required String eventType,
    Map<String, dynamic> eventMetadata = const {},
  }) {
    return FeedEvent(
      id: 'event-1',
      userId: 'user-1',
      eventType: eventType,
      eventMetadata: eventMetadata,
      reactions: const [],
      commentCount: 0,
      createdAt: DateTime(2026, 8, 1),
    );
  }

  Widget buildApp(FeedEvent event, {VoidCallback? onTapCard}) {
    return ProviderScope(
      overrides: <Override>[
        feedRepositoryProvider.overrideWithValue(FakeFeedRepository()),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: FeedEventCard(
            event: event,
            currentUserId: 'user-1',
            onTapComments: () {},
            onReactionToggled: (_, __) {},
            onTapCard: onTapCard,
          ),
        ),
      ),
    );
  }

  group('BC-52 club-session feed cards', () {
    testWidgets('session_opened renders "새 회차가 열렸어요"', (tester) async {
      await tester.pumpWidget(
        buildApp(
          buildEvent(
            eventType: 'session_opened',
            eventMetadata: {
              'club_id': 'club-1',
              'session_id': 'session-1',
              'book_id': 'book-1',
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('새 회차가 열렸어요'), findsOneWidget);
      expect(find.text('새 회차'), findsOneWidget);
    });

    testWidgets('agenda_published renders "새 발제문이 올라왔어요"', (tester) async {
      await tester.pumpWidget(
        buildApp(
          buildEvent(
            eventType: 'agenda_published',
            eventMetadata: {
              'club_id': 'club-1',
              'session_id': 'session-1',
              'agenda_id': 'agenda-1',
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('새 발제문이 올라왔어요'), findsOneWidget);
      expect(find.text('새 발제문'), findsOneWidget);
    });

    testWidgets('discussion_commented renders "토론에 새 답글이 달렸어요"', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          buildEvent(
            eventType: 'discussion_commented',
            eventMetadata: {
              'club_id': 'club-1',
              'session_id': 'session-1',
              'agenda_id': 'agenda-1',
              'topic_id': 'topic-1',
              'comment_id': 'comment-1',
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('토론에 새 답글이 달렸어요'), findsOneWidget);
      expect(find.text('토론 답글'), findsOneWidget);
    });

    testWidgets('tapping the card invokes onTapCard when provided', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        buildApp(
          buildEvent(
            eventType: 'session_opened',
            eventMetadata: {
              'club_id': 'club-1',
              'session_id': 'session-1',
              'book_id': 'book-1',
            },
          ),
          onTapCard: () => tapped = true,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('새 회차가 열렸어요'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets(
        'a non-club-session event stays non-interactive at the card '
        'level (no onTapCard wired)', (tester) async {
      await tester.pumpWidget(
        buildApp(buildEvent(eventType: 'BOOK_COMPLETED')),
      );
      await tester.pumpAndSettle();

      // No Material/InkWell wrapper renders when onTapCard is null — asserts
      // the widget skips the tap-wrapping branch entirely rather than
      // silently attaching a no-op tap handler.
      expect(
        find.ancestor(of: find.text('완독했어요!'), matching: find.byType(InkWell)),
        findsNothing,
      );
    });
  });

  group('clubSessionDeepLinkFor', () {
    test('resolves ids for a club-session event', () {
      final event = buildEvent(
        eventType: 'agenda_published',
        eventMetadata: {
          'club_id': 'club-1',
          'session_id': 'session-1',
          'agenda_id': 'agenda-1',
        },
      );

      final link = clubSessionDeepLinkFor(event);

      expect(link, isNotNull);
      expect(link!.clubId, 'club-1');
      expect(link.sessionId, 'session-1');
      expect(link.topicId, isNull);
    });

    test('carries topicId through for discussion_commented', () {
      final event = buildEvent(
        eventType: 'discussion_commented',
        eventMetadata: {
          'club_id': 'club-1',
          'session_id': 'session-1',
          'agenda_id': 'agenda-1',
          'topic_id': 'topic-1',
          'comment_id': 'comment-1',
        },
      );

      final link = clubSessionDeepLinkFor(event);

      expect(link, isNotNull);
      expect(link!.topicId, 'topic-1');
    });

    test('returns null for a non-club-session event type', () {
      final event = buildEvent(eventType: 'BOOK_COMPLETED');
      expect(clubSessionDeepLinkFor(event), isNull);
    });

    test('returns null when required ids are missing from metadata', () {
      final event = buildEvent(
        eventType: 'session_opened',
        eventMetadata: const {},
      );
      expect(clubSessionDeepLinkFor(event), isNull);
    });
  });
}
