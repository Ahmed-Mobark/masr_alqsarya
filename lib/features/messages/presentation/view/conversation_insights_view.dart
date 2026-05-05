import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/widgets/app_empty_screen.dart';
import 'package:masr_al_qsariya/core/widgets/shimmer_widget.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_audit_log_entry.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_tone_insights.dart';
import 'package:masr_al_qsariya/features/messages/presentation/cubit/conversation_insights_cubit.dart';
import 'package:masr_al_qsariya/features/messages/presentation/cubit/conversation_insights_state.dart';

class ConversationInsightsView extends StatelessWidget {
  const ConversationInsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            context.tr.chatInsightsTitle,
            style: AppTextStyles.heading2(),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primaryDark,
            unselectedLabelColor: AppColors.greyText,
            labelStyle: AppTextStyles.bodyMedium().copyWith(
              fontWeight: FontWeight.w700,
            ),
            tabs: [
              Tab(text: context.tr.chatInsightsToneTab),
              Tab(text: context.tr.chatInsightsAuditTab),
            ],
          ),
        ),
        body: TabBarView(
          children: const [
            _ToneAnalysisTab(),
            _AuditLogTab(),
          ],
        ),
      ),
    );
  }
}

String _formatInsightTimestamp(BuildContext context, DateTime? d) {
  if (d == null) return '';
  final loc = Localizations.localeOf(context);
  return DateFormat.yMMMd(loc.toString()).add_jm().format(d.toLocal());
}

/// Maps common API [tone] `label` values to localized copy.
String _displayApiToneHealthLabel(BuildContext context, String apiLabel) {
  final s = apiLabel.trim().toLowerCase();
  if (s.isEmpty) return context.tr.chatInsightsHealthy;
  if (s == 'healthy' || s == 'good' || s == 'optimal') {
    return context.tr.chatInsightsHealthy;
  }
  return apiLabel;
}

