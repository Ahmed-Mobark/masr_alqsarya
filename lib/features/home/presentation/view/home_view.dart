import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/data/dummy_data.dart';
import 'package:masr_al_qsariya/features/home/presentation/widgets/quick_action_card.dart';
import 'package:masr_al_qsariya/features/home/presentation/widgets/awaiting_card.dart';
import 'package:masr_al_qsariya/features/home/presentation/widgets/activity_item_tile.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/features/notifications/presentation/view/notifications_view.dart';
import 'package:masr_al_qsariya/features/profile/presentation/view/profile_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),

              // ── Top Header Row ──
              _buildHeaderRow(context),

              SizedBox(height: 28.h),

              // ── Quick Actions ──
              Text(
                context.tr.homeQuickActions,
                style: AppTextStyles.heading2(color: AppColors.darkText)
                    .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 14.h),
              _buildQuickActionsGrid(context),

              SizedBox(height: 28.h),

              // ── Awaiting Your Response ──
              Text(
                context.tr.homeAwaitingResponse,
                style: AppTextStyles.heading2(color: AppColors.darkText)
                    .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 12.h),
              _buildAwaitingSection(),

              SizedBox(height: 28.h),

              // ── Recent Activity ──
              Text(
                context.tr.homeRecentActivity,
                style: AppTextStyles.heading2(color: AppColors.darkText)
                    .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 8.h),
              _buildRecentActivityList(),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Top header: avatar with purple border + greeting, notification bell with yellow border.
  Widget _buildHeaderRow(BuildContext context) {
    final user = sl<Storage>().getUser();
    final displayName = (user?.fullName.isNotEmpty ?? false)
        ? user!.fullName
        : context.tr.homeGuest;

    return Row(
      children: [
        // Avatar with purple border
        Container(
          width: 52.w,
          height: 52.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryDark,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 24.r,
            backgroundColor: const Color(0xFFF0EDE6),
            child: Text(
              displayName.isNotEmpty ? displayName.characters.first : 'G',
              style: AppTextStyles.heading2(color: AppColors.primaryDark)
                  .copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // Greeting column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr.homeGoodMorning,
                style: AppTextStyles.caption(color: AppColors.greyText)
                    .copyWith(fontSize: 13.sp),
              ),
              SizedBox(height: 2.h),
              Text(
                displayName,
                style: AppTextStyles.heading2(color: AppColors.darkText)
                    .copyWith(fontSize: 17.sp, fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // Notification bell with yellow border
        GestureDetector(
          onTap: () {
            sl<AppNavigator>().push(screen: const NotificationsView());
          },
          child: Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            child: Icon(
              Iconsax.notification,
              size: 20.sp,
              color: AppColors.yellow,
            ),
          ),
        ),
      ],
    );
  }

  /// 3x2 grid of quick action cards matching Figma design.
  Widget _buildQuickActionsGrid(BuildContext context) {
    final actions = [
      _QuickAction(Iconsax.message, context.tr.homeSendMessage, () {}),
      _QuickAction(Iconsax.calendar_add, context.tr.homeAddSchedule, () {}),
      _QuickAction(Iconsax.receipt_item, context.tr.homeExpense, () {}),
      _QuickAction(Iconsax.calendar_1, context.tr.homeSessions, () {}),
      _QuickAction(Iconsax.video_play, context.tr.homeSessionsLibrary, () {}),
      _QuickAction(Iconsax.user, context.tr.profileTitle, () {
        sl<AppNavigator>().push(screen: const ProfileView());
      }),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.0,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return QuickActionCard(
          icon: action.icon,
          label: action.label,
          onTap: action.onTap,
        );
      },
    );
  }

  /// Horizontal list of awaiting response cards.
  Widget _buildAwaitingSection() {
    final items = DummyData.awaitingItems;

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 150.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          return AwaitingCard(item: items[index]);
        },
      ),
    );
  }

  /// Vertical list of recent activity tiles.
  Widget _buildRecentActivityList() {
    final activities = DummyData.recentActivity;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return ActivityItemTile(item: activities[index]);
      },
    );
  }
}

class _QuickAction {
  const _QuickAction(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}
