import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:masr_al_qsariya/features/documents/presentation/view/documents_view.dart';
import 'package:masr_al_qsariya/features/home/domain/entities/home_awaiting_call.dart';
import 'package:masr_al_qsariya/features/home/domain/entities/recent_activity.dart';
import 'package:masr_al_qsariya/features/home/presentation/cubit/home_awaiting_call_action_cubit.dart';
import 'package:masr_al_qsariya/features/home/presentation/cubit/home_awaiting_call_action_state.dart';
import 'package:masr_al_qsariya/features/home/presentation/cubit/home_recent_activities_cubit.dart';
import 'package:masr_al_qsariya/features/home/presentation/cubit/home_recent_activities_state.dart';
import 'package:masr_al_qsariya/features/home/presentation/widgets/activity_item_tile.dart';
import 'package:masr_al_qsariya/features/home/presentation/widgets/awaiting_card.dart';
import 'package:masr_al_qsariya/features/home/presentation/widgets/quick_action_card.dart';
import 'package:masr_al_qsariya/features/home/presentation/widgets/reschedule_bottom_sheet.dart';
import 'package:masr_al_qsariya/features/nav_bar/presentation/cubit/nav_bar_cubit.dart';
import 'package:masr_al_qsariya/features/notifications/presentation/view/notifications_view.dart';
import 'package:masr_al_qsariya/features/profile/presentation/view/privacy_security_static_view.dart';
import 'package:masr_al_qsariya/features/profile/presentation/view/profile_view.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/view/session_library_watch_view.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/view/sessions_library_view.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/view/sessions_view.dart'
    show SessionsView, openLiveSessionLobby;

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const String _pRecentActivities = 'mobile.home.recent_activities';
  static const String _pLiveSessions = 'mobile.home.live_sessions';
  static const String _pSessionLibrary = 'mobile.home.session_library';
  static const String _pWorkspaceChats = 'mobile.home.workspace_chats';
  static const String _pWorkspaceCalendarItems =
      'mobile.home.workspace_calendar_items';
  static const String _pWorkspaceRegularExpenses =
      'mobile.home.workspace_regular_expenses';
  static const String _pWorkspaceSupportExpenses =
      'mobile.home.workspace_support_expenses';
  static const String _pWorkspaceCalls = 'mobile.home.workspace_calls';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HomeRecentActivitiesCubit>()..load()),
        BlocProvider(create: (_) => sl<HomeAwaitingCallActionCubit>()),
      ],
      child: BlocListener<HomeAwaitingCallActionCubit, HomeAwaitingCallActionState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == HomeAwaitingCallActionStatus.failure) {
            final msg = state.error == 'workspace_missing'
                ? context.tr.scheduleErrorWorkspaceMissing
                : (state.error ?? context.tr.homeCallActionFailed);
            appToast(context: context, type: ToastType.error, message: msg);
            return;
          }
          if (state.status != HomeAwaitingCallActionStatus.success) return;
          final successMessage = state.actionType == HomeAwaitingCallActionType.confirm
              ? context.tr.homeCallConfirmedSuccess
              : context.tr.homeCallRescheduledSuccess;
          appToast(
            context: context,
            type: ToastType.success,
            message: successMessage,
          );
          context.read<HomeRecentActivitiesCubit>().load();
          context.read<HomeAwaitingCallActionCubit>().reset();
        },
        child: Scaffold(
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
                  if (_buildActions(context).isNotEmpty) ...[
                    Text(
                      context.tr.homeQuickActions,
                      style: AppTextStyles.heading2(
                        color: AppColors.darkText,
                      ).copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 14.h),
                    _buildQuickActionsGrid(context),
                  ],
                  _buildAwaitingBlock(context),
                  // ── Recent Activity ──
                  if (_can(_pRecentActivities)) ...[
                    Text(
                      context.tr.homeRecentActivity,
                      style: AppTextStyles.heading2(
                        color: AppColors.darkText,
                      ).copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 8.h),
                    _buildRecentActivityList(context),
                  ],
                  SizedBox(height: 24.h),
                ],
              ),
            ),
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
            border: Border.all(color: AppColors.primaryDark, width: 2),
          ),
          child: CircleAvatar(
            radius: 24.r,
            backgroundColor: const Color(0xFFF0EDE6),
            child: Text(
              displayName.isNotEmpty ? displayName.characters.first : 'G',
              style: AppTextStyles.heading2(
                color: AppColors.primaryDark,
              ).copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
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
                style: AppTextStyles.caption(
                  color: AppColors.greyText,
                ).copyWith(fontSize: 13.sp),
              ),
              SizedBox(height: 2.h),
              Text(
                displayName,
                style: AppTextStyles.heading2(
                  color: AppColors.darkText,
                ).copyWith(fontSize: 17.sp, fontWeight: FontWeight.w700),
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
              border: Border.all(color: AppColors.primary, width: 1.5),
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
    final actions = _buildActions(context);

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

  List<_QuickAction> _buildActions(BuildContext context) {
    void goToTab(int index) => context.read<NavBarCubit>().setIndex(index);
    final canExpense =
        _can(_pWorkspaceRegularExpenses) || _can(_pWorkspaceSupportExpenses);

    return [
      if (_can(_pWorkspaceChats))
        _QuickAction(
          Iconsax.message,
          context.tr.homeSendMessage,
          () => goToTab(3),
        ),
      if (_can(_pWorkspaceCalendarItems))
        _QuickAction(
          Iconsax.calendar_add,
          context.tr.homeAddSchedule,
          () => goToTab(1),
        ),
      if (canExpense)
        _QuickAction(
          Iconsax.receipt_item,
          context.tr.homeExpense,
          () => goToTab(4),
        ),
      _QuickAction(Iconsax.folder, context.tr.homeDocuments, () {
        sl<AppNavigator>().push(screen: const DocumentsView());
      }),
      _QuickAction(Iconsax.user, context.tr.profileTitle, () {
        sl<AppNavigator>().push(screen: const ProfileView());
      }),
      _QuickAction(
        Iconsax.shield_tick,
        context.tr.profileMenuPrivacySecurity,
        () {
          sl<AppNavigator>().push(screen: const PrivacySecurityStaticView());
        },
      ),
      if (_can(_pLiveSessions))
        _QuickAction(Iconsax.video_play, context.tr.homeSessions, () {
          sl<AppNavigator>().push(screen: const SessionsView());
        }),
      if (_can(_pSessionLibrary))
        _QuickAction(Iconsax.video_square, context.tr.homeSessionsLibrary, () {
          sl<AppNavigator>().push(screen: const SessionsLibraryView());
        }),
    ];
  }

  Widget _buildAwaitingBlock(BuildContext context) {
    if (!_can(_pWorkspaceCalls)) {
      return SizedBox(height: 28.h);
    }
    return BlocBuilder<HomeRecentActivitiesCubit, HomeRecentActivitiesState>(
      builder: (context, state) {
        final calls = _pendingCalls(state.calls);
        if (calls.isEmpty) return SizedBox(height: 28.h);
        final actionState = context.watch<HomeAwaitingCallActionCubit>().state;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 28.h),
            Text(
              context.tr.homeAwaitingResponse,
              style: AppTextStyles.heading2(
                color: AppColors.darkText,
              ).copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12.h),
            ...calls.map((call) {
              final isConfirmLoading =
                  actionState.status == HomeAwaitingCallActionStatus.loading &&
                      actionState.actionType == HomeAwaitingCallActionType.confirm &&
                      actionState.callId == call.id;
              final isRescheduleLoading =
                  actionState.status == HomeAwaitingCallActionStatus.loading &&
                      actionState.actionType == HomeAwaitingCallActionType.reschedule &&
                      actionState.callId == call.id;

              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: AwaitingCard(
                  subtitle: _awaitingSubtitle(context, call),
                  confirmLoading: isConfirmLoading,
                  requestLoading: isRescheduleLoading,
                  onConfirm: () =>
                      context.read<HomeAwaitingCallActionCubit>().confirm(call.id),
                  onRequestReschedule: () =>
                      _onRequestReschedule(context, call.id),
                ),
              );
            }),
            SizedBox(height: 28.h),
          ],
        );
      },
    );
  }

  bool _can(String permission) {
    final user = sl<Storage>().getUser();
    if (user == null) return true;
    return user.hasPermission(permission);
  }

  List<HomeAwaitingCall> _pendingCalls(List<HomeAwaitingCall> calls) {
    const visibleStatuses = <String>{
      'pending_confirmation',
      'reschedule_requested',
    };
    return calls
        .where((call) => visibleStatuses.contains(call.status.toLowerCase().trim()))
        .toList()
      ..sort((a, b) {
        final first = a.scheduledStartsAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final second = b.scheduledStartsAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return first.compareTo(second);
      });
  }

  String _awaitingSubtitle(BuildContext context, HomeAwaitingCall call) {
    final locale = Localizations.localeOf(context).toString();
    final start = call.scheduledStartsAt;
    final timeText = start == null ? '' : _formatCallDateTime(context, start, locale);
    final owner = call.createdByName.trim().isEmpty
        ? (call.workspaceName ?? context.tr.homeUpcomingCall)
        : call.createdByName.trim();
    if (timeText.isEmpty) return owner;
    return '$owner • $timeText';
  }

  String _formatCallDateTime(BuildContext context, DateTime date, String locale) {
    final now = DateTime.now();
    final isToday = now.year == date.year && now.month == date.month && now.day == date.day;
    final timePart = DateFormat.jm(locale).format(date);
    if (isToday) {
      return 'Today, $timePart';
    }
    return '${DateFormat.yMMMd(locale).format(date)}, $timePart';
  }

  Future<void> _onRequestReschedule(BuildContext context, int callId) async {
    final selectedDate = await RescheduleBottomSheet.show(context);
    if (!context.mounted || selectedDate == null) return;
    final payloadDate = DateFormat("M/d/yyyy'T'HH:mm:ss").format(selectedDate.toLocal());
    await context.read<HomeAwaitingCallActionCubit>().reschedule(
          callId: callId,
          scheduledStartsAt: payloadDate,
        );
  }

  /// Vertical list of recent activity tiles.
  Widget _buildRecentActivityList(BuildContext context) {
    return BlocBuilder<HomeRecentActivitiesCubit, HomeRecentActivitiesState>(
      builder: (context, state) {
        if (state.status == HomeRecentActivitiesStatus.loading &&
            state.activities.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == HomeRecentActivitiesStatus.failure) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              state.error ?? '',
              style: AppTextStyles.caption(
                color: AppColors.error,
              ).copyWith(fontSize: 12.sp),
            ),
          );
        }

        if (state.activities.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.activities.length,
          itemBuilder: (context, index) {
            final item = state.activities[index];
            return ActivityItemTile(
              item: item,
              onTap: () => _onRecentActivityTap(context, item),
            );
          },
        );
      },
    );
  }

  void _onRecentActivityTap(BuildContext context, RecentActivity item) {
    switch (item.kind) {
      case 'live_session':
        final liveSessionId = item.itemId;
        if (liveSessionId != null && liveSessionId > 0) {
          openLiveSessionLobby(liveSessionId);
          return;
        }
        final meetingLink = item.sessionLink?.trim();
        if (meetingLink != null && meetingLink.isNotEmpty) {
          sl<AppNavigator>().push(
            screen: SessionLibraryWatchView(
              initialUrl: meetingLink,
              title: item.title,
            ),
          );
        }
        return;

      case 'session_library_item':
        final videoUrl = item.singleVideoUrl?.trim();
        if (videoUrl != null && videoUrl.isNotEmpty) {
          sl<AppNavigator>().push(
            screen: SessionLibraryWatchView(
              initialUrl: videoUrl,
              title: item.title,
            ),
          );
          return;
        }
        sl<AppNavigator>().push(screen: const SessionsLibraryView());
        return;

      case 'news_feed':
        context.read<NavBarCubit>().setIndex(2);
        return;

      default:
        return;
    }
  }
}

class _QuickAction {
  const _QuickAction(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}
