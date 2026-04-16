import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = <_NotificationItem>[
      _NotificationItem(
        icon: Iconsax.message_text,
        title: 'New Message',
        body: 'Fatima sent you a message about this weekend\'s schedule.',
        time: '2 min ago',
        isRead: false,
      ),
      _NotificationItem(
        icon: Iconsax.calendar_tick,
        title: 'Schedule Updated',
        body: 'The co-parenting schedule for next week has been updated.',
        time: '1 hour ago',
        isRead: false,
      ),
      _NotificationItem(
        icon: Iconsax.money_send,
        title: 'Expense Added',
        body: 'A new shared expense of 500 EGP has been recorded.',
        time: '3 hours ago',
        isRead: true,
      ),
      _NotificationItem(
        icon: Iconsax.info_circle,
        title: 'Reminder',
        body: 'Don\'t forget the parent-teacher meeting tomorrow at 4 PM.',
        time: 'Yesterday',
        isRead: true,
      ),
      _NotificationItem(
        icon: Iconsax.shield_tick,
        title: 'Security Alert',
        body: 'A new device was used to sign in to your account.',
        time: '2 days ago',
        isRead: true,
      ),
    ];

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
        title: Text('Notifications', style: AppTextStyles.heading2()),
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return _buildNotificationTile(item);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.notification,
              size: 64, color: AppColors.greyText.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('No notifications yet',
              style: AppTextStyles.body(color: AppColors.greyText)),
          const SizedBox(height: 8),
          Text(
            'We\'ll notify you when something arrives',
            style: AppTextStyles.caption(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(_NotificationItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: item.isRead
            ? AppColors.cardBg
            : AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isRead
              ? AppColors.border
              : AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: AppColors.primaryDark, size: 22),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.bodyMedium(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.body,
                  style: AppTextStyles.caption(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Time
          Text(
            item.time,
            style: AppTextStyles.small(),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final String title;
  final String body;
  final String time;
  final bool isRead;

  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
  });
}
