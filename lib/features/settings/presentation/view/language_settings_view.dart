import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/app/app_body.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class LanguageSettingsView extends StatefulWidget {
  const LanguageSettingsView({super.key});

  @override
  State<LanguageSettingsView> createState() => _LanguageSettingsViewState();
}

class _LanguageSettingsViewState extends State<LanguageSettingsView> {
  // null = device language, otherwise the language code
  String? _selectedCode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize with current locale
    _selectedCode ??= Localizations.localeOf(context).languageCode;
  }

  void _selectLanguage(String? code) {
    setState(() => _selectedCode = code);
    if (code == null) {
      // Device language - use platform locale
      final platformLocale = WidgetsBinding.instance.platformDispatcher.locale;
      MyApp.of(context)?.setLocale(platformLocale);
    } else {
      MyApp.of(context)?.setLocale(Locale(code));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDeviceLanguage = _selectedCode == null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr.profileMenuLanguage,
          style: AppTextStyles.heading2(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Search bar
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  const Icon(Iconsax.search_normal,
                      size: 18, color: AppColors.greyText),
                  const SizedBox(width: 10),
                  Text(
                    context.tr.messagesSearch,
                    style: AppTextStyles.caption(color: AppColors.greyText),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Device Language option
            _buildLanguageItem(
              label: context.tr.languageDeviceLanguage,
              isSelected: isDeviceLanguage,
              onTap: () => _selectLanguage(null),
            ),
            const Divider(height: 1, color: AppColors.border),

            // English
            _buildLanguageItem(
              label: 'English',
              isSelected: !isDeviceLanguage && _selectedCode == 'en',
              onTap: () => _selectLanguage('en'),
            ),
            const Divider(height: 1, color: AppColors.border),

            // Arabic
            _buildLanguageItem(
              label: 'العربيه',
              isSelected: !isDeviceLanguage && _selectedCode == 'ar',
              onTap: () => _selectLanguage('ar'),
            ),
            const Divider(height: 1, color: AppColors.border),

            // French
            _buildLanguageItem(
              label: 'French',
              isSelected: !isDeviceLanguage && _selectedCode == 'fr',
              onTap: () => _selectLanguage('fr'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: AppTextStyles.body()),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
