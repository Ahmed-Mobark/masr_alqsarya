import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/co_parent_details_view.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:masr_al_qsariya/features/home/presentation/view/home_view.dart';

enum _RoleType { familySpace, solo }

class RoleOptionsView extends StatefulWidget {
  const RoleOptionsView({super.key});

  @override
  State<RoleOptionsView> createState() => _RoleOptionsViewState();
}

class _RoleOptionsViewState extends State<RoleOptionsView> {
  _RoleType? _selectedRole;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().fetchWorkspace();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: state.isLoadingWorkspace
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  AuthBackButton(
                                    onTap: () => Navigator.pop(context),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        context.tr.authRoleOptionsTitle,
                                        style: AppTextStyles.heading2(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 36),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Text(
                                context.tr.authRoleOptionsHeading,
                                style: AppTextStyles.heading2(),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                context.tr.authRoleOptionsSubtitle,
                                style: AppTextStyles.caption(
                                    color: AppColors.greyText),
                              ),
                              const SizedBox(height: 24),
                              _buildRoleCard(
                                icon: Icons.people_outline_rounded,
                                title: context.tr.authRoleFamilySpace,
                                subtitle: context.tr.authRoleFamilySpaceDesc,
                                isSelected:
                                    _selectedRole == _RoleType.familySpace,
                                onTap: () => setState(
                                    () => _selectedRole = _RoleType.familySpace),
                              ),
                              const SizedBox(height: 12),
                              _buildRoleCard(
                                icon: Icons.person_outline_rounded,
                                title: context.tr.authRoleSolo,
                                subtitle: context.tr.authRoleSoloDesc,
                                isSelected: _selectedRole == _RoleType.solo,
                                onTap: () => setState(
                                    () => _selectedRole = _RoleType.solo),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _selectedRole != null
                                ? () {
                                    if (_selectedRole == _RoleType.solo) {
                                      sl<AppNavigator>().pushAndRemoveUntil(
                                        screen: const HomeView(),
                                      );
                                    } else {
                                      sl<AppNavigator>().push(
                                        screen: const CoParentDetailsView(),
                                      );
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedRole != null
                                  ? AppColors.primary
                                  : AppColors.border,
                              foregroundColor: AppColors.darkText,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: Text(
                              context.tr.authNext.toUpperCase(),
                              style: AppTextStyles.button(
                                color: _selectedRole != null
                                    ? AppColors.darkText
                                    : AppColors.greyText,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildRoleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.inputBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.border.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? AppColors.primaryDark : AppColors.greyText,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium(color: AppColors.darkText)
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
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
}
