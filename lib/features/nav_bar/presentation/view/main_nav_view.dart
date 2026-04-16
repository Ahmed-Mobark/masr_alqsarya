import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/nav_bar/presentation/cubit/nav_bar_cubit.dart';
import 'package:masr_al_qsariya/features/home/presentation/view/home_view.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/view/schedule_view.dart';
import 'package:masr_al_qsariya/features/news/presentation/view/news_view.dart';
import 'package:masr_al_qsariya/features/messages/presentation/view/messages_view.dart';
import 'package:masr_al_qsariya/features/expense/presentation/view/expense_view.dart';

class MainNavView extends StatelessWidget {
  const MainNavView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NavBarCubit>(),
      child: const _MainNavContent(),
    );
  }
}

class _MainNavContent extends StatelessWidget {
  const _MainNavContent();

  static const List<Widget> _screens = [
    HomeView(),
    ScheduleView(),
    NewsView(),
    MessagesView(),
    ExpenseView(),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NavBarCubit>();
    return Scaffold(
      body: BlocBuilder<NavBarCubit, NavBarState>(
        buildWhen: (prev, next) => prev.currentIndex != next.currentIndex,
        builder: (context, state) {
          return IndexedStack(index: state.currentIndex, children: _screens);
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: BlocBuilder<NavBarCubit, NavBarState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavBarItem(
                      icon: Iconsax.home,
                      activeIcon: Iconsax.home_1,
                      label: context.tr.navHomeTabLabel,
                      isActive: state.currentIndex == 0,
                      onTap: () => cubit.setIndex(0),
                    ),
                    _NavBarItem(
                      icon: Iconsax.calendar,
                      activeIcon: Iconsax.calendar_1,
                      label: context.tr.navScheduleTabLabel,
                      isActive: state.currentIndex == 1,
                      onTap: () => cubit.setIndex(1),
                    ),
                    _NavBarItem(
                      icon: Iconsax.note,
                      activeIcon: Iconsax.note_1,
                      label: context.tr.navNewsTabLabel,
                      isActive: state.currentIndex == 2,
                      onTap: () => cubit.setIndex(2),
                    ),
                    _NavBarItem(
                      icon: Iconsax.message,
                      activeIcon: Iconsax.message,
                      label: context.tr.navMessagesTabLabel,
                      isActive: state.currentIndex == 3,
                      showBadge: state.hasUnreadMessages,
                      onTap: () => cubit.setIndex(3),
                    ),
                    _NavBarItem(
                      icon: Iconsax.wallet_3,
                      activeIcon: Iconsax.wallet_1,
                      label: context.tr.navExpenseTabLabel,
                      isActive: state.currentIndex == 4,
                      onTap: () => cubit.setIndex(4),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// A single item in the custom bottom navigation bar.
class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.showBadge = false,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final bool showBadge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.tabActive : AppColors.tabInactive;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gold dot indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: isActive ? 3 : 0,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: isActive ? AppColors.tabActive : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
            // Icon with optional badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  size: 24,
                  color: color,
                ),
                if (showBadge)
                  Positioned(
                    top: -2,
                    right: -4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            // Label
            Text(
              label,
              style: AppTextStyles.tabLabel(color: color).copyWith(
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
