import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/data/dummy_data.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/view/add_schedule_view.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/view/call_room_view.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/join_call_cubit.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/join_call_state.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/schedule_calls_cubit.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/schedule_calls_state.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<ScheduleCallsCubit>()..load(focusedMonth: DateTime.now()),
        ),
        BlocProvider(create: (_) => sl<JoinCallCubit>()),
      ],
      child: const _ScheduleBody(),
    );
  }
}

class _ScheduleBody extends StatefulWidget {
  const _ScheduleBody();

  @override
  State<_ScheduleBody> createState() => _ScheduleBodyState();
}

class _ScheduleBodyState extends State<_ScheduleBody> {
  DateTime _focusedMonth = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final int _selectedFilterIndex = 0;
  int? _lastOpenedCallId;
  TimeOfDay? _timeFrom;
  TimeOfDay? _timeTo;

  DateTime _gridStart(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final startWeekday = firstDayOfMonth.weekday % 7; // Sun=0
    return firstDayOfMonth.subtract(Duration(days: startWeekday));
  }

  List<CalendarEvent> _eventsForDay(DateTime day) {
    final dayEvents = _callEventsForDay(day).where(
      (e) =>
          e.date.year == day.year &&
          e.date.month == day.month &&
          e.date.day == day.day,
    );

    if (_selectedFilterIndex == 0) return dayEvents.toList();

    return dayEvents.where((e) => e.type == 'Call').toList();
  }

  List<CalendarEvent> _callEventsForDay(DateTime day) {
    final callsState = context.read<ScheduleCallsCubit>().state;
    if (callsState.calls.isEmpty) return const [];

    final visibleStart = _gridStart(_focusedMonth);
    final visibleEndExclusive = visibleStart.add(const Duration(days: 42));

    return callsState.calls
        .map((c) {
          final d = c.scheduledStartsAt.toLocal();
          if (d.isBefore(visibleStart) || !d.isBefore(visibleEndExclusive)) {
            return null;
          }
          final isSameDay =
              d.year == day.year && d.month == day.month && d.day == day.day;
          if (!isSameDay) return null;

          if (!_passesTimeWindow(d)) return null;

          final titleLocalized = c.mode == 'audio'
              ? context.tr.scheduleAudioCall
              : context.tr.scheduleVideoCall;

          return CalendarEvent(
            id: 'call_${c.id}',
            title: titleLocalized,
            titleAr: titleLocalized,
            titleFr: titleLocalized,
            date: DateTime(d.year, d.month, d.day),
            time: DateFormat("M/d/yyyy'T'HH:mm:ss").format(d),
            color: AppColors.primaryDark,
            type: 'Call',
            status: c.status == 'scheduled' ? 'pending' : c.status,
            notes: c.livekitRoomName,
          );
        })
        .whereType<CalendarEvent>()
        .toList();
  }

  bool _passesTimeWindow(DateTime dateTime) {
    final from = _timeFrom;
    final to = _timeTo;
    if (from == null && to == null) return true;

    final minutes = dateTime.hour * 60 + dateTime.minute;
    final fromMinutes = from != null ? from.hour * 60 + from.minute : 0;
    final toMinutes = to != null ? to.hour * 60 + to.minute : (24 * 60 - 1);

    // If user sets an overnight range (e.g. 22:00 → 02:00), treat it as wrap.
    if (fromMinutes <= toMinutes) {
      return minutes >= fromMinutes && minutes <= toMinutes;
    }
    return minutes >= fromMinutes || minutes <= toMinutes;
  }

  Color _statusColor(String? status) {
    return switch (status) {
      'approved' => AppColors.success,
      'pending' => AppColors.primary,
      'rejected' => AppColors.error,
      _ => AppColors.greyText,
    };
  }

