// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'ブッククラブ';

  @override
  String get loginTitle => '一緒に読書する\nスマートな方法';

  @override
  String get loginKakao => 'Kakaoで始める';

  @override
  String get loginApple => 'Appleで続ける';

  @override
  String get timerStart => '開始';

  @override
  String get timerPause => '一時停止';

  @override
  String get timerResume => '再開';

  @override
  String get timerStop => '完了';

  @override
  String get timerGoal => '今日の目標';

  @override
  String get timerAiPrep => 'AI読書準備';

  @override
  String get homeTabLibrary => '書棚';

  @override
  String get homeTabFeed => 'フィード';

  @override
  String get homeTabClub => 'クラブ';

  @override
  String get homeTabDiscover => '発見';

  @override
  String get homeTabProfile => 'プロフィール';

  @override
  String get clubCreate => 'クラブを作る';

  @override
  String get clubJoin => 'クラブに参加';

  @override
  String clubMembers(int count) {
    return '$count人';
  }

  @override
  String get proRequired => 'Pro機能です';

  @override
  String get proUpgrade => 'Proにアップグレード';

  @override
  String get commonConfirm => '確認';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonSave => '保存';

  @override
  String get commonDelete => '削除';

  @override
  String get commonLoading => '読み込み中...';

  @override
  String get commonError => 'エラーが発生しました';

  @override
  String get commonRetry => '再試行';

  @override
  String get bookSearch => '本を検索';

  @override
  String get bookAdd => '書棚に追加';

  @override
  String get readingComplete => '読書完了';

  @override
  String get challengeTitle => 'チャレンジ';

  @override
  String get notificationTitle => '通知';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLogout => 'サインアウト';
}
