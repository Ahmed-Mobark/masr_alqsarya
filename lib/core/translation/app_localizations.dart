import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
  /// **'You must upload a photo with a white background.'**
  String get errorPhotoRequired;

  /// No description provided for @onBoardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced Chemistry for Better Builds'**
  String get onBoardingTitle;

  /// No description provided for @onBoardingDescription.
  ///
  /// In en, this message translates to:
  /// **'High-performance admixtures and construction solutions engineered for durability, precision, and superior results.'**
  String get onBoardingDescription;

  /// No description provided for @onBoardingButtonText.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onBoardingButtonText;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @search_products.
  ///
  /// In en, this message translates to:
  /// **'Search Products'**
  String get search_products;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced Chemistry\nfor Better Builds'**
  String get heroTitle;

  /// No description provided for @heroDescription.
  ///
  /// In en, this message translates to:
  /// **'Advanced solutions for durable,\nprecise construction'**
  String get heroDescription;

  /// No description provided for @exploreProducts.
  ///
  /// In en, this message translates to:
  /// **'Explore Products'**
  String get exploreProducts;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @whoWeAre.
  ///
  /// In en, this message translates to:
  /// **'Who We Are?'**
  String get whoWeAre;

  /// No description provided for @whoWeAreDescription.
  ///
  /// In en, this message translates to:
  /// **'Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing Elit. Ut Efficitur Leo Ut Magna Mollis, Non Scelerisque Loremfa Cilisis.'**
  String get whoWeAreDescription;

  /// No description provided for @ourStory.
  ///
  /// In en, this message translates to:
  /// **'Our Story'**
  String get ourStory;

  /// No description provided for @innovativeSolutionsLine1.
  ///
  /// In en, this message translates to:
  /// **'INNOVATIVE SOLUTIONS'**
  String get innovativeSolutionsLine1;

  /// No description provided for @innovativeSolutionsLine2.
  ///
  /// In en, this message translates to:
  /// **'ADVANCED TECHNOLOGIES'**
  String get innovativeSolutionsLine2;

  /// No description provided for @aboutCompanyDescription.
  ///
  /// In en, this message translates to:
  /// **'NCC X-Calibur was established in January 2010, specialising in the field of Construction Chemicals. Our primary goal has been to introduce innovative products and services that align with the latest industry technologies while upholding international standards of high-quality production.'**
  String get aboutCompanyDescription;

  /// No description provided for @ourVision.
  ///
  /// In en, this message translates to:
  /// **'Our Vision'**
  String get ourVision;

  /// No description provided for @ourVisionDescription.
  ///
  /// In en, this message translates to:
  /// **'Our vision at NCC X-Calibur is to lead the global industry in sustainable construction chemical material technology. We are committed to integrating environmental considerations and sustainability into every aspect of our operations. By prioritising innovation and responsible practices, we aim to set new standards for the industry and contribute positively to the future of construction worldwide.'**
  String get ourVisionDescription;

  /// No description provided for @ourMission.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get ourMission;

  /// No description provided for @ourMissionDescription.
  ///
  /// In en, this message translates to:
  /// **'Our mission is to deliver high-performance construction chemical solutions that meet the highest standards of quality, safety, and sustainability. We strive to support our clients with innovative products and expert guidance, enabling them to achieve durable, efficient, and environmentally responsible construction outcomes.'**
  String get ourMissionDescription;

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

  /// No description provided for @productsTitle.
  ///
  /// In en, this message translates to:
  /// **'PRODUCTS'**
  String get productsTitle;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @productsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find the right solution by product or industry'**
  String get productsSubtitle;

  /// No description provided for @construction_chemicals.
  ///
  /// In en, this message translates to:
  /// **'Construction Chemicals'**
  String get construction_chemicals;

  /// No description provided for @concrete_admixture.
  ///
  /// In en, this message translates to:
  /// **'Concrete Admixtures'**
  String get concrete_admixture;

  /// No description provided for @flooring_system.
  ///
  /// In en, this message translates to:
  /// **'Flooring Systems'**
  String get flooring_system;

  /// No description provided for @infrastructure.
  ///
  /// In en, this message translates to:
  /// **'Infrastructure'**
  String get infrastructure;

  /// No description provided for @featurd_projects.
  ///
  /// In en, this message translates to:
  /// **'FEATURED PROJECTS'**
  String get featurd_projects;

  /// No description provided for @proven_project_resaults.
  ///
  /// In en, this message translates to:
  /// **'Proven results across key industries'**
  String get proven_project_resaults;

  /// No description provided for @read_more.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get read_more;

  /// No description provided for @blogs.
  ///
  /// In en, this message translates to:
  /// **'BLOGS'**
  String get blogs;

  /// No description provided for @blogs_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Latest Articles & Insights'**
  String get blogs_sub_title;

  /// No description provided for @getInTouchTitle.
  ///
  /// In en, this message translates to:
  /// **'Get in Touch'**
  String get getInTouchTitle;

  /// No description provided for @getInTouchDescription.
  ///
  /// In en, this message translates to:
  /// **'The point of using Lorem Ipsum is that it has more-or-less normal'**
  String get getInTouchDescription;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @writeHere.
  ///
  /// In en, this message translates to:
  /// **'Write Here...'**
  String get writeHere;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @contactLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'New York'**
  String get contactLocationTitle;

  /// No description provided for @contactLocationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'42 Mammoun Street, Saba Carpet and Antiques Store, UK'**
  String get contactLocationSubtitle;

  /// No description provided for @contactPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get contactPhoneTitle;

  /// No description provided for @contactPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'+44 123 456 789'**
  String get contactPhoneSubtitle;

  /// No description provided for @contactEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactEmailTitle;

  /// No description provided for @contactEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'info@ncc.com'**
  String get contactEmailSubtitle;

  /// No description provided for @product_type.
  ///
  /// In en, this message translates to:
  /// **'Product Type'**
  String get product_type;

  /// No description provided for @choose_industry.
  ///
  /// In en, this message translates to:
  /// **'Choose Industry'**
  String get choose_industry;

  /// No description provided for @download_brochure_pdf.
  ///
  /// In en, this message translates to:
  /// **'Download TDS ( Technical Data Sheet )'**
  String get download_brochure_pdf;

  /// No description provided for @calculate_quantity.
  ///
  /// In en, this message translates to:
  /// **'Calculate Quantity'**
  String get calculate_quantity;

  /// No description provided for @admixture.
  ///
  /// In en, this message translates to:
  /// **'Admixture'**
  String get admixture;

  /// No description provided for @waterproofing.
  ///
  /// In en, this message translates to:
  /// **'Waterproofing'**
  String get waterproofing;

  /// No description provided for @industrial.
  ///
  /// In en, this message translates to:
  /// **'Industrial'**
  String get industrial;

  /// No description provided for @strength_enhancement.
  ///
  /// In en, this message translates to:
  /// **'Strength Enhancement'**
  String get strength_enhancement;

  /// No description provided for @durability.
  ///
  /// In en, this message translates to:
  /// **'Durability'**
  String get durability;

  /// No description provided for @repair.
  ///
  /// In en, this message translates to:
  /// **'Repair'**
  String get repair;

  /// No description provided for @flooring.
  ///
  /// In en, this message translates to:
  /// **'Flooring'**
  String get flooring;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @usage.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get usage;

  /// No description provided for @packaging.
  ///
  /// In en, this message translates to:
  /// **'Packaging'**
  String get packaging;

  /// No description provided for @interestedInProduct.
  ///
  /// In en, this message translates to:
  /// **'Interested in This Product?'**
  String get interestedInProduct;

  /// No description provided for @contactTeamDesc.
  ///
  /// In en, this message translates to:
  /// **'Contact our team to check availability, specifications, and guidance for your project needs'**
  String get contactTeamDesc;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get emailLabel;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'ADDRESS'**
  String get addressLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'PHONE'**
  String get phoneLabel;

  /// No description provided for @nccAddress.
  ///
  /// In en, this message translates to:
  /// **'233 Industrial Zone, New Cairo – Egypt'**
  String get nccAddress;

  /// No description provided for @nccPhoneOne.
  ///
  /// In en, this message translates to:
  /// **'Whatsapp: +20 120 509 5090'**
  String get nccPhoneOne;

  /// No description provided for @nccHotline.
  ///
  /// In en, this message translates to:
  /// **'Hotline: 16960'**
  String get nccHotline;

  /// No description provided for @calculatorResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Calculation Result'**
  String get calculatorResultTitle;

  /// No description provided for @calculatorResultLiters.
  ///
  /// In en, this message translates to:
  /// **'Required in Liters'**
  String get calculatorResultLiters;

  /// No description provided for @unitLiters.
  ///
  /// In en, this message translates to:
  /// **'Liters'**
  String get unitLiters;

  /// No description provided for @calculatorResultGallons.
  ///
  /// In en, this message translates to:
  /// **'Required in Gallons'**
  String get calculatorResultGallons;

  /// No description provided for @unitGallons.
  ///
  /// In en, this message translates to:
  /// **'Gallons'**
  String get unitGallons;

  /// No description provided for @calculatorProductLabel.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get calculatorProductLabel;

  /// No description provided for @calculatorProductHint.
  ///
  /// In en, this message translates to:
  /// **'Select product'**
  String get calculatorProductHint;

  /// No description provided for @calculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Calculator'**
  String get calculatorTitle;

  /// No description provided for @calculatorHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Quantity Calculator'**
  String get calculatorHeaderTitle;

  /// No description provided for @calculatorHeaderDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the area to instantly calculate the required quantity in L, Gal, and Kg.'**
  String get calculatorHeaderDescription;

  /// No description provided for @calculatorAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter the working area (km²)?'**
  String get calculatorAreaLabel;

  /// No description provided for @dropdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Select the working area'**
  String get dropdownTitle;

  /// No description provided for @similar_projects.
  ///
  /// In en, this message translates to:
  /// **'SIMILAR PROJECTS'**
  String get similar_projects;

  /// No description provided for @products_used.
  ///
  /// In en, this message translates to:
  /// **'PRODUCTS USED'**
  String get products_used;

  /// No description provided for @our_projects.
  ///
  /// In en, this message translates to:
  /// **'OUR PROJECTS'**
  String get our_projects;

  /// No description provided for @projetc_use_this_product.
  ///
  /// In en, this message translates to:
  /// **'Projects Using This Product'**
  String get projetc_use_this_product;

  /// No description provided for @projetc_use_this_product_desc.
  ///
  /// In en, this message translates to:
  /// **'Explore real projects where this product delivered proven performance and reliable results.'**
  String get projetc_use_this_product_desc;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @construction_products.
  ///
  /// In en, this message translates to:
  /// **'Construction Products'**
  String get construction_products;

  /// No description provided for @insights_financial_updates.
  ///
  /// In en, this message translates to:
  /// **'INSIGHTS & FINANCIAL\nUPDATES'**
  String get insights_financial_updates;

  /// No description provided for @related_posts.
  ///
  /// In en, this message translates to:
  /// **'RELATED POSTS'**
  String get related_posts;

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

  /// No description provided for @is_required.
  ///
  /// In en, this message translates to:
  /// **'is required'**
  String get is_required;

  /// No description provided for @search_projects.
  ///
  /// In en, this message translates to:
  /// **'Search projects'**
  String get search_projects;

  /// No description provided for @no_projects_found.
  ///
  /// In en, this message translates to:
  /// **'No projects found'**
  String get no_projects_found;

  /// No description provided for @load_more.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get load_more;

  /// No description provided for @successful_projects_across_industries.
  ///
  /// In en, this message translates to:
  /// **'Successful Projects\nAcross Industries'**
  String get successful_projects_across_industries;

  /// No description provided for @discover_real_world_applications_of_our_solutions_across_different_industries.
  ///
  /// In en, this message translates to:
  /// **'Discover Real-World Applications\n Of Our Solutions Across Different Industries'**
  String
  get discover_real_world_applications_of_our_solutions_across_different_industries;

  /// No description provided for @no_products_found.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get no_products_found;
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
      <String>['ar', 'en'].contains(locale.languageCode);

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
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