class _ToneAnalysisTab extends StatelessWidget {
  const _ToneAnalysisTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationInsightsCubit, ConversationInsightsState>(
      builder: (context, state) {
        if (state.toneStatus == ConversationInsightsSliceStatus.loading) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: AppShimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerContainer(height: 180.h, borderRadius: 18.r),
                  SizedBox(height: 18.h),
                  ShimmerText(width: 200.w, height: 20.h),
                  SizedBox(height: 12.h),
                  ShimmerContainer(height: 88.h, borderRadius: 16.r),
                ],
              ),
            ),
          );
        }

        if (state.toneStatus == ConversationInsightsSliceStatus.failure) {
          return _InsightsErrorBody(
            message: state.toneError ?? '',
            onRetry: () => context.read<ConversationInsightsCubit>().retry(),
          );
        }

        final tone = state.tone;
        if (tone == null) {
          return _InsightsErrorBody(
            message: state.toneError ?? '',
            onRetry: () => context.read<ConversationInsightsCubit>().retry(),
          );
        }

        final score = tone.overallScore <= 0 ? 0.0 : tone.overallScore.clamp(0.0, 1.0);
        final bar = tone.barProgress <= 0 ? score : tone.barProgress.clamp(0.0, 1.0);

        final toneLabel =
            tone.toneLabel.isNotEmpty ? tone.toneLabel : context.tr.chatInsightsCalmNeutral;
        final healthLabel = _displayApiToneHealthLabel(context, tone.healthLabel);
        final qualityLabel =
            tone.qualityLabel.isNotEmpty ? tone.qualityLabel : context.tr.chatInsightsOptimal;
        final summary =
            tone.summary.isNotEmpty ? tone.summary : context.tr.chatInsightsToneDescription;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.chatInsightsOverallTone,
                      style: AppTextStyles.heading2(),
                    ),
                    SizedBox(height: 16.h),
                    Center(child: _ScoreCircle(score: score, qualityLabel: qualityLabel)),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            toneLabel,
                            style: AppTextStyles.bodyMedium().copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          healthLabel,
                          style: AppTextStyles.caption(color: AppColors.primaryDark),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999.r),
                      child: LinearProgressIndicator(
                        value: bar,
                        minHeight: 8.h,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      summary,
                      style: AppTextStyles.caption(color: AppColors.greyText),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                context.tr.chatInsightsRecentActivityTitle,
                style: AppTextStyles.heading2(),
              ),
              SizedBox(height: 12.h),
              if (tone.activities.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    context.tr.chatInsightsEmptyActivities,
                    style: AppTextStyles.body(color: AppColors.greyText),
                  ),
                )
              else
                ...tone.activities.map(
                  (a) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: _InsightActivityCard(
                      activity: a,
                      trailing: _formatInsightTimestamp(context, a.occurredAt),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _AuditLogTab extends StatelessWidget {
  const _AuditLogTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationInsightsCubit, ConversationInsightsState>(
      builder: (context, state) {
        if (state.logsStatus == ConversationInsightsSliceStatus.loading) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: AppShimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerText(width: 180.w, height: 22.h),
                  SizedBox(height: 12.h),
                  ShimmerContainer(height: 220.h, borderRadius: 18.r),
                  SizedBox(height: 12.h),
                  ShimmerContainer(height: 220.h, borderRadius: 18.r),
                ],
              ),
            ),
          );
        }

        if (state.logsStatus == ConversationInsightsSliceStatus.failure) {
          return _InsightsErrorBody(
            message: state.logsError ?? '',
            onRetry: () => context.read<ConversationInsightsCubit>().retry(),
          );
        }

        if (state.logs.isEmpty) {
          return AppEmptyScreen(
            title: context.tr.chatInsightsAuditSectionTitle,
            description: context.tr.chatInsightsEmptyAuditLog,
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr.chatInsightsAuditSectionTitle,
                style: AppTextStyles.heading2(),
              ),
              SizedBox(height: 12.h),
              ...state.logs.map(
                (e) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _AuditIncidentCard(entry: e),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InsightsErrorBody extends StatelessWidget {
  const _InsightsErrorBody({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message.isNotEmpty ? message : context.tr.auditLogLoadFailed,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(color: AppColors.greyText),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: onRetry,
              child: Text(context.tr.messagesRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuditIncidentCard extends StatelessWidget {
  const _AuditIncidentCard({required this.entry});

  final ChatAuditLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final header = entry.incidentLabel.isNotEmpty
        ? entry.incidentLabel
        : (entry.id != null ? '#${entry.id}' : context.tr.chatInsightsIncidentCode);
    final time = _formatInsightTimestamp(context, entry.occurredAt);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(18.r),
                topEnd: Radius.circular(18.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    header,
                    style: AppTextStyles.bodyMedium().copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (time.isNotEmpty)
                  Text(
                    time,
                    style: AppTextStyles.caption(color: AppColors.greyText),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.chatInsightsOriginalText,
                  style: AppTextStyles.bodyMedium().copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                _AuditTextBox(
                  text: entry.originalText.isNotEmpty
                      ? entry.originalText
                      : '—',
                  color: AppColors.error.withValues(alpha: 0.08),
                  lineColor: AppColors.error,
                ),
                SizedBox(height: 12.h),
                Text(
                  context.tr.chatInsightsRevisedText,
                  style: AppTextStyles.bodyMedium().copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                _AuditTextBox(
                  text: entry.revisedText.isNotEmpty ? entry.revisedText : '—',
                  color: AppColors.success.withValues(alpha: 0.1),
                  lineColor: AppColors.success,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditTextBox extends StatelessWidget {
  const _AuditTextBox({
    required this.text,
    required this.color,
    required this.lineColor,
  });

  final String text;
  final Color color;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.only(
        start: 12.w,
        end: 12.w,
        top: 12.h,
        bottom: 12.h,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3.w,
              decoration: BoxDecoration(
                color: lineColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.body(color: AppColors.greyText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreCircle extends StatelessWidget {
  const _ScoreCircle({
    required this.score,
    required this.qualityLabel,
  });

  final double score;
  final String qualityLabel;

  @override
  Widget build(BuildContext context) {
    final display = (score * 100).round();
    return SizedBox(
      width: 168.w,
      height: 168.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 168.w,
            height: 168.w,
            child: CircularProgressIndicator(
              value: score,
              strokeWidth: 16.w,
              strokeCap: StrokeCap.round,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$display%',
                style: AppTextStyles.heading1().copyWith(fontSize: 42.sp),
              ),
              Text(
                qualityLabel,
                style: AppTextStyles.caption(color: AppColors.primaryDark),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightActivityCard extends StatelessWidget {
  const _InsightActivityCard({
    required this.activity,
    required this.trailing,
  });

  final ChatToneActivity activity;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final style = _activityStyle(activity.kind);
    final title = activity.title.isNotEmpty ? activity.title : '—';
    final subtitle = activity.snippet.isNotEmpty ? activity.snippet : '';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(color: style.iconBg, shape: BoxShape.circle),
            child: Icon(style.icon, color: style.iconColor, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.bodyMedium().copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (trailing.isNotEmpty) ...[
                      SizedBox(width: 8.w),
                      Text(
                        trailing,
                        style: AppTextStyles.extraSmall(color: AppColors.greyText),
                      ),
                    ],
                  ],
                ),
                if (subtitle.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption(color: AppColors.greyText),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityVisualStyle {
  const _ActivityVisualStyle({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
}

_ActivityVisualStyle _activityStyle(ChatToneActivityKind kind) {
  switch (kind) {
    case ChatToneActivityKind.correction:
      return _ActivityVisualStyle(
        icon: Icons.check_circle_outline,
        iconColor: AppColors.blue,
        iconBg: AppColors.blue.withValues(alpha: 0.12),
      );
    case ChatToneActivityKind.alert:
      return _ActivityVisualStyle(
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        iconBg: AppColors.error.withValues(alpha: 0.12),
      );
    case ChatToneActivityKind.info:
      return _ActivityVisualStyle(
        icon: Icons.info_outline,
        iconColor: AppColors.primaryDark,
        iconBg: AppColors.purpleColorLight,
      );
    case ChatToneActivityKind.unknown:
      return _ActivityVisualStyle(
        icon: Icons.notifications_none_outlined,
        iconColor: AppColors.greyText,
        iconBg: AppColors.inputBg,
      );
  }
}
