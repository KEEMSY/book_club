import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko')
  ];

  /// No description provided for @appName.
  ///
  /// In ko, this message translates to:
  /// **'북클럽'**
  String get appName;

  /// No description provided for @loginTitle.
  ///
  /// In ko, this message translates to:
  /// **'독서를 함께하는\n스마트한 방법'**
  String get loginTitle;

  /// No description provided for @loginKakao.
  ///
  /// In ko, this message translates to:
  /// **'카카오로 시작하기'**
  String get loginKakao;

  /// No description provided for @loginApple.
  ///
  /// In ko, this message translates to:
  /// **'Apple로 시작하기'**
  String get loginApple;

  /// No description provided for @timerStart.
  ///
  /// In ko, this message translates to:
  /// **'시작'**
  String get timerStart;

  /// No description provided for @timerPause.
  ///
  /// In ko, this message translates to:
  /// **'일시정지'**
  String get timerPause;

  /// No description provided for @timerResume.
  ///
  /// In ko, this message translates to:
  /// **'재개'**
  String get timerResume;

  /// No description provided for @timerStop.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get timerStop;

  /// No description provided for @timerGoal.
  ///
  /// In ko, this message translates to:
  /// **'오늘 목표'**
  String get timerGoal;

  /// No description provided for @timerAiPrep.
  ///
  /// In ko, this message translates to:
  /// **'읽기 전 AI 준비'**
  String get timerAiPrep;

  /// No description provided for @homeTabLibrary.
  ///
  /// In ko, this message translates to:
  /// **'서재'**
  String get homeTabLibrary;

  /// No description provided for @homeTabFeed.
  ///
  /// In ko, this message translates to:
  /// **'피드'**
  String get homeTabFeed;

  /// No description provided for @homeTabClub.
  ///
  /// In ko, this message translates to:
  /// **'클럽'**
  String get homeTabClub;

  /// No description provided for @homeTabDiscover.
  ///
  /// In ko, this message translates to:
  /// **'탐색'**
  String get homeTabDiscover;

  /// No description provided for @homeTabProfile.
  ///
  /// In ko, this message translates to:
  /// **'프로필'**
  String get homeTabProfile;

  /// No description provided for @clubCreate.
  ///
  /// In ko, this message translates to:
  /// **'클럽 만들기'**
  String get clubCreate;

  /// No description provided for @clubJoin.
  ///
  /// In ko, this message translates to:
  /// **'클럽 참여'**
  String get clubJoin;

  /// No description provided for @clubMembers.
  ///
  /// In ko, this message translates to:
  /// **'{count}명'**
  String clubMembers(int count);

  /// No description provided for @proRequired.
  ///
  /// In ko, this message translates to:
  /// **'Pro 기능입니다'**
  String get proRequired;

  /// No description provided for @proUpgrade.
  ///
  /// In ko, this message translates to:
  /// **'Pro로 업그레이드'**
  String get proUpgrade;

  /// No description provided for @commonConfirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get commonConfirm;

  /// No description provided for @commonCancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get commonDelete;

  /// No description provided for @commonLoading.
  ///
  /// In ko, this message translates to:
  /// **'로딩 중...'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다'**
  String get commonError;

  /// No description provided for @commonRetry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get commonRetry;

  /// No description provided for @bookSearch.
  ///
  /// In ko, this message translates to:
  /// **'책 검색'**
  String get bookSearch;

  /// No description provided for @bookAdd.
  ///
  /// In ko, this message translates to:
  /// **'내 서재에 추가'**
  String get bookAdd;

  /// No description provided for @readingComplete.
  ///
  /// In ko, this message translates to:
  /// **'독서 완료'**
  String get readingComplete;

  /// No description provided for @challengeTitle.
  ///
  /// In ko, this message translates to:
  /// **'챌린지'**
  String get challengeTitle;

  /// No description provided for @notificationTitle.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get notificationTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get settingsLanguage;

  /// No description provided for @settingsLogout.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get settingsLogout;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
