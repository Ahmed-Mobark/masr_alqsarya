import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/live_session_lobby.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/live_session_lobby_cubit.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/live_session_lobby_state.dart';
import 'package:url_launcher/url_launcher.dart';

class SessionLobbyView extends StatelessWidget {
  const SessionLobbyView({super.key});

  static const String _dash = '\u2014';

  static Future<void> _openSessionLink(String? raw) async {
    final link = raw?.trim();
    if (link == null || link.isEmpty) return;
    final uri = Uri.tryParse(link);
    if (uri == null) return;
    if (!await canLaunchUrl(uri)) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _dateLabel(BuildContext context, DateTime? d) {
    if (d == null) return _dash;
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(d.toLocal());
  }

  String _timeLabel(BuildContext context, DateTime? d) {
    if (d == null) return _dash;
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.jm(locale).format(d.toLocal());
  }

  bool _canJoinSession(LiveSessionLobby lobby) {
    final link = lobby.sessionLink?.trim();
    if (link == null || link.isEmpty) return false;
    final start = lobby.startsAt?.toLocal();
    if (start == null) return true;
    return !DateTime.now().isBefore(start);
  }

  String _joinAvailableLabel(BuildContext context, LiveSessionLobby lobby) {
    final start = lobby.startsAt?.toLocal();
    if (start == null) return context.tr.sessionLobbyJoinNotAvailableYet;
    final locale = Localizations.localeOf(context).toString();
    final dateTime = DateFormat.yMMMd(locale).add_jm().format(start);
    return context.tr.sessionLobbyJoinAvailableAt(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18.sp,
            color: AppColors.yellow,
          ),
          onPressed: () => sl<AppNavigator>().pop(),
        ),
        title: Text(
          tr.sessionLobbyTitle,
          style: AppTextStyles.heading2(
            color: AppColors.darkText,
          ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocConsumer<LiveSessionLobbyCubit, LiveSessionLobbyState>(
          listenWhen: (previous, current) =>
              previous.bookingStatus != current.bookingStatus,
          listener: (context, state) {
            if (state.bookingStatus == LiveSessionLobbyBookingStatus.success) {
              appToast(
                context: context,
                type: ToastType.success,
                message: context.tr.sessionsBookedSuccess,
              );
              return;
            }
            if (state.bookingStatus == LiveSessionLobbyBookingStatus.failure) {
              final msg = state.bookingError == 'workspace_missing'
                  ? context.tr.scheduleErrorWorkspaceMissing
                  : (state.bookingError ?? context.tr.sessionsBookedFailed);
              appToast(context: context, type: ToastType.error, message: msg);
            }
          },
          builder: (context, state) {
            if (state.status == LiveSessionLobbyStatus.loading ||
                state.status == LiveSessionLobbyStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == LiveSessionLobbyStatus.failure) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.error ?? '',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body(color: AppColors.darkText),
                      ),
                      SizedBox(height: 16.h),
                      FilledButton(
                        onPressed: () =>
                            context.read<LiveSessionLobbyCubit>().load(),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.darkText,
                        ),
                        child: Text(tr.sessionsRetry),
                      ),
                    ],
                  ),
                ),
              );
            }

            final lobby = state.lobby;
            if (lobby == null) {
              return Center(child: Text(tr.sessionsEmpty));
            }
            final isBooked = lobby.isBooked ?? false;
            final canJoin = _canJoinSession(lobby);
            final isBooking =
                state.bookingStatus == LiveSessionLobbyBookingStatus.loading;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      16.w,
                      8.h,
                      16.w,
                      16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MediatorCard(
                          lobby: lobby,
                          dateLabel: _dateLabel(context, lobby.startsAt),
                          timeLabel: _timeLabel(context, lobby.startsAt),
                          durationLabel: lobby.durationMinutes != null
                              ? tr.sessionLobbyDurationValue(
                                  lobby.durationMinutes!,
                                )
                              : _dash,
                          scheduleTitle: tr.sessionLobbyScheduleTitle,
                          recordingTitle: tr.sessionLobbyRecordingConsentTitle,
                          recordingBody:
                              lobby.recordingConsentDescription
                                  .trim()
                                  .isNotEmpty
                              ? lobby.recordingConsentDescription
                              : tr.sessionLobbyRecordingPlaceholder,
                          consentLine:
                              lobby.recordingConsentAcknowledgement
                                  .trim()
                                  .isNotEmpty
                              ? lobby.recordingConsentAcknowledgement
                              : tr.sessionLobbyConsentDefaultLine,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.w, 0, 16.w, 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: isBooking
                              ? null
                              : (!isBooked
                                    ? () => context.read<LiveSessionLobbyCubit>().book()
                                    : (canJoin
                                          ? () => _openSessionLink(lobby.sessionLink)
                                          : null)),
                          style: FilledButton.styleFrom(
                            backgroundColor: !isBooked
                                ? AppColors.primary
                                : (canJoin ? AppColors.primary : AppColors.border),
                            foregroundColor: AppColors.darkText,
                            disabledBackgroundColor: AppColors.border,
                            disabledForegroundColor: AppColors.greyText,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                          ),
                          child: isBooking
                              ? SizedBox(
                                  width: 18.w,
                                  height: 18.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.darkText,
                                  ),
                                )
                              : Text(
                                  isBooked
                                      ? tr.sessionLobbyJoinSession
                                      : tr.sessionsBookNow,
                                  style:
                                      AppTextStyles.button(
                                        color: AppColors.darkText,
                                      ).copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                        ),
                      ),
                      if (isBooked && !canJoin) ...[
                        SizedBox(height: 8.h),
                        Text(
                          _joinAvailableLabel(context, lobby),
                          textAlign: TextAlign.center,
                          style:
                              AppTextStyles.caption(
                                color: AppColors.greyText,
                              ).copyWith(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                        ),
                      ],
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
}

