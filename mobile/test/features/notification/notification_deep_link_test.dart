import 'package:book_club/core/router/app_router.dart';
import 'package:book_club/features/notification/data/notification_models.dart';
import 'package:book_club/features/notification/presentation/notification_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  NotificationDto buildDto({
    required String ntype,
    Map<String, String> data = const {},
  }) {
    return NotificationDto(
      id: 'notif-1',
      ntype: ntype,
      title: 'title',
      body: 'body',
      data: data,
      createdAt: DateTime(2026, 8, 1),
    );
  }

  group('BC-52 club-session notification deep links', () {
    test('session_opened pushes to the session detail route', () {
      final target = notificationDeepLink(
        buildDto(
          ntype: 'session_opened',
          data: const {'club_id': 'club-1', 'session_id': 'session-1'},
        ),
      );

      expect(target, isNotNull);
      expect(target!.path, AppRoutes.sessionDetail('club-1', 'session-1'));
      expect(target.useGo, isFalse);
    });

    test('agenda_published pushes to the session detail route', () {
      final target = notificationDeepLink(
        buildDto(
          ntype: 'agenda_published',
          data: const {'club_id': 'club-1', 'session_id': 'session-1'},
        ),
      );

      expect(target, isNotNull);
      expect(target!.path, AppRoutes.sessionDetail('club-1', 'session-1'));
    });

    test('discussion_commented carries topic_id through as a focus target', () {
      final target = notificationDeepLink(
        buildDto(
          ntype: 'discussion_commented',
          data: const {
            'club_id': 'club-1',
            'session_id': 'session-1',
            'topic_id': 'topic-1',
          },
        ),
      );

      expect(target, isNotNull);
      expect(
        target!.path,
        AppRoutes.sessionDetail('club-1', 'session-1', topicId: 'topic-1'),
      );
    });

    test('returns null when club_id or session_id is missing', () {
      expect(notificationDeepLink(buildDto(ntype: 'session_opened')), isNull);
      expect(
        notificationDeepLink(
          buildDto(ntype: 'agenda_published', data: const {'club_id': 'c1'}),
        ),
        isNull,
      );
    });
  });

  group('existing ntype routing stays intact', () {
    test('club_joined pushes to club detail', () {
      final target = notificationDeepLink(
        buildDto(ntype: 'club_joined', data: const {'club_id': 'club-1'}),
      );

      expect(target, isNotNull);
      expect(target!.path, AppRoutes.clubDetail('club-1'));
      expect(target.useGo, isFalse);
    });

    test('comment replaces the stack via go, not push', () {
      final target = notificationDeepLink(buildDto(ntype: 'comment'));

      expect(target, isNotNull);
      expect(target!.path, AppRoutes.community);
      expect(target.useGo, isTrue);
    });

    test('an unknown ntype resolves to no destination', () {
      expect(notificationDeepLink(buildDto(ntype: 'unknown_type')), isNull);
    });
  });
}
