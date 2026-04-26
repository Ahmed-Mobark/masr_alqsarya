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

  /// No description provided for @callRecording.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get callRecording;

  /// No description provided for @callRecordingConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recording consent'**
  String get callRecordingConsentTitle;

  /// No description provided for @callRecordingConsentBody.
  ///
  /// In en, this message translates to:
  /// **'Do you allow this call to be recorded? Both parents must approve.'**
  String get callRecordingConsentBody;

  /// No description provided for @callRecordingApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get callRecordingApprove;

  /// No description provided for @callRecordingDeny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get callRecordingDeny;

  /// No description provided for @callRecordingConsentDenied.
  ///
  /// In en, this message translates to:
  /// **'Recording denied.'**
  String get callRecordingConsentDenied;

  /// No description provided for @callRecordingWaitingOther.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the other parent to approve.'**
  String get callRecordingWaitingOther;

  /// No description provided for @callRecordingStarted.
  ///
  /// In en, this message translates to:
  /// **'Recording started.'**
  String get callRecordingStarted;

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

  /// No description provided for @profileMoreInformation.
  ///
  /// In en, this message translates to:
  /// **'More Information'**
  String get profileMoreInformation;

  /// No description provided for @profileMenuAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileMenuAccount;

  /// No description provided for @profileMenuFamilySpace.
  ///
  /// In en, this message translates to:
  /// **'Family Space'**
  String get profileMenuFamilySpace;

  /// No description provided for @profileMenuPrivacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get profileMenuPrivacySecurity;

  /// No description provided for @profileMenuNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get profileMenuNotification;

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

  /// No description provided for @profileMenuLegalTerms.
  ///
  /// In en, this message translates to:
  /// **'Legal & Terms of Use'**
  String get profileMenuLegalTerms;

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

  /// No description provided for @profileMenuDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profileMenuDeleteAccount;

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

  /// No description provided for @accountSecurityPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get accountSecurityPersonalInfo;

  /// No description provided for @accountSecurityFirstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get accountSecurityFirstNameLabel;

  /// No description provided for @accountSecurityLastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get accountSecurityLastNameLabel;

  /// No description provided for @accountSecurityEmailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get accountSecurityEmailAddressLabel;

  /// No description provided for @accountSecurityPhoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get accountSecurityPhoneNumberLabel;

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

  /// No description provided for @accountSecurityEmailMissingForPassword.
  ///
  /// In en, this message translates to:
  /// **'Your account has no email address. Add one before changing your password.'**
  String get accountSecurityEmailMissingForPassword;

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

  /// No description provided for @languageDeviceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Device Language'**
  String get languageDeviceLanguage;

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

  /// No description provided for @messagesAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get messagesAll;

  /// No description provided for @messagesUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get messagesUnread;

  /// No description provided for @messagesMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get messagesMarkAllRead;

  /// No description provided for @messagesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load conversations.'**
  String get messagesLoadError;

  /// No description provided for @messagesWorkspaceMissing.
  ///
  /// In en, this message translates to:
  /// **'Workspace is not ready yet. Try signing in again.'**
  String get messagesWorkspaceMissing;

  /// No description provided for @messagesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get messagesEmptyTitle;

  /// No description provided for @messagesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'When you start messaging, threads will appear here.'**
  String get messagesEmptySubtitle;

  /// No description provided for @messagesRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get messagesRetry;

  /// No description provided for @chatLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load messages.'**
  String get chatLoadError;

  /// No description provided for @chatEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get chatEmptyTitle;

  /// No description provided for @chatEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send a message to start the conversation.'**
  String get chatEmptySubtitle;

  /// No description provided for @messagesRoleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get messagesRoleOwner;

  /// No description provided for @messagesRoleCoPartner.
  ///
  /// In en, this message translates to:
  /// **'Co-parent'**
  String get messagesRoleCoPartner;

  /// No description provided for @messagesRoleChild.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get messagesRoleChild;

  /// No description provided for @messagesNoPreview.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get messagesNoPreview;

  /// No description provided for @chatAttachmentFallback.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get chatAttachmentFallback;

  /// No description provided for @chatAttachmentDownloadAction.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get chatAttachmentDownloadAction;

  /// No description provided for @chatAttachmentDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not download the file.'**
  String get chatAttachmentDownloadFailed;

  /// No description provided for @chatAttachmentDownloadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved: {fileName}'**
  String chatAttachmentDownloadSuccess(String fileName);

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

  /// No description provided for @expenseRegularExpense.
  ///
  /// In en, this message translates to:
  /// **'Regular Expense'**
  String get expenseRegularExpense;

  /// No description provided for @expenseSupportPayment.
  ///
  /// In en, this message translates to:
  /// **'Support Payment'**
  String get expenseSupportPayment;

  /// No description provided for @expenseChildName.
  ///
  /// In en, this message translates to:
  /// **'Child Name'**
  String get expenseChildName;

  /// No description provided for @expenseSubmittedBy.
  ///
  /// In en, this message translates to:
  /// **'Submitted By'**
  String get expenseSubmittedBy;

  /// No description provided for @expenseReferenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Reference Number'**
  String get expenseReferenceNumber;

  /// No description provided for @expensePaymentPeriod.
  ///
  /// In en, this message translates to:
  /// **'Payment Period'**
  String get expensePaymentPeriod;

  /// No description provided for @expenseCourtCase.
  ///
  /// In en, this message translates to:
  /// **'Court Case'**
  String get expenseCourtCase;

  /// No description provided for @expensePaidBadge.
  ///
  /// In en, this message translates to:
  /// **'PAID'**
  String get expensePaidBadge;

  /// No description provided for @expenseViewReceipt.
  ///
  /// In en, this message translates to:
  /// **'VIEW RECEIPT'**
  String get expenseViewReceipt;

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

  /// No description provided for @invoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoiceTitle;

  /// No description provided for @invoiceNumberPrefix.
  ///
  /// In en, this message translates to:
  /// **'Invoice #'**
  String get invoiceNumberPrefix;

  /// No description provided for @invoiceExpenseInformation.
  ///
  /// In en, this message translates to:
  /// **'Expense Information'**
  String get invoiceExpenseInformation;

  /// No description provided for @invoiceCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get invoiceCategory;

  /// No description provided for @invoiceDateOfService.
  ///
  /// In en, this message translates to:
  /// **'Date of Service'**
  String get invoiceDateOfService;

  /// No description provided for @invoiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get invoiceDescription;

  /// No description provided for @invoicePaymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get invoicePaymentDetails;

  /// No description provided for @invoiceReferenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Reference Number'**
  String get invoiceReferenceNumber;

  /// No description provided for @invoicePaidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid On'**
  String get invoicePaidOn;

  /// No description provided for @invoicePaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get invoicePaymentMethod;

  /// No description provided for @invoiceVerifiedBy.
  ///
  /// In en, this message translates to:
  /// **'Verified By'**
  String get invoiceVerifiedBy;

  /// No description provided for @invoiceAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get invoiceAttachments;

  /// No description provided for @addExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpenseTitle;

  /// No description provided for @addExpenseChildLabel.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get addExpenseChildLabel;

  /// No description provided for @addExpenseChildBothChildren.
  ///
  /// In en, this message translates to:
  /// **'Both Children'**
  String get addExpenseChildBothChildren;

  /// No description provided for @addExpensePayerName.
  ///
  /// In en, this message translates to:
  /// **'Payer Name'**
  String get addExpensePayerName;

  /// No description provided for @addExpensePayerId.
  ///
  /// In en, this message translates to:
  /// **'Payer ID'**
  String get addExpensePayerId;

  /// No description provided for @addExpensePayeeName.
  ///
  /// In en, this message translates to:
  /// **'Payee Name'**
  String get addExpensePayeeName;

  /// No description provided for @addExpensePayeeId.
  ///
  /// In en, this message translates to:
  /// **'Payee ID'**
  String get addExpensePayeeId;

  /// No description provided for @addExpenseFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Expense Title'**
  String get addExpenseFieldHint;

  /// No description provided for @addExpenseCurrencyRequired.
  ///
  /// In en, this message translates to:
  /// **'Currency is required'**
  String get addExpenseCurrencyRequired;

  /// No description provided for @addExpenseExpenseTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Expense Title'**
  String get addExpenseExpenseTitleLabel;

  /// No description provided for @addExpenseCategoryMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get addExpenseCategoryMedical;

  /// No description provided for @addExpenseCategoryGroceries.
  ///
  /// In en, this message translates to:
  /// **'groceries'**
  String get addExpenseCategoryGroceries;

  /// No description provided for @addExpenseDatePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get addExpenseDatePlaceholder;

  /// No description provided for @addExpenseNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes ( Optional )'**
  String get addExpenseNotesOptional;

  /// No description provided for @addExpenseNotesHint.
  ///
  /// In en, this message translates to:
  /// **'note'**
  String get addExpenseNotesHint;

  /// No description provided for @addExpenseYesIPaidIt.
  ///
  /// In en, this message translates to:
  /// **'Yes, I paid it'**
  String get addExpenseYesIPaidIt;

  /// No description provided for @addExpenseNotPaidYet.
  ///
  /// In en, this message translates to:
  /// **'No, it has not been paid yet'**
  String get addExpenseNotPaidYet;

  /// No description provided for @addExpenseUploadReceiptOrInvoice.
  ///
  /// In en, this message translates to:
  /// **'Upload receipt or invoice'**
  String get addExpenseUploadReceiptOrInvoice;

  /// No description provided for @addExpenseProofTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File is too large (max 5 MB).'**
  String get addExpenseProofTooLarge;

  /// No description provided for @addExpenseProofPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not pick the file.'**
  String get addExpenseProofPickFailed;

  /// No description provided for @addExpenseSubmitExpense.
  ///
  /// In en, this message translates to:
  /// **'Submit Expense'**
  String get addExpenseSubmitExpense;

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

  /// No description provided for @authVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get authVerifyTitle;

  /// No description provided for @authVerifyCodeHeading.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get authVerifyCodeHeading;

  /// No description provided for @authVerifySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification code to your email address. Please enter it below.'**
  String get authVerifySubtitle;

  /// No description provided for @authDidntReceive.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get authDidntReceive;

  /// No description provided for @authResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get authResend;

  /// No description provided for @authContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get authContinue;

  /// No description provided for @authVerificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent successfully'**
  String get authVerificationCodeSent;

  /// No description provided for @authRoleOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Role Options'**
  String get authRoleOptionsTitle;

  /// No description provided for @authRoleOptionsHeading.
  ///
  /// In en, this message translates to:
  /// **'How will you use the app?'**
  String get authRoleOptionsHeading;

  /// No description provided for @authRoleOptionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the option that best describes your situation.'**
  String get authRoleOptionsSubtitle;

  /// No description provided for @authRoleFamilySpace.
  ///
  /// In en, this message translates to:
  /// **'Family Space'**
  String get authRoleFamilySpace;

  /// No description provided for @authRoleFamilySpaceDesc.
  ///
  /// In en, this message translates to:
  /// **'Co-parent with your partner in a shared family workspace.'**
  String get authRoleFamilySpaceDesc;

  /// No description provided for @authRoleSolo.
  ///
  /// In en, this message translates to:
  /// **'Solo'**
  String get authRoleSolo;

  /// No description provided for @authRoleSoloDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your parenting schedule independently.'**
  String get authRoleSoloDesc;

  /// No description provided for @authNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get authNext;

  /// No description provided for @authCoParentDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Co-Parent Details'**
  String get authCoParentDetailsTitle;

  /// No description provided for @authCoParentDetailsHeading.
  ///
  /// In en, this message translates to:
  /// **'Invite your co-parent'**
  String get authCoParentDetailsHeading;

  /// No description provided for @authCoParentDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your co-parent\'s details to send them an invitation.'**
  String get authCoParentDetailsSubtitle;

  /// No description provided for @authCoParentFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get authCoParentFirstName;

  /// No description provided for @authCoParentLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get authCoParentLastName;

  /// No description provided for @authCoParentEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authCoParentEmail;

  /// No description provided for @authCoParentPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get authCoParentPhone;

  /// No description provided for @authCoParentDate.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get authCoParentDate;

  /// No description provided for @authCoParentNote.
  ///
  /// In en, this message translates to:
  /// **'Your co-parent will receive an email invitation to join the family workspace.'**
  String get authCoParentNote;

  /// No description provided for @authOnboardingAddChildTitle.
  ///
  /// In en, this message translates to:
  /// **'Add children'**
  String get authOnboardingAddChildTitle;

  /// No description provided for @authOnboardingAddChildHeading.
  ///
  /// In en, this message translates to:
  /// **'Child details'**
  String get authOnboardingAddChildHeading;

  /// No description provided for @authOnboardingAddChildSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add each child’s information. Tap “Add another” to save and enter another child, or “Next” to finish and go to the app.'**
  String get authOnboardingAddChildSubtitle;

  /// No description provided for @authAddAnotherChild.
  ///
  /// In en, this message translates to:
  /// **'Add another'**
  String get authAddAnotherChild;

  /// No description provided for @familyChildDisplayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get familyChildDisplayNameLabel;

  /// No description provided for @familyChildDisplayNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter display name'**
  String get familyChildDisplayNameHint;

  /// No description provided for @familyChildFirstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get familyChildFirstNameLabel;

  /// No description provided for @familyChildFirstNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter first name'**
  String get familyChildFirstNameHint;

  /// No description provided for @familyChildLastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get familyChildLastNameLabel;

  /// No description provided for @familyChildLastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter last name'**
  String get familyChildLastNameHint;

  /// No description provided for @familyChildEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get familyChildEmailLabel;

  /// No description provided for @familyChildEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter email address'**
  String get familyChildEmailHint;

  /// No description provided for @familyChildPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get familyChildPhoneLabel;

  /// No description provided for @familyChildPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get familyChildPhoneHint;

  /// No description provided for @familyChildDateOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get familyChildDateOfBirthLabel;

  /// No description provided for @familyChildDateOfBirthHint.
  ///
  /// In en, this message translates to:
  /// **'DD-MM-YYYY'**
  String get familyChildDateOfBirthHint;

  /// No description provided for @familyChildAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Child added successfully'**
  String get familyChildAddedSuccess;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get authForgotPasswordTitle;

  /// No description provided for @authForgotPasswordHeading.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get authForgotPasswordHeading;

  /// No description provided for @authForgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we’ll send you a verification code.'**
  String get authForgotPasswordSubtitle;

  /// No description provided for @authForgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get authForgotPasswordButton;

  /// No description provided for @authForgotPasswordOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get authForgotPasswordOtpTitle;

  /// No description provided for @authForgotPasswordOtpHeading.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get authForgotPasswordOtpHeading;

  /// No description provided for @authForgotPasswordOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification code to your email. Please enter it below.'**
  String get authForgotPasswordOtpSubtitle;

  /// No description provided for @authResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPasswordTitle;

  /// No description provided for @authResetPasswordHeading.
  ///
  /// In en, this message translates to:
  /// **'Create a new password'**
  String get authResetPasswordHeading;

  /// No description provided for @authResetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different from previously used passwords.'**
  String get authResetPasswordSubtitle;

  /// No description provided for @authNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get authNewPasswordLabel;

  /// No description provided for @authNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'********'**
  String get authNewPasswordHint;

  /// No description provided for @authConfirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get authConfirmNewPasswordLabel;

  /// No description provided for @authResetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPasswordButton;

  /// No description provided for @authPasswordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get authPasswordResetSuccess;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @homeQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get homeQuickActions;

  /// No description provided for @homeAwaitingResponse.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Your Response'**
  String get homeAwaitingResponse;

  /// No description provided for @homeRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get homeRecentActivity;

  /// No description provided for @homeGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get homeGuest;

  /// No description provided for @homeWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get homeWelcomeBack;

  /// No description provided for @homeGoodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get homeGoodMorning;

  /// No description provided for @homeFrom.
  ///
  /// In en, this message translates to:
  /// **'From: '**
  String get homeFrom;

  /// No description provided for @newsFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get newsFilter;

  /// No description provided for @newsResetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset Filters'**
  String get newsResetFilters;

  /// No description provided for @newsSearchByName.
  ///
  /// In en, this message translates to:
  /// **'Search by Name'**
  String get newsSearchByName;

  /// No description provided for @newsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get newsSearchHint;

  /// No description provided for @newsSearchByType.
  ///
  /// In en, this message translates to:
  /// **'Search by Type'**
  String get newsSearchByType;

  /// No description provided for @newsSortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get newsSortBy;

  /// No description provided for @newsApplyFilters.
  ///
  /// In en, this message translates to:
  /// **'APPLY FILTERS'**
  String get newsApplyFilters;

  /// No description provided for @newsAllPosts.
  ///
  /// In en, this message translates to:
  /// **'All Posts'**
  String get newsAllPosts;

  /// No description provided for @newsUpdates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get newsUpdates;

  /// No description provided for @newsAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get newsAnnouncements;

  /// No description provided for @newsPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get newsPhotos;

  /// No description provided for @newsDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get newsDocuments;

  /// No description provided for @newsExpenseUpdates.
  ///
  /// In en, this message translates to:
  /// **'Expense Updates'**
  String get newsExpenseUpdates;

  /// No description provided for @newsNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newsNewest;

  /// No description provided for @newsOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get newsOldest;

  /// No description provided for @newsName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get newsName;

  /// No description provided for @newsSeeMore.
  ///
  /// In en, this message translates to:
  /// **'see more'**
  String get newsSeeMore;

  /// No description provided for @newsShowLess.
  ///
  /// In en, this message translates to:
  /// **'show less'**
  String get newsShowLess;

  /// No description provided for @newsLike.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get newsLike;

  /// No description provided for @newsHelpful.
  ///
  /// In en, this message translates to:
  /// **'Helpful'**
  String get newsHelpful;

  /// No description provided for @expenseCategoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get expenseCategoryEducation;

  /// No description provided for @expenseCategoryHealthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get expenseCategoryHealthcare;

  /// No description provided for @expenseCategoryActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get expenseCategoryActivities;

  /// No description provided for @expenseCategoryEssentials.
  ///
  /// In en, this message translates to:
  /// **'Essentials'**
  String get expenseCategoryEssentials;

  /// No description provided for @expenseCategoryClothing.
  ///
  /// In en, this message translates to:
  /// **'Clothing'**
  String get expenseCategoryClothing;

  /// No description provided for @expenseCategoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get expenseCategoryFood;

  /// No description provided for @expenseCategoryTransportation.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get expenseCategoryTransportation;

  /// No description provided for @expenseCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get expenseCategoryOther;

  /// No description provided for @scheduleFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get scheduleFilterAll;

  /// No description provided for @scheduleFilterParentingTime.
  ///
  /// In en, this message translates to:
  /// **'Parenting Time'**
  String get scheduleFilterParentingTime;

  /// No description provided for @scheduleFilterSchoolActivities.
  ///
  /// In en, this message translates to:
  /// **'School & Activities'**
  String get scheduleFilterSchoolActivities;

  /// No description provided for @scheduleFilterMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get scheduleFilterMedical;

  /// No description provided for @scheduleFilterCalls.
  ///
  /// In en, this message translates to:
  /// **'Calls'**
  String get scheduleFilterCalls;

  /// No description provided for @scheduleLegendApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get scheduleLegendApproved;

  /// No description provided for @scheduleLegendPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get scheduleLegendPending;

  /// No description provided for @scheduleLegendEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get scheduleLegendEvent;

  /// No description provided for @scheduleLegendCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get scheduleLegendCall;

  /// No description provided for @scheduleCallMode.
  ///
  /// In en, this message translates to:
  /// **'Call mode'**
  String get scheduleCallMode;

  /// No description provided for @scheduleCallModeAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get scheduleCallModeAudio;

  /// No description provided for @scheduleCallModeVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get scheduleCallModeVideo;

  /// No description provided for @scheduleCreateCall.
  ///
  /// In en, this message translates to:
  /// **'CREATE CALL'**
  String get scheduleCreateCall;

  /// No description provided for @scheduleErrorWorkspaceMissing.
  ///
  /// In en, this message translates to:
  /// **'Workspace is not ready yet. Try signing in again.'**
  String get scheduleErrorWorkspaceMissing;

  /// No description provided for @scheduleErrorScheduledStartsAtAfterNow.
  ///
  /// In en, this message translates to:
  /// **'Please choose a future date.'**
  String get scheduleErrorScheduledStartsAtAfterNow;

  /// No description provided for @scheduleErrorStartDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a start date.'**
  String get scheduleErrorStartDateRequired;

  /// No description provided for @scheduleCallExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get scheduleCallExpired;

  /// No description provided for @scheduleCallCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Call created successfully.'**
  String get scheduleCallCreatedSuccess;

  /// No description provided for @scheduleRoomName.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get scheduleRoomName;

  /// No description provided for @scheduleVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Video Call'**
  String get scheduleVideoCall;

  /// No description provided for @scheduleAudioCall.
  ///
  /// In en, this message translates to:
  /// **'Audio Call'**
  String get scheduleAudioCall;

  /// No description provided for @scheduleLegendRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get scheduleLegendRejected;

  /// No description provided for @scheduleNewScheduleRequest.
  ///
  /// In en, this message translates to:
  /// **'New Schedule Request'**
  String get scheduleNewScheduleRequest;

  /// No description provided for @scheduleAllCalls.
  ///
  /// In en, this message translates to:
  /// **'All Calls'**
  String get scheduleAllCalls;

  /// No description provided for @scheduleNoCalls.
  ///
  /// In en, this message translates to:
  /// **'No calls yet'**
  String get scheduleNoCalls;

  /// No description provided for @scheduleAddNewSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add New Schedule'**
  String get scheduleAddNewSchedule;

  /// No description provided for @scheduleEventType.
  ///
  /// In en, this message translates to:
  /// **'Event Type'**
  String get scheduleEventType;

  /// No description provided for @scheduleChild.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get scheduleChild;

  /// No description provided for @scheduleDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get scheduleDate;

  /// No description provided for @scheduleTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get scheduleTime;

  /// No description provided for @scheduleNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get scheduleNotes;

  /// No description provided for @scheduleSendRequest.
  ///
  /// In en, this message translates to:
  /// **'SEND REQUEST'**
  String get scheduleSendRequest;

  /// No description provided for @scheduleSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get scheduleSelect;

  /// No description provided for @scheduleVoiceCall.
  ///
  /// In en, this message translates to:
  /// **'Voice Call'**
  String get scheduleVoiceCall;

  /// No description provided for @scheduleJoin.
  ///
  /// In en, this message translates to:
  /// **'JOIN'**
  String get scheduleJoin;

  /// No description provided for @scheduleJoinCallSuccess.
  ///
  /// In en, this message translates to:
  /// **'Joined call successfully.'**
  String get scheduleJoinCallSuccess;

  /// No description provided for @scheduleJoinCallFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not join the call. Please try again.'**
  String get scheduleJoinCallFailed;

  /// No description provided for @callConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get callConnecting;

  /// No description provided for @callLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get callLive;

  /// No description provided for @callMic.
  ///
  /// In en, this message translates to:
  /// **'Mic'**
  String get callMic;

  /// No description provided for @callCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get callCamera;

  /// No description provided for @callLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get callLeave;

  /// No description provided for @callWaitingForOther.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the other participant…'**
  String get callWaitingForOther;

  /// No description provided for @callConnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the call.'**
  String get callConnectFailed;

  /// No description provided for @callNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get callNoInternet;

  /// No description provided for @callMicPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required to join the call.'**
  String get callMicPermissionRequired;

  /// No description provided for @callCameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required for video calls.'**
  String get callCameraPermissionRequired;

  /// No description provided for @callDisconnected.
  ///
  /// In en, this message translates to:
  /// **'You were disconnected from the call.'**
  String get callDisconnected;

  /// No description provided for @callReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Connection lost. Reconnecting…'**
  String get callReconnecting;

  /// No description provided for @callConnectionReplaced.
  ///
  /// In en, this message translates to:
  /// **'Call ended because you joined from another device.'**
  String get callConnectionReplaced;

  /// No description provided for @callUnsupportedPlatform.
  ///
  /// In en, this message translates to:
  /// **'Live calls are supported on Android/iOS only. Please run the mobile app.'**
  String get callUnsupportedPlatform;

  /// No description provided for @scheduleViewReceipt.
  ///
  /// In en, this message translates to:
  /// **'VIEW RECEIPT'**
  String get scheduleViewReceipt;

  /// No description provided for @scheduleExpensePaid.
  ///
  /// In en, this message translates to:
  /// **'Expense Paid'**
  String get scheduleExpensePaid;

  /// No description provided for @scheduleCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get scheduleCategory;

  /// No description provided for @homeSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get homeSendMessage;

  /// No description provided for @homeAddSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add Schedule'**
  String get homeAddSchedule;

  /// No description provided for @homeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get homeExpense;

  /// No description provided for @homeSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get homeSessions;

  /// No description provided for @homeSessionsLibrary.
  ///
  /// In en, this message translates to:
  /// **'Sessions Library'**
  String get homeSessionsLibrary;

  /// No description provided for @homeDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get homeDocuments;

  /// No description provided for @documentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsTitle;

  /// No description provided for @documentsFolders.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get documentsFolders;

  /// No description provided for @documentsFolderSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get documentsFolderSchool;

  /// No description provided for @documentsFolderCalls.
  ///
  /// In en, this message translates to:
  /// **'Calls'**
  String get documentsFolderCalls;

  /// No description provided for @documentsFolderInvoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get documentsFolderInvoices;

  /// No description provided for @documentsFolderLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get documentsFolderLegal;

  /// No description provided for @documentsAddedByParentAMother.
  ///
  /// In en, this message translates to:
  /// **'Added by: Parent A (Mother)'**
  String get documentsAddedByParentAMother;

  /// No description provided for @documentsAccessBothParents.
  ///
  /// In en, this message translates to:
  /// **'Access: Both Parents'**
  String get documentsAccessBothParents;

  /// No description provided for @documentsLastUpdatedByParentAMother.
  ///
  /// In en, this message translates to:
  /// **'Last Updated by: Parent A (Mother)'**
  String get documentsLastUpdatedByParentAMother;

  /// No description provided for @documentsLastUpdatedAtParentAMother.
  ///
  /// In en, this message translates to:
  /// **'Last Updated at : Parent A (Mother)'**
  String get documentsLastUpdatedAtParentAMother;

  /// No description provided for @documentsWhoCanView.
  ///
  /// In en, this message translates to:
  /// **'Who Can View'**
  String get documentsWhoCanView;

  /// No description provided for @documentsWhoCanEdit.
  ///
  /// In en, this message translates to:
  /// **'Who Can Edit'**
  String get documentsWhoCanEdit;

  /// No description provided for @documentsBothParents.
  ///
  /// In en, this message translates to:
  /// **'Both Parents'**
  String get documentsBothParents;

  /// No description provided for @documentsCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get documentsCustom;

  /// No description provided for @documentsNoOne.
  ///
  /// In en, this message translates to:
  /// **'No one'**
  String get documentsNoOne;

  /// No description provided for @documentsTabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get documentsTabAll;

  /// No description provided for @documentsTabVideos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get documentsTabVideos;

  /// No description provided for @documentsTabPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get documentsTabPhotos;

  /// No description provided for @documentsTabDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsTabDocuments;

  /// No description provided for @documentsTypePdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get documentsTypePdf;

  /// No description provided for @documentsTypeCourtDocument.
  ///
  /// In en, this message translates to:
  /// **'Court Document'**
  String get documentsTypeCourtDocument;

  /// No description provided for @documentsTypeInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get documentsTypeInvoice;

  /// No description provided for @documentsTypeImage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get documentsTypeImage;

  /// No description provided for @documentsEvidenceStatus.
  ///
  /// In en, this message translates to:
  /// **'Evidence Status'**
  String get documentsEvidenceStatus;

  /// No description provided for @documentsAllRecords.
  ///
  /// In en, this message translates to:
  /// **'All Records'**
  String get documentsAllRecords;

  /// No description provided for @documentsMarkedAsEvidence.
  ///
  /// In en, this message translates to:
  /// **'Marked as Evidence'**
  String get documentsMarkedAsEvidence;

  /// No description provided for @documentsAddedBy.
  ///
  /// In en, this message translates to:
  /// **'Added By'**
  String get documentsAddedBy;

  /// No description provided for @documentsAddedByParentA.
  ///
  /// In en, this message translates to:
  /// **'Parent A'**
  String get documentsAddedByParentA;

  /// No description provided for @documentsAddedByParentB.
  ///
  /// In en, this message translates to:
  /// **'Parent B'**
  String get documentsAddedByParentB;

  /// No description provided for @documentsAddedByLawyer.
  ///
  /// In en, this message translates to:
  /// **'Lawyer'**
  String get documentsAddedByLawyer;

  /// No description provided for @documentsAddedByMediator.
  ///
  /// In en, this message translates to:
  /// **'Mediator'**
  String get documentsAddedByMediator;

  /// No description provided for @documentsDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get documentsDateRange;

  /// No description provided for @documentsStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get documentsStartDate;

  /// No description provided for @documentsEndDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get documentsEndDate;

  /// No description provided for @homeUpcomingCall.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Call'**
  String get homeUpcomingCall;

  /// No description provided for @homeReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get homeReminder;

  /// No description provided for @homeConfirm.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM'**
  String get homeConfirm;

  /// No description provided for @homeRequestReschedule.
  ///
  /// In en, this message translates to:
  /// **'REQUEST RESCHEDULE'**
  String get homeRequestReschedule;

  /// No description provided for @homeNewEvent.
  ///
  /// In en, this message translates to:
  /// **'New Event'**
  String get homeNewEvent;

  /// No description provided for @homeNewSession.
  ///
  /// In en, this message translates to:
  /// **'New Session'**
  String get homeNewSession;

  /// No description provided for @homePendingCost.
  ///
  /// In en, this message translates to:
  /// **'{count} Pending cost'**
  String homePendingCost(Object count);

  /// No description provided for @homeReview.
  ///
  /// In en, this message translates to:
  /// **'REVIEW'**
  String get homeReview;

  /// No description provided for @rescheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Reschedule'**
  String get rescheduleTitle;

  /// No description provided for @rescheduleSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select a new date'**
  String get rescheduleSelectDate;

  /// No description provided for @rescheduleSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get rescheduleSelectTime;

  /// No description provided for @rescheduleSubmit.
  ///
  /// In en, this message translates to:
  /// **'REQUEST RESCHEDULE'**
  String get rescheduleSubmit;
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
