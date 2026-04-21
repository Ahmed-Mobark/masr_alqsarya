import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/config/app_images.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/login_view.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/verification_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _totalPages = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onSkip() {
    sl<Storage>().storeOnboardingCompleted(isOnboardingCompleted: true);
    sl<AppNavigator>().pushReplacement(screen: const LoginView());
  }

  void _onBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onLogin() {
    sl<Storage>().storeOnboardingCompleted(isOnboardingCompleted: true);
    sl<AppNavigator>().pushReplacement(screen: const LoginView());
  }

  void _onJoinWithCode() {
    sl<Storage>().storeOnboardingCompleted(isOnboardingCompleted: true);
    sl<AppNavigator>().push(screen: const VerificationView());
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _OnboardingPageData(
        imagePath: AppImages.onboarding1,
        title: context.tr.onboardingPage1Title,
        subtitle: context.tr.onboardingPage1Subtitle,
      ),
      _OnboardingPageData(
        imagePath: AppImages.onboarding2,
        title: context.tr.onboardingPage2Title,
        subtitle: context.tr.onboardingPage2Subtitle,
      ),
      _OnboardingPageData(
        imagePath: AppImages.onboarding3,
        title: context.tr.onboardingPage3Title,
        subtitle: context.tr.onboardingPage3Subtitle,
      ),
      _OnboardingPageData(
        imagePath: AppImages.onboarding4,
        title: context.tr.onboardingPage4Title,
        subtitle: context.tr.onboardingPage4Subtitle,
      ),
    ];

    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _totalPages,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) =>
            _buildPage(context, pages[index], index: index),
      ),
    );
  }

  Widget _buildPage(
    BuildContext context,
    _OnboardingPageData page, {
    required int index,
  }) {
    final isFinalPage = index == _totalPages - 1;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          page.imagePath,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.03),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.18),
                  Colors.black.withValues(alpha: isFinalPage ? 0.94 : 0.90),
                ],
                stops: const [0.0, 0.42, 0.68, 1.0],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10.w, 6.h, 10.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OnboardingTopBar(
                  onBack: _onBack,
                  onSkip: _onSkip,
                  skipLabel: context.tr.onboardingSkip.toUpperCase(),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: _OnboardingBottomContent(
                    title: page.title,
                    subtitle: page.subtitle,
                    isFinalPage: isFinalPage,
                    currentIndex: index,
                    onNext: _onNext,
                    onLogin: _onLogin,
                    onJoinWithCode: _onJoinWithCode,
                    nextLabel: index == _totalPages - 2
                        ? context.tr.onboardingGetStarted.toUpperCase()
                        : context.tr.onboardingNext.toUpperCase(),
                    loginLabel: context.tr.onboardingLogin.toUpperCase(),
                    joinWithCodeLabel: context.tr.onboardingJoinUsingCode
                        .toUpperCase(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  final String imagePath;
  final String title;
  final String subtitle;
}

class _OnboardingTopBar extends StatelessWidget {
  const _OnboardingTopBar({
    required this.onBack,
    required this.onSkip,
    required this.skipLabel,
  });

  final VoidCallback onBack;
  final VoidCallback onSkip;
  final String skipLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: _TopCircleButton(
              icon: Icons.arrow_back,
              onTap: onBack,
            ),
          ),
          Center(
            child: Image.asset(
              AppImages.logoSmall,
              width: 92.w,
              height: 68.h,
              fit: BoxFit.contain,
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: GestureDetector(
              onTap: onSkip,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                child: Text(
                  skipLabel,
                  style: AppTextStyles.button(
                    color: AppColors.white,
                  ).copyWith(fontSize: 15.sp, letterSpacing: 0, height: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingBottomContent extends StatelessWidget {
  const _OnboardingBottomContent({
    required this.title,
    required this.subtitle,
    required this.isFinalPage,
    required this.currentIndex,
    required this.onNext,
    required this.onLogin,
    required this.onJoinWithCode,
    required this.nextLabel,
    required this.loginLabel,
    required this.joinWithCodeLabel,
  });

  final String title;
  final String subtitle;
  final bool isFinalPage;
  final int currentIndex;
  final VoidCallback onNext;
  final VoidCallback onLogin;
  final VoidCallback onJoinWithCode;
  final String nextLabel;
  final String loginLabel;
  final String joinWithCodeLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isFinalPage) _OnboardingPageIndicator(currentIndex: currentIndex),
        if (!isFinalPage) SizedBox(height: 18.h),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 308.w),
          child: Text(
            title,
            style: AppTextStyles.heading1(
              color: AppColors.white,
            ).copyWith(fontSize: 26.sp, height: 1.18),
          ),
        ),
        SizedBox(height: 14.h),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 350.w),
          child: Text(
            subtitle,
            style: AppTextStyles.body(
              color: AppColors.white.withValues(alpha: 0.90),
            ).copyWith(fontSize: 14.sp, height: 1.35),
          ),
        ),
        SizedBox(height: 28.h),
        if (isFinalPage)
          Column(
            children: [
              _PrimaryOnboardingButton(text: loginLabel, onPressed: onLogin),
              SizedBox(height: 14.h),
              _SecondaryOnboardingButton(
                text: joinWithCodeLabel,
                onPressed: onJoinWithCode,
              ),
            ],
          )
        else
          _PrimaryOnboardingButton(text: nextLabel, onPressed: onNext),
      ],
    );
  }
}

class _TopCircleButton extends StatelessWidget {
  const _TopCircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Ink(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.96),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14.sp, color: AppColors.primaryDark),
        ),
      ),
    );
  }
}

class _OnboardingPageIndicator extends StatelessWidget {
  const _OnboardingPageIndicator({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: isActive ? 24.w : 7.w,
          height: 5.h,
          margin: EdgeInsetsDirectional.only(end: index == 2 ? 0 : 5.w),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : AppColors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(999.r),
          ),
        );
      }),
    );
  }
}

class _PrimaryOnboardingButton extends StatelessWidget {
  const _PrimaryOnboardingButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.darkText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.button(
            color: AppColors.darkText,
          ).copyWith(fontSize: 15.sp, height: 1),
        ),
      ),
    );
  }
}

class _SecondaryOnboardingButton extends StatelessWidget {
  const _SecondaryOnboardingButton({
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.darkText,
          side: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.85),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.button(
            color: AppColors.darkText,
          ).copyWith(fontSize: 15.sp, height: 1),
        ),
      ),
    );
  }
}
