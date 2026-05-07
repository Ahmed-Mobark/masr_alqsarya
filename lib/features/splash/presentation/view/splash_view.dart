import 'package:flutter/material.dart';
import 'package:masr_al_qsariya/core/config/app_images.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/features/language/presentation/view/language_view.dart';
import 'package:masr_al_qsariya/features/nav_bar/presentation/view/main_nav_view.dart';
import 'package:masr_al_qsariya/features/onboarding/presentation/view/onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final storage = sl<Storage>();
    final nextScreen = !storage.isSelectLang()
        ? const LanguageView()
        : !storage.isOnboardingCompleted()
            ? const OnboardingView()
            : storage.isAuthorized()
                ? const MainNavView()
                : const OnboardingView(initialPage: 3);
    sl<AppNavigator>().pushReplacement(
      screen: nextScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          AppImages.logoApp,
          width: 150,
          height: 172,
        ),
      ),
    );
  }
}
