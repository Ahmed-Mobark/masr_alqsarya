import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/login_view.dart';
import 'package:masr_al_qsariya/features/notifications/presentation/view/notifications_view.dart';
import 'package:masr_al_qsariya/features/profile/presentation/view/account_security_view.dart';
import 'package:masr_al_qsariya/features/profile/presentation/view/family_info_view.dart';
import 'package:masr_al_qsariya/features/settings/presentation/view/language_settings_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, curr) => prev.action != curr.action,
      listener: (context, state) {
        if (state.action == AuthAction.navigateToLogin) {
          sl<AppNavigator>().pushAndRemoveUntil(screen: const LoginView());
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
            onPressed: () => sl<AppNavigator>().pop(),
          ),
          title:
              Text(context.tr.profileTitle, style: AppTextStyles.heading2()),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildProfileHeader(),
                    const SizedBox(height: 28),
                    _buildMoreInformation(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // LOG OUT button at bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (prev, curr) =>
                      prev.isSubmitting != curr.isSubmitting,
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () => _showLogoutDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: state.isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : Text(
                              context.tr.profileMenuLogout.toUpperCase(),
                              style:
                                  AppTextStyles.button(color: AppColors.white),
                            ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final user = sl<Storage>().getUser();
    final displayName = (user?.fullName.isNotEmpty ?? false)
        ? user!.fullName
        : 'Leslie Pfeffer';
    final role = sl<Storage>().getSelectedRole() ?? 'Mother';

    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryDark, width: 2.5),
          ),
          child: const CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.inputBg,
            backgroundImage:
                NetworkImage('https://picsum.photos/200/200?random=200'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayName, style: AppTextStyles.heading2()),
              const SizedBox(height: 2),
              Text(role,
                  style: AppTextStyles.caption(color: AppColors.error)),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Clipboard.setData(const ClipboardData(text: 'DKVLRT'));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('DKVLRT',
                    style:
                        AppTextStyles.smallMedium(color: AppColors.darkText)),
                const SizedBox(width: 6),
                const Icon(Iconsax.copy, size: 14, color: AppColors.darkText),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoreInformation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.profileMoreInformation,
          style: AppTextStyles.heading2().copyWith(fontSize: 18),
        ),
        const SizedBox(height: 16),
        _buildMenuItem(
          title: context.tr.profileMenuAccount,
          onTap: () => sl<AppNavigator>().push(
            screen: const AccountSecurityView(),
          ),
        ),
        _buildDivider(),
        _buildMenuItem(
          title: context.tr.profileMenuFamilySpace,
          onTap: () => sl<AppNavigator>().push(
            screen: const FamilyInfoView(),
          ),
        ),
        _buildDivider(),
        _buildMenuItem(
          title: context.tr.profileMenuPrivacySecurity,
          onTap: () => sl<AppNavigator>().push(
            screen: const AccountSecurityView(),
          ),
        ),
        _buildDivider(),
        _buildMenuItem(
          title: context.tr.profileMenuNotification,
          onTap: () => sl<AppNavigator>().push(
            screen: const NotificationsView(),
          ),
        ),
        _buildDivider(),
        _buildMenuItem(
          title: context.tr.profileMenuLanguage,
          onTap: () => sl<AppNavigator>().push(
            screen: const LanguageSettingsView(),
          ),
        ),
        _buildDivider(),
        _buildMenuItem(
          title: context.tr.profileMenuLegalTerms,
          onTap: () => _showTermsOfUse(context),
        ),
        _buildDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: GestureDetector(
            onTap: () => _showDeleteAccountDialog(context),
            child: Text(
              context.tr.profileMenuDeleteAccount,
              style: AppTextStyles.body(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(child: Text(title, style: AppTextStyles.body())),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: AppColors.greyText),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: AppColors.border);
  }

  void _showTermsOfUse(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(context.tr.profileTermsTitle,
                  style: AppTextStyles.heading1()),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Text(
                    context.tr.profileTermsBody,
                    style: AppTextStyles.body(color: AppColors.greyText),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.tr.accountSecurityDeleteAccount,
            style: AppTextStyles.heading2()),
        content: Text(
          context.tr.accountSecurityDeleteConfirm,
          style: AppTextStyles.body(color: AppColors.greyText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.tr.commonCancel,
                style: AppTextStyles.bodyMedium(color: AppColors.greyText)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.tr.commonDelete,
                style: AppTextStyles.bodyMedium(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.tr.profileLogoutTitle,
            style: AppTextStyles.heading2()),
        content: Text(
          context.tr.profileLogoutConfirm,
          style: AppTextStyles.body(color: AppColors.greyText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.tr.commonCancel,
                style: AppTextStyles.bodyMedium(color: AppColors.greyText)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthCubit>().logout();
            },
            child: Text(context.tr.profileLogoutTitle,
                style: AppTextStyles.bodyMedium(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
