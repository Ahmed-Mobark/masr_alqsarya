import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = <_NotificationItem>[
      _NotificationItem(
        icon: Iconsax.message_text,
        title: context.tr.notificationsNewMessageTitle,
        body: context.tr.notificationsNewMessageBody,
        time: context.tr.timeMinutesAgo(2),
        isRead: false,
      ),
      _NotificationItem(
        icon: Iconsax.calendar_tick,
        title: context.tr.notificationsScheduleUpdatedTitle,
        body: context.tr.notificationsScheduleUpdatedBody,
        time: context.tr.timeHoursAgo(1),
        isRead: false,
      ),
      _NotificationItem(
        icon: Iconsax.money_send,
        title: context.tr.notificationsExpenseAddedTitle,
        body: context.tr.notificationsExpenseAddedBody,
        time: context.tr.timeHoursAgoPlural(3),
        isRead: true,
      ),
      _NotificationItem(
        icon: Iconsax.info_circle,
        title: context.tr.notificationsReminderTitle,
        body: context.tr.notificationsReminderBody,
        time: context.tr.timeYesterday,
        isRead: true,
      ),
      _NotificationItem(
        icon: Iconsax.shield_tick,
        title: context.tr.notificationsSecurityAlertTitle,
        body: context.tr.notificationsSecurityAlertBody,
        time: context.tr.timeDaysAgo(2),
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
          icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(context.tr.notificationsTitle, style: AppTextStyles.heading2()),
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? _buildEmptyState(context)
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.notification,
              size: 64, color: AppColors.greyText.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            context.tr.notificationsEmptyTitle,
            style: AppTextStyles.body(color: AppColors.greyText),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr.notificationsEmptySubtitle,
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
