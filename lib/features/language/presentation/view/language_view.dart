import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:masr_al_qsariya/core/navigation/app_router.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/l10n/locale_provider.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  String _selectedLanguageCode = 'en';

  static const _languages = [
    _LanguageOption(code: 'en', name: 'English'),
    _LanguageOption(code: 'ar', name: '\u0627\u0644\u0639\u0631\u0628\u064A\u0647'),
    _LanguageOption(code: 'fr', name: 'French'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              // Brand logo
              Image.asset(
                'assets/images/logoapp.png',
                width: 150,
                height: 172,
              ),
              const SizedBox(height: 40),
              // Title
              Text(
                'Select Language',
                style: AppTextStyles.heading1(),
              ),
              const SizedBox(height: 24),
              // Language cards
              ..._languages.map((lang) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildLanguageCard(lang),
                  )),
              const Spacer(),
              // Start button
              SizedBox(
                width: 343,
                height: 44,
                child: ElevatedButton(
                  onPressed: _onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.darkText,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text('START', style: AppTextStyles.button()),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(_LanguageOption lang) {
    final isSelected = _selectedLanguageCode == lang.code;
    return GestureDetector(
      onTap: () => setState(() => _selectedLanguageCode = lang.code),
      child: Container(
        width: 343,
        height: 64,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFF5F5F5),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Language icon
            Image.asset(
              'assets/icons/language_icon.png',
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 16),
            // Language name
            Text(lang.name, style: AppTextStyles.cardTitle()),
          ],
        ),
      ),
    );
  }

  void _onStart() {
    final localeProvider = context.read<LocaleProvider>();
    localeProvider.setLocale(Locale(_selectedLanguageCode));
    Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
  }
}

class _LanguageOption {
  final String code;
  final String name;

  const _LanguageOption({
    required this.code,
    required this.name,
  });
}
