import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/data/dummy_data.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  DateTime _focusedMonth = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Dummy calendar events
  final List<CalendarEvent> _events = [
    CalendarEvent(
      id: '1',
      title: 'Pickup from School',
      titleAr: 'الاستلام من المدرسة',
      titleFr: 'Récupérer à l\'école',
      date: DateTime.now(),
      time: '3:00 PM',
      color: AppColors.primaryDark,
      type: 'Pickup',
    ),
    CalendarEvent(
      id: '2',
      title: 'Doctor Appointment',
      titleAr: 'موعد الطبيب',
      titleFr: 'Rendez-vous médecin',
      date: DateTime.now(),
      time: '10:30 AM',
      color: AppColors.error,
      type: 'Medical',
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
    ),
  ];

  List<CalendarEvent> _eventsForDay(DateTime day) {
    return _events.where((e) =>
        e.date.year == day.year &&
        e.date.month == day.month &&
        e.date.day == day.day).toList();
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
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text('Shared Calendar', style: AppTextStyles.navTitle()),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Month/Year selector
          Container(
            color: AppColors.background,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _changeMonth(-1),
                  icon: const Icon(Iconsax.arrow_left_2, size: 20),
                ),
                Text(
                  _monthYearString(_focusedMonth),
                  style: AppTextStyles.heading2(),
                ),
                IconButton(
                  onPressed: () => _changeMonth(1),
                  icon: const Icon(Iconsax.arrow_right_3, size: 20),
                ),
              ],
            ),
          ),

          // Calendar Grid
          Container(
            color: AppColors.background,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _buildCalendarGrid(),
          ),

          const SizedBox(height: 12),

          // Events list
          Expanded(
            child: selectedEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Iconsax.calendar, size: 48,
                            color: AppColors.greyText.withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        Text('No events for this day',
                            style: AppTextStyles.caption()),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: selectedEvents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final event = selectedEvents[index];
                      return _EventCard(event: event);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add event
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Iconsax.add, color: AppColors.darkText),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final startWeekday = firstDayOfMonth.weekday % 7; // Sun=0
    final daysInMonth = lastDayOfMonth.day;

    const weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Column(
      children: [
        // Weekday headers
        Row(
          children: weekDays
              .map((d) => Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
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
                return const Expanded(child: SizedBox(height: 40));
              }
              final date = DateTime(
                  _focusedMonth.year, _focusedMonth.month, dayIndex);
              final isSelected = date.year == _selectedDay.year &&
                  date.month == _selectedDay.month &&
                  date.day == _selectedDay.day;
              final isToday = date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day;
              final hasEvents = _eventsForDay(date).isNotEmpty;

              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDay = date),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : isToday
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dayIndex',
                          style: AppTextStyles.smallMedium(
                            color: isSelected
                                ? AppColors.darkText
                                : AppColors.bodyText,
                          ),
                        ),
                        if (hasEvents)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.darkText
                                  : AppColors.primaryDark,
                              shape: BoxShape.circle,
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
        const SizedBox(height: 8),
      ],
    );
  }

  String _monthYearString(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _EventCard extends StatelessWidget {
  final CalendarEvent event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: event.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(event.title,
                              style: AppTextStyles.button()),
                          const SizedBox(height: 4),
                          Text(event.time,
                              style: AppTextStyles.caption()),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: event.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event.type,
                        style: AppTextStyles.tiny(color: event.color),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
