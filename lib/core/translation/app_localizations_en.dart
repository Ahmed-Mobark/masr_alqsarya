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
  String get pendingInvitationTitle => 'Family workspace invitation';

  @override
  String get pendingInvitationSubtitle =>
      'You have a pending invitation. You can accept to join the workspace or reject it.';

  @override
  String get pendingInvitationWorkspaceLabel => 'Workspace';

  @override
  String get pendingInvitationInvitedByLabel => 'Invited by';

  @override
  String get pendingInvitationRoleLabel => 'Role';

  @override
  String get pendingInvitationAccept => 'Accept invitation';

  @override
  String get pendingInvitationReject => 'Reject invitation';

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
  String get callRecording => 'Record';

  @override
  String get callRecordingConsentTitle => 'Recording consent';

  @override
  String get callRecordingConsentBody =>
      'Do you allow this call to be recorded? Both parents must approve.';

  @override
  String get callRecordingApprove => 'Approve';

  @override
  String get callRecordingDeny => 'Deny';

  @override
  String get callRecordingConsentDenied => 'Recording denied.';

  @override
  String get callRecordingWaitingOther =>
      'Waiting for the other parent to approve.';

  @override
  String get callRecordingStarted => 'Recording started.';

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
  String get accountSecurityChangePasswordSubtitle =>
      'Enter your current password, then choose a new password.';

  @override
  String get accountSecurityCurrentPasswordLabel => 'Current Password';

  @override
  String get accountSecurityPasswordChangedSuccess =>
      'Your password was updated successfully.';

  @override
  String get accountSecurityEmailMissingForPassword =>
      'Your account has no email address. Add one before changing your password.';

  @override
  String get accountSecurityEnableTwoFactor =>
      'Enable Two-Factor Authentication';

  @override
  String get accountSecurityDeleteAccount => 'Delete Account';

  @override
  String get accountSecurityDeleteConfirm =>
      'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get accountSecurityDeletePasswordPrompt =>
      'Enter your current password to confirm.';

  @override
  String get accountSecurityDeleteConfirmAction => 'Delete permanently';

  @override
  String get accountSecurityAccountDeleted => 'Your account has been deleted.';

  @override
  String get languageDeviceLanguage => 'Device Language';

  @override
  String get familyInfoTitle => 'Family Information';

  @override
  String get familyInfoStatusLabel => 'Status';

  @override
  String get familyInfoStatusPending => 'Pending';

  @override
  String get familyInfoStatusActive => 'Active';

  @override
  String get familyInfoStatusApproved => 'Approved';

  @override
  String get familyInfoSectionFamily => 'Family Info';

  @override
  String get familyInfoSectionOwner => 'Account holder';

  @override
  String get familyInfoSectionCoParent => 'Co-parent Information';

  @override
  String get familyInfoSectionChild => 'Child Information';

  @override
  String get familyInfoSectionLawyer => 'Lawyer Information';

  @override
  String get familyInfoFieldName => 'name';

  @override
  String get familyInfoFieldEmail => 'Email';

  @override
  String get familyInfoFieldPhone => 'Phone Number';

  @override
  String get familyInfoFieldBirthDate => 'Birth Date';

  @override
  String get familyInfoNoWorkspace =>
      'No workspace is selected. Please sign in again.';

  @override
  String get familyInfoRetry => 'Retry';

  @override
  String get familyInfoEmptyValue => '—';

  @override
  String get familyInfoProfessionalLawyerSubtitle =>
      'Invite a therapist, lawyer, or someone else you trust. You can resend or cancel the invitation while it is still pending.';

  @override
  String get familyInfoSectionProfessional => 'Trusted contacts';

  @override
  String get familyInfoAddSomeoneFamilySpace =>
      'Add someone to your Family space';

  @override
  String get inviteProfessionalTitle => 'Add someone to your Family space';

  @override
  String get inviteProfessionalSubtitle =>
      'You can invite trusted people to participate in your child\'s care and communication.';

  @override
  String get inviteProfessionalTypeLabel => 'Type';

  @override
  String get inviteProfessionalTypeHint => 'Select type';

  @override
  String get inviteProfessionalTypeTherapist => 'Therapist';

  @override
  String get inviteProfessionalTypeLawyer => 'Lawyer';

  @override
  String get inviteProfessionalTypeOther => 'Other';

  @override
  String get inviteProfessionalFirstNameLabel => 'First name';

  @override
  String get inviteProfessionalLastNameLabel => 'Last name';

  @override
  String get inviteProfessionalEmailLabel => 'Email';

  @override
  String get inviteProfessionalPhoneLabel => 'Phone number';

  @override
  String get inviteProfessionalFirstNameHint => 'Enter first name';

  @override
  String get inviteProfessionalLastNameHint => 'Enter last name';

  @override
  String get inviteProfessionalEmailHint => 'Enter email address';

  @override
  String get inviteProfessionalPhoneHint => 'Enter phone number';

  @override
  String get inviteProfessionalContinue => 'Continue';

  @override
  String get familyInfoInviteLawyer => 'Invite lawyer';

  @override
  String get familyInfoInviteLawyerTitle => 'Send an invitation';

  @override
  String get familyInfoLawyerInviteSuccess => 'Invitation sent.';

  @override
  String get familyInfoInvitationStatus => 'Invitation status';

  @override
  String get familyInfoMemberStatusLabel => 'Status';

  @override
  String get familyInfoInvitationPending => 'Pending';

  @override
  String get familyInfoInvitationAccepted => 'Accepted';

  @override
  String get familyInfoInvitationCancelled => 'Cancelled';

  @override
  String get familyInfoInvitationExpired => 'Expired';

  @override
  String get familyInfoInvitationDeclined => 'Declined';

  @override
  String get familyInfoInvitationUnknown => 'Unknown';

  @override
  String get familyInfoResendInvitation => 'Resend';

  @override
  String get familyInfoCancelInvitation => 'Cancel';

  @override
  String get familyInfoResendInvitationSuccess => 'Invitation resent.';

  @override
  String get familyInfoCancelInvitationSuccess => 'Invitation cancelled.';

  @override
  String get familyInfoLawyerEmailMissing =>
      'This invitation has no email on file. Pull to refresh or contact support.';

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
  String get messagesLoadError => 'Could not load conversations.';

  @override
  String get messagesWorkspaceMissing =>
      'Workspace is not ready yet. Try signing in again.';

  @override
  String get messagesEmptyTitle => 'No conversations yet';

  @override
  String get messagesEmptySubtitle =>
      'When you start messaging, threads will appear here.';

  @override
  String get messagesRetry => 'Retry';

  @override
  String get chatLoadError => 'Could not load messages.';

  @override
  String get chatEmptyTitle => 'No messages yet';

  @override
  String get chatEmptySubtitle => 'Send a message to start the conversation.';

  @override
  String get messagesRoleOwner => 'Owner';

  @override
  String get messagesRoleCoPartner => 'Co-parent';

  @override
  String get messagesRoleChild => 'Child';

  @override
  String get messagesNoPreview => 'No messages yet';

  @override
  String get chatAttachmentFallback => 'Attachment';

  @override
  String get chatAttachmentDownloadAction => 'Download';

  @override
  String get chatAttachmentDownloadFailed => 'Could not download the file.';

  @override
  String chatAttachmentDownloadSuccess(String fileName) {
    return 'Saved: $fileName';
  }

  @override
  String get newsTitle => 'News';

  @override
  String get commonError => 'Error';

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
  String get expenseSubmittedTo => 'Submitted To';

  @override
  String get expenseReferenceNumber => 'Reference Number';

  @override
  String get expensePaymentPeriod => 'Payment Period';

  @override
  String get expenseCourtCase => 'Court Case';

  @override
  String get expensePaidBadge => 'PAID';

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
  String get expenseNoDataTitle => 'No expenses yet.';

  @override
  String get invoiceTitle => 'Invoice';

  @override
  String get invoiceNumberPrefix => 'Invoice #';

  @override
  String get invoiceExpenseInformation => 'Expense Information';

  @override
  String get invoiceCategory => 'Category';

  @override
  String get invoiceDateOfService => 'Date of Service';

  @override
  String get invoiceDescription => 'Description';

  @override
  String get invoicePaymentDetails => 'Payment Details';

  @override
  String get invoiceReferenceNumber => 'Reference Number';

  @override
  String get invoicePaidOn => 'Paid On';

  @override
  String get invoicePaymentMethod => 'Payment Method';

  @override
  String get invoiceVerifiedBy => 'Verified By';

  @override
  String get invoiceAttachments => 'Attachments';

  @override
  String get addExpenseTitle => 'Add Expense';

  @override
  String get addExpenseChildLabel => 'Child';

  @override
  String get addExpenseChildBothChildren => 'Both Children';

  @override
  String get addExpenseChildAllChildren => 'All Children';

  @override
  String get addExpensePayerName => 'Payer Name';

  @override
  String get addExpensePayerId => 'Payer ID';

  @override
  String get addExpensePayeeName => 'Payee Name';

  @override
  String get addExpensePayeeId => 'Payee ID';

  @override
  String get addExpenseFieldHint => 'Expense Title';

  @override
  String get addExpenseCurrencyRequired => 'Currency is required';

  @override
  String get addExpenseExpenseTitleLabel => 'Expense Title';

  @override
  String get addExpenseCategoryMedical => 'Medical';

  @override
  String get addExpenseCategoryGroceries => 'groceries';

  @override
  String get addExpenseDatePlaceholder => 'Date';

  @override
  String get addExpenseNotesOptional => 'Notes ( Optional )';

  @override
  String get addExpenseNotesHint => 'Notes';

  @override
  String get addExpenseYesIPaidIt => 'Yes, I paid it';

  @override
  String get addExpenseNotPaidYet => 'No, it has not been paid yet';

  @override
  String get addExpenseUploadReceiptOrInvoice => 'Upload receipt or invoice';

  @override
  String get addExpensePickFromGallery => 'Choose photo from gallery';

  @override
  String get addExpenseTakePhoto => 'Take a photo';

  @override
  String get addExpensePickFile => 'Choose a file (PDF)';

  @override
  String get addExpenseProofTooLarge => 'File is too large (max 5 MB).';

  @override
  String get addExpenseProofPickFailed => 'Could not pick the file.';

  @override
  String get addExpenseSubmitExpense => 'Submit Expense';

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
  String get addExpenseTitleRequired => 'Title is required';

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
  String get authOnboardingAddChildTitle => 'Add children';

  @override
  String get authOnboardingAddChildHeading => 'Child details';

  @override
  String get authOnboardingAddChildSubtitle =>
      'Add each child’s information. Tap “Add another” to save and enter another child, or “Next” to finish and go to the app.';

  @override
  String get authAddAnotherChild => 'Add another';

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
  String get scheduleFilterCalls => 'Calls';

  @override
  String get scheduleLegendApproved => 'Approved';

  @override
  String get scheduleLegendPending => 'Pending';

  @override
  String get scheduleLegendEvent => 'Event';

  @override
  String get scheduleLegendCall => 'Call';

  @override
  String get scheduleCallMode => 'Call mode';

  @override
  String get scheduleCallModeAudio => 'Audio';

  @override
  String get scheduleCallModeVideo => 'Video';

  @override
  String get scheduleCreateCall => 'CREATE CALL';

  @override
  String get scheduleErrorWorkspaceMissing =>
      'Workspace is not ready yet. Try signing in again.';

  @override
  String get scheduleErrorScheduledStartsAtAfterNow =>
      'Please choose a future date.';

  @override
  String get scheduleErrorStartDateRequired => 'Please select a start date.';

  @override
  String get scheduleErrorEndTimeNotAfterStart =>
      'End time must be after start time on the same day.';

  @override
  String get scheduleCallExpired => 'Expired';

  @override
  String get scheduleCallCreatedSuccess => 'Call created successfully.';

  @override
  String get scheduleRoomName => 'Room';

  @override
  String get scheduleVideoCall => 'Video Call';

  @override
  String get scheduleAudioCall => 'Audio Call';

  @override
  String get scheduleLegendRejected => 'Rejected';

  @override
  String get scheduleNewScheduleRequest => 'New Schedule Request';

  @override
  String get scheduleAllCalls => 'All Calls';

  @override
  String get scheduleNoCalls => 'No calls yet';

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
  String get scheduleTimeStart => 'Start time';

  @override
  String get scheduleTimeEnd => 'End time';

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
  String get scheduleJoinCallSuccess => 'Joined call successfully.';

  @override
  String get scheduleJoinCallFailed =>
      'Could not join the call. Please try again.';

  @override
  String get callConnecting => 'Connecting…';

  @override
  String get callLive => 'Live';

  @override
  String get callMic => 'Mic';

  @override
  String get callCamera => 'Camera';

  @override
  String get callLeave => 'Leave';

  @override
  String get callWaitingForOther => 'Waiting for the other participant…';

  @override
  String get callConnectFailed => 'Could not connect to the call.';

  @override
  String get callNoInternet =>
      'No internet connection. Check your network and try again.';

  @override
  String get callMicPermissionRequired =>
      'Microphone permission is required to join the call.';

  @override
  String get callCameraPermissionRequired =>
      'Camera permission is required for video calls.';

  @override
  String get callDisconnected => 'You were disconnected from the call.';

  @override
  String get callReconnecting => 'Connection lost. Reconnecting…';

  @override
  String get callConnectionReplaced =>
      'Call ended because you joined from another device.';

  @override
  String get callUnsupportedPlatform =>
      'Live calls are supported on Android/iOS only. Please run the mobile app.';

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
  String get sessionsScreenTitle => 'Sessions';

  @override
  String get sessionsNextAvailableTitle => 'Next Available Sessions';

  @override
  String get sessionsJoin => 'JOIN';

  @override
  String get sessionsBookSession => 'BOOK SESSION';

  @override
  String get sessionsBookNow => 'BOOK NOW';

  @override
  String get sessionsBookedBadge => 'Booked';

  @override
  String get sessionsBookedSuccess => 'Session booked successfully.';

  @override
  String get sessionsBookedFailed =>
      'Could not book this session. Please try again.';

  @override
  String get sessionLobbyJoinNotAvailableYet =>
      'Join will be available when the session starts.';

  @override
  String sessionLobbyJoinAvailableAt(String time) {
    return 'Join will be available at $time.';
  }

  @override
  String get sessionsPublic => 'Public';

  @override
  String get sessionsPrivate => 'Private';

  @override
  String get sessionsSampleExpertName => 'Dr. Kevin Lowe';

  @override
  String get sessionsSampleExpertRole => 'Family Mediator • PhD Psychology';

  @override
  String get sessionsTomorrow => 'Tomorrow';

  @override
  String get sessionsWednesdayShort => 'Wed';

  @override
  String get sessionsTime0930 => '09:30 AM';

  @override
  String get sessionsRatingValue => '4.9';

  @override
  String get sessionsLibraryTitle => 'Sessions Library';

  @override
  String get sessionsLibrarySearchHint => 'Search';

  @override
  String get sessionsLibraryFilterA11y => 'Filter';

  @override
  String get sessionsLibraryTabAll => 'All';

  @override
  String get sessionsLibraryTabPublicSessions => 'Public Sessions';

  @override
  String get sessionsLibraryTabPrivateRecordings => 'Private Recordings';

  @override
  String get sessionsLibraryWatchRecording => 'WATCH RECORDING';

  @override
  String get sessionsLibraryTagPublic => 'Public';

  @override
  String get sessionsLibraryTagVlog => 'Vlog';

  @override
  String get sessionsLibraryTagPlaylist => 'Playlist';

  @override
  String get sessionsLibrarySampleRecordingTitle =>
      'Family Mediation – October 2026';

  @override
  String get sessionsLibrarySampleExpertName => 'Dr. Salma Hassan';

  @override
  String get sessionsLibrarySampleParticipantsAb => 'Parent A, Parent B';

  @override
  String get sessionsLibrarySampleFamiliesCount => '5 Families';

  @override
  String get sessionsLibrarySampleArchivedDate => 'Sept 12, 2026';

  @override
  String get sessionsLibraryLabelArchived => 'Archived';

  @override
  String get sessionsLibraryDurationSample => '45:30';

  @override
  String get sessionsLibraryEmpty => 'No recordings found.';

  @override
  String get sessionsLibraryTypeSingleVideo => 'Video';

  @override
  String get sessionsLibraryFilterSheetTitle => 'Filters';

  @override
  String get sessionsLibraryFilterSortLabel => 'Sort';

  @override
  String get sessionsLibraryFilterSortDesc => 'Newest first';

  @override
  String get sessionsLibraryFilterSortAsc => 'Oldest first';

  @override
  String get sessionsLibraryFilterExpertLabel => 'Expert';

  @override
  String get sessionsLibraryFilterExpertAll => 'All experts';

  @override
  String get sessionsLibraryFilterPerPageLabel => 'Items per page';

  @override
  String get sessionsLibraryFilterApply => 'Apply';

  @override
  String get sessionsLibraryFilterReset => 'Reset';

  @override
  String get sessionsLibraryWatchInAppTitle => 'Watch';

  @override
  String get sessionsLibraryWatchLoadFailed =>
      'Could not open this link. Check your connection and try again.';

  @override
  String get sessionsEmpty => 'No sessions yet.';

  @override
  String get sessionsRetry => 'Try again';

  @override
  String get sessionsStatusUpcoming => 'Upcoming';

  @override
  String get sessionsStatusScheduled => 'Scheduled';

  @override
  String get sessionsStatusLive => 'Live';

  @override
  String get sessionsStatusEnded => 'Ended';

  @override
  String get sessionsStatusArchived => 'Archived';

  @override
  String get sessionLobbyTitle => 'Session Lobby';

  @override
  String get sessionLobbyScheduleTitle => 'Session Schedule';

  @override
  String get sessionLobbyRecordingConsentTitle => 'Recording Consent';

  @override
  String get sessionLobbyJoinSession => 'JOIN SESSION';

  @override
  String get sessionLobbyStartDateLabel => 'Start Date';

  @override
  String get sessionLobbyStartTimeLabel => 'Start Time';

  @override
  String get sessionLobbyDurationLabel => 'Duration';

  @override
  String sessionLobbyDurationValue(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get sessionLobbyConsentDefaultLine =>
      'I consent to the recording of this session.';

  @override
  String get sessionLobbyRecordingPlaceholder =>
      'This session may be recorded for documentation and security purposes.';

  @override
  String get documentsTitle => 'Documents';

  @override
  String get documentsFolders => 'Folders';

  @override
  String get documentsFolderSchool => 'School';

  @override
  String get documentsFolderCalls => 'Calls';

  @override
  String get documentsFolderInvoices => 'Invoices';

  @override
  String get documentsFolderLegal => 'Legal';

  @override
  String get documentsAddedByParentAMother => 'Added by: Parent A (Mother)';

  @override
  String get documentsAccessBothParents => 'Access: Both Parents';

  @override
  String get documentsLastUpdatedByParentAMother =>
      'Last Updated by: Parent A (Mother)';

  @override
  String get documentsLastUpdatedAtParentAMother =>
      'Last Updated at : Parent A (Mother)';

  @override
  String get documentsWhoCanView => 'Who Can View';

  @override
  String get documentsWhoCanEdit => 'Who Can Edit';

  @override
  String get documentsBothParents => 'Both Parents';

  @override
  String get documentsCustom => 'Custom';

  @override
  String get documentsNoOne => 'No one';

  @override
  String get documentsTabAll => 'All';

  @override
  String get documentsTabVideos => 'Videos';

  @override
  String get documentsTabPhotos => 'Photos';

  @override
  String get documentsTabDocuments => 'Documents';

  @override
  String get documentsTypePdf => 'PDF';

  @override
  String get documentsTypeCourtDocument => 'Court Document';

  @override
  String get documentsTypeInvoice => 'Invoice';

  @override
  String get documentsTypeImage => 'Image';

  @override
  String get documentsEvidenceStatus => 'Evidence Status';

  @override
  String get documentsAllRecords => 'All Records';

  @override
  String get documentsMarkedAsEvidence => 'Marked as Evidence';

  @override
  String get documentsAddedBy => 'Added By';

  @override
  String get documentsAddedByParentA => 'Parent A';

  @override
  String get documentsAddedByParentB => 'Parent B';

  @override
  String get documentsAddedByLawyer => 'Lawyer';

  @override
  String get documentsAddedByMediator => 'Mediator';

  @override
  String get documentsDateRange => 'Date Range';

  @override
  String get documentsStartDate => 'Start Date';

  @override
  String get documentsEndDate => 'End Date';

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

  @override
  String get homeCallConfirmedSuccess => 'Call confirmed successfully.';

  @override
  String get homeCallRescheduledSuccess => 'Call rescheduled successfully.';

  @override
  String get homeCallActionFailed =>
      'Unable to complete this action right now.';

  @override
  String get documentDetailsTitle => 'Document';

  @override
  String get documentDetailsFileSummary => 'File Summary';

  @override
  String get documentDetailsAddedBy => 'Added By';

  @override
  String get documentDetailsDateAdded => 'Date Added';

  @override
  String get documentDetailsVisibility => 'Visibility';

  @override
  String get documentDetailsVisibilityBothParents =>
      'Both Parents (Joint Access)';

  @override
  String get documentDetailsInfo => 'Info';

  @override
  String documentDetailsFileLabel(Object name) {
    return 'File: $name';
  }

  @override
  String documentDetailsTypeLabel(Object type) {
    return 'Type: $type';
  }

  @override
  String documentDetailsSizeLabel(Object size) {
    return 'Size: $size';
  }

  @override
  String get documentDetailsActions => 'Document Actions';

  @override
  String get documentDetailsDownload => 'Download';

  @override
  String get documentDetailsUpdatePermissions => 'Update Permissions';

  @override
  String get documentDetailsActivityLog => 'Activity Log';

  @override
  String get documentDetailsArchive => 'Archive';

  @override
  String documentDetailsVisibilityCount(Object canView, Object total) {
    return '$canView of $total';
  }

  @override
  String get documentDetailsEvidence => 'Evidence';

  @override
  String get documentDetailsNotEvidence => 'Not Evidence';

  @override
  String get folderEmptyTitle => 'No files yet';

  @override
  String get folderEmptySubtitle =>
      'Files added to this folder will appear here';

  @override
  String get auditLogTitle => 'Audit Log';

  @override
  String get auditLogMarkAsEvidence => 'Mark as Evidence';

  @override
  String get auditLogEvidenceSubtitle => 'Visible to legal counsel and court';

  @override
  String get auditLogActivityHistory => 'Activity History';

  @override
  String get auditLogNoActivity => 'No activity yet';

  @override
  String get auditLogLoadFailed => 'Failed to load activity';

  @override
  String get auditLogDownload => 'DOWNLOAD';

  @override
  String auditLogActionUploaded(Object name) {
    return 'Uploaded by $name';
  }

  @override
  String auditLogActionViewed(Object name) {
    return 'Viewed by $name';
  }

  @override
  String auditLogActionDownloaded(Object name) {
    return 'Downloaded by $name';
  }

  @override
  String get auditLogActionMarkedAsEvidence => 'Marked as Evidence';

  @override
  String auditLogActionPermissionChanged(Object name) {
    return '$name changed permissions';
  }

  @override
  String get chatBlockedAlertTitle => 'Warning';

  @override
  String get chatBlockedDefaultReason =>
      'Sending inappropriate content is not allowed.';

  @override
  String chatBlockedWarningCount(Object count) {
    return 'Warnings: $count';
  }

  @override
  String get chatBlockedOk => 'OK';

  @override
  String get chatClearAttachments => 'Clear';

  @override
  String get chatAttachMenuTitle => 'Add attachment';

  @override
  String get chatAttachFromGallery => 'Photos';

  @override
  String get chatAttachFromFiles => 'Files';

  @override
  String get chatToneAssistantTitle => 'Tone Assistant Intervention';

  @override
  String get chatToneSuggestedAlternative => 'Suggested Alternative';

  @override
  String get chatToneRephraseMessage => 'REPHRASE MESSAGE';

  @override
  String get chatToneSendAsIs => 'SEND AS IS';

  @override
  String get chatAttachmentViewAction => 'View';

  @override
  String get chatFlaggedMessage => 'Flagged message';

  @override
  String get chatImagePreviewFailed => 'Could not display the image';

  @override
  String get chatPolicyTitle => 'Conversation Policy';

  @override
  String get chatPolicyDeletionTitle => 'Message Deletion';

  @override
  String get chatPolicyDeletionDescription =>
      'All sent messages are permanent. To maintain a transparent record for co-parenting safety, editing or deleting messages is not permitted.';

  @override
  String get chatPolicyHistoryTitle => 'Message History';

  @override
  String get chatPolicyHistoryDescription =>
      'Every message is timestamped and logged securely. Read receipts and delivery status are permanently recorded in the system logs.';

  @override
  String get chatPolicyLegalTitle => 'Legal Notice';

  @override
  String get chatPolicyLegalDescription =>
      'The entire conversation record can be exported as official documentation for legal proceedings or mediation requirements.';

  @override
  String get chatPolicyAcknowledge => 'I UNDERSTAND';

  @override
  String get chatInsightsTitle => 'Conversation Insights';

  @override
  String get chatInsightsToneTab => 'Tone Analysis';

  @override
  String get chatInsightsAuditTab => 'Audit Log';

  @override
  String get chatInsightsOverallTone => 'Overall Communication Tone';

  @override
  String get chatInsightsCalmNeutral => 'Calm & Neutral';

  @override
  String get chatInsightsHealthy => 'Healthy';

  @override
  String get chatInsightsOptimal => 'OPTIMAL';

  @override
  String get chatInsightsToneDescription =>
      'Your communication remains consistently constructive and professional. No significant patterns of escalation detected this week.';

  @override
  String get chatInsightsRecentActivityTitle => 'Recent Activity & Flags';

  @override
  String get chatInsightsPassiveAggressiveFlag => 'Passive-Aggressive Flag';

  @override
  String get chatInsightsPassiveAggressiveExample =>
      '\"I guess it\'s fine if you\'re late again...\"';

  @override
  String get chatInsightsToneCorrectionApplied => 'Tone Correction Applied';

  @override
  String get chatInsightsToneCorrectionDescription =>
      'User edited a message to follow neutrality guidelines before sending.';

  @override
  String get chatInsightsActivityDate => 'Oct 24, 09:12 AM';

  @override
  String get chatInsightsAuditSectionTitle => 'Message Audit Log';

  @override
  String get chatInsightsIncidentCode => 'Incident #4291-B';

  @override
  String get chatInsightsOriginalText => 'Original Text (Draft/Redacted)';

  @override
  String get chatInsightsRevisedText => 'Revised Text (Sent)';

  @override
  String get chatInsightsOriginalExample =>
      '\"You never inform me about the doctor\'s appointments until the last second. It\'s ridiculous.\"';

  @override
  String get chatInsightsRevisedExample =>
      '\"Please inform me about the doctor\'s appointments as soon as they are scheduled. Thank you.\"';

  @override
  String get chatInsightsEmptyActivities => 'No recent alerts or corrections.';

  @override
  String get chatInsightsEmptyAuditLog => 'No audit entries yet.';
}
