import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class AddScheduleView extends StatefulWidget {
  const AddScheduleView({super.key});

  @override
  State<AddScheduleView> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<AddScheduleView> {
  DateTime _focusedMonth = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String? _selectedEventType;
  String? _selectedChild;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _notesController = TextEditingController();

  static const List<String> _eventTypeKeys = [
    'Pickup',
    'Medical',
    'Activity',
    'School',
    'Custody',
    'Call',
  ];

  String _eventTypeLabel(BuildContext context, String key) {
    return switch (key) {
      'Pickup' => context.tr.scheduleEventTypePickup,
      'Medical' => context.tr.scheduleEventTypeMedical,
      'Activity' => context.tr.scheduleEventTypeActivity,
      'School' => context.tr.scheduleEventTypeSchool,
      'Custody' => context.tr.scheduleEventTypeCustody,
      'Call' => context.tr.scheduleLegendCall,
      _ => key,
    };
  }

  // Dummy children list
  final List<String> _children = ['Kelli', 'Omar', 'Sara'];

  void _changeMonth(int delta) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + delta,
      );
    });
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryDark,
              onPrimary: Colors.white,
              surface: AppColors.background,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryDark,
              onPrimary: Colors.white,
              surface: AppColors.background,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left, color: AppColors.primaryDark, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr.scheduleAddNewSchedule,
          style: AppTextStyles.heading2(color: AppColors.darkText)
              .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Month/Year selector ──
            Container(
              color: AppColors.background,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _changeMonth(-1),
                    child: Row(
                      children: [
                        Text(
                          _monthString(_focusedMonth),
                          style: AppTextStyles.heading2(color: AppColors.darkText)
                              .copyWith(fontSize: 16.sp),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Iconsax.arrow_down_1,
                            size: 16.sp, color: AppColors.darkText),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _changeMonth(1),
                    child: Row(
                      children: [
                        Text(
                          '${_focusedMonth.year}',
                          style: AppTextStyles.heading2(color: AppColors.darkText)
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
              padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 16.h),
              child: Row(
                children: [
                  _LegendDot(
                      color: AppColors.success,
                      label: context.tr.scheduleLegendApproved),
                  SizedBox(width: 14.w),
                  _LegendDot(
                      color: AppColors.primary,
                      label: context.tr.scheduleLegendPending),
                  SizedBox(width: 14.w),
                  _LegendDot(
                      color: AppColors.error,
                      label: context.tr.scheduleLegendRejected),
                  SizedBox(width: 14.w),
                  _LegendDot(
                      color: const Color(0xFF5B7FFF),
                      label: context.tr.scheduleLegendCall),
                ],
              ),
            ),

            SizedBox(height: 8.h),

            // ── Form ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section title
                  Text(
                    context.tr.scheduleNewScheduleRequest,
                    style: AppTextStyles.heading2(color: AppColors.darkText)
                        .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 16.h),

                  // Event Type + Child
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr.scheduleEventType,
                              style: AppTextStyles.bodyMedium(
                                      color: AppColors.darkText)
                                  .copyWith(fontSize: 14.sp),
                            ),
                            SizedBox(height: 8.h),
                            _buildDropdown<String>(
                              value: _selectedEventType,
                              hint: context.tr.scheduleSelect,
                              items: _eventTypeKeys,
                              labelBuilder: (key) =>
                                  _eventTypeLabel(context, key),
                              onChanged: (val) =>
                                  setState(() => _selectedEventType = val),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr.scheduleChild,
                              style: AppTextStyles.bodyMedium(
                                      color: AppColors.darkText)
                                  .copyWith(fontSize: 14.sp),
                            ),
                            SizedBox(height: 8.h),
                            _buildDropdown<String>(
                              value: _selectedChild,
                              hint: context.tr.scheduleSelect,
                              items: _children,
                              onChanged: (val) =>
                                  setState(() => _selectedChild = val),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Date + Time + Add button
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr.scheduleDate,
                              style: AppTextStyles.bodyMedium(
                                      color: AppColors.darkText)
                                  .copyWith(fontSize: 14.sp),
                            ),
                            SizedBox(height: 8.h),
                            GestureDetector(
                              onTap: _pickDate,
                              child: Container(
                                height: 48.h,
                                padding:
                                    EdgeInsets.symmetric(horizontal: 14.w),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border:
                                      Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _selectedDate != null
                                            ? DateFormat('MM/dd/yyyy')
                                                .format(_selectedDate!)
                                            : context.tr.scheduleDate,
                                        style: _selectedDate != null
                                            ? AppTextStyles.bodyMedium(
                                                color: AppColors.darkText)
                                            : AppTextStyles.caption(
                                                color: AppColors.greyText),
                                      ),
                                    ),
                                    Icon(Iconsax.calendar,
                                        size: 18.sp,
                                        color: AppColors.primary),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr.scheduleTime,
                              style: AppTextStyles.bodyMedium(
                                      color: AppColors.darkText)
                                  .copyWith(fontSize: 14.sp),
                            ),
                            SizedBox(height: 8.h),
                            GestureDetector(
                              onTap: _pickTime,
                              child: Container(
                                height: 48.h,
                                padding:
                                    EdgeInsets.symmetric(horizontal: 14.w),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border:
                                      Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _selectedTime != null
                                            ? _selectedTime!.format(context)
                                            : context.tr.scheduleTime,
                                        style: _selectedTime != null
                                            ? AppTextStyles.bodyMedium(
                                                color: AppColors.darkText)
                                            : AppTextStyles.caption(
                                                color: AppColors.greyText),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // "+" FAB
                      Padding(
                        padding: EdgeInsets.only(top: 24.h),
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Add additional date/time slot
                          },
                          child: Container(
                            width: 48.w,
                            height: 48.w,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Icon(Iconsax.add,
                                size: 22.sp, color: AppColors.darkText),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Notes
                  Text(
                    context.tr.scheduleNotes,
                    style: AppTextStyles.bodyMedium(color: AppColors.darkText)
                        .copyWith(fontSize: 14.sp),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    style: AppTextStyles.body(color: AppColors.darkText)
                        .copyWith(fontSize: 14.sp),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: EdgeInsets.all(14.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide:
                            BorderSide(color: AppColors.primary, width: 1.2),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Send Request Button
                  SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Submit schedule request
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.darkText,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                        ),
                        child: Text(
                          context.tr.scheduleSendRequest,
                          style: AppTextStyles.bodyMedium(
                                  color: AppColors.darkText)
                              .copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    String Function(T)? labelBuilder,
  }) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint,
              style: AppTextStyles.caption(color: AppColors.greyText)),
          isExpanded: true,
          icon: Icon(Iconsax.arrow_down_1,
              size: 16.sp, color: AppColors.greyText),
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      labelBuilder != null ? labelBuilder(item) : '$item',
                      style: AppTextStyles.bodyMedium(
                          color: AppColors.darkText),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final startWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    final localeName = Localizations.localeOf(context).toString();
    final weekDays = _weekDayLabels(localeName);

    return Column(
      children: [
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

              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _selectedDay = date;
                    _selectedDate = date;
                  }),
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
                    child: Center(
                      child: Text(
                        '$dayIndex',
                        style: AppTextStyles.smallMedium(
                          color: isSelected
                              ? Colors.white
                              : AppColors.bodyText,
                        ).copyWith(fontSize: 14.sp),
                      ),
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

  List<String> _weekDayLabels(String localeName) {
    final baseSunday = DateTime.utc(2024, 1, 7);
    final formatter = DateFormat.E(localeName);
    return List.generate(
        7, (i) => formatter.format(baseSunday.add(Duration(days: i))));
  }

  String _monthString(DateTime date) {
    final localeName = Localizations.localeOf(context).toString();
    return DateFormat.MMMM(localeName).format(date);
  }
}

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
