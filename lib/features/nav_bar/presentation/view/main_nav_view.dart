import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/nav_bar/presentation/cubit/nav_bar_cubit.dart';
import 'package:masr_al_qsariya/features/home/presentation/view/home_view.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/view/schedule_view.dart';
import 'package:masr_al_qsariya/features/news/presentation/view/news_view.dart';
import 'package:masr_al_qsariya/features/messages/presentation/cubit/messages_cubit.dart';
import 'package:masr_al_qsariya/features/messages/presentation/view/messages_view.dart';
import 'package:masr_al_qsariya/features/expense/presentation/view/expense_view.dart';
import 'package:masr_al_qsariya/features/nav_bar/session/shell_session_sync.dart';

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

class _MainNavContent extends StatefulWidget {
  const _MainNavContent();

  @override
  State<_MainNavContent> createState() => _MainNavContentState();
}

class _MainNavContentState extends State<_MainNavContent> {
  static const String _pNewsFeed = 'mobile.home.news_feed';
  static const String _pWorkspaceChats = 'mobile.home.workspace_chats';
  static const String _pWorkspaceCalendar = 'mobile.home.workspace_calendar';
  static const String _pWorkspaceCalls = 'mobile.home.workspace_calls';
  static const String _pWorkspaceCalendarItems = 'mobile.home.workspace_calendar_items';
  static const String _pWorkspaceRegularExpenses =
      'mobile.home.workspace_regular_expenses';
  static const String _pWorkspaceSupportExpenses =
      'mobile.home.workspace_support_expenses';

  late final List<Widget> _screens = [
    const HomeView(),
    const ScheduleView(),
    const NewsView(),
    BlocProvider(
      create: (_) => sl<MessagesCubit>()..loadThreads(),
      child: const MessagesView(),
    ),
    const ExpenseView(),
  ];

  bool _can(String permission) {
    final user = sl<Storage>().getUser();
    if (user == null) return true;
    return user.hasPermission(permission);
  }

  bool get _canSchedule =>
      _can(_pWorkspaceCalendar) ||
      _can(_pWorkspaceCalls) ||
      _can(_pWorkspaceCalendarItems);
  bool get _canNews => _can(_pNewsFeed);
  bool get _canMessages => _can(_pWorkspaceChats);
  bool get _canExpense =>
      _can(_pWorkspaceRegularExpenses) || _can(_pWorkspaceSupportExpenses);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      syncWorkspaceAndPrefetchChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NavBarCubit>();
    final tabs = <_NavTabConfig>[
      _NavTabConfig(
        index: 0,
        icon: Iconsax.home,
        activeIcon: Iconsax.home_1,
        label: context.tr.navHomeTabLabel,
      ),
      if (_canSchedule)
        _NavTabConfig(
          index: 1,
          icon: Iconsax.calendar,
          activeIcon: Iconsax.calendar_1,
          label: context.tr.navScheduleTabLabel,
        ),
      if (_canNews)
        _NavTabConfig(
          index: 2,
          icon: Iconsax.note,
          activeIcon: Iconsax.note_1,
          label: context.tr.navNewsTabLabel,
        ),
      if (_canMessages)
        _NavTabConfig(
          index: 3,
          icon: Iconsax.message,
          activeIcon: Iconsax.message,
          label: context.tr.navMessagesTabLabel,
          showBadge: true,
        ),
      if (_canExpense)
        _NavTabConfig(
          index: 4,
          icon: Iconsax.wallet_3,
          activeIcon: Iconsax.wallet_1,
          label: context.tr.navExpenseTabLabel,
        ),
    ];

    return Scaffold(
      body: BlocBuilder<NavBarCubit, NavBarState>(
        buildWhen: (prev, next) => prev.currentIndex != next.currentIndex,
        builder: (context, state) {
          final allowed = tabs.map((e) => e.index).toSet();
          final fallback = tabs.isEmpty ? 0 : tabs.first.index;
          final effectiveIndex =
              allowed.contains(state.currentIndex) ? state.currentIndex : fallback;
          if (effectiveIndex != state.currentIndex) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              cubit.setIndex(effectiveIndex);
            });
          }
          return IndexedStack(index: effectiveIndex, children: _screens);
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
                final allowed = tabs.map((e) => e.index).toSet();
                final fallback = tabs.isEmpty ? 0 : tabs.first.index;
                final effectiveIndex =
                    allowed.contains(state.currentIndex) ? state.currentIndex : fallback;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: tabs
                      .map(
                        (tab) => _NavBarItem(
                          icon: tab.icon,
                          activeIcon: tab.activeIcon,
                          label: tab.label,
                          isActive: effectiveIndex == tab.index,
                          showBadge: tab.showBadge && state.hasUnreadMessages,
                          onTap: () => cubit.setIndex(tab.index),
                        ),
                      )
                      .toList(growable: false),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTabConfig {
  const _NavTabConfig({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.showBadge = false,
  });

  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool showBadge;
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
              margin: const EdgeInsetsDirectional.only(bottom: 4),
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
                  PositionedDirectional(
                    top: -2,
                    end: -4,
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
