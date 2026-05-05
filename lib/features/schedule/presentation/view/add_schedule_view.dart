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
      create: (_) => sl<AddScheduleCubit>()..loadTypes(),
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
            final now = DateTime.now();
            final todayCalendar = DateTime(now.year, now.month, now.day);
            final minFocusedMonth = DateTime(
              todayCalendar.year,
              todayCalendar.month,
              1,
            );
            final canGoToPreviousMonth = state.focusedMonth.isAfter(
              minFocusedMonth,
            );

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
                        onTap: canGoToPreviousMonth
                            ? () => cubit.changeMonth(-1)
                            : null,
                        child: Opacity(
                          opacity: canGoToPreviousMonth ? 1 : 0.35,
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
                    minimumSelectableDate: todayCalendar,
                    onSelectDay: cubit.selectDay,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.w, 0, 20.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),

                      Text(
                        context.tr.scheduleEventType,
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.darkText,
                        ).copyWith(fontSize: 14.sp),
                      ),
                      SizedBox(height: 8.h),
                      _buildDropdown<String>(
                        value: state.selectedEventType,
                        hint: context.tr.scheduleSelect,
                        items: state.eventTypes.isEmpty
                            ? const ['audio_call', 'video_call', 'simple_event']
                            : state.eventTypes.map((t) => t.value).toList(),
                        labelBuilder: (v) {
                          final match = state.eventTypes
                              .where((e) => e.value == v)
                              .toList();
                          if (match.isNotEmpty) return match.first.label;
                          return switch (v) {
                            'audio_call' => 'Audio Call',
                            'video_call' => 'Video Call',
                            'simple_event' => 'Event',
                            _ => v,
                          };
                        },
                        onChanged: cubit.setEventType,
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
                        value: DateFormat.yMMMd(
                          Localizations.localeOf(context).toString(),
                        ).format(state.selectedDate ?? state.selectedDay),
                        onTap: null,
                      ),

                      SizedBox(height: 16.h),

                      Text(
                        context.tr.scheduleTimeStart,
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.darkText,
                        ).copyWith(fontSize: 14.sp),
                      ),
                      SizedBox(height: 8.h),
                      _TimeField(
                        value:
                            state.selectedTime?.format(context) ??
                            context.tr.scheduleSelect,
                        onTap: () async {
                          final time = await _pickTime(
                            context,
                            initialTime:
                                state.selectedTime ??
                                const TimeOfDay(hour: 9, minute: 0),
                            helpText: context.tr.scheduleTimeStart,
                          );
                          if (time != null) cubit.setTime(time);
                        },
                      ),

                      SizedBox(height: 16.h),
                      Text(
                        context.tr.scheduleTimeEnd,
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.darkText,
                        ).copyWith(fontSize: 14.sp),
                      ),
                      SizedBox(height: 8.h),
                      _TimeField(
                        value:
                            state.selectedEndTime?.format(context) ??
                            context.tr.scheduleSelect,
                        onTap: () async {
                          final time = await _pickTime(
                            context,
                            initialTime:
                                state.selectedEndTime ??
                                state.selectedTime ??
                                const TimeOfDay(hour: 17, minute: 0),
                            helpText: context.tr.scheduleTimeEnd,
                          );
                          if (time != null) {
                            final ok = cubit.setEndTime(time);
                            if (!ok && context.mounted) {
                              await appToast(
                                context: context,
                                type: ToastType.error,
                                message: context
                                    .tr
                                    .scheduleErrorEndTimeNotAfterStart,
                              );
                            }
                          }
                        },
                      ),

                      SizedBox(height: 16.h),
                      Text(
                        context.tr.scheduleNotes,
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.darkText,
                        ).copyWith(fontSize: 14.sp),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        initialValue: state.note ?? '',
                        onChanged: cubit.setNote,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: context.tr.scheduleNotes,
                          filled: true,
                          fillColor: AppColors.background,
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
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),

                      SizedBox(height: 28.h),

                      SafeArea(
                        top: false,
                        child: SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed:
                                state.status == AddScheduleStatus.submitting ||
                                    state.hasInvalidEndBeforeStart
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
                                    context.tr.commonSave,
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

  /// Numeric time entry (no analog dial) — simpler than default [TimePickerEntryMode.dial].
  Future<TimeOfDay?> _pickTime(
    BuildContext context, {
    required TimeOfDay initialTime,
    String? helpText,
  }) {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.input,
      helpText: helpText,
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
  }

  String _localizeError(BuildContext context, String raw) {
    final msg = raw.trim();
    if (msg.isEmpty) return context.tr.sorryMessage;

    // Internal codes from cubit
    if (msg == 'workspace_missing') {
      return context.tr.scheduleErrorWorkspaceMissing;
    }
    if (msg == 'missing_type') return context.tr.errorFieldRequired;
    if (msg == 'missing_start_date') {
      return context.tr.scheduleErrorStartDateRequired;
    }
    if (msg == 'end_time_not_after_start') {
      return context.tr.scheduleErrorEndTimeNotAfterStart;
    }

    // Backend validation message (as seen in screenshot)
    final lower = msg.toLowerCase();
    if (lower.contains('scheduled') &&
        (lower.contains('starts at') || lower.contains('starts_at')) &&
        lower.contains('date after now')) {
      return context.tr.scheduleErrorScheduledStartsAtAfterNow;
    }

    return msg;
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.focusedMonth,
    required this.selectedDay,
    required this.minimumSelectableDate,
    required this.onSelectDay,
  });

  final DateTime focusedMonth;
  final DateTime selectedDay;
  final DateTime minimumSelectableDate;
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
              final isDisabled = date.isBefore(minimumSelectableDate);
              final isSelected =
                  !isDisabled &&
                  date.year == selectedDay.year &&
                  date.month == selectedDay.month &&
                  date.day == selectedDay.day;
              final isToday =
                  date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: isDisabled ? null : () => onSelectDay(date),
                  child: Container(
                    height: 44.h,
                    margin: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.blue
                          : isToday && !isDisabled
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
                              : isDisabled
                              ? AppColors.greyText.withValues(alpha: 0.45)
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
  const _DateField({required this.value, this.onTap});

  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final field = InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.background,
        contentPadding: EdgeInsetsDirectional.fromSTEB(14.w, 14.h, 14.w, 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.border),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.border),
        ),
        prefixIcon: Icon(
          Iconsax.calendar,
          size: 18.sp,
          color: onTap == null ? AppColors.greyText : AppColors.primary,
        ),
      ),
      child: Text(
        value,
        style: AppTextStyles.bodyMedium(
          color: onTap == null ? AppColors.greyText : AppColors.darkText,
        ).copyWith(fontSize: 14.sp),
      ),
    );

    if (onTap == null) {
      return field;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: field,
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
