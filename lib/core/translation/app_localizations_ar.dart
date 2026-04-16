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
  String errorPhoneValidation(Object length, Object start) {
    return 'يجب أن يبدأ رقم الهاتف بـ $start وأن يكون طوله $length رقم.';
  }

  @override
  String get errorExperienceRequired => 'يجب إضافة تجربة واحدة على الأقل.';

  @override
  String get errorIdDocumentRequired => 'يجب رفع مستند الهوية للتحقق من هويتك.';

  @override
  String get errorPhotoRequired => 'يجب رفع صورة بخلفية بيضاء.';

  @override
  String get onBoardingTitle => 'الكيمياء المتقدمة لبناء أفضل';

  @override
  String get onBoardingDescription =>
      'الإمدادات المقاومة للإجهاد والحلول المبنية للبناء مصممة لضمان المقاومة والدقة والنتائج العالية.';

  @override
  String get onBoardingButtonText => 'ابدأ الآن';

  @override
  String get home => 'الرئيسية';

  @override
  String get products => 'المنتجات';

  @override
  String get projects => 'مشاريع';

  @override
  String get contact => 'اتصل بنا';

  @override
  String get search_products => 'البحث عن المنتجات';

  @override
  String get heroTitle => 'الكيمياء المتقدمة\nلبناء أفضل';

  @override
  String get heroDescription => 'حلول متقدمة للبناء المستدام،\nالدقيق';

  @override
  String get exploreProducts => 'استكشف المنتجات';

  @override
  String get aboutUs => 'معلومات عنا';

  @override
  String get whoWeAre => 'من نحن؟';

  @override
  String get whoWeAreDescription =>
      'لوريم إيبسوم دولور سيت أميت، كونسيكتيتور أديبيسينج إيليت. أوت إفيسيتور ليو أوت ماجنا موليس، نون سسيليسكيو لوريمفا سيلليسيس.';

  @override
  String get ourStory => 'قصتنا';

  @override
  String get innovativeSolutionsLine1 => 'حلول مبتكرة';

  @override
  String get innovativeSolutionsLine2 => 'تقنيات متقدمة';

  @override
  String get aboutCompanyDescription =>
      'تأسست إن سي سي إكس-كاليبر في يناير 2010، متخصصة في مجال الكيماويات الإنشائية. كان هدفنا الأساسي تقديم منتجات وخدمات مبتكرة تتماشى مع أحدث تقنيات الصناعة مع الحفاظ على المعايير الدولية للإنتاج عالي الجودة.';

  @override
  String get ourVision => 'رؤيتنا';

  @override
  String get ourVisionDescription =>
      'رؤيتنا في إن سي سي إكس-كاليبر هي قيادة الصناعة العالمية في تقنية مواد الكيماويات الإنشائية المستدامة. نحن ملتزمون بدمج الاعتبارات البيئية والاستدامة في كل جانب من عملياتنا. من خلال إعطاء الأولوية للابتكار والممارسات المسؤولة، نهدف إلى وضع معايير جديدة للصناعة والإسهام إيجابياً في مستقبل البناء worldwide.';

  @override
  String get ourMission => 'مهمتنا';

  @override
  String get ourMissionDescription =>
      'مهمتنا هي تقديم حلول كيماويات إنشائية عالية الأداء تلبي أعلى معايير الجودة والسلامة والاستدامة. نسعى لدعم عملائنا بمنتجات مبتكرة وإرشاد خبراء، لتمكينهم من تحقيق نتائج بناء متينة وفعالة ومسؤولة بيئياً.';

  @override
  String get sorryMessage => 'نحن آسفون';

  @override
  String get nothingFound => 'لم يتم العثور على شيء';

  @override
  String get chooseImage => 'تحميل اختيار صورة';

  @override
  String get takePicture => 'تحميل التقط صورة';

  @override
  String get chooseFromFiles => 'تحميل اختيار من الملفات';

  @override
  String get productsTitle => 'المنتجات';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get productsSubtitle => 'ابحث عن الحل المناسب حسب المنتج أو الصناعة';

  @override
  String get construction_chemicals => 'مواد كيميائية للبناء';

  @override
  String get concrete_admixture => 'إضافات الخرسانة';

  @override
  String get flooring_system => 'أنظمة الأرضيات';

  @override
  String get infrastructure => 'بنية تحتية';

  @override
  String get featurd_projects => 'المشاريع المميزة';

  @override
  String get proven_project_resaults =>
      'نتائج مثبتة في مختلف القطاعات الرئيسية';

  @override
  String get read_more => 'اقرأ المزيد';

  @override
  String get blogs => 'المدونات';

  @override
  String get blogs_sub_title => 'أحدث المقالات والتحليلات';

  @override
  String get getInTouchTitle => 'تواصل معنا';

  @override
  String get getInTouchDescription =>
      'نقطة استخدام لوريم إيبسوم هي أنها تحتوي على أكثر أو أقل طبيعي';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get writeHere => 'اكتب هنا...';

  @override
  String get sendMessage => 'إرسال الرسالة';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get company => 'الشركة';

  @override
  String get contactLocationTitle => 'نيويورك';

  @override
  String get contactLocationSubtitle =>
      '42 شارع مأمون، متجر سابا للسجاد والتحف، المملكة المتحدة';

  @override
  String get contactPhoneTitle => 'رقم الهاتف';

  @override
  String get contactPhoneSubtitle => '+44 123 456 789';

  @override
  String get contactEmailTitle => 'البريد الإلكتروني';

  @override
  String get contactEmailSubtitle => 'info@ncc.com';

  @override
  String get product_type => 'نوع المنتج';

  @override
  String get choose_industry => 'اختر الصناعة';

  @override
  String get download_brochure_pdf => 'تحميل TDS ( ورقة البيانات الفنية )';

  @override
  String get calculate_quantity => 'حساب الكمية';

  @override
  String get admixture => 'إضافات';

  @override
  String get waterproofing => 'عزل مائي';

  @override
  String get industrial => 'صناعي';

  @override
  String get strength_enhancement => 'تعزيز القوة';

  @override
  String get durability => 'المتانة';

  @override
  String get repair => 'إصلاح';

  @override
  String get flooring => 'الأرضيات';

  @override
  String get features => 'المميزات';

  @override
  String get usage => 'الاستخدام';

  @override
  String get packaging => 'التعبئة';

  @override
  String get interestedInProduct => 'مهتم بهذا المنتج؟';

  @override
  String get contactTeamDesc =>
      'تواصل مع فريقنا للتحقق من التوفر والمواصفات والإرشادات لاحتياجات مشروعك';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get addressLabel => 'العنوان';

  @override
  String get phoneLabel => 'الهاتف';

  @override
  String get nccAddress => '233 المنطقة الصناعية، التجمع الخامس – مصر';

  @override
  String get nccPhoneOne => 'واتساب: +20 120 509 5090';

  @override
  String get nccHotline => 'الخط الساخن: 16960';

  @override
  String get calculatorResultTitle => 'نتيجة الحساب';

  @override
  String get calculatorResultLiters => 'المطلوب باللتر';

  @override
  String get unitLiters => 'لتر';

  @override
  String get calculatorResultGallons => 'المطلوب بالجالون';

  @override
  String get unitGallons => 'جالون';

  @override
  String get calculatorProductLabel => 'المنتج';

  @override
  String get calculatorProductHint => 'اختر المنتج';

  @override
  String get calculatorTitle => 'آلة حاسبة';

  @override
  String get calculatorHeaderTitle => 'حاسبة كمية المنتج';

  @override
  String get calculatorHeaderDescription =>
      'أدخل المنطقة لحساب الكمية المطلوبة على الفور باللتر والجالون والكيلوجرام.';

  @override
  String get calculatorAreaLabel => 'أدخل منطقة العمل (كم²)؟';

  @override
  String get dropdownTitle => 'حدد منطقة العمل';

  @override
  String get similar_projects => 'مشاريع مماثلة';

  @override
  String get products_used => 'المنتجات المستخدمة';

  @override
  String get our_projects => 'مشاريعنا';

  @override
  String get projetc_use_this_product => 'المشاريع التي تستخدم هذا المنتج';

  @override
  String get projetc_use_this_product_desc =>
      'استكشف مشاريع حقيقية حيث قدم هذا المنتج أداءً مثبتاً ونتائج موثوقة.';

  @override
  String get country => 'دولة';

  @override
  String get construction_products => 'منتجات البناء';

  @override
  String get insights_financial_updates => 'رؤى وتحديثات مالية';

  @override
  String get related_posts => 'منشورات ذات صلة';

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
  String get is_required => 'مطلوب';

  @override
  String get search_projects => 'البحث عن المشاريع';

  @override
  String get no_projects_found => 'لم يتم العثور على أي مشاريع';

  @override
  String get load_more => 'تحميل المزيد';

  @override
  String get successful_projects_across_industries =>
      'مشاريع ناجحة في مختلف القطاعات';

  @override
  String
  get discover_real_world_applications_of_our_solutions_across_different_industries =>
      'اكتشف التطبيقات العملية لحلولنا في مختلف الصناعات';

  @override
  String get no_products_found => 'لم يتم العثور على منتجات';
}
