import 'package:flutter/material.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';

class AccountSecurityView extends StatelessWidget {
  const AccountSecurityView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = sl<Storage>().getUser();
    final firstName = user?.firstName ?? 'Colin';
    final lastName = user?.lastName ?? 'Colin';
    final email = user?.email ?? 'Colin.Schmeler18@gmail.com';
    final phone = user?.phone ?? '(586) 517-3830 x22319';

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
        title: Text(context.tr.accountSecurityTitle,
            style: AppTextStyles.heading2()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Personal Info heading
            Text(
              context.tr.accountSecurityPersonalInfo,
              style: AppTextStyles.heading2().copyWith(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // First Name
            _buildField(
              label: context.tr.accountSecurityFirstNameLabel,
              value: firstName,
            ),
            const SizedBox(height: 20),

            // Last Name
            _buildField(
              label: context.tr.accountSecurityLastNameLabel,
              value: lastName,
            ),
            const SizedBox(height: 20),

            // Email Address
            _buildField(
              label: context.tr.accountSecurityEmailAddressLabel,
              value: email,
            ),
            const SizedBox(height: 20),

            // Phone Number
            Text(
              context.tr.accountSecurityPhoneNumberLabel,
              style: AppTextStyles.body(),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  // Country flag + code
                  const Text('🇪🇬', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 6),
                  Text('+20', style: AppTextStyles.body()),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 18, color: AppColors.greyText),
                  const SizedBox(width: 8),
                  Container(
                    width: 1,
                    height: 20,
                    color: AppColors.border,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(phone, style: AppTextStyles.body()),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body()),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(value, style: AppTextStyles.body()),
        ),
      ],
    );
  }
}
