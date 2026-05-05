import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/widgets/app_empty_screen.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/session_library_entry.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/session_library_cubit.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/session_library_state.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/view/session_library_watch_view.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/widgets/sessions_library_filter_sheet.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/widgets/sessions_library_recording_card.dart';

class SessionsLibraryView extends StatelessWidget {
  const SessionsLibraryView({super.key});

  static void _openWatchInApp(String? raw, String title) {
    final link = raw?.trim();
    if (link == null || link.isEmpty) return;
    sl<AppNavigator>().push(
      screen: SessionLibraryWatchView(
        initialUrl: link,
        title: title,
      ),
    );
  }

  static String _typeTag(BuildContext context, SessionLibraryEntry e) {
    final t = e.libraryType.toLowerCase().trim();
    if (t.contains('playlist')) return context.tr.sessionsLibraryTagPlaylist;
    if (t.contains('vlog')) return context.tr.sessionsLibraryTagVlog;
    if (t.contains('single') || t == 'video') {
      return context.tr.sessionsLibraryTypeSingleVideo;
    }
    if (t.isEmpty) return context.tr.sessionsLibraryTagPublic;
    return e.libraryType;
  }

  static String? _archivedLine(BuildContext context, SessionLibraryEntry e) {
    final raw = e.archivedLine?.trim();
    if (raw == null || raw.isEmpty) return null;
    return '${context.tr.sessionsLibraryLabelArchived}: $raw';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SessionLibraryCubit>()..load(),
      child: const _SessionsLibraryBody(),
    );
  }
}

class _SessionsLibraryBody extends StatelessWidget {
  const _SessionsLibraryBody();

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
            color: AppColors.darkText,
          ),
          onPressed: () => sl<AppNavigator>().pop(),
        ),
        title: Text(
          tr.sessionsLibraryTitle,
          style: AppTextStyles.heading2(
            color: AppColors.darkText,
          ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<SessionLibraryCubit, SessionLibraryState>(
            buildWhen: (p, c) => p.filters != c.filters,
            builder: (context, state) {
              final showDot = state.filters.hasActiveCustomizations;
              return IconButton(
                tooltip: tr.sessionsLibraryFilterA11y,
                icon: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Iconsax.filter,
                      size: 22.sp,
                      color: AppColors.darkText,
                    ),
                    if (showDot)
                      PositionedDirectional(
                        top: 4.h,
                        end: 2.w,
                        child: Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.scaffoldBg,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () => showSessionsLibraryFilterSheet(context),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.w, 4.h, 16.w, 12.h),
              child: TextField(
                onChanged: (v) =>
                    context.read<SessionLibraryCubit>().onSearchChanged(v),
                decoration: InputDecoration(
                  hintText: tr.sessionsLibrarySearchHint,
                  hintStyle: AppTextStyles.caption(
                    color: AppColors.captionText,
                  ).copyWith(fontSize: 14.sp),
                  prefixIcon: Icon(
                    Iconsax.search_normal_1,
                    size: 20.sp,
                    color: AppColors.greyText,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: EdgeInsetsDirectional.symmetric(
                    vertical: 12.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            BlocBuilder<SessionLibraryCubit, SessionLibraryState>(
              buildWhen: (p, c) => p.categoryIndex != c.categoryIndex,
              builder: (context, state) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsetsDirectional.fromSTEB(16.w, 0, 16.w, 12.h),
                  child: Row(
                    children: [
                      _CategoryChip(
                        label: tr.sessionsLibraryTabAll,
                        selected: state.categoryIndex == 0,
                        onTap: () => context
                            .read<SessionLibraryCubit>()
                            .setCategoryIndex(0),
                      ),
                      SizedBox(width: 8.w),
                      _CategoryChip(
                        label: tr.sessionsLibraryTabPublicSessions,
                        selected: state.categoryIndex == 1,
                        onTap: () => context
                            .read<SessionLibraryCubit>()
                            .setCategoryIndex(1),
                      ),
                      SizedBox(width: 8.w),
                      _CategoryChip(
                        label: tr.sessionsLibraryTabPrivateRecordings,
                        selected: state.categoryIndex == 2,
                        onTap: () => context
                            .read<SessionLibraryCubit>()
                            .setCategoryIndex(2),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<SessionLibraryCubit, SessionLibraryState>(
                builder: (context, state) {
                  if (state.status == SessionLibraryStatus.loading &&
                      state.items.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == SessionLibraryStatus.failure) {
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
                                  context.read<SessionLibraryCubit>().load(),
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

                  if (state.items.isEmpty) {
                    return AppEmptyScreen(title: tr.sessionsLibraryEmpty);
                  }

                  return RefreshIndicator(
                    color: AppColors.yellow,
                    onRefresh: () =>
                        context.read<SessionLibraryCubit>().load(),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsetsDirectional.fromSTEB(
                        16.w,
                        4.h,
                        16.w,
                        24.h,
                      ),
                      itemCount: state.items.length,
                      separatorBuilder: (_, __) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final e = state.items[index];
                        return SessionsLibraryRecordingCard(
                          tagLabel: SessionsLibraryView._typeTag(context, e),
                          title: e.title,
                          durationLabel: e.durationLabel,
                          watchLabel: tr.sessionsLibraryWatchRecording,
                          expertLine: e.expertName,
                          participantsLine: e.participantsLine,
                          archivedLine: SessionsLibraryView._archivedLine(
                            context,
                            e,
                          ),
                          thumbnailLocked: e.isLocked,
                          thumbnailImageUrl: e.thumbnailUrl,
                          onWatch: () => SessionsLibraryView._openWatchInApp(
                            e.watchUrl,
                            e.title,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.sessionSlotInactiveBg,
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            label,
            style: AppTextStyles.smallMedium(
              color: AppColors.darkText,
            ).copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