class _MediatorCard extends StatelessWidget {
  const _MediatorCard({
    required this.lobby,
    required this.dateLabel,
    required this.timeLabel,
    required this.durationLabel,
    required this.scheduleTitle,
    required this.recordingTitle,
    required this.recordingBody,
    required this.consentLine,
  });

  final LiveSessionLobby lobby;
  final String dateLabel;
  final String timeLabel;
  final String durationLabel;
  final String scheduleTitle;
  final String recordingTitle;
  final String recordingBody;
  final String consentLine;

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final imageUrl = lobby.mediatorImageUrl?.trim();

    return Column(
      children: [
        _ShadowCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: SizedBox(
                      width: 72.w,
                      height: 72.w,
                      child: imageUrl != null && imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => ColoredBox(
                                color: AppColors.inputBg,
                                child: Center(
                                  child: SizedBox(
                                    width: 22.w,
                                    height: 22.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                              errorWidget: (_, __, ___) => ColoredBox(
                                color: AppColors.inputBg,
                                child: Icon(
                                  Iconsax.user,
                                  size: 32.sp,
                                  color: AppColors.greyText,
                                ),
                              ),
                            )
                          : ColoredBox(
                              color: AppColors.inputBg,
                              child: Icon(
                                Iconsax.user,
                                size: 32.sp,
                                color: AppColors.greyText,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lobby.mediatorName,
                          style:
                              AppTextStyles.heading2(
                                color: AppColors.darkText,
                              ).copyWith(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        if (lobby.mediatorTitle.trim().isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Text(
                            lobby.mediatorTitle,
                            style: AppTextStyles.caption(
                              color: AppColors.greyText,
                            ).copyWith(fontSize: 12.sp),
                          ),
                        ],
                        SizedBox(height: 8.h),
                        if (lobby.mediatorRating.isNotEmpty)
                          Row(
                            children: [
                              Icon(
                                Iconsax.star1,
                                size: 18.sp,
                                color: AppColors.yellow,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                lobby.mediatorRating,
                                style:
                                    AppTextStyles.smallMedium(
                                      color: AppColors.darkText,
                                    ).copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (lobby.mediatorBio.trim().isNotEmpty) ...[
                SizedBox(height: 12.h),
                Text(
                  lobby.mediatorBio,
                  style: AppTextStyles.body(
                    color: AppColors.greyText,
                  ).copyWith(fontSize: 13.sp, height: 1.45),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 14.h),
        _ShadowCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Iconsax.calendar_1,
                    size: 20.sp,
                    color: AppColors.yellow,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    scheduleTitle,
                    style: AppTextStyles.smallMedium(
                      color: AppColors.darkText,
                    ).copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Expanded(
                    child: _ScheduleColumn(
                      label: tr.sessionLobbyStartDateLabel,
                      value: dateLabel,
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                    child: VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: AppColors.border,
                    ),
                  ),
                  Expanded(
                    child: _ScheduleColumn(
                      label: tr.sessionLobbyStartTimeLabel,
                      value: timeLabel,
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                    child: VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: AppColors.border,
                    ),
                  ),
                  Expanded(
                    child: _ScheduleColumn(
                      label: tr.sessionLobbyDurationLabel,
                      value: durationLabel,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        _ShadowCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Iconsax.video, size: 20.sp, color: AppColors.yellow),
                  SizedBox(width: 8.w),
                  Text(
                    recordingTitle,
                    style: AppTextStyles.smallMedium(
                      color: AppColors.darkText,
                    ).copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                recordingBody,
                style: AppTextStyles.body(
                  color: AppColors.greyText,
                ).copyWith(fontSize: 13.sp, height: 1.45),
              ),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsetsDirectional.fromSTEB(12.w, 12.h, 12.w, 12.h),
                decoration: BoxDecoration(
                  color: AppColors.sessionSlotsSurface,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Iconsax.tick_circle,
                      size: 22.sp,
                      color: AppColors.yellow,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        consentLine,
                        style:
                            AppTextStyles.smallMedium(
                              color: AppColors.darkText,
                            ).copyWith(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShadowCard extends StatelessWidget {
  const _ShadowCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ScheduleColumn extends StatelessWidget {
  const _ScheduleColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTextStyles.caption(
            color: AppColors.greyText,
          ).copyWith(fontSize: 11.sp),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 6.h),
        Text(
          value,
          style: AppTextStyles.smallMedium(
            color: AppColors.darkText,
          ).copyWith(fontSize: 13.sp, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
