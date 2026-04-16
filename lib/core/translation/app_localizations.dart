import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'translation/app_localizations.dart';
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
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @errorFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get errorFieldRequired;

  /// No description provided for @errorInvalidName.
  ///
  /// In en, this message translates to:
  /// **'Invalid name format'**
  String get errorInvalidName;

  /// No description provided for @errorInvalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Invalid URL'**
  String get errorInvalidUrl;

  /// No description provided for @errorInvalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get errorInvalidPhoneNumber;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get errorInvalidEmail;

  /// No description provided for @errorInvalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long with uppercase, lowercase, and special characters'**
  String get errorInvalidPassword;

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errorPasswordMismatch;

  /// No description provided for @errorInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get errorInvalidNumber;

  /// No description provided for @errorInvalidIban.
  ///
  /// In en, this message translates to:
  /// **'Invalid IBAN format'**
  String get errorInvalidIban;

  /// No description provided for @errorInvalidMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid mobile number'**
  String get errorInvalidMobileNumber;

  /// No description provided for @errorInvalidStcPayId.
  ///
  /// In en, this message translates to:
  /// **'Invalid STC Pay ID'**
  String get errorInvalidStcPayId;

  /// No description provided for @errorInvalidNationalId.
  ///
  /// In en, this message translates to:
  /// **'Invalid National ID'**
  String get errorInvalidNationalId;

  /// No description provided for @errorInvalidPassport.
  ///
  /// In en, this message translates to:
  /// **'Invalid passport number'**
  String get errorInvalidPassport;

  /// No description provided for @sorryMessage.
  ///
  /// In en, this message translates to:
  /// **'We are sorry'**
  String get sorryMessage;

  /// No description provided for @nothingFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing Found'**
  String get nothingFound;

  /// No description provided for @errorPhoneValidation.
  ///
  /// In en, this message translates to:
  /// **'The phone number must start with {start} and be {length} digits long.'**
  String errorPhoneValidation(Object length, Object start);

  /// No description provided for @errorExperienceRequired.
  ///
  /// In en, this message translates to:
  /// **'You must add at least one experience.'**
  String get errorExperienceRequired;

  /// No description provided for @errorIdDocumentRequired.
  ///
  /// In en, this message translates to:
  /// **'You must upload an ID document to verify your identity.'**
  String get errorIdDocumentRequired;

  /// No description provided for @errorPhotoRequired.
  ///
  /// In en, this message translates to:
  /// **'You must upload a photo with a white background'**
  String get errorPhotoRequired;

  /// No description provided for @updateAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get updateAvailableTitle;

  /// No description provided for @updateMandatoryMessage.
  ///
  /// In en, this message translates to:
  /// **'A new version of the app is available. Please update to continue using the app.'**
  String get updateMandatoryMessage;

  /// No description provided for @updateOptionalMessage.
  ///
  /// In en, this message translates to:
  /// **'A new version of the app is available. We recommend updating for the best experience.'**
  String get updateOptionalMessage;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @chooseImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Choose Image'**
  String get chooseImage;

  /// No description provided for @takePicture.
  ///
  /// In en, this message translates to:
  /// **'Upload Take Picture'**
  String get takePicture;

  /// No description provided for @chooseFromFiles.
  ///
  /// In en, this message translates to:
  /// **'Upload Choose From Files'**
  String get chooseFromFiles;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsPushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get settingsPushNotifications;

  /// No description provided for @settingsEmailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get settingsEmailNotifications;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsToneAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Tone Analysis'**
  String get settingsToneAnalysis;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @navHomeTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHomeTabLabel;

  /// No description provided for @navScheduleTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get navScheduleTabLabel;

  /// No description provided for @navNewsTabLabel.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get navNewsTabLabel;

  /// No description provided for @navMessagesTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get navMessagesTabLabel;

  /// No description provided for @navExpenseTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get navExpenseTabLabel;

  /// No description provided for @scheduleSharedCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Shared Calendar'**
  String get scheduleSharedCalendarTitle;

  /// No description provided for @scheduleNoEventsForDay.
  ///
  /// In en, this message translates to:
  /// **'No events for this day'**
  String get scheduleNoEventsForDay;

  /// No description provided for @scheduleEventTypePickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get scheduleEventTypePickup;

  /// No description provided for @scheduleEventTypeMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get scheduleEventTypeMedical;

  /// No description provided for @scheduleEventTypeActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get scheduleEventTypeActivity;

  /// No description provided for @scheduleEventTypeSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get scheduleEventTypeSchool;

  /// No description provided for @scheduleEventTypeCustody.
  ///
  /// In en, this message translates to:
  /// **'Custody'**
  String get scheduleEventTypeCustody;

  /// No description provided for @scheduleAllDay.
  ///
  /// In en, this message translates to:
  /// **'All Day'**
  String get scheduleAllDay;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get authLoginTitle;

  /// No description provided for @authLoginIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Masr Al-Osariya'**
  String get authLoginIntroTitle;

  /// No description provided for @authLoginIntroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start building a safe and organized co-parenting experience.'**
  String get authLoginIntroSubtitle;

  /// No description provided for @authEmailTab.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailTab;

  /// No description provided for @authPhoneTab.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get authPhoneTab;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authEmailEntryHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get authEmailEntryHint;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get authEmailHint;

  /// No description provided for @authPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get authPhoneLabel;

  /// No description provided for @authPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+20 123 456 7890'**
  String get authPhoneHint;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'********'**
  String get authPasswordHint;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// No description provided for @authLoginButton.
  ///
  /// In en, this message translates to:
  /// **'LOG IN'**
  String get authLoginButton;

  /// No description provided for @authOrContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get authOrContinueWith;

  /// No description provided for @authDontHaveAccountPrefix.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get authDontHaveAccountPrefix;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUp;

  /// No description provided for @authSignUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUpTitle;

  /// No description provided for @authSignUpIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'How will you use the app?'**
  String get authSignUpIntroTitle;

  /// No description provided for @authSignUpIntroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the option that best describes you.'**
  String get authSignUpIntroSubtitle;

  /// No description provided for @authFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullNameLabel;

  /// No description provided for @authFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullNameHint;

  /// No description provided for @authFirstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get authFirstNameLabel;

  /// No description provided for @authFirstNameHint.
  ///
  /// In en, this message translates to:
  /// **'John'**
  String get authFirstNameHint;

  /// No description provided for @authLastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get authLastNameLabel;

  /// No description provided for @authLastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Doe'**
  String get authLastNameHint;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authAgreeTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the '**
  String get authAgreeTermsPrefix;

  /// No description provided for @authTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get authTermsAndConditions;

  /// No description provided for @authAgreeTermsSuffix.
  ///
  /// In en, this message translates to:
  /// **' to continue.'**
  String get authAgreeTermsSuffix;

  /// No description provided for @authAgreeTermsToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms & Conditions to continue.'**
  String get authAgreeTermsToContinue;

  /// No description provided for @authOrShort.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get authOrShort;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authContinueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authContinueWithApple;

  /// No description provided for @authSignUpButton.
  ///
  /// In en, this message translates to:
  /// **'SIGN UP'**
  String get authSignUpButton;

  /// No description provided for @authAlreadyHaveAccountPrefix.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get authAlreadyHaveAccountPrefix;

  /// No description provided for @authLoginLink.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get authLoginLink;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get commonShare;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileMenuAccountSecurity.
  ///
  /// In en, this message translates to:
  /// **'Account & Security'**
  String get profileMenuAccountSecurity;

  /// No description provided for @profileMenuFamilyInformation.
  ///
  /// In en, this message translates to:
  /// **'Family Information'**
  String get profileMenuFamilyInformation;

  /// No description provided for @profileMenuNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileMenuNotifications;

  /// No description provided for @profileMenuLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileMenuLanguage;

  /// No description provided for @profileMenuTermsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get profileMenuTermsOfUse;

  /// No description provided for @profileMenuInvitePeople.
  ///
  /// In en, this message translates to:
  /// **'Invite People'**
  String get profileMenuInvitePeople;

  /// No description provided for @profileMenuLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileMenuLogout;

  /// No description provided for @profileTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get profileTermsTitle;

  /// No description provided for @profileTermsBody.
  ///
  /// In en, this message translates to:
  /// **'By using this application, you agree to the following terms and conditions. Please read them carefully before proceeding.\\n\\n1. You must be at least 18 years old to use this service.\\n\\n2. All information provided must be accurate and up to date.\\n\\n3. You are responsible for maintaining the confidentiality of your account.\\n\\n4. We reserve the right to modify these terms at any time.\\n\\n5. Any misuse of the platform may result in account suspension.'**
  String get profileTermsBody;

  /// No description provided for @profileInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite People'**
  String get profileInviteTitle;

  /// No description provided for @profileInviteDescription.
  ///
  /// In en, this message translates to:
  /// **'Share your invite code with family and friends.'**
  String get profileInviteDescription;

  /// No description provided for @profileLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogoutTitle;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get profileLogoutConfirm;

  /// No description provided for @accountSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Account & Security'**
  String get accountSecurityTitle;

  /// No description provided for @accountSecurityEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get accountSecurityEmailLabel;

  /// No description provided for @accountSecurityPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get accountSecurityPhoneLabel;

  /// No description provided for @accountSecurityChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get accountSecurityChangePassword;

  /// No description provided for @accountSecurityEnableTwoFactor.
  ///
  /// In en, this message translates to:
  /// **'Enable Two-Factor Authentication'**
  String get accountSecurityEnableTwoFactor;

  /// No description provided for @accountSecurityDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get accountSecurityDeleteAccount;

  /// No description provided for @accountSecurityDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get accountSecurityDeleteConfirm;

  /// No description provided for @familyInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Information'**
  String get familyInfoTitle;

  /// No description provided for @familyChildrenTitle.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get familyChildrenTitle;

  /// No description provided for @familyAddChild.
  ///
  /// In en, this message translates to:
  /// **'Add Child'**
  String get familyAddChild;

  /// No description provided for @familyInfoSaved.
  ///
  /// In en, this message translates to:
  /// **'Family information saved'**
  String get familyInfoSaved;

  /// No description provided for @familyCoParent.
  ///
  /// In en, this message translates to:
  /// **'Co-Parent'**
  String get familyCoParent;

  /// No description provided for @familyConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get familyConnected;

  /// No description provided for @familyYearsOld.
  ///
  /// In en, this message translates to:
  /// **'{age} years old'**
  String familyYearsOld(Object age);

  /// No description provided for @familyChildNameHint.
  ///
  /// In en, this message translates to:
  /// **'Child name'**
  String get familyChildNameHint;

  /// No description provided for @familyChildAgeHint.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get familyChildAgeHint;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll notify you when something arrives'**
  String get notificationsEmptySubtitle;

  /// No description provided for @notificationsNewMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'New Message'**
  String get notificationsNewMessageTitle;

  /// No description provided for @notificationsNewMessageBody.
  ///
  /// In en, this message translates to:
  /// **'Fatima sent you a message about this weekend\'s schedule.'**
  String get notificationsNewMessageBody;

  /// No description provided for @notificationsScheduleUpdatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule Updated'**
  String get notificationsScheduleUpdatedTitle;

  /// No description provided for @notificationsScheduleUpdatedBody.
  ///
  /// In en, this message translates to:
  /// **'The co-parenting schedule for next week has been updated.'**
  String get notificationsScheduleUpdatedBody;

  /// No description provided for @notificationsExpenseAddedTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense Added'**
  String get notificationsExpenseAddedTitle;

  /// No description provided for @notificationsExpenseAddedBody.
  ///
  /// In en, this message translates to:
  /// **'A new shared expense of 500 EGP has been recorded.'**
  String get notificationsExpenseAddedBody;

  /// No description provided for @notificationsReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get notificationsReminderTitle;

  /// No description provided for @notificationsReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget the parent-teacher meeting tomorrow at 4 PM.'**
  String get notificationsReminderBody;

  /// No description provided for @notificationsSecurityAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Security Alert'**
  String get notificationsSecurityAlertTitle;

  /// No description provided for @notificationsSecurityAlertBody.
  ///
  /// In en, this message translates to:
  /// **'A new device was used to sign in to your account.'**
  String get notificationsSecurityAlertBody;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String timeMinutesAgo(Object minutes);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} hour ago'**
  String timeHoursAgo(Object hours);

  /// No description provided for @timeHoursAgoPlural.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours ago'**
  String timeHoursAgoPlural(Object hours);

  /// No description provided for @timeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get timeYesterday;

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String timeDaysAgo(Object days);

  /// No description provided for @chatTypeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get chatTypeMessageHint;

  /// No description provided for @updatePleaseUpdateToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please update the app to continue.'**
  String get updatePleaseUpdateToContinue;

  /// No description provided for @updateNewVersionAvailableShort.
  ///
  /// In en, this message translates to:
  /// **'A new version is available.'**
  String get updateNewVersionAvailableShort;

  /// No description provided for @languageSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get languageSelectTitle;

  /// No description provided for @commonStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get commonStart;

  /// No description provided for @messagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @messagesSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get messagesSearch;

  /// No description provided for @newsTitle.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get newsTitle;

  /// No description provided for @expenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expenseTitle;

  /// No description provided for @expenseTotalThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Total This Month'**
  String get expenseTotalThisMonth;

  /// No description provided for @expenseYouPaid.
  ///
  /// In en, this message translates to:
  /// **'You Paid'**
  String get expenseYouPaid;

  /// No description provided for @expenseCoParentPaid.
  ///
  /// In en, this message translates to:
  /// **'Co-parent Paid'**
  String get expenseCoParentPaid;

  /// No description provided for @expenseAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get expenseAddExpense;

  /// No description provided for @addExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpenseTitle;

  /// No description provided for @addExpenseCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get addExpenseCategoryLabel;

  /// No description provided for @addExpenseSelectCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get addExpenseSelectCategoryHint;

  /// No description provided for @addExpenseDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get addExpenseDateLabel;

  /// No description provided for @addExpenseSelectDateHint.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get addExpenseSelectDateHint;

  /// No description provided for @addExpenseAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get addExpenseAmountLabel;

  /// No description provided for @addExpenseEnterAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get addExpenseEnterAmountHint;

  /// No description provided for @addExpenseAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Amount is required'**
  String get addExpenseAmountRequired;

  /// No description provided for @addExpenseEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get addExpenseEnterValidAmount;

  /// No description provided for @addExpenseCurrencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get addExpenseCurrencyLabel;

  /// No description provided for @addExpenseSelectCurrencyHint.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get addExpenseSelectCurrencyHint;

  /// No description provided for @addExpenseDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get addExpenseDescriptionLabel;

  /// No description provided for @addExpenseEnterDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get addExpenseEnterDescriptionHint;

  /// No description provided for @addExpenseProofOfPurchaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Proof of Purchase'**
  String get addExpenseProofOfPurchaseLabel;

  /// No description provided for @addExpenseTapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload'**
  String get addExpenseTapToUpload;

  /// No description provided for @addExpenseUploadFormats.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG or PDF'**
  String get addExpenseUploadFormats;

  /// No description provided for @addExpenseAlreadyPaidQuestion.
  ///
  /// In en, this message translates to:
  /// **'Have you already paid this expense?'**
  String get addExpenseAlreadyPaidQuestion;

  /// No description provided for @ourMissionDescription.
  ///
  /// In en, this message translates to:
  /// **'Our mission is to provide high-performance construction chemical solutions that meet the highest standards of quality, safety, and sustainability. We support our customers with innovative products and expert guidance, enabling them to achieve durable, efficient, and environmentally responsible construction results.'**
  String get ourMissionDescription;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started!'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingLogin.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get onboardingLogin;

  /// No description provided for @onboardingJoinUsingCode.
  ///
  /// In en, this message translates to:
  /// **'Join Using a Code'**
  String get onboardingJoinUsingCode;

  /// No description provided for @onboardingPage1Title.
  ///
  /// In en, this message translates to:
  /// **'A better way to co-parent'**
  String get onboardingPage1Title;

  /// No description provided for @onboardingPage1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'A secure space designed to help parents communicate, organize, and make decisions with less conflict and more clarity.'**
  String get onboardingPage1Subtitle;

  /// No description provided for @onboardingPage2Title.
  ///
  /// In en, this message translates to:
  /// **'Clear and respectful communication'**
  String get onboardingPage2Title;

  /// No description provided for @onboardingPage2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'All messages are documented, time-stamped, and cannot be edited or deleted, helping conversations stay accountable and constructive.'**
  String get onboardingPage2Subtitle;

  /// No description provided for @onboardingPage3Title.
  ///
  /// In en, this message translates to:
  /// **'Important documents, safely stored'**
  String get onboardingPage3Title;

  /// No description provided for @onboardingPage3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep medical, school, legal, and financial documents encrypted and accessible with full access history.'**
  String get onboardingPage3Subtitle;

  /// No description provided for @onboardingPage4Title.
  ///
  /// In en, this message translates to:
  /// **'Built on trust and privacy'**
  String get onboardingPage4Title;

  /// No description provided for @onboardingPage4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your data is protected with strong security measures and handled according to Egyptian data protection law.'**
  String get onboardingPage4Subtitle;
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
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
