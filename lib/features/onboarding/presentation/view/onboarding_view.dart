import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
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

  static const _backgrounds = [
    'assets/images/onboarding_1.png',
    'assets/images/onboarding_2.png',
    'assets/images/onboarding_3.png',
    'assets/images/onboarding_4.png',
  ];

  static const _titles = [
    'A better way to co-parent',
    'Clear and respectful communication',
    'Important documents, safely stored',
    'Built on trust and privacy',
  ];

  static const _subtitles = [
    'A secure space designed to help parents communicate, organize, and make decisions — with less conflict and more clarity.',
    'All messages are documented, time-stamped, and cannot be edited or deleted — helping conversations stay accountable and constructive.',
    'Keep medical, school, legal, and financial documents encrypted and accessible — with full access history.',
    'Your data is protected with strong security measures and handled according to Egyptian data protection law.',
  ];

  static const _buttonLabels = [
    'NEXT',
    'NEXT',
    'Get Started!',
  ];

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
    sl<AppNavigator>().pushReplacement(screen: const LoginView());
  }

  void _onJoinWithCode() {
    sl<AppNavigator>().pushReplacement(screen: const VerificationView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page view
          PageView.builder(
            controller: _pageController,
            itemCount: _totalPages,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => _buildPage(index),
          ),
          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back arrow
                  GestureDetector(
                    onTap: _onBack,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFF5F5F5),
                          width: 0.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 12,
                        color: Color(0xFFFBBC05),
                      ),
                    ),
                  ),
                  // Logo
                  Image.asset(
                    'assets/images/logo_small.png',
                    width: 90,
                    height: 68,
                    fit: BoxFit.contain,
                  ),
                  // Skip
                  GestureDetector(
                    onTap: _onSkip,
                    child: Text(
                      'SKIP',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    final bool isFinalPage = index == 3;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.asset(
          _backgrounds[index],
          fit: BoxFit.cover,
        ),
        // Dark gradient overlay at bottom for readability
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
        ),
        // Bottom content area
        Positioned(
          top: 539,
          left: 16,
          right: 16,
          bottom: 0,
          child: isFinalPage ? _buildFinalPageContent() : _buildPageContent(index),
        ),
      ],
    );
  }

  Widget _buildPageContent(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Page indicator dots
        Row(
          children: List.generate(3, (dotIndex) {
            final bool isActive = dotIndex == index;
            return Container(
              width: isActive ? 22 : 5,
              height: 5,
              margin: EdgeInsets.only(right: dotIndex < 2 ? 4 : 0),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFFFEDB65)
                    : const Color(0xFFE2E2E2),
                borderRadius: BorderRadius.circular(5),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        // Title
        SizedBox(
          width: 271,
          child: Text(
            _titles[index],
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Subtitle
        Text(
          _subtitles[index],
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFE2E2E2),
          ),
        ),
        const SizedBox(height: 32),
        // Button
        SizedBox(
          width: 343,
          height: 44,
          child: ElevatedButton(
            onPressed: _onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFEDB65),
              foregroundColor: AppColors.darkText,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              _buttonLabels[index],
              style: AppTextStyles.button(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinalPageContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Text(
          _titles[3],
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 16),
        // Subtitle
        Text(
          _subtitles[3],
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFE2E2E2),
          ),
        ),
        const SizedBox(height: 32),
        // LOG IN button
        SizedBox(
          width: 343,
          height: 44,
          child: ElevatedButton(
            onPressed: _onLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFEDB65),
              foregroundColor: AppColors.darkText,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'LOG IN',
              style: AppTextStyles.button(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // JOIN USING A CODE button
        SizedBox(
          width: 343,
          height: 44,
          child: OutlinedButton(
            onPressed: _onJoinWithCode,
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.darkText,
              elevation: 0,
              side: const BorderSide(
                color: Color(0xFFFEDB65),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'JOIN USING A CODE',
              style: AppTextStyles.button(),
            ),
          ),
        ),
      ],
    );
  }
}
