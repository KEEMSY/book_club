// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => '북클럽';

  @override
  String get loginTitle => '독서를 함께하는\n스마트한 방법';

  @override
  String get loginKakao => '카카오로 시작하기';

  @override
  String get loginApple => 'Apple로 시작하기';

  @override
  String get timerStart => '시작';

  @override
  String get timerPause => '일시정지';

  @override
  String get timerResume => '재개';

  @override
  String get timerStop => '완료';

  @override
  String get timerGoal => '오늘 목표';

  @override
  String get timerAiPrep => '읽기 전 AI 준비';

  @override
  String get homeTabLibrary => '서재';

  @override
  String get homeTabFeed => '피드';

  @override
  String get homeTabClub => '클럽';

  @override
  String get homeTabDiscover => '탐색';

  @override
  String get homeTabProfile => '프로필';

  @override
  String get clubCreate => '클럽 만들기';

  @override
  String get clubJoin => '클럽 참여';

  @override
  String clubMembers(int count) {
    return '$count명';
  }

  @override
  String get proRequired => 'Pro 기능입니다';

  @override
  String get proUpgrade => 'Pro로 업그레이드';

  @override
  String get commonConfirm => '확인';

  @override
  String get commonCancel => '취소';

  @override
  String get commonSave => '저장';

  @override
  String get commonDelete => '삭제';

  @override
  String get commonLoading => '로딩 중...';

  @override
  String get commonError => '오류가 발생했습니다';

  @override
  String get commonRetry => '다시 시도';

  @override
  String get bookSearch => '책 검색';

  @override
  String get bookAdd => '내 서재에 추가';

  @override
  String get readingComplete => '독서 완료';

  @override
  String get challengeTitle => '챌린지';

  @override
  String get notificationTitle => '알림';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsLogout => '로그아웃';
}
