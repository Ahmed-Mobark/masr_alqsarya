import 'package:flutter/material.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/features/home/presentation/view/home_view.dart';

class RoleOptionsView extends StatefulWidget {
  const RoleOptionsView({super.key});

  @override
  State<RoleOptionsView> createState() => _RoleOptionsViewState();
}

class _RoleOptionsViewState extends State<RoleOptionsView> {
  int _selectedTabIndex = 0;
  int? _selectedRoleIndex;

  static const _tabs = ['Family', 'Individual'];

  static const _familyRoles = [
    {'title': 'Parent A', 'subtitle': 'Primary guardian'},
    {'title': 'Parent B', 'subtitle': 'Secondary guardian'},
    {'title': 'Child', 'subtitle': 'Family member'},
    {'title': 'Other', 'subtitle': 'Extended family'},
  ];

  static const _individualRoles = [
    {'title': 'Tourist', 'subtitle': 'Visiting traveler'},
    {'title': 'Student', 'subtitle': 'Educational visit'},
    {'title': 'Researcher', 'subtitle': 'Academic purpose'},
  ];

  List<Map<String, String>> get _currentRoles =>
      _selectedTabIndex == 0 ? _familyRoles : _individualRoles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Back arrow
              _buildBackArrow(context),
              const SizedBox(height: 24),

              // Title
              Center(
                child: Text(
                  'Role Options',
                  style: AppTextStyles.heading2(),
                ),
              ),
              const SizedBox(height: 24),

              // Segmented tab selector
              _buildTabSelector(),
              const SizedBox(height: 24),

              // Role cards
              ..._currentRoles.asMap().entries.map((entry) {
                final index = entry.key;
                final role = entry.value;
                return _buildRoleCard(
                  title: role['title']!,
                  subtitle: role['subtitle']!,
                  isSelected: _selectedRoleIndex == index,
                  onTap: () => setState(() => _selectedRoleIndex = index),
                );
              }),
              const SizedBox(height: 32),

              // Next button
              _buildGoldButton(
                text: 'Next',
                onPressed: _selectedRoleIndex != null
                    ? () {
                        sl<AppNavigator>().pushAndRemoveUntil(
                          screen: const HomeView(),
                        );
                      }
                    : null,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      width: 343,
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isSelected = _selectedTabIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                _selectedTabIndex = index;
                _selectedRoleIndex = null;
              }),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: AppTextStyles.bodyMedium(
                    color: isSelected
                        ? AppColors.darkText
                        : AppColors.greyText,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 343,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.inputBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio-style indicator
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryDark
                      : AppColors.greyText,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption(color: AppColors.greyText),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoldButton({
    required String text,
    required VoidCallback? onPressed,
  }) {
    final enabled = onPressed != null;
    return SizedBox(
      width: 343,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              enabled ? AppColors.primary : AppColors.border,
          foregroundColor: AppColors.darkText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.button(
            color: enabled ? AppColors.darkText : AppColors.greyText,
          ),
        ),
      ),
    );
  }
}

Widget _buildBackArrow(BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.pop(context),
    child: Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 16,
        color: AppColors.primaryDark,
      ),
    ),
  );
}
