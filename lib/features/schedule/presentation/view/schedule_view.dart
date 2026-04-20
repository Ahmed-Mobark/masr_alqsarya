import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/data/dummy_data.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/view/add_schedule_view.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  DateTime _focusedMonth = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  int _selectedFilterIndex = 0;

  // Dummy calendar events
  final List<CalendarEvent> _events = [
    CalendarEvent(
      id: '1',
      title: 'School Event, Kelli',
      titleAr: 'حدث مدرسي، كيلي',
      titleFr: 'Événement scolaire, Kelli',
      date: DateTime.now(),
      time: '3:00 PM',
      color: const Color(0xFF5B7FFF),
      type: 'School',
      location: '620 E Walnut Street, Colton 81233',
      notes: 'Lorem ipsum dolor sit amet consectetur. Lorem ipsum dolor sit amet consectetur.',
      status: 'approved',
    ),
    CalendarEvent(
      id: '2',
      title: 'Voice Call',
      titleAr: 'مكالمة صوتية',
      titleFr: 'Appel vocal',
      date: DateTime.now(),
      time: '2:00 PM',
      color: AppColors.primaryDark,
      type: 'Call',
      status: 'pending',
    ),
    CalendarEvent(
      id: '3',
      title: 'Soccer Practice',
      titleAr: 'تمرين كرة القدم',
      titleFr: 'Entraînement de football',
      date: DateTime.now().add(const Duration(days: 1)),
      time: '5:00 PM',
      color: AppColors.success,
      type: 'Activity',
      status: 'approved',
    ),
    CalendarEvent(
      id: '4',
      title: 'Parent-Teacher Meeting',
      titleAr: 'اجتماع أولياء الأمور',
      titleFr: 'Réunion parents-professeurs',
      date: DateTime.now().add(const Duration(days: 2)),
      time: '9:00 AM',
      color: const Color(0xFF5B7FFF),
      type: 'School',
      status: 'pending',
    ),
    CalendarEvent(
      id: '5',
      title: 'Weekend with Co-parent',
      titleAr: 'عطلة نهاية الأسبوع',
      titleFr: 'Week-end avec coparent',
      date: DateTime.now().add(const Duration(days: 3)),
      time: 'All Day',
      color: AppColors.statusBadge,
      type: 'Custody',
      status: 'approved',
    ),
    CalendarEvent(
      id: '6',
      title: 'Expense Paid',
      titleAr: 'مصروف مدفوع',
      titleFr: 'Dépense payée',
      date: DateTime.now(),
      time: '',
      color: AppColors.error,
      type: 'Expense',
      status: 'approved',
      expenseAmount: '-299 EGP',
      expenseCategory: 'Education',
    ),
  ];

  List<String> _filterLabels(BuildContext context) => [
        context.tr.scheduleFilterAll,
        context.tr.scheduleFilterParentingTime,
        context.tr.scheduleFilterSchoolActivities,
        context.tr.scheduleFilterMedical,
      ];

  static const List<String> _filterTypes = [
    'All',
    'Custody',
    'School',
    'Medical',
  ];

  List<CalendarEvent> _eventsForDay(DateTime day) {
    final dayEvents = _events.where((e) =>
        e.date.year == day.year &&
        e.date.month == day.month &&
        e.date.day == day.day);

    if (_selectedFilterIndex == 0) return dayEvents.toList();

    final filterType = _filterTypes[_selectedFilterIndex];
    if (filterType == 'School') {
      return dayEvents
          .where((e) => e.type == 'School' || e.type == 'Activity')
          .toList();
    }
    return dayEvents.where((e) => e.type == filterType).toList();
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
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + delta,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _eventsForDay(_selectedDay);
    final filterLabels = _filterLabels(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Container(
              color: AppColors.background,
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr.scheduleSharedCalendarTitle,
                    style: AppTextStyles.heading2(color: AppColors.darkText)
                        .copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                    onTap: () {
                      sl<AppNavigator>()
                          .push(screen: const AddScheduleView());
                    },
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Iconsax.add, size: 20.sp,
                          color: AppColors.darkText),
                    ),
                  ),
                ],
              ),
            ),

            // ── Filter chips ──
            Container(
              color: AppColors.background,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: SizedBox(
                height: 38.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: filterLabels.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedFilterIndex == index;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedFilterIndex = index),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(999.r),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          filterLabels[index],
                          style: AppTextStyles.smallMedium(
                            color: AppColors.darkText,
                          ).copyWith(
                            fontSize: 13.sp,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ── Month/Year selector ──
            Container(
              color: AppColors.background,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Month dropdown
                  GestureDetector(
                    onTap: () => _changeMonth(-1),
                    child: Row(
                      children: [
                        Text(
                          _monthString(_focusedMonth),
                          style: AppTextStyles.heading2(
                                  color: AppColors.darkText)
                              .copyWith(fontSize: 16.sp),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Iconsax.arrow_down_1,
                            size: 16.sp, color: AppColors.darkText),
                      ],
                    ),
                  ),
                  // Year dropdown
                  GestureDetector(
                    onTap: () => _changeMonth(1),
                    child: Row(
                      children: [
                        Text(
                          '${_focusedMonth.year}',
                          style: AppTextStyles.heading2(
                                  color: AppColors.darkText)
                              .copyWith(fontSize: 16.sp),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Iconsax.arrow_down_1,
                            size: 16.sp, color: AppColors.darkText),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Calendar Grid ──
            Container(
              color: AppColors.background,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: _buildCalendarGrid(),
            ),

            // ── Legend ──
            Container(
              color: AppColors.background,
              padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 12.h),
              child: Row(
                children: [
                  _LegendDot(
                      color: AppColors.success,
                      label: context.tr.scheduleLegendApproved),
                  SizedBox(width: 16.w),
                  _LegendDot(
                      color: AppColors.primary,
                      label: context.tr.scheduleLegendPending),
                  SizedBox(width: 16.w),
                  _LegendDot(
                      color: AppColors.error,
                      label: context.tr.scheduleLegendEvent),
                  SizedBox(width: 16.w),
                  _LegendDot(
                      color: const Color(0xFF5B7FFF),
                      label: context.tr.scheduleLegendCall),
                ],
              ),
            ),

            // ── Events list ──
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                children: [
                  SizedBox(height: 8.h),
                  // Section title
                  Text(
                    context.tr.scheduleNewScheduleRequest,
                    style: AppTextStyles.heading2(color: AppColors.darkText)
                        .copyWith(
                            fontSize: 18.sp, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 12.h),
                  if (selectedEvents.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 40.h),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Iconsax.calendar,
                                size: 48.sp,
                                color: AppColors.greyText
                                    .withValues(alpha: 0.5)),
                            SizedBox(height: 12.h),
                            Text(
                              context.tr.scheduleNoEventsForDay,
                              style: AppTextStyles.caption(),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...selectedEvents.map((event) => Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: _buildEventCard(context, event),
                        )),
                ],
              ),
            ),
          ],
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
              style: AppTextStyles.caption(color: AppColors.greyText)
                  .copyWith(fontSize: 12.sp),
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
                        style: AppTextStyles.bodyMedium(
                                color: AppColors.darkText)
                            .copyWith(
                                fontSize: 15.sp, fontWeight: FontWeight.w600),
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
                      style: AppTextStyles.caption(color: AppColors.greyText)
                          .copyWith(fontSize: 12.sp),
                    ),
                    if (event.location != null) ...[
                      SizedBox(width: 12.w),
                      Icon(Iconsax.location,
                          size: 14.sp, color: AppColors.greyText),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          event.location!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption(
                                  color: AppColors.greyText)
                              .copyWith(fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ],
                ),

                // Notes
                if (event.notes != null) ...[
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
                          style: AppTextStyles.smallMedium(
                                  color: AppColors.primaryDark)
                              .copyWith(
                                  fontSize: 12.sp, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          event.notes!,
                          style:
                              AppTextStyles.caption(color: AppColors.bodyText)
                                  .copyWith(fontSize: 12.sp, height: 1.4),
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
    final firstDayOfMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final startWeekday = firstDayOfMonth.weekday % 7; // Sun=0
    final daysInMonth = lastDayOfMonth.day;

    final localeName = Localizations.localeOf(context).toString();
    final weekDays = _weekDayLabels(localeName);

    return Column(
      children: [
        // Weekday headers
        Row(
          children: weekDays
              .map((d) => Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Text(d,
                            style: AppTextStyles.tiny(
                                color: AppColors.greyText)),
                      ),
                    ),
                  ))
              .toList(),
        ),
        // Day cells
        ...List.generate(6, (week) {
          return Row(
            children: List.generate(7, (day) {
              final dayIndex = week * 7 + day - startWeekday + 1;
              if (dayIndex < 1 || dayIndex > daysInMonth) {
                return Expanded(child: SizedBox(height: 44.h));
              }
              final date = DateTime(
                  _focusedMonth.year, _focusedMonth.month, dayIndex);
              final isSelected = date.year == _selectedDay.year &&
                  date.month == _selectedDay.month &&
                  date.day == _selectedDay.day;
              final isToday = date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day;
              final dayEvents = _eventsForDay(date);
              final hasEvents = dayEvents.isNotEmpty;

              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDay = date),
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
                          '$dayIndex',
                          style: AppTextStyles.smallMedium(
                            color: isSelected
                                ? Colors.white
                                : AppColors.bodyText,
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
      colors.add(_statusColor(e.status));
      if (colors.length >= 3) break;
    }
    return colors
        .map((c) => Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(
                color: c,
                shape: BoxShape.circle,
              ),
            ))
        .toList();
  }

  List<String> _weekDayLabels(String localeName) {
    final baseSunday = DateTime.utc(2024, 1, 7); // Sunday
    final formatter = DateFormat.E(localeName);
    return List.generate(
        7, (i) => formatter.format(baseSunday.add(Duration(days: i))));
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
          style: AppTextStyles.tiny(color: AppColors.greyText)
              .copyWith(fontSize: 10.sp),
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
              'Today, ${event.time}',
              style: AppTextStyles.caption(color: AppColors.greyText)
                  .copyWith(fontSize: 12.sp),
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
                      child: Icon(Iconsax.call,
                          size: 20.sp, color: AppColors.primaryDark),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      context.tr.scheduleVoiceCall,
                      style: AppTextStyles.bodyMedium(
                              color: AppColors.darkText)
                          .copyWith(
                              fontSize: 15.sp, fontWeight: FontWeight.w600),
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
                      context.tr.scheduleJoin,
                      style: AppTextStyles.bodyMedium(
                              color: AppColors.darkText)
                          .copyWith(
                              fontSize: 14.sp, fontWeight: FontWeight.w700),
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
              style: AppTextStyles.caption(color: AppColors.greyText)
                  .copyWith(fontSize: 12.sp),
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
                      child: Icon(Iconsax.money_send,
                          size: 20.sp, color: AppColors.error),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr.scheduleExpensePaid,
                            style: AppTextStyles.bodyMedium(
                                    color: AppColors.darkText)
                                .copyWith(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600),
                          ),
                          if (event.expenseCategory != null)
                            Text(
                              '${context.tr.scheduleCategory}: ${event.expenseCategory}',
                              style: AppTextStyles.caption(
                                      color: AppColors.greyText)
                                  .copyWith(fontSize: 12.sp),
                            ),
                        ],
                      ),
                    ),
                    if (event.expenseAmount != null)
                      Text(
                        event.expenseAmount!,
                        style: AppTextStyles.heading2(color: AppColors.darkText)
                            .copyWith(
                                fontSize: 16.sp, fontWeight: FontWeight.w700),
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
                              color: AppColors.darkText)
                          .copyWith(
                              fontSize: 14.sp, fontWeight: FontWeight.w700),
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
