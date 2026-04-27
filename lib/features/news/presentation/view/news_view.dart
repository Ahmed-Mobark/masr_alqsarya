import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/features/news/presentation/cubit/news_cubit.dart';
import 'package:masr_al_qsariya/features/news/presentation/cubit/news_state.dart';
import 'package:masr_al_qsariya/features/news/presentation/widgets/news_feed_card.dart';
import 'package:masr_al_qsariya/features/news/presentation/widgets/news_filter_sheet.dart';
import 'package:masr_al_qsariya/features/news/domain/entities/news_feed.dart';
import 'package:masr_al_qsariya/features/notifications/presentation/view/notifications_view.dart';

class NewsView extends StatelessWidget {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NewsCubit>()..loadInitial(),
      child: const _NewsViewBodyStateful(),
    );
  }
}

class _NewsViewBodyStateful extends StatefulWidget {
  const _NewsViewBodyStateful();

  @override
  State<_NewsViewBodyStateful> createState() => _NewsViewBodyStatefulState();
}

class _NewsViewBodyStatefulState extends State<_NewsViewBodyStateful> {
  final ScrollController _controller = ScrollController();
  static const double _loadMoreThresholdPx = 220;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    final scrollingDown =
        position.userScrollDirection == ScrollDirection.reverse;
    if (!scrollingDown) return;

    final nearBottom =
        position.pixels >= (position.maxScrollExtent - _loadMoreThresholdPx);
    if (nearBottom) {
      context.read<NewsCubit>().loadMore();
    }
  }

  Future<void> _openFilterSheet() async {
    final cubit = context.read<NewsCubit>();
    final state = cubit.state;
    final result = await NewsFilterSheet.show(
      context,
      initialSearch: state.search,
      initialType: state.selectedType,
      initialSort: state.sortDirection,
    );
    if (result != null && mounted) {
      cubit.applyFilters(
        search: result.search,
        type: result.type,
        sortDirection: result.sortDirection,
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NewsCubit>();
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            _buildHeader(context),

            SizedBox(height: 8.h),

            // ── Filter row ──
            _buildFilterRow(),

            SizedBox(height: 4.h),

            // ── Feed list ──
            Expanded(
              child: BlocBuilder<NewsCubit, NewsState>(
                builder: (context, state) {
                  if (state.status == NewsStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primaryDark),
                    );
                  }

                  if (state.status == NewsStatus.failure &&
                      state.items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.error ?? context.tr.sorryMessage,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.body(
                                  color: AppColors.greyText),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: cubit.loadInitial,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.darkText,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              child: Text(context.tr.commonStart),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state.items.isEmpty) {
                    return Center(
                      child: Text(
                        context.tr.nothingFound,
                        style: AppTextStyles.body(color: AppColors.greyText),
                      ),
                    );
                  }

                  final showBottomLoader =
                      state.status == NewsStatus.loadingMore;

                  return RefreshIndicator(
                    color: AppColors.primaryDark,
                    onRefresh: cubit.refresh,
                    child: ListView.separated(
                      controller: _controller,
                      padding: const EdgeInsets.all(16),
                      itemCount:
                          state.items.length + (showBottomLoader ? 1 : 0),
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        if (index >= state.items.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          );
                        }
                        final item = state.items[index];
                        final reactingType = state.reacting[item.id];
                        return NewsFeedCard(
                          item: item,
                          isLikeLoading:
                              reactingType == NewsReaction.like,
                          isHelpfulLoading:
                              reactingType == NewsReaction.helpful,
                          onLike: () => context.read<NewsCubit>().react(
                              feedId: item.id,
                              reaction: NewsReaction.like),
                          onHelpful: () => context.read<NewsCubit>().react(
                              feedId: item.id,
                              reaction: NewsReaction.helpful),
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

  Widget _buildHeader(BuildContext context) {
    final user = sl<Storage>().getUser();
    final displayName =
        (user?.fullName.isNotEmpty ?? false) ? user!.fullName : context.tr.homeGuest;
    final subtitle =
        (user?.email.isNotEmpty ?? false) ? user!.email : context.tr.homeGoodMorning;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 22.r,
            backgroundColor: AppColors.border,
            child: Text(
              displayName.isNotEmpty ? displayName.characters.first : 'G',
              style: AppTextStyles.bodyMedium(color: AppColors.greyText),
            ),
          ),
          SizedBox(width: 12.w),
          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style:
                      AppTextStyles.small(color: AppColors.lightGreyText),
                ),
                SizedBox(height: 2.h),
                Text(
                  displayName,
                  style:
                      AppTextStyles.bodyMedium(color: AppColors.darkText)
                          .copyWith(fontSize: 16.sp),
                ),
              ],
            ),
          ),
          // Notification bell
          GestureDetector(
            onTap: () {
              sl<AppNavigator>().push(screen: const NotificationsView());
            },
            child: Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: AppColors.scaffoldBg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4),
                ),
              ),
              child: Icon(
                Iconsax.notification,
                size: 20.sp,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: _openFilterSheet,
        child: BlocBuilder<NewsCubit, NewsState>(
          buildWhen: (p, c) => p.hasActiveFilters != c.hasActiveFilters,
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.filter,
                      size: 20.sp,
                      color: state.hasActiveFilters
                          ? AppColors.primary
                          : AppColors.greyText,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      context.tr.newsFilter,
                      style: AppTextStyles.bodyMedium(
                        color: state.hasActiveFilters
                            ? AppColors.primary
                            : AppColors.greyText,
                      ).copyWith(fontSize: 14.sp),
                    ),
                    if (state.hasActiveFilters) ...[
                      SizedBox(width: 6.w),
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
