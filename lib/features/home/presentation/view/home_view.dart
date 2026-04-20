import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // ── Top Header Row ──────────────────────────────────────
              _buildHeaderRow(context),

              const SizedBox(height: 24),

              // ── Quick Actions ───────────────────────────────────────
              Text(
                'Quick Actions',
                style: AppTextStyles.heading2(),
              ),
              const SizedBox(height: 12),
              _buildQuickActionsGrid(),

              const SizedBox(height: 24),

              // ── Awaiting Your Response ──────────────────────────────
              Text(
                'Awaiting Your Response',
                style: AppTextStyles.heading2(),
              ),
              const SizedBox(height: 12),
              _buildAwaitingSection(),

              const SizedBox(height: 24),

              // ── Recent Activity ─────────────────────────────────────
              Text(
                'Recent Activity',
                style: AppTextStyles.heading2(),
              ),
              const SizedBox(height: 8),
              _buildRecentActivityList(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Top header: avatar + greeting (left), notification bell (right).
  Widget _buildHeaderRow(BuildContext context) {
    final user = sl<Storage>().getUser();
    final displayName = (user?.fullName.isNotEmpty ?? false)
        ? user!.fullName
        : 'Guest';
    final subtitle = (user?.email.isNotEmpty ?? false)
        ? user!.email
        : 'Welcome back';

    return SizedBox(
      height: 40,
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.border,
            child: Text(
              displayName.isNotEmpty ? displayName.characters.first : 'G',
              style: AppTextStyles.bodyMedium(color: AppColors.greyText),
            ),
          ),
          const SizedBox(width: 10),
          // Greeting column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                subtitle,
                style: AppTextStyles.small(color: AppColors.lightGreyText),
              ),
              Text(
                displayName,
                style: AppTextStyles.bodyMedium(color: AppColors.bodyText),
              ),
            ],
          ),
          const Spacer(),
          // Notification bell
          GestureDetector(
            onTap: () {
              sl<AppNavigator>().push(screen: const NotificationsView());
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.scaffoldBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.notification,
                size: 20,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 3x2 grid of quick action cards.
  Widget _buildQuickActionsGrid() {
    final actions = DummyData.quickActions;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 109 / 93,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return QuickActionCard(
          item: actions[index],
          onTap: () {
            // Navigate based on action title
          },
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
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
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
