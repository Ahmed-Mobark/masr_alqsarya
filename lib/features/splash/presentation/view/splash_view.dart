import 'package:flutter/material.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/features/language/presentation/view/language_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToLanguage();
  }

  Future<void> _navigateToLanguage() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    sl<AppNavigator>().pushReplacement(
      screen: const LanguageView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/logoapp.png',
          width: 150,
          height: 172,
        ),
      ),
    );
  }
}
