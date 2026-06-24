// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'BookClub';

  @override
  String get loginTitle => 'The smarter way\nto read together';

  @override
  String get loginKakao => 'Continue with Kakao';

  @override
  String get loginApple => 'Continue with Apple';

  @override
  String get timerStart => 'Start';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerResume => 'Resume';

  @override
  String get timerStop => 'Done';

  @override
  String get timerGoal => 'Today\'s Goal';

  @override
  String get timerAiPrep => 'AI Reading Prep';

  @override
  String get homeTabLibrary => 'Library';

  @override
  String get homeTabFeed => 'Feed';

  @override
  String get homeTabClub => 'Club';

  @override
  String get homeTabDiscover => 'Discover';

  @override
  String get homeTabProfile => 'Profile';

  @override
  String get clubCreate => 'Create Club';

  @override
  String get clubJoin => 'Join Club';

  @override
  String clubMembers(int count) {
    return '$count members';
  }

  @override
  String get proRequired => 'Pro feature';

  @override
  String get proUpgrade => 'Upgrade to Pro';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonError => 'An error occurred';

  @override
  String get commonRetry => 'Retry';

  @override
  String get bookSearch => 'Search books';

  @override
  String get bookAdd => 'Add to Library';

  @override
  String get readingComplete => 'Reading Complete';

  @override
  String get challengeTitle => 'Challenges';

  @override
  String get notificationTitle => 'Notifications';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLogout => 'Sign Out';
}
