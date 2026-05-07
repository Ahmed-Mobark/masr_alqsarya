import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class RescheduleBottomSheet extends StatefulWidget {
  const RescheduleBottomSheet({super.key});

  static Future<DateTime?> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const RescheduleBottomSheet(),
    );
  }

  @override
  State<RescheduleBottomSheet> createState() => _RescheduleBottomSheetState();
}

class _RescheduleBottomSheetState extends State<RescheduleBottomSheet> {
  late DateTime _focusedMonth;
  DateTime? _selectedDay;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth =
          DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth =
          DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        top: 12.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            // Title
            Text(
              context.tr.rescheduleTitle,
              style: AppTextStyles.heading2(color: AppColors.darkText)
                  .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 20.h),
            // Month/Year navigation
            _buildMonthNavigator(),
            SizedBox(height: 12.h),
            // Calendar grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildCalendarGrid(),
            ),
            SizedBox(height: 20.h),
            // Time picker
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildTimePicker(),
            ),
            SizedBox(height: 24.h),
            // Submit button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: (_selectedDay != null && _selectedTime != null)
                      ? () {
                          final day = _selectedDay!;
                          final time = _selectedTime!;
                          final selected = DateTime(
                            day.year,
                            day.month,
                            day.day,
                            time.hour,
                            time.minute,
                          );
                          Navigator.pop(context, selected);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.darkText,
                    disabledBackgroundColor:
                        AppColors.primary.withValues(alpha: 0.4),
                    disabledForegroundColor:
                        AppColors.darkText.withValues(alpha: 0.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                  child: Text(
                    context.tr.rescheduleSubmit,
                    style: AppTextStyles.bodyMedium(color: AppColors.darkText)
                        .copyWith(
                            fontSize: 14.sp, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthNavigator() {
    final localeName = Localizations.localeOf(context).toString();
    final monthName = DateFormat.MMMM(localeName).format(_focusedMonth);
    final year = _focusedMonth.year.toString();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _previousMonth,
            child: Icon(Icons.chevron_left, size: 24.sp,
                color: AppColors.darkText),
          ),
          Text(
            '$monthName $year',
            style: AppTextStyles.bodyMedium(color: AppColors.darkText)
                .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          GestureDetector(
            onTap: _nextMonth,
            child: Icon(Icons.chevron_right, size: 24.sp,
                color: AppColors.darkText),
          ),
        ],
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
                            style: AppTextStyles.caption(
                                color: AppColors.greyText)
                                .copyWith(fontSize: 12.sp)),
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
                return Expanded(child: SizedBox(height: 42.h));
              }
              final date = DateTime(
                  _focusedMonth.year, _focusedMonth.month, dayIndex);
              final isSelected = _selectedDay != null &&
                  date.year == _selectedDay!.year &&
                  date.month == _selectedDay!.month &&
                  date.day == _selectedDay!.day;
              final isToday = date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day;
              final isPast = date.isBefore(
                  DateTime.now().subtract(const Duration(days: 1)));

              return Expanded(
                child: GestureDetector(
                  onTap: isPast
                      ? null
                      : () => setState(() => _selectedDay = date),
                  child: Container(
                    height: 42.h,
                    margin: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : isToday
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Text(
                        '$dayIndex',
                        style: AppTextStyles.smallMedium(
                          color: isPast
                              ? AppColors.greyText.withValues(alpha: 0.4)
                              : isSelected
                                  ? AppColors.darkText
                                  : AppColors.darkText,
                        ).copyWith(
                          fontSize: 14.sp,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _buildTimePicker() {
    return GestureDetector(
      onTap: _pickTime,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, size: 20.sp, color: AppColors.greyText),
            SizedBox(width: 10.w),
            Text(
              _selectedTime != null
                  ? _formatTime(_selectedTime!)
                  : context.tr.rescheduleSelectTime,
              style: AppTextStyles.bodyMedium(
                color: _selectedTime != null
                    ? AppColors.darkText
                    : AppColors.greyText,
              ).copyWith(fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _weekDayLabels(String localeName) {
    final baseSunday = DateTime.utc(2024, 1, 7); // Sunday
    final formatter = DateFormat.E(localeName);
    return List.generate(
        7, (i) => formatter.format(baseSunday.add(Duration(days: i))));
  }
}
