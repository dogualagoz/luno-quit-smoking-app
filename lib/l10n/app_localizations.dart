import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('tr'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Cigerito Quit Smoking App'**
  String get appTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Cigerito Quit Smoking App! Let\'s embark on a smoke-free journey together.'**
  String get welcomeMessage;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @trackProgress.
  ///
  /// In en, this message translates to:
  /// **'Track your progress and see how far you\'ve come.'**
  String get trackProgress;

  /// No description provided for @setGoals.
  ///
  /// In en, this message translates to:
  /// **'Set your goals and stay motivated to quit smoking.'**
  String get setGoals;

  /// No description provided for @supportCommunity.
  ///
  /// In en, this message translates to:
  /// **'Join our supportive community of quitters.'**
  String get supportCommunity;

  /// No description provided for @tipsAndResources.
  ///
  /// In en, this message translates to:
  /// **'Access tips and resources to help you quit smoking.'**
  String get tipsAndResources;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations on taking the first step towards a healthier life!'**
  String get congratulations;

  /// No description provided for @daysWithoutSmoking.
  ///
  /// In en, this message translates to:
  /// **'Days without smoking'**
  String get daysWithoutSmoking;

  /// No description provided for @moneySaved.
  ///
  /// In en, this message translates to:
  /// **'Money saved'**
  String get moneySaved;

  /// No description provided for @healthBenefits.
  ///
  /// In en, this message translates to:
  /// **'Health benefits'**
  String get healthBenefits;

  /// No description provided for @quitDate.
  ///
  /// In en, this message translates to:
  /// **'Quit Date'**
  String get quitDate;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @successStories.
  ///
  /// In en, this message translates to:
  /// **'Success Stories'**
  String get successStories;

  /// No description provided for @shareYourStory.
  ///
  /// In en, this message translates to:
  /// **'Share your story and inspire others to quit smoking.'**
  String get shareYourStory;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need help? Reach out to our support team for assistance.'**
  String get needHelp;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get confirmLogout;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @damage.
  ///
  /// In en, this message translates to:
  /// **'Damage'**
  String get damage;

  /// No description provided for @crisis.
  ///
  /// In en, this message translates to:
  /// **'Crisis'**
  String get crisis;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @settingsHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings ⚙️'**
  String get settingsHeaderTitle;

  /// No description provided for @settingsHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalize, organize, and know yourself.'**
  String get settingsHeaderSubtitle;

  /// No description provided for @toolsAndAppearance.
  ///
  /// In en, this message translates to:
  /// **'Tools & Appearance'**
  String get toolsAndAppearance;

  /// No description provided for @dailyAverage.
  ///
  /// In en, this message translates to:
  /// **'Daily average'**
  String get dailyAverage;

  /// No description provided for @packPrice.
  ///
  /// In en, this message translates to:
  /// **'Pack price'**
  String get packPrice;

  /// No description provided for @goalZeroReminder.
  ///
  /// In en, this message translates to:
  /// **'Goal is zero, remember.'**
  String get goalZeroReminder;

  /// No description provided for @customizationComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Customization coming soon'**
  String get customizationComingSoon;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share the app'**
  String get shareApp;

  /// No description provided for @suggestFeedback.
  ///
  /// In en, this message translates to:
  /// **'Suggest & Report'**
  String get suggestFeedback;

  /// No description provided for @errorScreenTest.
  ///
  /// In en, this message translates to:
  /// **'Error Screen Test (Developer)'**
  String get errorScreenTest;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Resources, disclaimers, and app info'**
  String get aboutSubtitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account Permanently?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountContent.
  ///
  /// In en, this message translates to:
  /// **'All your data and account will be permanently deleted. This action cannot be undone. Do you confirm?'**
  String get deleteAccountContent;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @securityRetryMessage.
  ///
  /// In en, this message translates to:
  /// **'For security, please sign out and sign in again before deleting the account.'**
  String get securityRetryMessage;

  /// No description provided for @smokingInfo.
  ///
  /// In en, this message translates to:
  /// **'Smoking Info'**
  String get smokingInfo;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout?'**
  String get logoutConfirmTitle;

  /// No description provided for @onboardingIntroSpeech.
  ///
  /// In en, this message translates to:
  /// **'Welcome! I\'m Cigerito. I\'m here to help you crush smoking for good.'**
  String get onboardingIntroSpeech;

  /// No description provided for @onboardingIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'You can do it'**
  String get onboardingIntroTitle;

  /// No description provided for @onboardingIntroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll plan together, fight together, and you will win. Ready to begin?'**
  String get onboardingIntroSubtitle;

  /// No description provided for @onboardingDailyCigarettesQuestion.
  ///
  /// In en, this message translates to:
  /// **'How many cigarettes do you smoke per day?'**
  String get onboardingDailyCigarettesQuestion;

  /// No description provided for @onboardingDailyCigarettesUnit.
  ///
  /// In en, this message translates to:
  /// **'cigarettes / day'**
  String get onboardingDailyCigarettesUnit;

  /// No description provided for @onboardingPacketPriceQuestion.
  ///
  /// In en, this message translates to:
  /// **'How much does a pack of cigarettes cost?'**
  String get onboardingPacketPriceQuestion;

  /// No description provided for @onboardingMonthlyExpenseLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly expense:'**
  String get onboardingMonthlyExpenseLabel;

  /// No description provided for @onboardingMonthlyExpenseHint.
  ///
  /// In en, this message translates to:
  /// **'With this money, you could eat at a nice restaurant every month.'**
  String get onboardingMonthlyExpenseHint;

  /// No description provided for @onboardingCigarettesTableauTitle.
  ///
  /// In en, this message translates to:
  /// **'Bitter Tableau'**
  String get onboardingCigarettesTableauTitle;

  /// No description provided for @onboardingCigarettesTotalCigarettes.
  ///
  /// In en, this message translates to:
  /// **'Total cigarettes'**
  String get onboardingCigarettesTotalCigarettes;

  /// No description provided for @onboardingCigarettesTowerHeight.
  ///
  /// In en, this message translates to:
  /// **'Tower height'**
  String get onboardingCigarettesTowerHeight;

  /// Count string showing the number of cigarettes smoked
  ///
  /// In en, this message translates to:
  /// **'{count} cigarettes'**
  String onboardingCigarettesCount(Object count);

  /// No description provided for @onboardingMoneyGainTitle.
  ///
  /// In en, this message translates to:
  /// **'Your savings if you quit'**
  String get onboardingMoneyGainTitle;

  /// No description provided for @onboardingMoneyGainInOneMonth.
  ///
  /// In en, this message translates to:
  /// **'In 1 month'**
  String get onboardingMoneyGainInOneMonth;

  /// No description provided for @onboardingMoneyGainInSixMonths.
  ///
  /// In en, this message translates to:
  /// **'In 6 months'**
  String get onboardingMoneyGainInSixMonths;

  /// No description provided for @onboardingMoneyGainInOneYear.
  ///
  /// In en, this message translates to:
  /// **'In 1 year'**
  String get onboardingMoneyGainInOneYear;

  /// No description provided for @onboardingMoneyGainInFiveYears.
  ///
  /// In en, this message translates to:
  /// **'In 5 years'**
  String get onboardingMoneyGainInFiveYears;

  /// No description provided for @reasonsHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get reasonsHealth;

  /// No description provided for @reasonsEconomy.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get reasonsEconomy;

  /// No description provided for @reasonsFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get reasonsFamily;

  /// No description provided for @reasonsBeauty.
  ///
  /// In en, this message translates to:
  /// **'Beauty'**
  String get reasonsBeauty;

  /// No description provided for @reasonsFreedom.
  ///
  /// In en, this message translates to:
  /// **'Freedom'**
  String get reasonsFreedom;

  /// No description provided for @reasonsSmell.
  ///
  /// In en, this message translates to:
  /// **'Smell'**
  String get reasonsSmell;

  /// No description provided for @reasonsFitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get reasonsFitness;

  /// No description provided for @reasonsLongerLife.
  ///
  /// In en, this message translates to:
  /// **'Longer life'**
  String get reasonsLongerLife;

  /// No description provided for @triggerMorningCoffee.
  ///
  /// In en, this message translates to:
  /// **'Morning coffee'**
  String get triggerMorningCoffee;

  /// No description provided for @triggerStressfulMoments.
  ///
  /// In en, this message translates to:
  /// **'Stressful moments'**
  String get triggerStressfulMoments;

  /// No description provided for @triggerAfterMeal.
  ///
  /// In en, this message translates to:
  /// **'After a meal'**
  String get triggerAfterMeal;

  /// No description provided for @triggerWithAlcohol.
  ///
  /// In en, this message translates to:
  /// **'With alcohol'**
  String get triggerWithAlcohol;

  /// No description provided for @triggerBoredom.
  ///
  /// In en, this message translates to:
  /// **'Boredom'**
  String get triggerBoredom;

  /// No description provided for @triggerBreakTime.
  ///
  /// In en, this message translates to:
  /// **'Break time'**
  String get triggerBreakTime;

  /// No description provided for @triggerNightTime.
  ///
  /// In en, this message translates to:
  /// **'Night time'**
  String get triggerNightTime;

  /// No description provided for @triggerOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get triggerOther;

  /// No description provided for @tryingFirstTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'First attempt'**
  String get tryingFirstTimeTitle;

  /// No description provided for @tryingFirstTimeDesc.
  ///
  /// In en, this message translates to:
  /// **'This time I\'m really determined'**
  String get tryingFirstTimeDesc;

  /// No description provided for @tryingSecondTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Tried 2-3 times'**
  String get tryingSecondTimeTitle;

  /// No description provided for @tryingSecondTimeDesc.
  ///
  /// In en, this message translates to:
  /// **'I\'ve fought before, I\'m experienced'**
  String get tryingSecondTimeDesc;

  /// No description provided for @tryingManyTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Many attempts'**
  String get tryingManyTimesTitle;

  /// No description provided for @tryingManyTimesDesc.
  ///
  /// In en, this message translates to:
  /// **'I\'ve tried many times but I\'m not giving up'**
  String get tryingManyTimesDesc;

  /// No description provided for @tryingNeverCountedTitle.
  ///
  /// In en, this message translates to:
  /// **'Never counted'**
  String get tryingNeverCountedTitle;

  /// No description provided for @tryingNeverCountedDesc.
  ///
  /// In en, this message translates to:
  /// **'I got lost in the quitting cycle'**
  String get tryingNeverCountedDesc;

  /// Message that mentions the number of years the user smoked
  ///
  /// In en, this message translates to:
  /// **'You\'ve smoked for {years} years, huh? Don\'t worry, quitting together shouldn\'t take even {years} days!'**
  String onboardingYearsInterstitialBubble(Object years);

  /// No description provided for @legalIntroSpeech.
  ///
  /// In en, this message translates to:
  /// **'No one will judge you here.\n\nThis journey is shaped by your will and correct information. Please answer honestly so I can help you best.'**
  String get legalIntroSpeech;

  /// No description provided for @legalFinalMedicalTitle.
  ///
  /// In en, this message translates to:
  /// **'Not medical advice'**
  String get legalFinalMedicalTitle;

  /// No description provided for @legalFinalMedicalDescription.
  ///
  /// In en, this message translates to:
  /// **'This app is not a medical device or treatment method. Always consult a healthcare professional during the smoking cessation process.'**
  String get legalFinalMedicalDescription;

  /// No description provided for @legalFinalPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Data privacy'**
  String get legalFinalPrivacyTitle;

  /// No description provided for @legalFinalPrivacyDescription.
  ///
  /// In en, this message translates to:
  /// **'All data is stored only on your device. We do not share personal health information with third parties.'**
  String get legalFinalPrivacyDescription;

  /// No description provided for @legalFinalPurposeTitle.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get legalFinalPurposeTitle;

  /// No description provided for @legalFinalPurposeDescription.
  ///
  /// In en, this message translates to:
  /// **'This app does not promote smoking. Its purpose is to raise awareness and support your quitting process.'**
  String get legalFinalPurposeDescription;

  /// No description provided for @authSelectionOnboardingComplete.
  ///
  /// In en, this message translates to:
  /// **'Onboarding completed!'**
  String get authSelectionOnboardingComplete;

  /// Greeting text shown after onboarding is finished, with the user's display name provided.
  ///
  /// In en, this message translates to:
  /// **'Amazing {userName}! I\'m ready to continue this journey with you. How would you like to proceed?'**
  String authSelectionGreeting(Object userName);

  /// No description provided for @authContinueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authContinueWithApple;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authContinueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with email'**
  String get authContinueWithEmail;

  /// No description provided for @authContinueAnonymously.
  ///
  /// In en, this message translates to:
  /// **'Continue anonymously'**
  String get authContinueAnonymously;

  /// No description provided for @authAnonymousInfo.
  ///
  /// In en, this message translates to:
  /// **'With anonymous login, your data stays only on this device. Create an account to sync across devices.'**
  String get authAnonymousInfo;

  /// No description provided for @authTermsNoticePrefix.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to '**
  String get authTermsNoticePrefix;

  /// No description provided for @authTermsNoticeTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get authTermsNoticeTerms;

  /// No description provided for @authTermsNoticeAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get authTermsNoticeAnd;

  /// No description provided for @authTermsNoticePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get authTermsNoticePrivacy;

  /// No description provided for @authTermsNoticeSuffix.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get authTermsNoticeSuffix;

  /// No description provided for @emailLoginSpeech.
  ///
  /// In en, this message translates to:
  /// **'Sign in with email and keep track of your data from anywhere!'**
  String get emailLoginSpeech;

  /// No description provided for @emailLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get emailLoginTitle;

  /// No description provided for @emailLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and password'**
  String get emailLoginSubtitle;

  /// No description provided for @emailLoginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLoginEmailLabel;

  /// No description provided for @emailLoginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'example@mail.com'**
  String get emailLoginEmailHint;

  /// No description provided for @emailLoginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get emailLoginPasswordLabel;

  /// No description provided for @emailLoginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get emailLoginPasswordHint;

  /// No description provided for @emailLoginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot my password'**
  String get emailLoginForgotPassword;

  /// No description provided for @emailLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get emailLoginButton;

  /// No description provided for @emailLoginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get emailLoginNoAccount;

  /// No description provided for @emailLoginSignUp.
  ///
  /// In en, this message translates to:
  /// **'Create one'**
  String get emailLoginSignUp;

  /// No description provided for @emailLoginOrFast.
  ///
  /// In en, this message translates to:
  /// **'or quick login'**
  String get emailLoginOrFast;

  /// No description provided for @emailRegisterSpeech.
  ///
  /// In en, this message translates to:
  /// **'Create a new account, I won\'t forget you!'**
  String get emailRegisterSpeech;

  /// No description provided for @emailRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get emailRegisterTitle;

  /// No description provided for @emailRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your free account now'**
  String get emailRegisterSubtitle;

  /// No description provided for @emailRegisterEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailRegisterEmailLabel;

  /// No description provided for @emailRegisterEmailHint.
  ///
  /// In en, this message translates to:
  /// **'example@mail.com'**
  String get emailRegisterEmailHint;

  /// No description provided for @emailRegisterPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get emailRegisterPasswordLabel;

  /// No description provided for @emailRegisterPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get emailRegisterPasswordHint;

  /// No description provided for @emailRegisterButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get emailRegisterButton;

  /// No description provided for @emailRegisterAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get emailRegisterAlreadyHaveAccount;

  /// No description provided for @emailRegisterLogin.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get emailRegisterLogin;

  /// No description provided for @emailRegisterOrFast.
  ///
  /// In en, this message translates to:
  /// **'or quick login'**
  String get emailRegisterOrFast;

  /// No description provided for @mainCigarettesDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cigarette Amount'**
  String get mainCigarettesDetailsTitle;

  /// No description provided for @mainCigarettesDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Long enough to pass these:'**
  String get mainCigarettesDetailsSubtitle;

  /// No description provided for @mainError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String mainError(Object error);

  /// No description provided for @mainTotalCigarettes.
  ///
  /// In en, this message translates to:
  /// **'Total cigarettes smoked'**
  String get mainTotalCigarettes;

  /// No description provided for @mainDistance.
  ///
  /// In en, this message translates to:
  /// **'End to end: {distance}'**
  String mainDistance(Object distance);

  /// No description provided for @mainHeight.
  ///
  /// In en, this message translates to:
  /// **'{height}m Height'**
  String mainHeight(Object height);

  /// No description provided for @mainMoneyDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cost Analysis'**
  String get mainMoneyDetailsTitle;

  /// No description provided for @mainMoneyDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You could have bought these:'**
  String get mainMoneyDetailsSubtitle;

  /// No description provided for @mainMoneyDetailsProjections.
  ///
  /// In en, this message translates to:
  /// **'Future Projections'**
  String get mainMoneyDetailsProjections;

  /// No description provided for @mainTotalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get mainTotalSpent;

  /// No description provided for @mainBurningText.
  ///
  /// In en, this message translates to:
  /// **'Burning second by second...'**
  String get mainBurningText;

  /// No description provided for @mainRecoveryDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Preparation to Quit'**
  String get mainRecoveryDetailsTitle;

  /// No description provided for @mainRecoveryDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What increases your preparation level?'**
  String get mainRecoveryDetailsSubtitle;

  /// No description provided for @mainRecoveryScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Your preparation to quit score'**
  String get mainRecoveryScoreLabel;

  /// No description provided for @welcomeScreenWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nCigerito'**
  String get welcomeScreenWelcome;

  /// No description provided for @welcomeScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to step into a smoke-free, healthy and free life?'**
  String get welcomeScreenSubtitle;

  /// No description provided for @welcomeScreenStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s begin'**
  String get welcomeScreenStart;

  /// No description provided for @welcomeScreenAlreadyMember.
  ///
  /// In en, this message translates to:
  /// **'Already a member? '**
  String get welcomeScreenAlreadyMember;

  /// No description provided for @welcomeScreenLogin.
  ///
  /// In en, this message translates to:
  /// **'Then sign in'**
  String get welcomeScreenLogin;

  /// No description provided for @smokingYearsQuestion.
  ///
  /// In en, this message translates to:
  /// **'How long have you been smoking?'**
  String get smokingYearsQuestion;

  /// No description provided for @smokingYearsUnit.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get smokingYearsUnit;

  /// No description provided for @smokingYearsOneYear.
  ///
  /// In en, this message translates to:
  /// **'1 year'**
  String get smokingYearsOneYear;

  /// No description provided for @smokingYearsMaxYear.
  ///
  /// In en, this message translates to:
  /// **'40 years'**
  String get smokingYearsMaxYear;

  /// No description provided for @smokingYearsSelected.
  ///
  /// In en, this message translates to:
  /// **'{year} years'**
  String smokingYearsSelected(Object year);

  /// No description provided for @summarySmoked.
  ///
  /// In en, this message translates to:
  /// **'cigarettes smoked'**
  String get summarySmoked;

  /// No description provided for @summarySpent.
  ///
  /// In en, this message translates to:
  /// **'spent'**
  String get summarySpent;

  /// No description provided for @summaryDaysLost.
  ///
  /// In en, this message translates to:
  /// **'days lost'**
  String get summaryDaysLost;

  /// No description provided for @summaryMinutesStolen.
  ///
  /// In en, this message translates to:
  /// **'mins stolen'**
  String get summaryMinutesStolen;

  /// No description provided for @summaryCarBuy.
  ///
  /// In en, this message translates to:
  /// **'You could have bought a new car with {money}.'**
  String summaryCarBuy(Object money);

  /// No description provided for @summaryNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name or nickname...'**
  String get summaryNameHint;

  /// No description provided for @timeDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Time Analysis'**
  String get timeDetailsTitle;

  /// No description provided for @timeDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What You Could Do Instead?'**
  String get timeDetailsSubtitle;

  /// No description provided for @timeDetailsTotalLost.
  ///
  /// In en, this message translates to:
  /// **'Total Lost'**
  String get timeDetailsTotalLost;

  /// No description provided for @timeDetailsDaysShort.
  ///
  /// In en, this message translates to:
  /// **'d '**
  String get timeDetailsDaysShort;

  /// No description provided for @timeDetailsHoursShort.
  ///
  /// In en, this message translates to:
  /// **'h '**
  String get timeDetailsHoursShort;

  /// No description provided for @timeDetailsMinsShort.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get timeDetailsMinsShort;

  /// No description provided for @timeDetailsHoursConst.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get timeDetailsHoursConst;

  /// No description provided for @timeDetailsEquivBookTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading a Book'**
  String get timeDetailsEquivBookTitle;

  /// No description provided for @timeDetailsEquivBookUnit.
  ///
  /// In en, this message translates to:
  /// **'books'**
  String get timeDetailsEquivBookUnit;

  /// No description provided for @timeDetailsEquivMovieTitle.
  ///
  /// In en, this message translates to:
  /// **'Watching a Movie'**
  String get timeDetailsEquivMovieTitle;

  /// No description provided for @timeDetailsEquivMovieUnit.
  ///
  /// In en, this message translates to:
  /// **'movies'**
  String get timeDetailsEquivMovieUnit;

  /// No description provided for @timeDetailsEquivLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning a New Language'**
  String get timeDetailsEquivLanguageTitle;

  /// No description provided for @timeDetailsEquivLanguageUnit.
  ///
  /// In en, this message translates to:
  /// **'languages (Basic)'**
  String get timeDetailsEquivLanguageUnit;

  /// No description provided for @recoveryFactorLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Limit Compliance'**
  String get recoveryFactorLimitTitle;

  /// No description provided for @recoveryFactorLimitDesc.
  ///
  /// In en, this message translates to:
  /// **'Your score increases every time you stay under your daily cigarette limit.'**
  String get recoveryFactorLimitDesc;

  /// No description provided for @recoveryFactorCrisisTitle.
  ///
  /// In en, this message translates to:
  /// **'Crisis Management'**
  String get recoveryFactorCrisisTitle;

  /// No description provided for @recoveryFactorCrisisDesc.
  ///
  /// In en, this message translates to:
  /// **'Using the \"Crisis\" button instead of smoking when you have a craving strengthens your willpower.'**
  String get recoveryFactorCrisisDesc;

  /// No description provided for @recoveryFactorTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Regular Tracking'**
  String get recoveryFactorTrackingTitle;

  /// No description provided for @recoveryFactorTrackingDesc.
  ///
  /// In en, this message translates to:
  /// **'Using the app every day and entering your data shows your determination.'**
  String get recoveryFactorTrackingDesc;

  /// No description provided for @recoveryFactorTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Time Gained'**
  String get recoveryFactorTimeTitle;

  /// No description provided for @recoveryFactorTimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Every minute you gain by not smoking brings you closer to freedom.'**
  String get recoveryFactorTimeDesc;

  /// No description provided for @cigarettesEquivStatueTitle.
  ///
  /// In en, this message translates to:
  /// **'Statue of Liberty'**
  String get cigarettesEquivStatueTitle;

  /// No description provided for @cigarettesEquivEiffelTitle.
  ///
  /// In en, this message translates to:
  /// **'Eiffel Tower'**
  String get cigarettesEquivEiffelTitle;

  /// No description provided for @cigarettesEquivBurjTitle.
  ///
  /// In en, this message translates to:
  /// **'Burj Khalifa'**
  String get cigarettesEquivBurjTitle;

  /// No description provided for @cigarettesEquivEverestTitle.
  ///
  /// In en, this message translates to:
  /// **'Mount Everest'**
  String get cigarettesEquivEverestTitle;

  /// No description provided for @cigarettesDetailsTimes.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get cigarettesDetailsTimes;

  /// No description provided for @moneyEquivCoffeeTitle.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get moneyEquivCoffeeTitle;

  /// No description provided for @moneyEquivCinemaTitle.
  ///
  /// In en, this message translates to:
  /// **'Cinema Ticket'**
  String get moneyEquivCinemaTitle;

  /// No description provided for @moneyEquivConsoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Gaming Console'**
  String get moneyEquivConsoleTitle;

  /// No description provided for @moneyEquivPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'High-end Phone'**
  String get moneyEquivPhoneTitle;

  /// No description provided for @moneyDetailsCount.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get moneyDetailsCount;

  /// No description provided for @moneyDetailsProjection1Week.
  ///
  /// In en, this message translates to:
  /// **'In 1 Week'**
  String get moneyDetailsProjection1Week;

  /// No description provided for @moneyDetailsProjection1Month.
  ///
  /// In en, this message translates to:
  /// **'In 1 Month'**
  String get moneyDetailsProjection1Month;

  /// No description provided for @moneyDetailsProjection1Year.
  ///
  /// In en, this message translates to:
  /// **'In 1 Year'**
  String get moneyDetailsProjection1Year;

  /// No description provided for @crisisQuote1.
  ///
  /// In en, this message translates to:
  /// **'This urge will pass in 3-5 minutes. You have overcome harder things.'**
  String get crisisQuote1;

  /// No description provided for @crisisQuote2.
  ///
  /// In en, this message translates to:
  /// **'Every crisis you resist is a victory that heals your lungs.'**
  String get crisisQuote2;

  /// No description provided for @crisisQuote3.
  ///
  /// In en, this message translates to:
  /// **'Breathe in, let it go. Not smoke, but clean air.'**
  String get crisisQuote3;

  /// No description provided for @crisisQuote4.
  ///
  /// In en, this message translates to:
  /// **'One cigarette steals 7 minutes of your life. But this crisis will pass in 5 minutes.'**
  String get crisisQuote4;

  /// No description provided for @crisisQuote5.
  ///
  /// In en, this message translates to:
  /// **'You resisted until today, you will resist now.'**
  String get crisisQuote5;

  /// No description provided for @crisisQuote6.
  ///
  /// In en, this message translates to:
  /// **'Your brain is tricking you. You\'re hearing the voice of habit, not a real desire.'**
  String get crisisQuote6;

  /// No description provided for @crisisQuote7.
  ///
  /// In en, this message translates to:
  /// **'If you overcome this moment, you will wake up stronger tomorrow.'**
  String get crisisQuote7;

  /// No description provided for @crisisQuote8.
  ///
  /// In en, this message translates to:
  /// **'A cigarette is not a solution. Just a 5-minute delay.'**
  String get crisisQuote8;

  /// No description provided for @crisisQuote9.
  ///
  /// In en, this message translates to:
  /// **'Cravings will decrease. Each one will be shorter than the last.'**
  String get crisisQuote9;

  /// No description provided for @crisisQuote10.
  ///
  /// In en, this message translates to:
  /// **'This moment is temporary. But your health is permanent.'**
  String get crisisQuote10;

  /// No description provided for @crisisBreathIn.
  ///
  /// In en, this message translates to:
  /// **'Breathe In'**
  String get crisisBreathIn;

  /// No description provided for @crisisBreathHold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get crisisBreathHold;

  /// No description provided for @crisisBreathOut.
  ///
  /// In en, this message translates to:
  /// **'Slowly Breathe Out'**
  String get crisisBreathOut;

  /// No description provided for @crisisModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Crisis Mode ⚡'**
  String get crisisModeTitle;

  /// No description provided for @crisisButtonText.
  ///
  /// In en, this message translates to:
  /// **'Craving Started!'**
  String get crisisButtonText;

  /// No description provided for @crisisButtonSubtext.
  ///
  /// In en, this message translates to:
  /// **'Press the button, we will get through this moment together.\nAverage crisis duration: 3-5 minutes'**
  String get crisisButtonSubtext;

  /// No description provided for @crisisStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Crisis Statistics'**
  String get crisisStatsTitle;

  /// No description provided for @crisisStatSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped cravings'**
  String get crisisStatSkipped;

  /// No description provided for @crisisStatThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get crisisStatThisWeek;

  /// No description provided for @crisisStatSuccessRate.
  ///
  /// In en, this message translates to:
  /// **'Success rate'**
  String get crisisStatSuccessRate;

  /// No description provided for @crisisSkipExercise.
  ///
  /// In en, this message translates to:
  /// **'Skip Exercise →'**
  String get crisisSkipExercise;

  /// No description provided for @crisisSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Great, You Resisted! 💪'**
  String get crisisSuccessTitle;

  /// No description provided for @crisisSuccessDescription.
  ///
  /// In en, this message translates to:
  /// **'You did breathing exercises for {timeStr} and overcame this crisis.\nNow save this moment — data will empower you.'**
  String crisisSuccessDescription(Object timeStr);

  /// No description provided for @crisisSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Crisis'**
  String get crisisSaveButton;

  /// No description provided for @crisisPassButton.
  ///
  /// In en, this message translates to:
  /// **'Pass Without Saving'**
  String get crisisPassButton;

  /// No description provided for @damageHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Damage Report'**
  String get damageHeaderTitle;

  /// No description provided for @damageHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I have bad news. I also have good news, but listen to the bad first.'**
  String get damageHeaderSubtitle;

  /// No description provided for @damageSpeechBubble.
  ///
  /// In en, this message translates to:
  /// **'Time to face the bitter truth. Are you ready? I\'m not.'**
  String get damageSpeechBubble;

  /// No description provided for @damageDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This data is based on averages. Actual damage may vary by person.'**
  String get damageDisclaimer;

  /// No description provided for @damageSources.
  ///
  /// In en, this message translates to:
  /// **'Sources: ACS, WHO, U.S. Surgeon General, CDC'**
  String get damageSources;

  /// No description provided for @damageTotalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Total damage spread over {years} years'**
  String damageTotalSubtitle(Object years);

  /// No description provided for @damageTotalScore.
  ///
  /// In en, this message translates to:
  /// **'General Damage Score'**
  String get damageTotalScore;

  /// No description provided for @statMoneyLabel.
  ///
  /// In en, this message translates to:
  /// **'Money Spent'**
  String get statMoneyLabel;

  /// No description provided for @statMoneySubtext.
  ///
  /// In en, this message translates to:
  /// **'₺{rate}/min burning'**
  String statMoneySubtext(Object rate);

  /// No description provided for @statMoneyAction.
  ///
  /// In en, this message translates to:
  /// **'what could you buy? — tap'**
  String get statMoneyAction;

  /// No description provided for @statTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time Lost'**
  String get statTimeLabel;

  /// No description provided for @statTimeSubtext.
  ///
  /// In en, this message translates to:
  /// **'The counter is running...'**
  String get statTimeSubtext;

  /// No description provided for @statTimeNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started yet'**
  String get statTimeNotStarted;

  /// No description provided for @statCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Cigarettes Smoked'**
  String get statCountLabel;

  /// No description provided for @statCountSubtext.
  ///
  /// In en, this message translates to:
  /// **'{distance} km — You could climb Everest'**
  String statCountSubtext(Object distance);

  /// No description provided for @statCountNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not measured yet'**
  String get statCountNotStarted;

  /// No description provided for @statPrepLabel.
  ///
  /// In en, this message translates to:
  /// **'Preparation Level'**
  String get statPrepLabel;

  /// No description provided for @statPrepSubtext.
  ///
  /// In en, this message translates to:
  /// **'You are {percent}% ready to quit'**
  String statPrepSubtext(Object percent);

  /// No description provided for @statPrepAction.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to quit? — tap'**
  String get statPrepAction;

  /// No description provided for @damageOrganLungs.
  ///
  /// In en, this message translates to:
  /// **'Lungs'**
  String get damageOrganLungs;

  /// No description provided for @damageOrganHeart.
  ///
  /// In en, this message translates to:
  /// **'Heart'**
  String get damageOrganHeart;

  /// No description provided for @damageOrganBlood.
  ///
  /// In en, this message translates to:
  /// **'Blood Circulation'**
  String get damageOrganBlood;

  /// No description provided for @damageOrganBrain.
  ///
  /// In en, this message translates to:
  /// **'Brain'**
  String get damageOrganBrain;

  /// No description provided for @damageOrganMouth.
  ///
  /// In en, this message translates to:
  /// **'Mouth & Throat'**
  String get damageOrganMouth;

  /// No description provided for @damageOrganStomach.
  ///
  /// In en, this message translates to:
  /// **'Stomach & Digestion'**
  String get damageOrganStomach;

  /// No description provided for @damageDesc0.
  ///
  /// In en, this message translates to:
  /// **'No serious damage yet, but the risk is increasing.'**
  String get damageDesc0;

  /// No description provided for @damageDesc1.
  ///
  /// In en, this message translates to:
  /// **'Early stage damage signs — {percent}% risk.'**
  String damageDesc1(Object percent);

  /// No description provided for @damageDesc2.
  ///
  /// In en, this message translates to:
  /// **'Medium level damage — {percent}% affected.'**
  String damageDesc2(Object percent);

  /// No description provided for @damageDesc3.
  ///
  /// In en, this message translates to:
  /// **'High damage — {percent}% capacity lost.'**
  String damageDesc3(Object percent);

  /// No description provided for @damageDesc4.
  ///
  /// In en, this message translates to:
  /// **'Critical level — {percent}% at serious risk.'**
  String damageDesc4(Object percent);

  /// No description provided for @damageOrganLungsQuote.
  ///
  /// In en, this message translates to:
  /// **'Being out of breath while climbing stairs is no coincidence.'**
  String get damageOrganLungsQuote;

  /// No description provided for @damageOrganHeartQuote.
  ///
  /// In en, this message translates to:
  /// **'Your heart loves you, but how long can it keep up this pace?'**
  String get damageOrganHeartQuote;

  /// No description provided for @damageOrganBloodQuote.
  ///
  /// In en, this message translates to:
  /// **'Your veins are hardening, every cigarette is another nail.'**
  String get damageOrganBloodQuote;

  /// No description provided for @damageOrganBrainQuote.
  ///
  /// In en, this message translates to:
  /// **'With every breath, less oxygen goes to your brain.'**
  String get damageOrganBrainQuote;

  /// No description provided for @damageOrganMouthQuote.
  ///
  /// In en, this message translates to:
  /// **'Your vocal cords are thickening with every smoke.'**
  String get damageOrganMouthQuote;

  /// No description provided for @damageOrganStomachQuote.
  ///
  /// In en, this message translates to:
  /// **'When your stomach fills with smoke, even eating becomes hard.'**
  String get damageOrganStomachQuote;

  /// No description provided for @diaryHistoryNoLogTitle.
  ///
  /// In en, this message translates to:
  /// **'No Logs Yet'**
  String get diaryHistoryNoLogTitle;

  /// No description provided for @diaryHistoryNoLogDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your first honest log to start your journey and see your progress.'**
  String get diaryHistoryNoLogDesc;

  /// No description provided for @diaryHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'My Diary 📖'**
  String get diaryHistoryTitle;

  /// No description provided for @diaryHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every step taken, every line written leads to a cleaner future.'**
  String get diaryHistorySubtitle;

  /// No description provided for @diaryHistoryToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get diaryHistoryToday;

  /// No description provided for @diaryHistoryYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get diaryHistoryYesterday;

  /// No description provided for @diaryHistoryFilterWeek.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get diaryHistoryFilterWeek;

  /// No description provided for @diaryHistoryFilterMonth.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get diaryHistoryFilterMonth;

  /// No description provided for @diaryHistoryFilterYear.
  ///
  /// In en, this message translates to:
  /// **'Y'**
  String get diaryHistoryFilterYear;

  /// No description provided for @diaryHistoryPages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get diaryHistoryPages;

  /// No description provided for @diaryHistoryStats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get diaryHistoryStats;

  /// No description provided for @diaryHistoryCigarettesPerDay.
  ///
  /// In en, this message translates to:
  /// **'cigs/day'**
  String get diaryHistoryCigarettesPerDay;

  /// No description provided for @diaryHistoryAvgWeek.
  ///
  /// In en, this message translates to:
  /// **'Average this week'**
  String get diaryHistoryAvgWeek;

  /// No description provided for @diaryHistoryAvgMonth.
  ///
  /// In en, this message translates to:
  /// **'Average this month'**
  String get diaryHistoryAvgMonth;

  /// No description provided for @diaryHistoryAvgYear.
  ///
  /// In en, this message translates to:
  /// **'Average this year'**
  String get diaryHistoryAvgYear;

  /// No description provided for @diarySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Summary'**
  String get diarySummaryTitle;

  /// No description provided for @diarySummaryUnitCigarette.
  ///
  /// In en, this message translates to:
  /// **'cigs'**
  String get diarySummaryUnitCigarette;

  /// No description provided for @diarySummaryUnitCurrency.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get diarySummaryUnitCurrency;

  /// No description provided for @diarySummaryUnitMinute.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get diarySummaryUnitMinute;

  /// No description provided for @diarySummaryBadgeLoss.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get diarySummaryBadgeLoss;

  /// No description provided for @diarySummaryBadgeClean.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get diarySummaryBadgeClean;

  /// No description provided for @diarySummaryResisted.
  ///
  /// In en, this message translates to:
  /// **'Resisted {count} cravings'**
  String diarySummaryResisted(Object count);

  /// No description provided for @diarySummaryCostTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Cost'**
  String get diarySummaryCostTitle;

  /// No description provided for @diarySummaryBadgeFinancial.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get diarySummaryBadgeFinancial;

  /// No description provided for @diarySummaryCostDesc.
  ///
  /// In en, this message translates to:
  /// **'Money burned'**
  String get diarySummaryCostDesc;

  /// No description provided for @diarySummaryTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Time Lost'**
  String get diarySummaryTimeTitle;

  /// No description provided for @diarySummaryBadgeTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get diarySummaryBadgeTime;

  /// No description provided for @diarySummaryTimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Time stolen from your life'**
  String get diarySummaryTimeDesc;

  /// No description provided for @diarySummaryButtonSlip.
  ///
  /// In en, this message translates to:
  /// **'I Smoked'**
  String get diarySummaryButtonSlip;

  /// No description provided for @diarySummaryMessageSlip.
  ///
  /// In en, this message translates to:
  /// **'Any step back from harm is a gain. You progress as long as you log.'**
  String get diarySummaryMessageSlip;

  /// No description provided for @diarySummaryMessageClean.
  ///
  /// In en, this message translates to:
  /// **'Crystal clean! No smoke today, one step closer to the goal.'**
  String get diarySummaryMessageClean;

  /// No description provided for @diarySummaryCompareSame.
  ///
  /// In en, this message translates to:
  /// **'Same as yesterday'**
  String get diarySummaryCompareSame;

  /// No description provided for @diarySummaryCompareCurrencyBetter.
  ///
  /// In en, this message translates to:
  /// **'Saved {amount} \$ compared to yesterday'**
  String diarySummaryCompareCurrencyBetter(Object amount);

  /// No description provided for @diarySummaryCompareCurrencyWorse.
  ///
  /// In en, this message translates to:
  /// **'Spent {amount} \$ more than yesterday'**
  String diarySummaryCompareCurrencyWorse(Object amount);

  /// No description provided for @diarySummaryCompareTimeBetter.
  ///
  /// In en, this message translates to:
  /// **'Saved {amount} minutes compared to yesterday'**
  String diarySummaryCompareTimeBetter(Object amount);

  /// No description provided for @diarySummaryCompareTimeWorse.
  ///
  /// In en, this message translates to:
  /// **'Lost {amount} minutes more than yesterday'**
  String diarySummaryCompareTimeWorse(Object amount);

  /// No description provided for @diarySummaryCompareCountBetter.
  ///
  /// In en, this message translates to:
  /// **'{amount} {unit} less than yesterday'**
  String diarySummaryCompareCountBetter(Object amount, Object unit);

  /// No description provided for @diarySummaryCompareCountWorse.
  ///
  /// In en, this message translates to:
  /// **'{amount} {unit} more than yesterday'**
  String diarySummaryCompareCountWorse(Object amount, Object unit);

  /// No description provided for @diaryQuickAddTitle.
  ///
  /// In en, this message translates to:
  /// **'A smoke burned...'**
  String get diaryQuickAddTitle;

  /// No description provided for @diaryQuickAddDesc.
  ///
  /// In en, this message translates to:
  /// **'Want to leave a note on why you smoked? Or just add the count?'**
  String get diaryQuickAddDesc;

  /// No description provided for @diaryQuickAddButtonSkip.
  ///
  /// In en, this message translates to:
  /// **'Never mind, just add 1 cig'**
  String get diaryQuickAddButtonSkip;

  /// No description provided for @diaryQuickAddButtonNote.
  ///
  /// In en, this message translates to:
  /// **'Share why you smoked'**
  String get diaryQuickAddButtonNote;

  /// No description provided for @diaryChartTooltipMeasure.
  ///
  /// In en, this message translates to:
  /// **'cigarette measurement'**
  String get diaryChartTooltipMeasure;

  /// No description provided for @diaryChartTooltipClean.
  ///
  /// In en, this message translates to:
  /// **'Yay! Clean day 🌱'**
  String get diaryChartTooltipClean;

  /// No description provided for @diaryChartTooltipWarning.
  ///
  /// In en, this message translates to:
  /// **'Be careful! ⚠️'**
  String get diaryChartTooltipWarning;

  /// No description provided for @diaryChartTooltipControl.
  ///
  /// In en, this message translates to:
  /// **'You are in control 👍'**
  String get diaryChartTooltipControl;

  /// No description provided for @diaryChartTooltipUnit.
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get diaryChartTooltipUnit;

  /// No description provided for @diaryCardStatusCravingResisted.
  ///
  /// In en, this message translates to:
  /// **'Craving Resisted'**
  String get diaryCardStatusCravingResisted;

  /// No description provided for @diaryCardStatusCount.
  ///
  /// In en, this message translates to:
  /// **'{count} units'**
  String diaryCardStatusCount(Object count);

  /// No description provided for @diaryCardIntensity.
  ///
  /// In en, this message translates to:
  /// **'Intensity: {intensity}/10'**
  String diaryCardIntensity(Object intensity);

  /// No description provided for @diaryCardBadgeResisted.
  ///
  /// In en, this message translates to:
  /// **'Resistance'**
  String get diaryCardBadgeResisted;

  /// No description provided for @diaryCardDetailLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get diaryCardDetailLocation;

  /// No description provided for @diaryCardDetailMood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get diaryCardDetailMood;

  /// No description provided for @diaryCardDetailActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get diaryCardDetailActivity;

  /// No description provided for @diaryCardDetailCompanion.
  ///
  /// In en, this message translates to:
  /// **'With Whom'**
  String get diaryCardDetailCompanion;

  /// No description provided for @diaryLogSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get diaryLogSave;

  /// No description provided for @diaryLogContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get diaryLogContinue;

  /// No description provided for @diaryChartDays.
  ///
  /// In en, this message translates to:
  /// **'Mon,Tue,Wed,Thu,Fri,Sat,Sun'**
  String get diaryChartDays;

  /// No description provided for @diaryChartMonths.
  ///
  /// In en, this message translates to:
  /// **'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec'**
  String get diaryChartMonths;

  /// No description provided for @diaryStepCondLabel.
  ///
  /// In en, this message translates to:
  /// **'CONDITIONS'**
  String get diaryStepCondLabel;

  /// No description provided for @diaryStepCondTitle.
  ///
  /// In en, this message translates to:
  /// **'What were you doing?'**
  String get diaryStepCondTitle;

  /// No description provided for @diaryStepCondOther.
  ///
  /// In en, this message translates to:
  /// **'Which activity? Please specify:'**
  String get diaryStepCondOther;

  /// No description provided for @diaryStepCondOtherHint.
  ///
  /// In en, this message translates to:
  /// **'After eating, with coffee etc...'**
  String get diaryStepCondOtherHint;

  /// No description provided for @diaryStepCongratTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re Awesome!'**
  String get diaryStepCongratTitle;

  /// No description provided for @diaryStepCongratDesc.
  ///
  /// In en, this message translates to:
  /// **'You managed to close today smoke-free. Your lungs are thanking you! 🫁✨'**
  String get diaryStepCongratDesc;

  /// No description provided for @diaryStepCongratAction.
  ///
  /// In en, this message translates to:
  /// **'Smoke-free Day Will Be Logged'**
  String get diaryStepCongratAction;

  /// No description provided for @diaryStepTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get diaryStepTimeLabel;

  /// No description provided for @diaryStepTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'When was it?'**
  String get diaryStepTimeTitle;

  /// No description provided for @diaryStepTimeAction.
  ///
  /// In en, this message translates to:
  /// **'To log current time, you can just continue.'**
  String get diaryStepTimeAction;

  /// No description provided for @diaryStepIntensityLabel.
  ///
  /// In en, this message translates to:
  /// **'CRAVING INTENSITY'**
  String get diaryStepIntensityLabel;

  /// No description provided for @diaryStepIntensityTitle.
  ///
  /// In en, this message translates to:
  /// **'How strong was your urge to smoke?'**
  String get diaryStepIntensityTitle;

  /// No description provided for @diaryStepIntensityMin.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get diaryStepIntensityMin;

  /// No description provided for @diaryStepIntensityMax.
  ///
  /// In en, this message translates to:
  /// **'Maddening!'**
  String get diaryStepIntensityMax;

  /// No description provided for @diaryStepLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'LOCATION'**
  String get diaryStepLocationLabel;

  /// No description provided for @diaryStepLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Where were you?'**
  String get diaryStepLocationTitle;

  /// No description provided for @diaryStepLocationHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get diaryStepLocationHome;

  /// No description provided for @diaryStepLocationWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get diaryStepLocationWork;

  /// No description provided for @diaryStepLocationOutside.
  ///
  /// In en, this message translates to:
  /// **'Outside'**
  String get diaryStepLocationOutside;

  /// No description provided for @diaryStepLocationCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get diaryStepLocationCar;

  /// No description provided for @diaryStepLocationCafe.
  ///
  /// In en, this message translates to:
  /// **'Cafe/Restaurant'**
  String get diaryStepLocationCafe;

  /// No description provided for @diaryStepLocationServiceComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Location service will be added soon!'**
  String get diaryStepLocationServiceComingSoon;

  /// No description provided for @diaryStepLocationFind.
  ///
  /// In en, this message translates to:
  /// **'Find My Location'**
  String get diaryStepLocationFind;

  /// No description provided for @diaryStepLocationManual.
  ///
  /// In en, this message translates to:
  /// **'Or enter manually:'**
  String get diaryStepLocationManual;

  /// No description provided for @diaryStepLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Type location name...'**
  String get diaryStepLocationHint;

  /// No description provided for @diaryStepNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'NOTES'**
  String get diaryStepNotesLabel;

  /// No description provided for @diaryStepNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Would you like to write what happened?'**
  String get diaryStepNotesTitle;

  /// No description provided for @diaryStepNotesHint.
  ///
  /// In en, this message translates to:
  /// **'You can write your feelings and triggers here...'**
  String get diaryStepNotesHint;

  /// No description provided for @diaryStepCompanionLabel.
  ///
  /// In en, this message translates to:
  /// **'SOCIAL CONTEXT'**
  String get diaryStepCompanionLabel;

  /// No description provided for @diaryStepCompanionTitle.
  ///
  /// In en, this message translates to:
  /// **'Who were you with?'**
  String get diaryStepCompanionTitle;

  /// No description provided for @diaryStepCompanionDesc.
  ///
  /// In en, this message translates to:
  /// **'Who got the smoke most? Let\'s pick just one.'**
  String get diaryStepCompanionDesc;

  /// No description provided for @diaryStepMoodLabel.
  ///
  /// In en, this message translates to:
  /// **'MOOD'**
  String get diaryStepMoodLabel;

  /// No description provided for @diaryStepMoodTitle.
  ///
  /// In en, this message translates to:
  /// **'How were you feeling?'**
  String get diaryStepMoodTitle;

  /// No description provided for @diaryStepMoodOther.
  ///
  /// In en, this message translates to:
  /// **'Which mood? Please specify:'**
  String get diaryStepMoodOther;

  /// No description provided for @diaryStepMoodOtherHint.
  ///
  /// In en, this message translates to:
  /// **'Anxious, Excited etc...'**
  String get diaryStepMoodOtherHint;

  /// No description provided for @diaryStepAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'AMOUNT'**
  String get diaryStepAmountLabel;

  /// No description provided for @diaryStepAmountTitle.
  ///
  /// In en, this message translates to:
  /// **'How many did you smoke?'**
  String get diaryStepAmountTitle;

  /// No description provided for @diaryStepAmountUnit.
  ///
  /// In en, this message translates to:
  /// **'cigs'**
  String get diaryStepAmountUnit;

  /// No description provided for @diaryStepCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'How was today?'**
  String get diaryStepCheckTitle;

  /// No description provided for @diaryStepCheckDesc.
  ///
  /// In en, this message translates to:
  /// **'Cigerito is taking notes. Did you smoke at all today?'**
  String get diaryStepCheckDesc;

  /// No description provided for @diaryStepCheckNoTitle.
  ///
  /// In en, this message translates to:
  /// **'No,\nI didn\'t!'**
  String get diaryStepCheckNoTitle;

  /// No description provided for @diaryStepCheckNoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Beat the craving'**
  String get diaryStepCheckNoSubtitle;

  /// No description provided for @diaryStepCheckYesTitle.
  ///
  /// In en, this message translates to:
  /// **'Yes,\nI did'**
  String get diaryStepCheckYesTitle;

  /// No description provided for @diaryStepCheckYesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Had a slip'**
  String get diaryStepCheckYesSubtitle;

  /// No description provided for @diaryStepStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'RESULT'**
  String get diaryStepStatusLabel;

  /// No description provided for @diaryStepStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Please indicate if you smoked'**
  String get diaryStepStatusTitle;

  /// No description provided for @diaryStepStatusYesTitle.
  ///
  /// In en, this message translates to:
  /// **'Yes, unfortunately I did'**
  String get diaryStepStatusYesTitle;

  /// No description provided for @diaryStepStatusYesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Not a defeat, just feedback.'**
  String get diaryStepStatusYesSubtitle;

  /// No description provided for @diaryStepStatusNoTitle.
  ///
  /// In en, this message translates to:
  /// **'No, I resisted!'**
  String get diaryStepStatusNoTitle;

  /// No description provided for @diaryStepStatusNoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Awesome, another victory!'**
  String get diaryStepStatusNoSubtitle;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get settingsThemeDark;

  /// No description provided for @settingsReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get settingsReminders;

  /// No description provided for @aboutDisclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get aboutDisclaimerTitle;

  /// No description provided for @aboutDisclaimerText.
  ///
  /// In en, this message translates to:
  /// **'This application does not provide medical advice. While the presented data is based on scientific sources, please consult a healthcare professional for your personal health situation. The app aims to support your smoking cessation process; it does not offer treatment or diagnosis.'**
  String get aboutDisclaimerText;

  /// No description provided for @aboutSourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Scientific Sources'**
  String get aboutSourcesTitle;

  /// No description provided for @aboutTosTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service (TOS)'**
  String get aboutTosTitle;

  /// No description provided for @aboutPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get aboutPrivacyTitle;

  /// No description provided for @aboutTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery Timeline'**
  String get aboutTimelineTitle;

  /// No description provided for @aboutSourcePrefix.
  ///
  /// In en, this message translates to:
  /// **'Source: '**
  String get aboutSourcePrefix;

  /// No description provided for @aboutDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get aboutDurationMinutes;

  /// No description provided for @aboutDurationHours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get aboutDurationHours;

  /// No description provided for @aboutDurationDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get aboutDurationDays;

  /// No description provided for @aboutDurationMonths.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get aboutDurationMonths;

  /// No description provided for @aboutDurationYears.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get aboutDurationYears;

  /// No description provided for @settingsTosText.
  ///
  /// In en, this message translates to:
  /// **'Last Update: January 1, 2026\n\n1. Acceptance\nBy using the Luno app (\"App\"), you agree to these Terms of Service (\"Terms\"). If you disagree with these terms, you should not use the App.\n\n2. Nature of the Service\nLuno is a motivation and tracking tool designed to assist your quitting process. The App does not offer medical diagnosis, advice, or treatment. You should contact a qualified healthcare professional for medical conditions.\n\n3. User Account\n- You are responsible for the security of your account.\n- Your data may be stored locally or on the cloud (Firebase) with your consent.\n\n4. Disclaimer\nLuno developers are not liable for any direct or indirect damages arising from the use of the app.\n\n5. Modifications\nLuno reserves the right to modify these Terms at any time without prior notice.\n\nContact: You can use the contact tools within the App for feedback and support.'**
  String get settingsTosText;

  /// No description provided for @settingsPrivacyText.
  ///
  /// In en, this message translates to:
  /// **'Last Update: January 1, 2026\n\nAt Luno, we highly value your privacy. This policy explains how your information is collected, used, and protected.\n\n1. Collected Information\n- Personal Information: Email address and login credentials provided voluntarily.\n- App Data: Profile details like daily cigarettes, age, price, and log info kept in History (craving/slip).\n\n2. Data Usage\n- Personalizing content (e.g., calculating money saved).\n- Improving app experience.\n\n3. Storage and Security\n- Data is stored on your device (Hive) and can also be securely encrypted on the cloud (Google Firebase).\n- All communication via Firebase is protected by SSL.\n\n4. Third-Party Sharing\nLuno does not share or sell your data to third parties without your explicit consent.\n\n5. Your Rights\nYou can request the deletion of your account and data at any time.\n\nContact Us: For all privacy-related questions, reach out to us at alagozdogu@gmail.com.'**
  String get settingsPrivacyText;

  /// No description provided for @recoveryProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery Progress'**
  String get recoveryProgressTitle;

  /// No description provided for @settingsCustomization.
  ///
  /// In en, this message translates to:
  /// **'Cigerito Customization'**
  String get settingsCustomization;

  /// No description provided for @errorSimulation.
  ///
  /// In en, this message translates to:
  /// **'Error Screen Simulation'**
  String get errorSimulation;
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
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
