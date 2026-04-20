import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/app/app_body.dart';
import 'package:masr_al_qsariya/core/config/app_icons.dart';
import 'package:masr_al_qsariya/core/config/app_images.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/login_view.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  late String _selectedLanguageCode;

  static const _languages = [
    _LanguageOption(code: 'en', name: 'English'),
    _LanguageOption(
      code: 'ar',
      name: '\u0627\u0644\u0639\u0631\u0628\u064A\u0647',
    ),
    _LanguageOption(code: 'fr', name: 'French'),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedLanguageCode = Localizations.localeOf(context).languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 36.h),
                      Image.asset(
                        AppImages.logoApp,
                        width: 140.w,
                        height: 210.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 26.h),
                      Text(
                        context.tr.languageSelectTitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading2().copyWith(
                          fontSize: 16.sp,
                          color: AppColors.darkText,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      ..._languages.map(
                        (lang) => Padding(
                          padding: EdgeInsets.only(bottom: 22.h),
                          child: _LanguageCard(
                            option: lang,
                            isSelected: _selectedLanguageCode == lang.code,
                            onTap: () {
                              if (_selectedLanguageCode == lang.code) return;
                              setState(() {
                                _selectedLanguageCode = lang.code;
                              });
                              MyApp.of(context)?.setLocale(Locale(lang.code));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h, top: 16.h),
                child: SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: _onStart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.darkText,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                    ),
                    child: Text(
                      context.tr.commonStart.toUpperCase(),
                      style: AppTextStyles.button().copyWith(
                        fontSize: 16.sp,
                        color: AppColors.darkText,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onStart() async {
    final appState = MyApp.of(context);
    if (appState == null) return;
    await appState.setLocale(Locale(_selectedLanguageCode));
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storage = sl<Storage>();
      sl<AppNavigator>().pushReplacement(
        screen: storage.isOnboardingCompleted()
            ? const LoginView()
            : const OnboardingView(),
      );
    });
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final _LanguageOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.border.withValues(alpha: 0.55),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 18.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset(AppIcons.languageIcon, width: 28.w, height: 28.w),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  option.name,
                  style: AppTextStyles.bodyMedium(
                    color: AppColors.darkText,
                  ).copyWith(fontSize: 15.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption {
  final String code;
  final String name;

  const _LanguageOption({required this.code, required this.name});
}
