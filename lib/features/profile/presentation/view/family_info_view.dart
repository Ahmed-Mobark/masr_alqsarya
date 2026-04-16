import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class FamilyInfoView extends StatefulWidget {
  const FamilyInfoView({super.key});

  @override
  State<FamilyInfoView> createState() => _FamilyInfoViewState();
}

class _FamilyInfoViewState extends State<FamilyInfoView> {
  final List<_ChildInfo> _children = [
    _ChildInfo(name: 'Youssef', age: 8),
    _ChildInfo(name: 'Mariam', age: 5),
  ];

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
        title: Text(context.tr.familyInfoTitle, style: AppTextStyles.heading2()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Co-parent info card
            _buildCoParentCard(),
            const SizedBox(height: 24),

            // Children section
            Text(context.tr.familyChildrenTitle, style: AppTextStyles.heading2()),
            const SizedBox(height: 12),
            ..._children.asMap().entries.map(
                  (entry) => _buildChildCard(entry.value, entry.key),
                ),
            const SizedBox(height: 12),

            // Add Child button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => _showAddChildDialog(context),
                icon: const Icon(Iconsax.add, size: 20),
                label: Text(context.tr.familyAddChild,
                    style: AppTextStyles.bodyMedium(color: AppColors.primaryDark)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryDark,
                  side: const BorderSide(
                      color: AppColors.primaryDark, style: BorderStyle.solid),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.tr.familyInfoSaved),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.darkText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(context.tr.commonSave, style: AppTextStyles.button()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoParentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Iconsax.user, color: AppColors.primaryDark, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tr.familyCoParent, style: AppTextStyles.caption()),
                    const SizedBox(height: 2),
                    Text('Fatima Ali', style: AppTextStyles.bodyMedium()),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.tr.familyConnected,
                  style: AppTextStyles.small(color: AppColors.success),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Iconsax.sms, size: 16, color: AppColors.greyText),
              const SizedBox(width: 8),
              Text(
                'fatima.ali@email.com',
                style: AppTextStyles.caption(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChildCard(_ChildInfo child, int index) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Photo placeholder
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Iconsax.user, color: AppColors.greyText, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(child.name, style: AppTextStyles.bodyMedium()),
                const SizedBox(height: 4),
                Text(
                  context.tr.familyYearsOld(child.age),
                  style: AppTextStyles.caption(),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Iconsax.edit_2, size: 18, color: AppColors.greyText),
            onPressed: () {
              // TODO: edit child
            },
          ),
        ],
      ),
    );
  }

  void _showAddChildDialog(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.tr.familyAddChild, style: AppTextStyles.heading2()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: context.tr.familyChildNameHint,
                hintStyle: AppTextStyles.body(color: AppColors.greyText),
                filled: true,
                fillColor: AppColors.inputBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: context.tr.familyChildAgeHint,
                hintStyle: AppTextStyles.body(color: AppColors.greyText),
                filled: true,
                fillColor: AppColors.inputBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr.commonCancel,
                style: AppTextStyles.bodyMedium(color: AppColors.greyText)),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              final age = int.tryParse(ageController.text.trim());
              if (name.isNotEmpty && age != null) {
                setState(() {
                  _children.add(_ChildInfo(name: name, age: age));
                });
              }
              Navigator.pop(context);
            },
            child: Text(context.tr.commonAdd,
                style: AppTextStyles.bodyMedium(color: AppColors.primaryDark)),
          ),
        ],
      ),
    );
  }
}

class _ChildInfo {
  final String name;
  final int age;

  const _ChildInfo({required this.name, required this.age});
}
