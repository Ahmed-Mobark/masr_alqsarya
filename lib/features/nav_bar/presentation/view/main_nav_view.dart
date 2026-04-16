import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/home/presentation/view/home_view.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/view/schedule_view.dart';
import 'package:masr_al_qsariya/features/news/presentation/view/news_view.dart';
import 'package:masr_al_qsariya/features/messages/presentation/view/messages_view.dart';
import 'package:masr_al_qsariya/features/expense/presentation/view/expense_view.dart';

class MainNavView extends StatefulWidget {
  const MainNavView({super.key});

  @override
  State<MainNavView> createState() => _MainNavViewState();
}

class _MainNavViewState extends State<MainNavView> {
  int _currentIndex = 0;

  /// Whether the Messages tab has unread messages.
  final bool _hasUnreadMessages = true;

  final List<Widget> _screens = const [
    HomeView(),
    ScheduleView(),
    NewsView(),
    MessagesView(),
    ExpenseView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  icon: Iconsax.home,
                  activeIcon: Iconsax.home_1,
                  label: 'Home',
                  isActive: _currentIndex == 0,
                  onTap: () => _onTabTap(0),
                ),
                _NavBarItem(
                  icon: Iconsax.calendar,
                  activeIcon: Iconsax.calendar_1,
                  label: 'Schedule',
                  isActive: _currentIndex == 1,
                  onTap: () => _onTabTap(1),
                ),
                _NavBarItem(
                  icon: Iconsax.note,
                  activeIcon: Iconsax.note_1,
                  label: 'News',
                  isActive: _currentIndex == 2,
                  onTap: () => _onTabTap(2),
                ),
                _NavBarItem(
                  icon: Iconsax.message,
                  activeIcon: Iconsax.message,
                  label: 'Messages',
                  isActive: _currentIndex == 3,
                  showBadge: _hasUnreadMessages,
                  onTap: () => _onTabTap(3),
                ),
                _NavBarItem(
                  icon: Iconsax.wallet_3,
                  activeIcon: Iconsax.wallet_1,
                  label: 'Expense',
                  isActive: _currentIndex == 4,
                  onTap: () => _onTabTap(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTabTap(int index) {
    setState(() {
      _currentIndex = index;
    });
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