  void _changeMonth(int delta) {
    final next = DateTime(_focusedMonth.year, _focusedMonth.month + delta);
    setState(() => _focusedMonth = next);
    context.read<ScheduleCallsCubit>().load(focusedMonth: next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: BlocListener<JoinCallCubit, JoinCallState>(
          listenWhen: (prev, next) => prev.status != next.status,
          listener: (context, state) {
            if (state.status == JoinCallStatus.success) {
              appToast(
                context: context,
                type: ToastType.success,
                message: context.tr.scheduleJoinCallSuccess,
              );
              final callId = state.activeCallId;
              final joined = state.joined;
              if (callId == null || joined == null) return;
              if (_lastOpenedCallId == callId) return;
              _lastOpenedCallId = callId;

              final joinCubit = context.read<JoinCallCubit>();

              String? mode;
              for (final c in context.read<ScheduleCallsCubit>().state.calls) {
                if (c.id == callId) {
                  mode = c.mode;
                  break;
                }
              }
              final isVideo = (mode ?? 'video') == 'video';

              sl<AppNavigator>()
                  .push(
                    screen: CallRoomView(
                      livekitUrl: joined.livekitUrl,
                      token: joined.token,
                      roomName: joined.roomName,
                      isVideo: isVideo,
                      callId: callId,
                    ),
                  )
                  .then((_) {
                    if (!mounted) return;
                    _lastOpenedCallId = null;
                    joinCubit.reset();
                  });
            }
            if (state.status == JoinCallStatus.failure) {
              final msg = state.error == 'workspace_missing'
                  ? context.tr.scheduleErrorWorkspaceMissing
                  : context.tr.scheduleJoinCallFailed;
              appToast(context: context, type: ToastType.error, message: msg);
            }
          },
          child: BlocBuilder<ScheduleCallsCubit, ScheduleCallsState>(
            builder: (context, callsState) {
              final isLoading =
                  callsState.status == ScheduleCallsStatus.loading;
              final isFailure =
                  callsState.status == ScheduleCallsStatus.failure;
              final hasCalls = callsState.calls.isNotEmpty;
              final sortedCalls = [...callsState.calls]
                ..sort((a, b) {
                  final created = b.createdAt.compareTo(a.createdAt);
                  if (created != 0) return created;
                  final scheduled = b.scheduledStartsAt.compareTo(
                    a.scheduledStartsAt,
                  );
                  if (scheduled != 0) return scheduled;
                  return b.id.compareTo(a.id);
                });

              final selectedCalls = sortedCalls.where((c) {
                final d = c.scheduledStartsAt.toLocal();
                return d.year == _selectedDay.year &&
                    d.month == _selectedDay.month &&
                    d.day == _selectedDay.day;
              }).toList();

              return RefreshIndicator(
                onRefresh: () => context.read<ScheduleCallsCubit>().load(
                  focusedMonth: _focusedMonth,
                ),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // ── Header ──
                    SliverToBoxAdapter(
                      child: Container(
                        color: AppColors.background,
                        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.tr.scheduleSharedCalendarTitle,
                              style:
                                  AppTextStyles.heading2(
                                    color: AppColors.darkText,
                                  ).copyWith(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await sl<AppNavigator>().push(
                                  screen: const AddScheduleView(),
                                );
                                if (!context.mounted) return;
                                context.read<ScheduleCallsCubit>().load();
                              },
                              child: Container(
                                width: 36.w,
                                height: 36.w,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  Iconsax.add,
                                  size: 20.sp,
                                  color: AppColors.darkText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                    SliverToBoxAdapter(
                      child: Container(
                        color: AppColors.background,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: Builder(
                          builder: (context) {
                            // In RTL, users expect the timeline to move the other way.
                            final isRtl =
                                Directionality.of(context) == ui.TextDirection.rtl;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                              onTap: () => _changeMonth(isRtl ? 1 : -1),
                              borderRadius: BorderRadius.circular(12.r),
                              child: Padding(
                                padding: EdgeInsets.all(6.w),
                                child: Icon(
                                  isRtl ? Iconsax.arrow_right_3 : Iconsax.arrow_left_2,
                                  size: 18.sp,
                                  color: AppColors.darkText,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '${_monthString(_focusedMonth)} ${_focusedMonth.year}',
                                  style: AppTextStyles.heading2(
                                    color: AppColors.darkText,
                                  ).copyWith(fontSize: 16.sp),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => _changeMonth(isRtl ? -1 : 1),
                              borderRadius: BorderRadius.circular(12.r),
                              child: Padding(
                                padding: EdgeInsets.all(6.w),
                                child: Icon(
                                  isRtl ? Iconsax.arrow_left_2 : Iconsax.arrow_right_3,
                                  size: 18.sp,
                                  color: AppColors.darkText,
                                ),
                              ),
                            ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    // ── Calendar Grid ──
                    SliverToBoxAdapter(
                      child: Container(
                        color: AppColors.background,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: GestureDetector(
                          onHorizontalDragEnd: (details) {
                            final v = details.primaryVelocity ?? 0;
                            if (v.abs() < 120) return;
                            // Swipe left → next month, swipe right → previous month.
                            _changeMonth(v < 0 ? 1 : -1);
                          },
                          child: _buildCalendarGrid(),
                        ),
                      ),
                    ),

                    // ── Legend ──
                    SliverToBoxAdapter(
                      child: Container(
                        color: AppColors.background,
                        padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 12.h),
                        child: Row(
                          children: [
                            _LegendDot(
                              color: AppColors.success,
                              label: context.tr.scheduleLegendApproved,
                            ),
                            SizedBox(width: 16.w),
                            _LegendDot(
                              color: AppColors.primary,
                              label: context.tr.scheduleLegendPending,
                            ),
                            SizedBox(width: 16.w),
                            _LegendDot(
                              color: AppColors.error,
                              label: context.tr.scheduleLegendEvent,
                            ),
                            SizedBox(width: 16.w),
                            _LegendDot(
                              color: const Color(0xFF5B7FFF),
                              label: context.tr.scheduleLegendCall,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Events ──
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          SizedBox(height: 8.h),
                          Text(
                            context.tr.scheduleAllCalls,
                            style:
                                AppTextStyles.heading2(
                                  color: AppColors.darkText,
                                ).copyWith(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          SizedBox(height: 12.h),
                          if (isLoading)
                            Padding(
                              padding: EdgeInsets.only(top: 28.h),
                              child: Center(
                                child: SizedBox(
                                  width: 22.w,
                                  height: 22.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else if (isFailure)
                            Padding(
                              padding: EdgeInsets.only(top: 28.h),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Iconsax.warning_2,
                                      size: 40.sp,
                                      color: AppColors.error.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      callsState.error ??
                                          context.tr.sorryMessage,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.caption(
                                        color: AppColors.greyText,
                                      ),
                                    ),
                                    SizedBox(height: 14.h),
                                    SizedBox(
                                      height: 44.h,
                                      child: ElevatedButton(
                                        onPressed: () => context
                                            .read<ScheduleCallsCubit>()
                                            .load(focusedMonth: _focusedMonth),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: AppColors.darkText,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              999.r,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          context.tr.messagesRetry,
                                          style:
                                              AppTextStyles.bodyMedium(
                                                color: AppColors.darkText,
                                              ).copyWith(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (!hasCalls)
                            Padding(
                              padding: EdgeInsets.only(top: 40.h, bottom: 24.h),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Iconsax.calendar,
                                      size: 48.sp,
                                      color: AppColors.greyText.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      context.tr.scheduleNoCalls,
                                      style: AppTextStyles.caption(),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ...(selectedCalls.isEmpty
                                ? [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 24.h,
                                        bottom: 8.h,
                                      ),
                                      child: Center(
                                        child: Text(
                                          context.tr.scheduleNoEventsForDay,
                                          style: AppTextStyles.caption(
                                            color: AppColors.greyText,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                : selectedCalls.map((c) {
                              final d = c.scheduledStartsAt.toLocal();
                              final day = DateTime(d.year, d.month, d.day);
                              final titleLocalized = c.mode == 'audio'
                                  ? context.tr.scheduleAudioCall
                                  : context.tr.scheduleVideoCall;
                              final event = CalendarEvent(
                                id: 'call_${c.id}',
                                title: titleLocalized,
                                titleAr: titleLocalized,
                                titleFr: titleLocalized,
                                date: day,
                                time:
                                    DateFormat("M/d/yyyy'T'HH:mm:ss").format(d),
                                startsAt: d,
                                color: AppColors.primaryDark,
                                type: 'Call',
                                status: c.status == 'scheduled'
                                    ? 'pending'
                                    : c.status,
                                notes: c.livekitRoomName,
                              );
                              return Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: _buildEventCard(context, event),
                              );
                            }).toList()),
                          SizedBox(height: 16.h),
                        ]),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, CalendarEvent event) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final title = switch (localeCode) {
      'ar' => event.titleAr,
      'fr' => event.titleFr,
      _ => event.title,
    };
    final dateStr = DateFormat('M/dd/yyyy').format(event.date);

    if (event.type == 'Call') {
      return _CallCard(event: event, title: title);
    }

    if (event.type == 'Expense') {
      return _ExpenseCard(event: event, title: title);
    }

    // Standard event card
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
            child: Text(
              dateStr,
              style: AppTextStyles.caption(
                color: AppColors.greyText,
              ).copyWith(fontSize: 12.sp),
            ),
          ),
          Divider(height: 1, color: AppColors.border.withValues(alpha: 0.4)),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon + title
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: event.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        _eventIcon(event.type),
                        size: 20.sp,
                        color: event.color,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        title,
                        style:
                            AppTextStyles.bodyMedium(
                              color: AppColors.darkText,
                            ).copyWith(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Time + location
                Row(
                  children: [
                    Icon(Iconsax.clock, size: 14.sp, color: AppColors.greyText),
                    SizedBox(width: 6.w),
                    Text(
                      event.time == 'All Day'
                          ? context.tr.scheduleAllDay
                          : event.time,
                      style: AppTextStyles.caption(
                        color: AppColors.greyText,
                      ).copyWith(fontSize: 12.sp),
                    ),
                    if (event.location != null) ...[
                      SizedBox(width: 12.w),
                      Icon(
                        Iconsax.location,
                        size: 14.sp,
                        color: AppColors.greyText,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          event.location!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption(
                            color: AppColors.greyText,
                          ).copyWith(fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ],
                ),

                // Notes
                if (event.notes != null && event.notes!.trim().isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr.scheduleNotes,
                          style:
                              AppTextStyles.smallMedium(
                                color: AppColors.primaryDark,
                              ).copyWith(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          event.notes!,
                          style: AppTextStyles.caption(
                            color: AppColors.bodyText,
                          ).copyWith(fontSize: 12.sp, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _eventIcon(String type) {
    return switch (type) {
      'School' => Iconsax.teacher,
      'Medical' => Iconsax.health,
      'Activity' => Iconsax.activity,
      'Pickup' => Iconsax.car,
      'Custody' => Iconsax.people,
      'Call' => Iconsax.call,
      _ => Iconsax.calendar_1,
    };
  }

  Widget _buildCalendarGrid() {
    final gridStart = _gridStart(_focusedMonth);
    final focusedMonthOnly = DateTime(_focusedMonth.year, _focusedMonth.month);

    final localeName = Localizations.localeOf(context).toString();
    final weekDays = _weekDayLabels(localeName);

    return Column(
      children: [
        // Weekday headers
        Row(
          children: weekDays
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Text(
                        d,
                        style: AppTextStyles.tiny(color: AppColors.greyText),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        // Day cells
        ...List.generate(6, (week) {
          return Row(
            children: List.generate(7, (day) {
              final date = gridStart.add(Duration(days: week * 7 + day));
              final cellMonthOnly = DateTime(date.year, date.month);
              final isInFocusedMonth = cellMonthOnly == focusedMonthOnly;
              final isSelected =
                  date.year == _selectedDay.year &&
                  date.month == _selectedDay.month &&
                  date.day == _selectedDay.day;
              final isToday =
                  date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day;
              final dayEvents = _eventsForDay(date);
              final hasEvents = dayEvents.isNotEmpty;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (isInFocusedMonth) {
                      setState(() => _selectedDay = date);
                      return;
                    }
                    setState(() {
                      _focusedMonth = DateTime(date.year, date.month);
                      _selectedDay = date;
                    });
                    context.read<ScheduleCallsCubit>().load(
                      focusedMonth: _focusedMonth,
                    );
                  },
                  child: Container(
                    height: 44.h,
                    margin: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF5B7FFF)
                          : isToday
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${date.day}',
                          style: AppTextStyles.smallMedium(
                            color: isSelected
                                ? Colors.white
                                : isInFocusedMonth
                                ? AppColors.bodyText
                                : AppColors.greyText,
                          ).copyWith(fontSize: 14.sp),
                        ),
                        if (hasEvents)
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _buildEventDots(dayEvents),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }),
        SizedBox(height: 4.h),
      ],
    );
  }

  List<Widget> _buildEventDots(List<CalendarEvent> events) {
    final colors = <Color>{};
    for (final e in events) {
      colors.add(
        e.type == 'Call' ? AppColors.primaryDark : _statusColor(e.status),
      );
      if (colors.length >= 3) break;
    }
    return colors
        .map(
          (c) => Container(
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            width: 5.w,
            height: 5.w,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle),
          ),
        )
        .toList();
  }

  List<String> _weekDayLabels(String localeName) {
    final baseSunday = DateTime.utc(2024, 1, 7); // Sunday
    final formatter = DateFormat.E(localeName);
    return List.generate(
      7,
      (i) => formatter.format(baseSunday.add(Duration(days: i))),
    );
  }

  String _monthString(DateTime date) {
    final localeName = Localizations.localeOf(context).toString();
    return DateFormat.MMMM(localeName).format(date);
  }
}

// ── Legend dot ──
class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: AppTextStyles.tiny(
            color: AppColors.greyText,
          ).copyWith(fontSize: 10.sp),
        ),
      ],
    );
  }
}

// ── Call Card ──
class _CallCard extends StatelessWidget {
  const _CallCard({required this.event, required this.title});
  final CalendarEvent event;
  final String title;

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toString();
    final dt = event.startsAt;
    final header = dt == null
        ? event.time
        : '${DateFormat.yMMMd(localeName).format(dt)} • ${DateFormat.jm(localeName).format(dt)}';
    final isExpired = dt != null && dt.isBefore(DateTime.now());

    final statusLabel = switch (event.status) {
      'approved' => context.tr.scheduleLegendApproved,
      'pending' => context.tr.scheduleLegendPending,
      'rejected' => context.tr.scheduleLegendRejected,
      _ => context.tr.scheduleLegendPending,
    };
    final statusColor = switch (event.status) {
      'approved' => AppColors.success,
      'pending' => AppColors.primary,
      'rejected' => AppColors.error,
      _ => AppColors.primary,
    };

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
            child: Text(
              header,
              style: AppTextStyles.caption(
                color: AppColors.greyText,
              ).copyWith(fontSize: 12.sp),
            ),
          ),
          Divider(height: 1, color: AppColors.border.withValues(alpha: 0.4)),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Iconsax.call,
                        size: 20.sp,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style:
                                AppTextStyles.bodyMedium(
                                  color: AppColors.darkText,
                                ).copyWith(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(999.r),
                                ),
                                child: Text(
                                  statusLabel,
                                  style: AppTextStyles.tiny(
                                    color: statusColor,
                                  ).copyWith(fontSize: 10.sp),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (event.notes != null && event.notes!.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Text(
                    '${context.tr.scheduleRoomName}: ${event.notes}',
                    style: AppTextStyles.caption(
                      color: AppColors.greyText,
                    ).copyWith(fontSize: 12.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 14.h),
                SizedBox(
                  width: double.infinity,
                  height: 44.h,
                  child: BlocBuilder<JoinCallCubit, JoinCallState>(
                    builder: (context, joinState) {
                      final callId = int.tryParse(
                        event.id.replaceFirst('call_', ''),
                      );
                      final isJoining =
                          joinState.status == JoinCallStatus.loading &&
                          joinState.activeCallId == callId;
                      return ElevatedButton(
                        onPressed: isExpired || isJoining || callId == null
                            ? null
                            : () => context.read<JoinCallCubit>().join(callId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.darkText,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                        ),
                        child: isJoining
                            ? SizedBox(
                                width: 18.r,
                                height: 18.r,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.darkText,
                                ),
                              )
                            : Text(
                                isExpired
                                    ? context.tr.scheduleCallExpired
                                    : context.tr.scheduleJoin,
                                style:
                                    AppTextStyles.bodyMedium(
                                      color: AppColors.darkText,
                                    ).copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Expense Card ──
class _ExpenseCard extends StatelessWidget {
  const _ExpenseCard({required this.event, required this.title});
  final CalendarEvent event;
  final String title;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('M/dd/yyyy').format(event.date);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
            child: Text(
              dateStr,
              style: AppTextStyles.caption(
                color: AppColors.greyText,
              ).copyWith(fontSize: 12.sp),
            ),
          ),
          Divider(height: 1, color: AppColors.border.withValues(alpha: 0.4)),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Iconsax.money_send,
                        size: 20.sp,
                        color: AppColors.error,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr.scheduleExpensePaid,
                            style:
                                AppTextStyles.bodyMedium(
                                  color: AppColors.darkText,
                                ).copyWith(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          if (event.expenseCategory != null)
                            Text(
                              '${context.tr.scheduleCategory}: ${event.expenseCategory}',
                              style: AppTextStyles.caption(
                                color: AppColors.greyText,
                              ).copyWith(fontSize: 12.sp),
                            ),
                        ],
                      ),
                    ),
                    if (event.expenseAmount != null)
                      Text(
                        event.expenseAmount!,
                        style: AppTextStyles.heading2(color: AppColors.darkText)
                            .copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                  ],
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  width: double.infinity,
                  height: 44.h,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.darkText,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                    child: Text(
                      context.tr.scheduleViewReceipt,
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.darkText,
                      ).copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
