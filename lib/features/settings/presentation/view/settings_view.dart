import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/navigation/app_router.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/settings/presentation/widgets/settings_row.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  final bool _darkMode = false;
  bool _toneAnalysis = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.darkText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Settings', style: AppTextStyles.heading2()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              // Push Notifications
              SettingsRow(
                icon: Iconsax.notification,
                title: 'Push Notifications',
                trailing: Switch(
                  value: _pushNotifications,
                  onChanged: (v) => setState(() => _pushNotifications = v),
                  activeTrackColor: AppColors.primary,
                    activeThumbColor: AppColors.primaryDark,
                ),
              ),
              const Divider(color: AppColors.border, height: 1, indent: 70),

              // Email Notifications
              SettingsRow(
                icon: Iconsax.sms,
                title: 'Email Notifications',
                trailing: Switch(
                  value: _emailNotifications,
                  onChanged: (v) => setState(() => _emailNotifications = v),
                  activeTrackColor: AppColors.primary,
                    activeThumbColor: AppColors.primaryDark,
                ),
              ),
              const Divider(color: AppColors.border, height: 1, indent: 70),

              // Dark Mode (disabled)
              SettingsRow(
                icon: Iconsax.moon,
                title: 'Dark Mode',
                trailing: Switch(
                  value: _darkMode,
                  onChanged: null, // disabled for now
                  activeTrackColor: AppColors.primary,
                    activeThumbColor: AppColors.primaryDark,
                ),
              ),
              const Divider(color: AppColors.border, height: 1, indent: 70),

              // Tone Analysis
              SettingsRow(
                icon: Iconsax.message_text,
                title: 'Tone Analysis',
                trailing: Switch(
                  value: _toneAnalysis,
                  onChanged: (v) => setState(() => _toneAnalysis = v),
                  activeTrackColor: AppColors.primary,
                    activeThumbColor: AppColors.primaryDark,
                ),
              ),
              const Divider(color: AppColors.border, height: 1, indent: 70),

              // Language
              SettingsRow(
                icon: Iconsax.global,
                title: 'Language',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.languageSettings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
