import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/login_view.dart';
import 'package:masr_al_qsariya/features/notifications/presentation/view/notifications_view.dart';
import 'package:masr_al_qsariya/features/profile/presentation/view/account_security_view.dart';
import 'package:masr_al_qsariya/features/profile/presentation/view/family_info_view.dart';
import 'package:masr_al_qsariya/features/settings/presentation/view/language_settings_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(context.tr.profileTitle, style: AppTextStyles.heading2()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 32),
            _buildMenuList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.inputBg,
          backgroundImage:
              NetworkImage('https://picsum.photos/200/200?random=200'),
        ),
        const SizedBox(height: 12),
        Text('Ahmed Mohamed', style: AppTextStyles.heading2()),
        const SizedBox(height: 4),
        Text(
          'ahmed.mohamed@email.com',
          style: AppTextStyles.caption(),
        ),
      ],
    );
  }

  Widget _buildMenuList(BuildContext context) {
    final menuItems = [
      _MenuItem(
        icon: Iconsax.shield_tick,
        title: context.tr.profileMenuAccountSecurity,
        onTap: () => sl<AppNavigator>().push(
          screen: const AccountSecurityView(),
        ),
      ),
      _MenuItem(
        icon: Iconsax.people,
        title: context.tr.profileMenuFamilyInformation,
        onTap: () => sl<AppNavigator>().push(
          screen: const FamilyInfoView(),
        ),
      ),
      _MenuItem(
        icon: Iconsax.notification,
        title: context.tr.profileMenuNotifications,
        onTap: () => sl<AppNavigator>().push(
          screen: const NotificationsView(),
        ),
      ),
      _MenuItem(
        icon: Iconsax.global,
        title: context.tr.profileMenuLanguage,
        onTap: () => sl<AppNavigator>().push(
          screen: const LanguageSettingsView(),
        ),
      ),
      _MenuItem(
        icon: Iconsax.document_text,
        title: context.tr.profileMenuTermsOfUse,
        onTap: () => _showTermsOfUse(context),
      ),
      _MenuItem(
        icon: Iconsax.send_2,
        title: context.tr.profileMenuInvitePeople,
        onTap: () => _showInviteDialog(context),
      ),
      _MenuItem(
        icon: Iconsax.logout,
        title: context.tr.profileMenuLogout,
        isDestructive: true,
        onTap: () => _showLogoutDialog(context),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: menuItems.length,
        separatorBuilder: (_, __) => const Divider(
          color: AppColors.border,
          height: 1,
          indent: 56,
        ),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return ListTile(
            onTap: item.onTap,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.greyText.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: item.isDestructive ? AppColors.error : AppColors.greyText,
                size: 20,
              ),
            ),
            title: Text(
              item.title,
              style: AppTextStyles.bodyMedium(
                color: item.isDestructive ? AppColors.error : AppColors.darkText,
              ),
            ),
            trailing: item.isDestructive
                ? null
                : const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.greyText,
                  ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          );
        },
      ),
    );
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
              Text(context.tr.profileTermsTitle, style: AppTextStyles.heading1()),
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

  void _showInviteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.tr.profileInviteTitle, style: AppTextStyles.heading2()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.tr.profileInviteDescription,
              style: AppTextStyles.body(color: AppColors.greyText),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('MASR-2024-XYZ', style: AppTextStyles.bodyMedium()),
                  const Icon(Iconsax.copy, size: 20, color: AppColors.primaryDark),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr.commonClose,
                style: AppTextStyles.bodyMedium(color: AppColors.greyText)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr.commonShare,
                style: AppTextStyles.bodyMedium(color: AppColors.primaryDark)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.tr.profileLogoutTitle, style: AppTextStyles.heading2()),
        content: Text(
          context.tr.profileLogoutConfirm,
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
              sl<AppNavigator>().pushAndRemoveUntil(screen: const LoginView());
            },
            child: Text(context.tr.profileLogoutTitle,
                style: AppTextStyles.bodyMedium(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });
}
