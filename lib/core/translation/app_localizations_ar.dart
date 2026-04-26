// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get errorFieldRequired => 'هذا الحقل مطلوب';

  @override
  String get errorInvalidName => 'تنسيق الاسم غير صحيح';

  @override
  String get errorInvalidUrl => 'عنوان URL غير صالح';

  @override
  String get errorInvalidPhoneNumber => 'رقم الهاتف غير صحيح';

  @override
  String get errorInvalidEmail => 'عنوان البريد الإلكتروني غير صحيح';

  @override
  String get errorInvalidPassword =>
      'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل مع أحرف كبيرة وصغيرة ورموز خاصة';

  @override
  String get errorPasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get errorInvalidNumber => 'رقم غير صالح';

  @override
  String get errorInvalidIban => 'تنسيق IBAN غير صالح';

  @override
  String get errorInvalidMobileNumber => 'رقم الجوال غير صالح';

  @override
  String get errorInvalidStcPayId => 'معرف STC Pay غير صالح';

  @override
  String get errorInvalidNationalId => 'رقم الهوية الوطنية غير صالح';

  @override
  String get errorInvalidPassport => 'رقم جواز السفر غير صالح';

  @override
  String get sorryMessage => 'نحن آسفون';

  @override
  String get nothingFound => 'لم يتم العثور على شيء';

  @override
  String errorPhoneValidation(Object length, Object start) {
    return 'يجب أن يبدأ رقم الهاتف بـ $start وأن يكون طوله $length رقم.';
  }

  @override
  String get errorExperienceRequired => 'يجب إضافة تجربة واحدة على الأقل.';

  @override
  String get errorIdDocumentRequired => 'يجب رفع مستند الهوية للتحقق من هويتك.';

  @override
  String get errorPhotoRequired => 'يجب رفع صورة بخلفية بيضاء';

  @override
  String get updateAvailableTitle => 'تحديث متاح';

  @override
  String get updateMandatoryMessage =>
      'يتوفر إصدار جديد من التطبيق. يرجى التحديث للمتابعة في استخدام التطبيق.';

  @override
  String get updateOptionalMessage =>
      'يتوفر إصدار جديد من التطبيق. نوصي بالتحديث للحصول على أفضل تجربة.';

  @override
  String get updateNow => 'تحديث الآن';

  @override
  String get skip => 'تخطي';

  @override
  String get chooseImage => 'تحميل اختيار صورة';

  @override
  String get takePicture => 'تحميل التقط صورة';

  @override
  String get chooseFromFiles => 'تحميل اختيار من الملفات';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsPushNotifications => 'إشعارات الدفع';

  @override
  String get settingsEmailNotifications => 'إشعارات البريد الإلكتروني';

  @override
  String get settingsDarkMode => 'الوضع الداكن';

  @override
  String get settingsToneAnalysis => 'تحليل النبرة';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get navHomeTabLabel => 'الرئيسية';

  @override
  String get navScheduleTabLabel => 'الجدول';

  @override
  String get navNewsTabLabel => 'الأخبار';

  @override
  String get navMessagesTabLabel => 'الرسائل';

  @override
  String get navExpenseTabLabel => 'المصروفات';

  @override
  String get scheduleSharedCalendarTitle => 'التقويم المشترك';

  @override
  String get scheduleNoEventsForDay => 'لا توجد أحداث لهذا اليوم';

  @override
  String get scheduleEventTypePickup => 'استلام';

  @override
  String get scheduleEventTypeMedical => 'طبي';

  @override
  String get scheduleEventTypeActivity => 'نشاط';

  @override
  String get scheduleEventTypeSchool => 'مدرسة';

  @override
  String get scheduleEventTypeCustody => 'حضانة';

  @override
  String get scheduleAllDay => 'طوال اليوم';

  @override
  String get authLoginTitle => 'تسجيل الدخول';

  @override
  String get authLoginIntroTitle => 'مرحبًا بك في مصر الأسرية';

  @override
  String get authLoginIntroSubtitle =>
      'ابدأ في بناء تجربة تربية مشتركة آمنة ومنظمة.';

  @override
  String get authEmailTab => 'البريد الإلكتروني';

  @override
  String get authPhoneTab => 'رقم الهاتف';

  @override
  String get authEmailLabel => 'البريد الإلكتروني';

  @override
  String get authEmailEntryHint => 'أدخل البريد الإلكتروني';

  @override
  String get authEmailHint => 'example@email.com';

  @override
  String get authPhoneLabel => 'رقم الهاتف';

  @override
  String get authPhoneHint => '+20 123 456 7890';

  @override
  String get authPasswordLabel => 'كلمة المرور';

  @override
  String get authPasswordHint => '********';

  @override
  String get authForgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get authLoginButton => 'تسجيل الدخول';

  @override
  String get authOrContinueWith => 'أو المتابعة باستخدام';

  @override
  String get authDontHaveAccountPrefix => 'ليس لديك حساب؟ ';

  @override
  String get authSignUp => 'إنشاء حساب';

  @override
  String get authSignUpTitle => 'إنشاء حساب';

  @override
  String get authSignUpIntroTitle => 'كيف ستستخدم التطبيق؟';

  @override
  String get authSignUpIntroSubtitle => 'اختر الخيار الذي يصفك بشكل أفضل.';

  @override
  String get authFullNameLabel => 'الاسم الكامل';

  @override
  String get authFullNameHint => 'الاسم الكامل';

  @override
  String get authFirstNameLabel => 'الاسم الأول';

  @override
  String get authFirstNameHint => 'محمد';

  @override
  String get authLastNameLabel => 'اسم العائلة';

  @override
  String get authLastNameHint => 'أحمد';

  @override
  String get authConfirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get authAgreeTermsPrefix => 'يرجى الموافقة على ';

  @override
  String get authTermsAndConditions => 'الشروط والأحكام';

  @override
  String get authAgreeTermsSuffix => ' للمتابعة.';

  @override
  String get authAgreeTermsToContinue =>
      'يرجى الموافقة على الشروط والأحكام للمتابعة.';

  @override
  String get authOrShort => 'أو';

  @override
  String get authContinueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get authContinueWithApple => 'المتابعة باستخدام Apple';

  @override
  String get authSignUpButton => 'إنشاء حساب';

  @override
  String get authAlreadyHaveAccountPrefix => 'لديك حساب بالفعل؟ ';

  @override
  String get authLoginLink => 'تسجيل الدخول';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonClose => 'إغلاق';

  @override
  String get commonShare => 'مشاركة';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonAdd => 'إضافة';

  @override
  String get commonDelete => 'حذف';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get profileMoreInformation => 'مزيد من المعلومات';

  @override
  String get profileMenuAccount => 'الحساب';

  @override
  String get profileMenuFamilySpace => 'مساحة العائلة';

  @override
  String get profileMenuPrivacySecurity => 'الخصوصية والأمان';

  @override
  String get profileMenuNotification => 'الإشعارات';

  @override
  String get profileMenuAccountSecurity => 'الحساب والأمان';

  @override
  String get profileMenuFamilyInformation => 'معلومات العائلة';

  @override
  String get profileMenuNotifications => 'الإشعارات';

  @override
  String get profileMenuLanguage => 'اللغة';

  @override
  String get profileMenuLegalTerms => 'الشروط القانونية والاستخدام';

  @override
  String get profileMenuTermsOfUse => 'شروط الاستخدام';

  @override
  String get profileMenuInvitePeople => 'دعوة أشخاص';

  @override
  String get profileMenuDeleteAccount => 'حذف الحساب';

  @override
  String get profileMenuLogout => 'تسجيل الخروج';

  @override
  String get profileTermsTitle => 'شروط الاستخدام';

  @override
  String get profileTermsBody =>
      'باستخدام هذا التطبيق، فإنك توافق على الشروط والأحكام التالية. يرجى قراءتها بعناية قبل المتابعة.\\n\\n1. يجب أن يكون عمرك 18 عامًا على الأقل لاستخدام هذه الخدمة.\\n\\n2. يجب أن تكون جميع المعلومات المقدمة دقيقة ومحدثة.\\n\\n3. أنت مسؤول عن الحفاظ على سرية حسابك.\\n\\n4. نحتفظ بالحق في تعديل هذه الشروط في أي وقت.\\n\\n5. قد يؤدي أي سوء استخدام للمنصة إلى تعليق الحساب.';

  @override
  String get profileInviteTitle => 'دعوة أشخاص';

  @override
  String get profileInviteDescription =>
      'شارك رمز الدعوة الخاص بك مع العائلة والأصدقاء.';

  @override
  String get profileLogoutTitle => 'تسجيل الخروج';

  @override
  String get profileLogoutConfirm => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get accountSecurityTitle => 'الحساب والأمان';

  @override
  String get accountSecurityPersonalInfo => 'المعلومات الشخصية';

  @override
  String get accountSecurityFirstNameLabel => 'الاسم الأول';

  @override
  String get accountSecurityLastNameLabel => 'اسم العائلة';

  @override
  String get accountSecurityEmailAddressLabel => 'عنوان البريد الإلكتروني';

  @override
  String get accountSecurityPhoneNumberLabel => 'رقم الهاتف';

  @override
  String get accountSecurityEmailLabel => 'البريد الإلكتروني';

  @override
  String get accountSecurityPhoneLabel => 'الهاتف';

  @override
  String get accountSecurityChangePassword => 'تغيير كلمة المرور';

  @override
  String get accountSecurityEmailMissingForPassword =>
      'لا يوجد بريد إلكتروني مرتبط بحسابك. أضف بريدًا إلكترونيًا قبل تغيير كلمة المرور.';

  @override
  String get accountSecurityEnableTwoFactor => 'تفعيل المصادقة الثنائية';

  @override
  String get accountSecurityDeleteAccount => 'حذف الحساب';

  @override
  String get accountSecurityDeleteConfirm =>
      'هل أنت متأكد أنك تريد حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get languageDeviceLanguage => 'لغة الجهاز';

  @override
  String get familyInfoTitle => 'معلومات العائلة';

  @override
  String get familyChildrenTitle => 'الأطفال';

  @override
  String get familyAddChild => 'إضافة طفل';

  @override
  String get familyInfoSaved => 'تم حفظ معلومات العائلة';

  @override
  String get familyCoParent => 'الوالد/الوالدة الآخر';

  @override
  String get familyConnected => 'متصل';

  @override
  String familyYearsOld(Object age) {
    return '$age سنة';
  }

  @override
  String get familyChildNameHint => 'اسم الطفل';

  @override
  String get familyChildAgeHint => 'العمر';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsEmptyTitle => 'لا توجد إشعارات بعد';

  @override
  String get notificationsEmptySubtitle => 'سنخبرك عند وصول أي شيء';

  @override
  String get notificationsNewMessageTitle => 'رسالة جديدة';

  @override
  String get notificationsNewMessageBody =>
      'أرسلت فاطمة رسالة بخصوص جدول عطلة نهاية الأسبوع.';

  @override
  String get notificationsScheduleUpdatedTitle => 'تم تحديث الجدول';

  @override
  String get notificationsScheduleUpdatedBody =>
      'تم تحديث جدول المشاركة للأسبوع القادم.';

  @override
  String get notificationsExpenseAddedTitle => 'تمت إضافة مصروف';

  @override
  String get notificationsExpenseAddedBody =>
      'تم تسجيل مصروف مشترك جديد بقيمة 500 جنيه.';

  @override
  String get notificationsReminderTitle => 'تذكير';

  @override
  String get notificationsReminderBody =>
      'لا تنسَ اجتماع أولياء الأمور غدًا الساعة 4 مساءً.';

  @override
  String get notificationsSecurityAlertTitle => 'تنبيه أمني';

  @override
  String get notificationsSecurityAlertBody =>
      'تم استخدام جهاز جديد لتسجيل الدخول إلى حسابك.';

  @override
  String timeMinutesAgo(Object minutes) {
    return 'قبل $minutes دقيقة';
  }

  @override
  String timeHoursAgo(Object hours) {
    return 'قبل $hours ساعة';
  }

  @override
  String timeHoursAgoPlural(Object hours) {
    return 'قبل $hours ساعات';
  }

  @override
  String get timeYesterday => 'أمس';

  @override
  String timeDaysAgo(Object days) {
    return 'قبل $days أيام';
  }

  @override
  String get chatTypeMessageHint => 'اكتب رسالة...';

  @override
  String get updatePleaseUpdateToContinue => 'يرجى تحديث التطبيق للمتابعة.';

  @override
  String get updateNewVersionAvailableShort => 'يتوفر إصدار جديد.';

  @override
  String get languageSelectTitle => 'اختر اللغة';

  @override
  String get commonStart => 'ابدأ';

  @override
  String get messagesTitle => 'الرسائل';

  @override
  String get messagesSearch => 'بحث';

  @override
  String get messagesAll => 'الكل';

  @override
  String get messagesUnread => 'غير مقروءة';

  @override
  String get messagesMarkAllRead => 'تحديد الكل كمقروء';

  @override
  String get messagesLoadError => 'تعذر تحميل المحادثات.';

  @override
  String get messagesWorkspaceMissing =>
      'مساحة العمل غير جاهزة بعد. حاول تسجيل الدخول مرة أخرى.';

  @override
  String get messagesEmptyTitle => 'لا محادثات بعد';

  @override
  String get messagesEmptySubtitle => 'عند بدء المراسلة ستظهر المحادثات هنا.';

  @override
  String get messagesRetry => 'إعادة المحاولة';

  @override
  String get chatLoadError => 'تعذر تحميل الرسائل.';

  @override
  String get chatEmptyTitle => 'لا رسائل بعد';

  @override
  String get chatEmptySubtitle => 'أرسل رسالة لبدء المحادثة.';

  @override
  String get messagesRoleOwner => 'مالك';

  @override
  String get messagesRoleCoPartner => 'شريك تربية';

  @override
  String get messagesRoleChild => 'طفل';

  @override
  String get messagesNoPreview => 'لا رسائل بعد';

  @override
  String get chatAttachmentFallback => 'مرفق';

  @override
  String get chatAttachmentDownloadAction => 'تحميل';

  @override
  String get chatAttachmentDownloadFailed => 'تعذر تنزيل الملف.';

  @override
  String chatAttachmentDownloadSuccess(String fileName) {
    return 'تم الحفظ: $fileName';
  }

  @override
  String get newsTitle => 'الأخبار';

  @override
  String get expenseTitle => 'المصروفات';

  @override
  String get expenseRegularExpense => 'مصروف عادي';

  @override
  String get expenseSupportPayment => 'دفع نفقة';

  @override
  String get expenseChildName => 'اسم الطفل';

  @override
  String get expenseSubmittedBy => 'مقدم من';

  @override
  String get expenseReferenceNumber => 'رقم المرجع';

  @override
  String get expensePaymentPeriod => 'فترة الدفع';

  @override
  String get expenseCourtCase => 'رقم القضية';

  @override
  String get expensePaidBadge => 'مدفوع';

  @override
  String get expenseViewReceipt => 'عرض الإيصال';

  @override
  String get expenseTotalThisMonth => 'الإجمالي هذا الشهر';

  @override
  String get expenseYouPaid => 'دفعتَ أنت';

  @override
  String get expenseCoParentPaid => 'دفع الوالد/الوالدة الآخر';

  @override
  String get expenseAddExpense => 'إضافة مصروف';

  @override
  String get invoiceTitle => 'الفاتورة';

  @override
  String get invoiceNumberPrefix => 'فاتورة رقم ';

  @override
  String get invoiceExpenseInformation => 'معلومات المصروف';

  @override
  String get invoiceCategory => 'الفئة';

  @override
  String get invoiceDateOfService => 'تاريخ الخدمة';

  @override
  String get invoiceDescription => 'الوصف';

  @override
  String get invoicePaymentDetails => 'تفاصيل الدفع';

  @override
  String get invoiceReferenceNumber => 'رقم المرجع';

  @override
  String get invoicePaidOn => 'تاريخ الدفع';

  @override
  String get invoicePaymentMethod => 'طريقة الدفع';

  @override
  String get invoiceVerifiedBy => 'تم التحقق بواسطة';

  @override
  String get invoiceAttachments => 'المرفقات';

  @override
  String get addExpenseTitle => 'إضافة مصروف';

  @override
  String get addExpenseChildLabel => 'الطفل';

  @override
  String get addExpenseChildBothChildren => 'كلا الطفلين';

  @override
  String get addExpensePayerName => 'اسم الدافع';

  @override
  String get addExpensePayerId => 'معرّف الدافع';

  @override
  String get addExpensePayeeName => 'اسم المستلم';

  @override
  String get addExpensePayeeId => 'معرّف المستلم';

  @override
  String get addExpenseFieldHint => 'عنوان المصروف';

  @override
  String get addExpenseCurrencyRequired => 'العملة مطلوبة';

  @override
  String get addExpenseExpenseTitleLabel => 'عنوان المصروف';

  @override
  String get addExpenseCategoryMedical => 'طبي';

  @override
  String get addExpenseCategoryGroceries => 'بقالة';

  @override
  String get addExpenseDatePlaceholder => 'التاريخ';

  @override
  String get addExpenseNotesOptional => 'ملاحظات ( اختياري )';

  @override
  String get addExpenseNotesHint => 'ملاحظة';

  @override
  String get addExpenseYesIPaidIt => 'نعم، قمت بالدفع';

  @override
  String get addExpenseNotPaidYet => 'لا، لم يتم الدفع بعد';

  @override
  String get addExpenseUploadReceiptOrInvoice => 'ارفع إيصالاً أو فاتورة';

  @override
  String get addExpenseProofTooLarge =>
      'الملف كبير جدًا (الحد الأقصى 5 ميجابايت).';

  @override
  String get addExpenseProofPickFailed => 'تعذر اختيار الملف.';

  @override
  String get addExpenseSubmitExpense => 'إرسال المصروف';

  @override
  String get addExpenseCategoryLabel => 'الفئة';

  @override
  String get addExpenseSelectCategoryHint => 'اختر الفئة';

  @override
  String get addExpenseDateLabel => 'التاريخ';

  @override
  String get addExpenseSelectDateHint => 'اختر التاريخ';

  @override
  String get addExpenseAmountLabel => 'المبلغ';

  @override
  String get addExpenseEnterAmountHint => 'أدخل المبلغ';

  @override
  String get addExpenseAmountRequired => 'المبلغ مطلوب';

  @override
  String get addExpenseEnterValidAmount => 'أدخل مبلغًا صحيحًا';

  @override
  String get addExpenseCurrencyLabel => 'العملة';

  @override
  String get addExpenseSelectCurrencyHint => 'اختر العملة';

  @override
  String get addExpenseDescriptionLabel => 'الوصف';

  @override
  String get addExpenseEnterDescriptionHint => 'أدخل الوصف';

  @override
  String get addExpenseProofOfPurchaseLabel => 'إثبات الشراء';

  @override
  String get addExpenseTapToUpload => 'اضغط للرفع';

  @override
  String get addExpenseUploadFormats => 'JPG أو PNG أو PDF';

  @override
  String get addExpenseAlreadyPaidQuestion => 'هل قمت بدفع هذا المصروف بالفعل؟';

  @override
  String get ourMissionDescription =>
      'مهمتنا هي تقديم حلول كيماويات إنشائية عالية الأداء تلبي أعلى معايير الجودة والسلامة والاستدامة. نسعى لدعم عملائنا بمنتجات مبتكرة وإرشاد خبراء، لتمكينهم من تحقيق نتائج بناء متينة وفعالة ومسؤولة بيئياً.';

  @override
  String get onboardingSkip => 'تخطي';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingGetStarted => 'ابدأ الآن!';

  @override
  String get onboardingLogin => 'تسجيل الدخول';

  @override
  String get onboardingJoinUsingCode => 'الانضمام باستخدام رمز';

  @override
  String get onboardingPage1Title => 'طريقة أفضل للتربية المشتركة';

  @override
  String get onboardingPage1Subtitle =>
      'مساحة آمنة تساعد الوالدين على التواصل والتنظيم واتخاذ القرارات بقدر أقل من الخلاف والمزيد من الوضوح.';

  @override
  String get onboardingPage2Title => 'تواصل واضح ومحترم';

  @override
  String get onboardingPage2Subtitle =>
      'جميع الرسائل موثقة ومؤرخة ولا يمكن تعديلها أو حذفها، مما يساعد على إبقاء المحادثات مسؤولة وبنّاءة.';

  @override
  String get onboardingPage3Title => 'مستندات مهمة ومحفوظة بأمان';

  @override
  String get onboardingPage3Subtitle =>
      'احتفظ بالمستندات الطبية والمدرسية والقانونية والمالية مشفرة ومتاحة مع سجل وصول كامل.';

  @override
  String get onboardingPage4Title => 'مبني على الثقة والخصوصية';

  @override
  String get onboardingPage4Subtitle =>
      'بياناتك محمية بإجراءات أمنية قوية ويتم التعامل معها وفقًا لقانون حماية البيانات المصري.';

  @override
  String get authVerifyTitle => 'التحقق';

  @override
  String get authVerifyCodeHeading => 'أدخل رمز التحقق';

  @override
  String get authVerifySubtitle =>
      'لقد أرسلنا رمز التحقق إلى بريدك الإلكتروني. يرجى إدخاله أدناه.';

  @override
  String get authDidntReceive => 'لم تستلم الرمز؟';

  @override
  String get authResend => 'إعادة الإرسال';

  @override
  String get authContinue => 'متابعة';

  @override
  String get authVerificationCodeSent => 'تم إرسال رمز التحقق بنجاح';

  @override
  String get authRoleOptionsTitle => 'خيارات الدور';

  @override
  String get authRoleOptionsHeading => 'كيف ستستخدم التطبيق؟';

  @override
  String get authRoleOptionsSubtitle => 'اختر الخيار الذي يصف وضعك بشكل أفضل.';

  @override
  String get authRoleFamilySpace => 'مساحة العائلة';

  @override
  String get authRoleFamilySpaceDesc =>
      'شارك في تربية أطفالك مع شريكك في مساحة عائلية مشتركة.';

  @override
  String get authRoleSolo => 'فردي';

  @override
  String get authRoleSoloDesc => 'أدر جدول الأبوة بشكل مستقل.';

  @override
  String get authNext => 'التالي';

  @override
  String get authCoParentDetailsTitle => 'تفاصيل الوالد/الوالدة الآخر';

  @override
  String get authCoParentDetailsHeading => 'ادعُ شريكك في التربية';

  @override
  String get authCoParentDetailsSubtitle =>
      'أدخل تفاصيل شريكك في التربية لإرسال دعوة له.';

  @override
  String get authCoParentFirstName => 'الاسم الأول';

  @override
  String get authCoParentLastName => 'اسم العائلة';

  @override
  String get authCoParentEmail => 'البريد الإلكتروني';

  @override
  String get authCoParentPhone => 'رقم الهاتف';

  @override
  String get authCoParentDate => 'تاريخ الميلاد';

  @override
  String get authCoParentNote =>
      'سيتلقى شريكك في التربية دعوة عبر البريد الإلكتروني للانضمام إلى مساحة العائلة.';

  @override
  String get authOnboardingAddChildTitle => 'إضافة الأطفال';

  @override
  String get authOnboardingAddChildHeading => 'بيانات الطفل';

  @override
  String get authOnboardingAddChildSubtitle =>
      'أدخل بيانات كل طفل. اضغط «إضافة آخر» للحفظ وإدخال طفل آخر، أو «التالي» للإنهاء والانتقال للتطبيق.';

  @override
  String get authAddAnotherChild => 'إضافة آخر';

  @override
  String get familyChildDisplayNameLabel => 'الاسم المعروض';

  @override
  String get familyChildDisplayNameHint => 'أدخل الاسم المعروض';

  @override
  String get familyChildFirstNameLabel => 'الاسم الأول';

  @override
  String get familyChildFirstNameHint => 'أدخل الاسم الأول';

  @override
  String get familyChildLastNameLabel => 'اسم العائلة';

  @override
  String get familyChildLastNameHint => 'أدخل اسم العائلة';

  @override
  String get familyChildEmailLabel => 'البريد الإلكتروني';

  @override
  String get familyChildEmailHint => 'أدخل البريد الإلكتروني';

  @override
  String get familyChildPhoneLabel => 'رقم الهاتف';

  @override
  String get familyChildPhoneHint => 'أدخل رقم الهاتف';

  @override
  String get familyChildDateOfBirthLabel => 'تاريخ الميلاد';

  @override
  String get familyChildDateOfBirthHint => 'يوم-شهر-سنة';

  @override
  String get familyChildAddedSuccess => 'تمت إضافة الطفل بنجاح';

  @override
  String get authForgotPasswordTitle => 'نسيت كلمة المرور';

  @override
  String get authForgotPasswordHeading => 'هل نسيت كلمة المرور؟';

  @override
  String get authForgotPasswordSubtitle =>
      'أدخل بريدك الإلكتروني وسنرسل لك رمز تحقق.';

  @override
  String get authForgotPasswordButton => 'إرسال الرمز';

  @override
  String get authForgotPasswordOtpTitle => 'رمز التحقق';

  @override
  String get authForgotPasswordOtpHeading => 'أدخل رمز التحقق';

  @override
  String get authForgotPasswordOtpSubtitle =>
      'لقد أرسلنا رمز تحقق إلى بريدك الإلكتروني. يرجى إدخاله أدناه.';

  @override
  String get authResetPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get authResetPasswordHeading => 'إنشاء كلمة مرور جديدة';

  @override
  String get authResetPasswordSubtitle =>
      'يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمات المرور المستخدمة سابقًا.';

  @override
  String get authNewPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get authNewPasswordHint => '********';

  @override
  String get authConfirmNewPasswordLabel => 'تأكيد كلمة المرور الجديدة';

  @override
  String get authResetPasswordButton => 'إعادة تعيين';

  @override
  String get authPasswordResetSuccess => 'تمت إعادة تعيين كلمة المرور بنجاح';

  @override
  String get back => 'عودة';

  @override
  String get homeQuickActions => 'إجراءات سريعة';

  @override
  String get homeAwaitingResponse => 'في انتظار ردك';

  @override
  String get homeRecentActivity => 'النشاط الأخير';

  @override
  String get homeGuest => 'زائر';

  @override
  String get homeWelcomeBack => 'مرحبًا بعودتك';

  @override
  String get homeGoodMorning => 'صباح الخير';

  @override
  String get homeFrom => 'من: ';

  @override
  String get newsFilter => 'تصفية';

  @override
  String get newsResetFilters => 'إعادة تعيين';

  @override
  String get newsSearchByName => 'البحث بالاسم';

  @override
  String get newsSearchHint => 'بحث';

  @override
  String get newsSearchByType => 'البحث بالنوع';

  @override
  String get newsSortBy => 'ترتيب حسب';

  @override
  String get newsApplyFilters => 'تطبيق التصفية';

  @override
  String get newsAllPosts => 'جميع المنشورات';

  @override
  String get newsUpdates => 'تحديثات';

  @override
  String get newsAnnouncements => 'إعلانات';

  @override
  String get newsPhotos => 'صور';

  @override
  String get newsDocuments => 'مستندات';

  @override
  String get newsExpenseUpdates => 'تحديثات المصروفات';

  @override
  String get newsNewest => 'الأحدث';

  @override
  String get newsOldest => 'الأقدم';

  @override
  String get newsName => 'الاسم';

  @override
  String get newsSeeMore => 'عرض المزيد';

  @override
  String get newsShowLess => 'عرض أقل';

  @override
  String get newsLike => 'إعجاب';

  @override
  String get newsHelpful => 'مفيد';

  @override
  String get expenseCategoryEducation => 'تعليم';

  @override
  String get expenseCategoryHealthcare => 'رعاية صحية';

  @override
  String get expenseCategoryActivities => 'أنشطة';

  @override
  String get expenseCategoryEssentials => 'أساسيات';

  @override
  String get expenseCategoryClothing => 'ملابس';

  @override
  String get expenseCategoryFood => 'طعام';

  @override
  String get expenseCategoryTransportation => 'مواصلات';

  @override
  String get expenseCategoryOther => 'أخرى';

  @override
  String get scheduleFilterAll => 'الكل';

  @override
  String get scheduleFilterParentingTime => 'وقت الأبوة';

  @override
  String get scheduleFilterSchoolActivities => 'المدرسة والأنشطة';

  @override
  String get scheduleFilterMedical => 'طبي';

  @override
  String get scheduleFilterCalls => 'المكالمات';

  @override
  String get scheduleLegendApproved => 'موافق عليه';

  @override
  String get scheduleLegendPending => 'قيد الانتظار';

  @override
  String get scheduleLegendEvent => 'حدث';

  @override
  String get scheduleLegendCall => 'مكالمة';

  @override
  String get scheduleCallMode => 'وضع المكالمة';

  @override
  String get scheduleCallModeAudio => 'صوتية';

  @override
  String get scheduleCallModeVideo => 'فيديو';

  @override
  String get scheduleCreateCall => 'إنشاء مكالمة';

  @override
  String get scheduleErrorWorkspaceMissing =>
      'مساحة العمل غير جاهزة بعد. حاول تسجيل الدخول مرة أخرى.';

  @override
  String get scheduleErrorScheduledStartsAtAfterNow =>
      'يرجى اختيار تاريخ في المستقبل.';

  @override
  String get scheduleCallCreatedSuccess => 'تم إنشاء المكالمة بنجاح.';

  @override
  String get scheduleRoomName => 'الغرفة';

  @override
  String get scheduleVideoCall => 'مكالمة فيديو';

  @override
  String get scheduleAudioCall => 'مكالمة صوتية';

  @override
  String get scheduleLegendRejected => 'مرفوض';

  @override
  String get scheduleNewScheduleRequest => 'طلب جدول جديد';

  @override
  String get scheduleAllCalls => 'كل المكالمات';

  @override
  String get scheduleNoCalls => 'لا توجد مكالمات بعد';

  @override
  String get scheduleAddNewSchedule => 'إضافة جدول جديد';

  @override
  String get scheduleEventType => 'نوع الحدث';

  @override
  String get scheduleChild => 'الطفل';

  @override
  String get scheduleDate => 'التاريخ';

  @override
  String get scheduleTime => 'الوقت';

  @override
  String get scheduleNotes => 'ملاحظات';

  @override
  String get scheduleSendRequest => 'إرسال الطلب';

  @override
  String get scheduleSelect => 'اختر';

  @override
  String get scheduleVoiceCall => 'مكالمة صوتية';

  @override
  String get scheduleJoin => 'انضم';

  @override
  String get scheduleJoinCallSuccess => 'تم الانضمام للمكالمة بنجاح.';

  @override
  String get scheduleJoinCallFailed => 'تعذر الانضمام للمكالمة. حاول مرة أخرى.';

  @override
  String get callConnecting => 'جارٍ الاتصال…';

  @override
  String get callLive => 'مباشر';

  @override
  String get callMic => 'الميكروفون';

  @override
  String get callCamera => 'الكاميرا';

  @override
  String get callLeave => 'إنهاء';

  @override
  String get callWaitingForOther => 'في انتظار الطرف الآخر…';

  @override
  String get callConnectFailed => 'تعذر الاتصال بالمكالمة.';

  @override
  String get callNoInternet =>
      'لا يوجد اتصال بالإنترنت. تحقق من الشبكة وحاول مرة أخرى.';

  @override
  String get callMicPermissionRequired =>
      'يلزم السماح بالوصول إلى الميكروفون للانضمام إلى المكالمة.';

  @override
  String get callCameraPermissionRequired =>
      'يلزم السماح بالوصول إلى الكاميرا لإجراء مكالمة فيديو.';

  @override
  String get callDisconnected => 'تم قطع الاتصال بالمكالمة.';

  @override
  String get callReconnecting => 'انقطع الاتصال. جارٍ إعادة الاتصال…';

  @override
  String get callConnectionReplaced =>
      'انتهت المكالمة لأنك انضممت من جهاز آخر.';

  @override
  String get callUnsupportedPlatform =>
      'المكالمات المباشرة متاحة على Android وiOS فقط. شغّل التطبيق على الهاتف.';

  @override
  String get scheduleViewReceipt => 'عرض الإيصال';

  @override
  String get scheduleExpensePaid => 'مصروف مدفوع';

  @override
  String get scheduleCategory => 'الفئة';

  @override
  String get homeSendMessage => 'إرسال رسالة';

  @override
  String get homeAddSchedule => 'إضافة جدول';

  @override
  String get homeExpense => 'المصروفات';

  @override
  String get homeSessions => 'الجلسات';

  @override
  String get homeSessionsLibrary => 'مكتبة الجلسات';

  @override
  String get homeDocuments => 'المستندات';

  @override
  String get homeUpcomingCall => 'مكالمة قادمة';

  @override
  String get homeReminder => 'تذكير';

  @override
  String get homeConfirm => 'تأكيد';

  @override
  String get homeRequestReschedule => 'طلب إعادة جدولة';

  @override
  String get homeNewEvent => 'حدث جديد';

  @override
  String get homeNewSession => 'جلسة جديدة';

  @override
  String homePendingCost(Object count) {
    return '$count تكلفة معلقة';
  }

  @override
  String get homeReview => 'مراجعة';

  @override
  String get rescheduleTitle => 'طلب إعادة جدولة';

  @override
  String get rescheduleSelectDate => 'اختر تاريخاً جديداً';

  @override
  String get rescheduleSelectTime => 'اختر الوقت';

  @override
  String get rescheduleSubmit => 'طلب إعادة جدولة';
}
