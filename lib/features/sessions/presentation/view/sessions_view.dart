import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/widgets/app_empty_screen.dart';
import 'package:masr_al_qsariya/features/sessions/domain/usecases/get_live_session_detail_usecase.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/live_session_lobby_cubit.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/live_sessions_cubit.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/live_sessions_state.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/view/session_lobby_view.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/widgets/live_session_list_tile.dart';

void openLiveSessionLobby(int liveSessionId) {
  if (liveSessionId <= 0) return;
  sl<AppNavigator>().push(
    screen: BlocProvider(
      create: (_) => LiveSessionLobbyCubit(
        sl<GetLiveSessionDetailUseCase>(),
        liveSessionId: liveSessionId,
      )..load(),
      child: const SessionLobbyView(),
    ),
  );
}

class SessionsView extends StatelessWidget {
  const SessionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LiveSessionsCubit>()..load(),
      child: const _SessionsViewBody(),
    );
  }
}

class _SessionsViewBody extends StatelessWidget {
  const _SessionsViewBody();

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
          tr.sessionsScreenTitle,
          style: AppTextStyles.heading2(
            color: AppColors.darkText,
          ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<LiveSessionsCubit, LiveSessionsState>(
          builder: (context, state) {
            final loading =
                state.status == LiveSessionsStatus.loading && state.items.isEmpty;

            if (loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == LiveSessionsStatus.failure) {
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
                            context.read<LiveSessionsCubit>().load(),
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
              return AppEmptyScreen(title: tr.sessionsEmpty);
            }

            return RefreshIndicator(
              color: AppColors.yellow,
              onRefresh: () => context.read<LiveSessionsCubit>().load(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 24.h),
                itemCount: state.items.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final session = state.items[index];
                  return LiveSessionListTile(
                    session: session,
                    onTap: () => openLiveSessionLobby(session.id),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
