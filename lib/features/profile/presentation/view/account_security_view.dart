import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class AccountSecurityView extends StatefulWidget {
  const AccountSecurityView({super.key});

  @override
  State<AccountSecurityView> createState() => _AccountSecurityViewState();
}

class _AccountSecurityViewState extends State<AccountSecurityView> {
  bool _twoFactorEnabled = false;

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
        title: Text(context.tr.accountSecurityTitle, style: AppTextStyles.heading2()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email field (read-only)
            _buildReadOnlyField(
              label: context.tr.accountSecurityEmailLabel,
              value: 'ahmed.mohamed@email.com',
              icon: Iconsax.sms,
            ),
            const SizedBox(height: 16),

            // Phone field (read-only)
            _buildReadOnlyField(
              label: context.tr.accountSecurityPhoneLabel,
              value: '+20 100 123 4567',
              icon: Iconsax.call,
            ),
            const SizedBox(height: 24),

            // Change Password button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: navigate to change password
                },
                icon: const Icon(Iconsax.lock, size: 20),
                label: Text(context.tr.accountSecurityChangePassword,
                    style: AppTextStyles.bodyMedium(color: AppColors.primaryDark)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryDark,
                  side: const BorderSide(color: AppColors.primaryDark),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Two-Factor Authentication toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Iconsax.shield_tick,
                        color: AppColors.primaryDark, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      context.tr.accountSecurityEnableTwoFactor,
                      style: AppTextStyles.bodyMedium(),
                    ),
                  ),
                  Switch(
                    value: _twoFactorEnabled,
                    onChanged: (v) => setState(() => _twoFactorEnabled = v),
                    activeTrackColor: AppColors.primary,
                    activeThumbColor: AppColors.primaryDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Delete Account
            Center(
              child: TextButton(
                onPressed: () => _showDeleteAccountDialog(context),
                child: Text(
                  context.tr.accountSecurityDeleteAccount,
                  style: AppTextStyles.bodyMedium(color: AppColors.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption()),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.inputBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.greyText, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(value, style: AppTextStyles.body()),
              ),
              const Icon(Iconsax.lock, color: AppColors.greyText, size: 16),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.tr.accountSecurityDeleteAccount, style: AppTextStyles.heading2()),
        content: Text(
          context.tr.accountSecurityDeleteConfirm,
          style: AppTextStyles.body(color: AppColors.greyText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr.commonCancel,
                style: AppTextStyles.bodyMedium(color: AppColors.greyText)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: handle account deletion
            },
            child: Text(context.tr.commonDelete,
                style: AppTextStyles.bodyMedium(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
