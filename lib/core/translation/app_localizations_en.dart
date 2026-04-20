// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get errorFieldRequired => 'This field is required';

  @override
  String get errorInvalidName => 'Invalid name format';

  @override
  String get errorInvalidUrl => 'Invalid URL';

  @override
  String get errorInvalidPhoneNumber => 'Invalid phone number';

  @override
  String get errorInvalidEmail => 'Invalid email address';

  @override
  String get errorInvalidPassword =>
      'Password must be at least 8 characters long with uppercase, lowercase, and special characters';

  @override
  String get errorPasswordMismatch => 'Passwords do not match';

  @override
  String get errorInvalidNumber => 'Invalid number';

  @override
  String get errorInvalidIban => 'Invalid IBAN format';

  @override
  String get errorInvalidMobileNumber => 'Invalid mobile number';

  @override
  String get errorInvalidStcPayId => 'Invalid STC Pay ID';

  @override
  String get errorInvalidNationalId => 'Invalid National ID';

  @override
  String get errorInvalidPassport => 'Invalid passport number';

  @override
  String get sorryMessage => 'We are sorry';

  @override
  String get nothingFound => 'Nothing Found';

  @override
  String errorPhoneValidation(Object length, Object start) {
    return 'The phone number must start with $start and be $length digits long.';
  }

  @override
  String get errorExperienceRequired => 'You must add at least one experience.';

  @override
  String get errorIdDocumentRequired =>
      'You must upload an ID document to verify your identity.';

  @override
  String get errorPhotoRequired =>
      'You must upload a photo with a white background';

  @override
  String get updateAvailableTitle => 'Update Available';

  @override
  String get updateMandatoryMessage =>
      'A new version of the app is available. Please update to continue using the app.';

  @override
  String get updateOptionalMessage =>
      'A new version of the app is available. We recommend updating for the best experience.';

  @override
  String get updateNow => 'Update Now';

  @override
  String get skip => 'Skip';

  @override
  String get chooseImage => 'Upload Choose Image';

  @override
  String get takePicture => 'Upload Take Picture';

  @override
  String get chooseFromFiles => 'Upload Choose From Files';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPushNotifications => 'Push Notifications';

  @override
  String get settingsEmailNotifications => 'Email Notifications';

  @override
  String get settingsDarkMode => 'Dark Mode';

  @override
  String get settingsToneAnalysis => 'Tone Analysis';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get navHomeTabLabel => 'Home';

  @override
  String get navScheduleTabLabel => 'Schedule';

  @override
  String get navNewsTabLabel => 'News';

  @override
  String get navMessagesTabLabel => 'Messages';

  @override
  String get navExpenseTabLabel => 'Expense';

  @override
  String get scheduleSharedCalendarTitle => 'Shared Calendar';

  @override
  String get scheduleNoEventsForDay => 'No events for this day';

  @override
  String get scheduleEventTypePickup => 'Pickup';

  @override
  String get scheduleEventTypeMedical => 'Medical';

  @override
  String get scheduleEventTypeActivity => 'Activity';

  @override
  String get scheduleEventTypeSchool => 'School';

  @override
  String get scheduleEventTypeCustody => 'Custody';

  @override
  String get scheduleAllDay => 'All Day';

  @override
  String get authLoginTitle => 'Log In';

  @override
  String get authLoginIntroTitle => 'Welcome to Masr Al-Osariya';

  @override
  String get authLoginIntroSubtitle =>
      'Start building a safe and organized co-parenting experience.';

  @override
  String get authEmailTab => 'Email';

  @override
  String get authPhoneTab => 'Phone Number';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailEntryHint => 'Enter Email';

  @override
  String get authEmailHint => 'example@email.com';

  @override
  String get authPhoneLabel => 'Phone Number';

  @override
  String get authPhoneHint => '+20 123 456 7890';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHint => '********';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authLoginButton => 'LOG IN';

  @override
  String get authOrContinueWith => 'Or continue with';

  @override
  String get authDontHaveAccountPrefix => 'Don\'t have an account? ';

  @override
  String get authSignUp => 'Sign Up';

  @override
  String get authSignUpTitle => 'Sign Up';

  @override
  String get authSignUpIntroTitle => 'How will you use the app?';

  @override
  String get authSignUpIntroSubtitle =>
      'Choose the option that best describes you.';

  @override
  String get authFullNameLabel => 'Full Name';

  @override
  String get authFullNameHint => 'Full Name';

  @override
  String get authFirstNameLabel => 'First Name';

  @override
  String get authFirstNameHint => 'John';

  @override
  String get authLastNameLabel => 'Last Name';

  @override
  String get authLastNameHint => 'Doe';

  @override
  String get authConfirmPasswordLabel => 'Confirm Password';

  @override
  String get authAgreeTermsPrefix => 'Please agree to the ';

  @override
  String get authTermsAndConditions => 'Terms & Conditions';

  @override
  String get authAgreeTermsSuffix => ' to continue.';

  @override
  String get authAgreeTermsToContinue =>
      'Please agree to the Terms & Conditions to continue.';

  @override
  String get authOrShort => 'Or';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authContinueWithApple => 'Continue with Apple';

  @override
  String get authSignUpButton => 'SIGN UP';

  @override
  String get authAlreadyHaveAccountPrefix => 'Already have an account? ';

  @override
  String get authLoginLink => 'LOGIN';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClose => 'Close';

  @override
  String get commonShare => 'Share';

  @override
  String get commonSave => 'Save';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonDelete => 'Delete';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileMoreInformation => 'More Information';

  @override
  String get profileMenuAccount => 'Account';

  @override
  String get profileMenuFamilySpace => 'Family Space';

  @override
  String get profileMenuPrivacySecurity => 'Privacy & Security';

  @override
  String get profileMenuNotification => 'Notification';

  @override
  String get profileMenuAccountSecurity => 'Account & Security';

  @override
  String get profileMenuFamilyInformation => 'Family Information';

  @override
  String get profileMenuNotifications => 'Notifications';

  @override
  String get profileMenuLanguage => 'Language';

  @override
  String get profileMenuLegalTerms => 'Legal & Terms of Use';

  @override
  String get profileMenuTermsOfUse => 'Terms of Use';

  @override
  String get profileMenuInvitePeople => 'Invite People';

  @override
  String get profileMenuDeleteAccount => 'Delete Account';

  @override
  String get profileMenuLogout => 'Log Out';

  @override
  String get profileTermsTitle => 'Terms of Use';

  @override
  String get profileTermsBody =>
      'By using this application, you agree to the following terms and conditions. Please read them carefully before proceeding.\\n\\n1. You must be at least 18 years old to use this service.\\n\\n2. All information provided must be accurate and up to date.\\n\\n3. You are responsible for maintaining the confidentiality of your account.\\n\\n4. We reserve the right to modify these terms at any time.\\n\\n5. Any misuse of the platform may result in account suspension.';

  @override
  String get profileInviteTitle => 'Invite People';

  @override
  String get profileInviteDescription =>
      'Share your invite code with family and friends.';

  @override
  String get profileLogoutTitle => 'Log Out';

  @override
  String get profileLogoutConfirm => 'Are you sure you want to log out?';

  @override
  String get accountSecurityTitle => 'Account & Security';

  @override
  String get accountSecurityPersonalInfo => 'Personal Info';

  @override
  String get accountSecurityFirstNameLabel => 'First Name';

  @override
  String get accountSecurityLastNameLabel => 'Last Name';

  @override
  String get accountSecurityEmailAddressLabel => 'Email Address';

  @override
  String get accountSecurityPhoneNumberLabel => 'Phone Number';

  @override
  String get accountSecurityEmailLabel => 'Email';

  @override
  String get accountSecurityPhoneLabel => 'Phone';

  @override
  String get accountSecurityChangePassword => 'Change Password';

  @override
  String get accountSecurityEnableTwoFactor =>
      'Enable Two-Factor Authentication';

  @override
  String get accountSecurityDeleteAccount => 'Delete Account';

  @override
  String get accountSecurityDeleteConfirm =>
      'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get languageDeviceLanguage => 'Device Language';

  @override
  String get familyInfoTitle => 'Family Information';

  @override
  String get familyChildrenTitle => 'Children';

  @override
  String get familyAddChild => 'Add Child';

  @override
  String get familyInfoSaved => 'Family information saved';

  @override
  String get familyCoParent => 'Co-Parent';

  @override
  String get familyConnected => 'Connected';

  @override
  String familyYearsOld(Object age) {
    return '$age years old';
  }

  @override
  String get familyChildNameHint => 'Child name';

  @override
  String get familyChildAgeHint => 'Age';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmptyTitle => 'No notifications yet';

  @override
  String get notificationsEmptySubtitle =>
      'We\'ll notify you when something arrives';

  @override
  String get notificationsNewMessageTitle => 'New Message';

  @override
  String get notificationsNewMessageBody =>
      'Fatima sent you a message about this weekend\'s schedule.';

  @override
  String get notificationsScheduleUpdatedTitle => 'Schedule Updated';

  @override
  String get notificationsScheduleUpdatedBody =>
      'The co-parenting schedule for next week has been updated.';

  @override
  String get notificationsExpenseAddedTitle => 'Expense Added';

  @override
  String get notificationsExpenseAddedBody =>
      'A new shared expense of 500 EGP has been recorded.';

  @override
  String get notificationsReminderTitle => 'Reminder';

  @override
  String get notificationsReminderBody =>
      'Don\'t forget the parent-teacher meeting tomorrow at 4 PM.';

  @override
  String get notificationsSecurityAlertTitle => 'Security Alert';

  @override
  String get notificationsSecurityAlertBody =>
      'A new device was used to sign in to your account.';

  @override
  String timeMinutesAgo(Object minutes) {
    return '$minutes min ago';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '$hours hour ago';
  }

  @override
  String timeHoursAgoPlural(Object hours) {
    return '$hours hours ago';
  }

  @override
  String get timeYesterday => 'Yesterday';

  @override
  String timeDaysAgo(Object days) {
    return '$days days ago';
  }

  @override
  String get chatTypeMessageHint => 'Type a message...';

  @override
  String get updatePleaseUpdateToContinue =>
      'Please update the app to continue.';

  @override
  String get updateNewVersionAvailableShort => 'A new version is available.';

  @override
  String get languageSelectTitle => 'Select Language';

  @override
  String get commonStart => 'Start';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get messagesSearch => 'Search';

  @override
  String get messagesAll => 'All';

  @override
  String get messagesUnread => 'Unread';

  @override
  String get messagesMarkAllRead => 'Mark all as read';

  @override
  String get newsTitle => 'News';

  @override
  String get expenseTitle => 'Expense';

  @override
  String get expenseRegularExpense => 'Regular Expense';

  @override
  String get expenseSupportPayment => 'Support Payment';

  @override
  String get expenseChildName => 'Child Name';

  @override
  String get expenseSubmittedBy => 'Submitted By';

  @override
  String get expenseReferenceNumber => 'Reference Number';

  @override
  String get expensePaymentPeriod => 'Payment Period';

  @override
  String get expenseCourtCase => 'Court Case';

  @override
  String get expenseViewReceipt => 'VIEW RECEIPT';

  @override
  String get expenseTotalThisMonth => 'Total This Month';

  @override
  String get expenseYouPaid => 'You Paid';

  @override
  String get expenseCoParentPaid => 'Co-parent Paid';

  @override
  String get expenseAddExpense => 'Add Expense';

  @override
  String get addExpenseTitle => 'Add Expense';

  @override
  String get addExpenseCategoryLabel => 'Category';

  @override
  String get addExpenseSelectCategoryHint => 'Select Category';

  @override
  String get addExpenseDateLabel => 'Date';

  @override
  String get addExpenseSelectDateHint => 'Select Date';

  @override
  String get addExpenseAmountLabel => 'Amount';

  @override
  String get addExpenseEnterAmountHint => 'Enter amount';

  @override
  String get addExpenseAmountRequired => 'Amount is required';

  @override
  String get addExpenseEnterValidAmount => 'Enter a valid amount';

  @override
  String get addExpenseCurrencyLabel => 'Currency';

  @override
  String get addExpenseSelectCurrencyHint => 'Select Currency';

  @override
  String get addExpenseDescriptionLabel => 'Description';

  @override
  String get addExpenseEnterDescriptionHint => 'Enter description';

  @override
  String get addExpenseProofOfPurchaseLabel => 'Proof of Purchase';

  @override
  String get addExpenseTapToUpload => 'Tap to upload';

  @override
  String get addExpenseUploadFormats => 'JPG, PNG or PDF';

  @override
  String get addExpenseAlreadyPaidQuestion =>
      'Have you already paid this expense?';

  @override
  String get ourMissionDescription =>
      'Our mission is to provide high-performance construction chemical solutions that meet the highest standards of quality, safety, and sustainability. We support our customers with innovative products and expert guidance, enabling them to achieve durable, efficient, and environmentally responsible construction results.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started!';

  @override
  String get onboardingLogin => 'Log In';

  @override
  String get onboardingJoinUsingCode => 'Join Using a Code';

  @override
  String get onboardingPage1Title => 'A better way to co-parent';

  @override
  String get onboardingPage1Subtitle =>
      'A secure space designed to help parents communicate, organize, and make decisions with less conflict and more clarity.';

  @override
  String get onboardingPage2Title => 'Clear and respectful communication';

  @override
  String get onboardingPage2Subtitle =>
      'All messages are documented, time-stamped, and cannot be edited or deleted, helping conversations stay accountable and constructive.';

  @override
  String get onboardingPage3Title => 'Important documents, safely stored';

  @override
  String get onboardingPage3Subtitle =>
      'Keep medical, school, legal, and financial documents encrypted and accessible with full access history.';

  @override
  String get onboardingPage4Title => 'Built on trust and privacy';

  @override
  String get onboardingPage4Subtitle =>
      'Your data is protected with strong security measures and handled according to Egyptian data protection law.';

  @override
  String get authVerifyTitle => 'Verification';

  @override
  String get authVerifyCodeHeading => 'Enter verification code';

  @override
  String get authVerifySubtitle =>
      'We sent a verification code to your email address. Please enter it below.';

  @override
  String get authDidntReceive => 'Didn\'t receive the code?';

  @override
  String get authResend => 'Resend';

  @override
  String get authContinue => 'Continue';

  @override
  String get authVerificationCodeSent => 'Verification code sent successfully';

  @override
  String get authRoleOptionsTitle => 'Role Options';

  @override
  String get authRoleOptionsHeading => 'How will you use the app?';

  @override
  String get authRoleOptionsSubtitle =>
      'Choose the option that best describes your situation.';

  @override
  String get authRoleFamilySpace => 'Family Space';

  @override
  String get authRoleFamilySpaceDesc =>
      'Co-parent with your partner in a shared family workspace.';

  @override
  String get authRoleSolo => 'Solo';

  @override
  String get authRoleSoloDesc =>
      'Manage your parenting schedule independently.';

  @override
  String get authNext => 'Next';

  @override
  String get authCoParentDetailsTitle => 'Co-Parent Details';

  @override
  String get authCoParentDetailsHeading => 'Invite your co-parent';

  @override
  String get authCoParentDetailsSubtitle =>
      'Enter your co-parent\'s details to send them an invitation.';

  @override
  String get authCoParentFirstName => 'First Name';

  @override
  String get authCoParentLastName => 'Last Name';

  @override
  String get authCoParentEmail => 'Email';

  @override
  String get authCoParentPhone => 'Phone Number';

  @override
  String get authCoParentDate => 'Date of Birth';

  @override
  String get authCoParentNote =>
      'Your co-parent will receive an email invitation to join the family workspace.';

  @override
  String get familyChildDisplayNameLabel => 'Display Name';

  @override
  String get familyChildDisplayNameHint => 'Enter display name';

  @override
  String get familyChildFirstNameLabel => 'First Name';

  @override
  String get familyChildFirstNameHint => 'Enter first name';

  @override
  String get familyChildLastNameLabel => 'Last Name';

  @override
  String get familyChildLastNameHint => 'Enter last name';

  @override
  String get familyChildEmailLabel => 'Email';

  @override
  String get familyChildEmailHint => 'Enter email address';

  @override
  String get familyChildPhoneLabel => 'Phone Number';

  @override
  String get familyChildPhoneHint => 'Enter phone number';

  @override
  String get familyChildDateOfBirthLabel => 'Date of Birth';

  @override
  String get familyChildDateOfBirthHint => 'DD-MM-YYYY';

  @override
  String get familyChildAddedSuccess => 'Child added successfully';

  @override
  String get authForgotPasswordTitle => 'Forgot Password';

  @override
  String get authForgotPasswordHeading => 'Forgot your password?';

  @override
  String get authForgotPasswordSubtitle =>
      'Enter your email and we’ll send you a verification code.';

  @override
  String get authForgotPasswordButton => 'Send Code';

  @override
  String get authForgotPasswordOtpTitle => 'Verification Code';

  @override
  String get authForgotPasswordOtpHeading => 'Enter verification code';

  @override
  String get authForgotPasswordOtpSubtitle =>
      'We sent a verification code to your email. Please enter it below.';

  @override
  String get authResetPasswordTitle => 'Reset Password';

  @override
  String get authResetPasswordHeading => 'Create a new password';

  @override
  String get authResetPasswordSubtitle =>
      'Your new password must be different from previously used passwords.';

  @override
  String get authNewPasswordLabel => 'New Password';

  @override
  String get authNewPasswordHint => '********';

  @override
  String get authConfirmNewPasswordLabel => 'Confirm New Password';

  @override
  String get authResetPasswordButton => 'Reset Password';

  @override
  String get authPasswordResetSuccess => 'Password reset successfully';

  @override
  String get back => 'Back';

  @override
  String get homeQuickActions => 'Quick Actions';

  @override
  String get homeAwaitingResponse => 'Awaiting Your Response';

  @override
  String get homeRecentActivity => 'Recent Activity';

  @override
  String get homeGuest => 'Guest';

  @override
  String get homeWelcomeBack => 'Welcome back';

  @override
  String get homeGoodMorning => 'Good Morning';

  @override
  String get homeFrom => 'From: ';

  @override
  String get newsFilter => 'Filter';

  @override
  String get newsResetFilters => 'Reset Filters';

  @override
  String get newsSearchByName => 'Search by Name';

  @override
  String get newsSearchHint => 'Search';

  @override
  String get newsSearchByType => 'Search by Type';

  @override
  String get newsSortBy => 'Sort by';

  @override
  String get newsApplyFilters => 'APPLY FILTERS';

  @override
  String get newsAllPosts => 'All Posts';

  @override
  String get newsUpdates => 'Updates';

  @override
  String get newsAnnouncements => 'Announcements';

  @override
  String get newsPhotos => 'Photos';

  @override
  String get newsDocuments => 'Documents';

  @override
  String get newsExpenseUpdates => 'Expense Updates';

  @override
  String get newsNewest => 'Newest';

  @override
  String get newsOldest => 'Oldest';

  @override
  String get newsName => 'Name';

  @override
  String get newsSeeMore => 'see more';

  @override
  String get newsShowLess => 'show less';

  @override
  String get newsLike => 'Like';

  @override
  String get newsHelpful => 'Helpful';

  @override
  String get expenseCategoryEducation => 'Education';

  @override
  String get expenseCategoryHealthcare => 'Healthcare';

  @override
  String get expenseCategoryActivities => 'Activities';

  @override
  String get expenseCategoryEssentials => 'Essentials';

  @override
  String get expenseCategoryClothing => 'Clothing';

  @override
  String get expenseCategoryFood => 'Food';

  @override
  String get expenseCategoryTransportation => 'Transportation';

  @override
  String get expenseCategoryOther => 'Other';

  @override
  String get scheduleFilterAll => 'All';

  @override
  String get scheduleFilterParentingTime => 'Parenting Time';

  @override
  String get scheduleFilterSchoolActivities => 'School & Activities';

  @override
  String get scheduleFilterMedical => 'Medical';

  @override
  String get scheduleLegendApproved => 'Approved';

  @override
  String get scheduleLegendPending => 'Pending';

  @override
  String get scheduleLegendEvent => 'Event';

  @override
  String get scheduleLegendCall => 'Call';

  @override
  String get scheduleLegendRejected => 'Rejected';

  @override
  String get scheduleNewScheduleRequest => 'New Schedule Request';

  @override
  String get scheduleAddNewSchedule => 'Add New Schedule';

  @override
  String get scheduleEventType => 'Event Type';

  @override
  String get scheduleChild => 'Child';

  @override
  String get scheduleDate => 'Date';

  @override
  String get scheduleTime => 'Time';

  @override
  String get scheduleNotes => 'Notes';

  @override
  String get scheduleSendRequest => 'SEND REQUEST';

  @override
  String get scheduleSelect => 'Select';

  @override
  String get scheduleVoiceCall => 'Voice Call';

  @override
  String get scheduleJoin => 'JOIN';

  @override
  String get scheduleViewReceipt => 'VIEW RECEIPT';

  @override
  String get scheduleExpensePaid => 'Expense Paid';

  @override
  String get scheduleCategory => 'Category';

  @override
  String get homeSendMessage => 'Send Message';

  @override
  String get homeAddSchedule => 'Add Schedule';

  @override
  String get homeExpense => 'Expense';

  @override
  String get homeSessions => 'Sessions';

  @override
  String get homeSessionsLibrary => 'Sessions Library';

  @override
  String get homeDocuments => 'Documents';

  @override
  String get homeUpcomingCall => 'Upcoming Call';

  @override
  String get homeReminder => 'Reminder';

  @override
  String get homeConfirm => 'CONFIRM';

  @override
  String get homeRequestReschedule => 'REQUEST RESCHEDULE';

  @override
  String get homeNewEvent => 'New Event';

  @override
  String get homeNewSession => 'New Session';

  @override
  String homePendingCost(Object count) {
    return '$count Pending cost';
  }

  @override
  String get homeReview => 'REVIEW';

  @override
  String get rescheduleTitle => 'Request Reschedule';

  @override
  String get rescheduleSelectDate => 'Select a new date';

  @override
  String get rescheduleSelectTime => 'Select Time';

  @override
  String get rescheduleSubmit => 'REQUEST RESCHEDULE';
}
