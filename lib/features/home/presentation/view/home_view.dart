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
import 'package:masr_al_qsariya/features/home/domain/entities/recent_activity.dart';
import 'package:masr_al_qsariya/features/home/presentation/cubit/home_recent_activities_cubit.dart';
import 'package:masr_al_qsariya/features/home/presentation/cubit/home_recent_activities_state.dart';
import 'package:masr_al_qsariya/features/home/presentation/widgets/activity_item_tile.dart';
import 'package:masr_al_qsariya/features/home/presentation/widgets/awaiting_card.dart';
import 'package:masr_al_qsariya/features/home/presentation/widgets/quick_action_card.dart';
import 'package:masr_al_qsariya/features/nav_bar/presentation/cubit/nav_bar_cubit.dart';
import 'package:masr_al_qsariya/features/notifications/presentation/view/notifications_view.dart';
import 'package:masr_al_qsariya/features/profile/presentation/view/privacy_security_static_view.dart';
import 'package:masr_al_qsariya/features/profile/presentation/view/profile_view.dart';
import 'package:masr_al_qsariya/features/schedule/domain/entities/call.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/join_call_cubit.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/join_call_state.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/schedule_calls_cubit.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/schedule_calls_state.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/view/call_room_view.dart';
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
        BlocProvider(
          create: (_) =>
              sl<ScheduleCallsCubit>()..load(focusedMonth: DateTime.now()),
        ),
        BlocProvider(create: (_) => sl<JoinCallCubit>()),
      ],
      child: BlocListener<JoinCallCubit, JoinCallState>(
        listenWhen: (prev, next) => prev.status != next.status,
        listener: (context, state) {
          if (state.status == JoinCallStatus.failure) {
            final msg = state.error == 'workspace_missing'
                ? context.tr.scheduleErrorWorkspaceMissing
                : (state.error ?? context.tr.scheduleJoinCallFailed);
            appToast(context: context, type: ToastType.error, message: msg);
            return;
          }

          if (state.status != JoinCallStatus.success) return;
          final joined = state.joined;
          final callId = state.activeCallId;
          if (joined == null || callId == null) return;

          CallEntity? call;
          for (final e in context.read<ScheduleCallsCubit>().state.calls) {
            if (e.id == callId) {
              call = e;
              break;
            }
          }
          final isVideo = (call?.mode ?? 'video') == 'video';

          appToast(
            context: context,
            type: ToastType.success,
            message: context.tr.scheduleJoinCallSuccess,
          );
          sl<AppNavigator>().push(
            screen: CallRoomView(
              livekitUrl: joined.livekitUrl,
              token: joined.token,
              roomName: joined.roomName,
              isVideo: isVideo,
              callId: callId,
            ),
          );
          context.read<JoinCallCubit>().reset();
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

  /// Horizontal list of awaiting response cards.
  Widget _buildAwaitingSection(BuildContext context) {
    return BlocBuilder<ScheduleCallsCubit, ScheduleCallsState>(
      builder: (context, callsState) {
        final call = _nextCallWithinHour(callsState.calls);
        if (call == null) return const SizedBox.shrink();

        return BlocBuilder<JoinCallCubit, JoinCallState>(
          builder: (context, joinState) {
            final isJoining =
                joinState.status == JoinCallStatus.loading &&
                joinState.activeCallId == call.id;
            return AwaitingCard(
              subtitle: _awaitingSubtitle(context, call),
              joinLoading: isJoining,
              onJoin: () => context.read<JoinCallCubit>().join(call.id),
            );
          },
        );
      },
    );
  }

  Widget _buildAwaitingBlock(BuildContext context) {
    if (!_can(_pWorkspaceCalls)) {
      return SizedBox(height: 28.h);
    }
    return BlocBuilder<ScheduleCallsCubit, ScheduleCallsState>(
      builder: (context, callsState) {
        final call = _nextCallWithinHour(callsState.calls);
        if (call == null) return SizedBox(height: 28.h);

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
            _buildAwaitingSection(context),
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

  CallEntity? _nextCallWithinHour(List<CallEntity> calls) {
    final now = DateTime.now();
    final oneHourLater = now.add(const Duration(hours: 1));
    final todayStart = DateTime(now.year, now.month, now.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));

    final upcoming =
        calls.where((call) {
            if (call.status != 'scheduled') return false;
            final localStart = call.scheduledStartsAt.toLocal();
            if (localStart.isBefore(todayStart) ||
                !localStart.isBefore(tomorrowStart)) {
              return false;
            }
            if (localStart.isBefore(now)) return false;
            return !localStart.isAfter(oneHourLater);
          }).toList()
          ..sort((a, b) => a.scheduledStartsAt.compareTo(b.scheduledStartsAt));

    return upcoming.isEmpty ? null : upcoming.first;
  }

  String _awaitingSubtitle(BuildContext context, CallEntity call) {
    final callLabel = call.mode == 'audio'
        ? context.tr.scheduleAudioCall
        : context.tr.scheduleVideoCall;
    final localStart = call.scheduledStartsAt.toLocal();
    final locale = Localizations.localeOf(context).toString();
    final timeText = DateFormat.jm(locale).format(localStart);
    return '$callLabel - $timeText';
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
