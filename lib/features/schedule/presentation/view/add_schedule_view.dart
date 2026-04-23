import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/add_schedule_cubit.dart';
import 'package:masr_al_qsariya/features/schedule/presentation/cubit/add_schedule_state.dart';

class AddScheduleView extends StatelessWidget {
  const AddScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AddScheduleCubit>(),
      child: const _AddScheduleBody(),
    );
  }
}

class _AddScheduleBody extends StatelessWidget {
  const _AddScheduleBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddScheduleCubit>();
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.primaryDark,
            size: 22.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr.scheduleAddNewSchedule,
          style: AppTextStyles.heading2(
            color: AppColors.darkText,
          ).copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<AddScheduleCubit, AddScheduleState>(
          listenWhen: (previous, current) =>
              previous.status != current.status ||
              previous.error != current.error,
          listener: (context, state) async {
            if (state.status == AddScheduleStatus.failure &&
                state.error != null &&
                state.error!.isNotEmpty) {
              await appToast(
                context: context,
                type: ToastType.error,
                message: _localizeError(context, state.error!),
              );
              return;
            }

            if (state.status == AddScheduleStatus.success) {
              await appToast(
                context: context,
                type: ToastType.success,
                message: context.tr.scheduleCallCreatedSuccess,
              );
              if (context.mounted) Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Calendar month header + grid (date picker)
                Container(
                  color: AppColors.background,
                  padding: EdgeInsetsDirectional.fromSTEB(
                    16.w,
                    12.h,
                    16.w,
                    8.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => cubit.changeMonth(-1),
                        child: Row(
                          children: [
                            Text(
                              _monthString(context, state.focusedMonth),
                              style: AppTextStyles.heading2(
                                color: AppColors.darkText,
                              ).copyWith(fontSize: 16.sp),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Iconsax.arrow_down_1,
                              size: 16.sp,
                              color: AppColors.darkText,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => cubit.changeMonth(1),
                        child: Row(
                          children: [
                            Text(
                              '${state.focusedMonth.year}',
                              style: AppTextStyles.heading2(
                                color: AppColors.darkText,
                              ).copyWith(fontSize: 16.sp),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Iconsax.arrow_down_1,
                              size: 16.sp,
                              color: AppColors.darkText,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: AppColors.background,
                  padding: EdgeInsetsDirectional.fromSTEB(12.w, 0, 12.w, 10.h),
                  child: _CalendarGrid(
                    focusedMonth: state.focusedMonth,
                    selectedDay: state.selectedDate ?? state.selectedDay,
                    onSelectDay: (d) {
                      cubit.selectDay(d);
                      cubit.setDate(d);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.w, 0, 20.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),

                      Text(
                        context.tr.scheduleCallMode,
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.darkText,
                        ).copyWith(fontSize: 14.sp),
                      ),
                      SizedBox(height: 8.h),
                      _buildDropdown<String>(
                        value: state.selectedCallMode,
                        hint: context.tr.scheduleSelect,
                        items: const ['audio', 'video'],
                        labelBuilder: (m) => m == 'audio'
                            ? context.tr.scheduleCallModeAudio
                            : context.tr.scheduleCallModeVideo,
                        onChanged: cubit.setCallMode,
                      ),

                      SizedBox(height: 16.h),

                      Text(
                        context.tr.scheduleDate,
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.darkText,
                        ).copyWith(fontSize: 14.sp),
                      ),
                      SizedBox(height: 8.h),
                      _DateField(
                        value: DateFormat(
                          "M/d/yyyy'T'HH:mm:ss",
                        ).format(
                          context.read<AddScheduleCubit>().scheduledStartsAt(),
                        ),
                        onTap: () => _showCompactDatePickerSheet(
                          context: context,
                          focusedMonth: state.focusedMonth,
                          selected: state.selectedDate ?? state.selectedDay,
                          onMonthChanged: cubit.changeMonth,
                          onSelected: (d) {
                            cubit.selectDay(d);
                            cubit.setDate(d);
                          },
                        ),
                      ),

                      SizedBox(height: 16.h),

                      Text(
                        context.tr.scheduleTime,
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.darkText,
                        ).copyWith(fontSize: 14.sp),
                      ),
                      SizedBox(height: 8.h),
                      _TimeField(
                        value: state.selectedTime?.format(context) ??
                            context.tr.scheduleSelect,
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: state.selectedTime ?? TimeOfDay.now(),
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
                          if (time != null) cubit.setTime(time);
                        },
                      ),

                      SizedBox(height: 28.h),

                      SafeArea(
                        top: false,
                        child: SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed:
                                state.status == AddScheduleStatus.submitting
                                ? null
                                : () async {
                                    await cubit.submit();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.darkText,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999.r),
                              ),
                            ),
                            child: state.status == AddScheduleStatus.submitting
                                ? SizedBox(
                                    width: 18.w,
                                    height: 18.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.darkText,
                                      ),
                                    ),
                                  )
                                : Text(
                                    context.tr.scheduleCreateCall,
                                    style:
                                        AppTextStyles.bodyMedium(
                                          color: AppColors.darkText,
                                        ).copyWith(
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
            );
          },
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
          hint: Text(
            hint,
            style: AppTextStyles.caption(color: AppColors.greyText),
          ),
          isExpanded: true,
          icon: Icon(
            Iconsax.arrow_down_1,
            size: 16.sp,
            color: AppColors.greyText,
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    labelBuilder != null ? labelBuilder(item) : '$item',
                    style: AppTextStyles.bodyMedium(color: AppColors.darkText),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  String _monthString(BuildContext context, DateTime date) {
    final localeName = Localizations.localeOf(context).toString();
    return DateFormat.MMMM(localeName).format(date);
  }

  String _localizeError(BuildContext context, String raw) {
    final msg = raw.trim();
    if (msg.isEmpty) return context.tr.sorryMessage;

    // Internal codes from cubit
    if (msg == 'workspace_missing') {
      return context.tr.scheduleErrorWorkspaceMissing;
    }
    if (msg == 'missing_type') return context.tr.errorFieldRequired;

    // Backend validation message (as seen in screenshot)
    final lower = msg.toLowerCase();
    if (lower.contains('scheduled') &&
        (lower.contains('starts at') || lower.contains('starts_at')) &&
        lower.contains('date after now')) {
      return context.tr.scheduleErrorScheduledStartsAtAfterNow;
    }

    return msg;
  }

  Future<void> _showCompactDatePickerSheet({
    required BuildContext context,
    required DateTime focusedMonth,
    required DateTime selected,
    required void Function(int delta) onMonthChanged,
    required ValueChanged<DateTime> onSelected,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (context) {
        // This sheet is purely UI; state is still driven by the cubit.
        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => onMonthChanged(-1),
                    child: Row(
                      children: [
                        Text(
                          _monthString(context, focusedMonth),
                          style: AppTextStyles.heading2(
                            color: AppColors.darkText,
                          ).copyWith(fontSize: 16.sp),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Iconsax.arrow_down_1,
                          size: 16.sp,
                          color: AppColors.darkText,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onMonthChanged(1),
                    child: Row(
                      children: [
                        Text(
                          '${focusedMonth.year}',
                          style: AppTextStyles.heading2(
                            color: AppColors.darkText,
                          ).copyWith(fontSize: 16.sp),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Iconsax.arrow_down_1,
                          size: 16.sp,
                          color: AppColors.darkText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              _CalendarGrid(
                focusedMonth: focusedMonth,
                selectedDay: selected,
                onSelectDay: (d) {
                  onSelected(d);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.focusedMonth,
    required this.selectedDay,
    required this.onSelectDay,
  });

  final DateTime focusedMonth;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onSelectDay;

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(
      focusedMonth.year,
      focusedMonth.month + 1,
      0,
    );
    final startWeekday = firstDayOfMonth.weekday % 7; // Sun=0
    final daysInMonth = lastDayOfMonth.day;

    final localeName = Localizations.localeOf(context).toString();
    final weekDays = _weekDayLabels(localeName);

    return Column(
      children: [
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
        ...List.generate(6, (week) {
          return Row(
            children: List.generate(7, (day) {
              final dayIndex = week * 7 + day - startWeekday + 1;
              if (dayIndex < 1 || dayIndex > daysInMonth) {
                return Expanded(child: SizedBox(height: 44.h));
              }
              final date = DateTime(
                focusedMonth.year,
                focusedMonth.month,
                dayIndex,
              );
              final isSelected =
                  date.year == selectedDay.year &&
                  date.month == selectedDay.month &&
                  date.day == selectedDay.day;
              final isToday =
                  date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onSelectDay(date),
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
                          color: isSelected ? Colors.white : AppColors.bodyText,
                        ).copyWith(fontSize: 14.sp),
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

  List<String> _weekDayLabels(String localeName) {
    final baseSunday = DateTime.utc(2024, 1, 7); // Sunday
    final formatter = DateFormat.E(localeName);
    return List.generate(
      7,
      (i) => formatter.format(baseSunday.add(Duration(days: i))),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.value, required this.onTap});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.background,
            contentPadding: EdgeInsetsDirectional.fromSTEB(
              14.w,
              14.h,
              14.w,
              14.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary, width: 1.2),
            ),
            prefixIcon: Icon(
              Iconsax.calendar,
              size: 18.sp,
              color: AppColors.primary,
            ),
          ),
          child: Text(
            value,
            style: AppTextStyles.bodyMedium(
              color: AppColors.darkText,
            ).copyWith(fontSize: 14.sp),
          ),
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({required this.value, required this.onTap});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.background,
            contentPadding: EdgeInsetsDirectional.fromSTEB(
              14.w,
              14.h,
              14.w,
              14.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary, width: 1.2),
            ),
            prefixIcon: Icon(
              Iconsax.clock,
              size: 18.sp,
              color: AppColors.primary,
            ),
          ),
          child: Text(
            value,
            style: AppTextStyles.bodyMedium(
              color: AppColors.darkText,
            ).copyWith(fontSize: 14.sp),
          ),
        ),
      ),
    );
  }
}
