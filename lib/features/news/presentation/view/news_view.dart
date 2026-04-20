import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/rendering.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/news/presentation/cubit/news_cubit.dart';
import 'package:masr_al_qsariya/features/news/presentation/cubit/news_state.dart';
import 'package:masr_al_qsariya/features/news/presentation/widgets/news_feed_card.dart';
import 'package:masr_al_qsariya/features/news/domain/entities/news_feed.dart';

class NewsView extends StatelessWidget {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NewsCubit>()..loadInitial(),
      child: const _NewsViewBody(),
    );
  }
}

class _NewsViewBody extends StatelessWidget {
  const _NewsViewBody();

  @override
  Widget build(BuildContext context) {
    return const _NewsViewBodyStateful();
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

    // Trigger when user is near the bottom.
    final nearBottom =
        position.pixels >= (position.maxScrollExtent - _loadMoreThresholdPx);
    if (nearBottom) {
      context.read<NewsCubit>().loadMore();
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
      appBar: AppBar(
        title: Text(context.tr.newsTitle, style: AppTextStyles.navTitle()),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state.status == NewsStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryDark),
            );
          }

          if (state.status == NewsStatus.failure && state.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.error ?? context.tr.sorryMessage,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body(color: AppColors.greyText),
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

          final showBottomLoader = state.status == NewsStatus.loadingMore;

          return RefreshIndicator(
            color: AppColors.primaryDark,
            onRefresh: cubit.refresh,
            child: ListView.separated(
              controller: _controller,
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length + (showBottomLoader ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 16),
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
                  isLikeLoading: reactingType == NewsReaction.like,
                  isHelpfulLoading: reactingType == NewsReaction.helpful,
                  onLike: () => context
                      .read<NewsCubit>()
                      .react(feedId: item.id, reaction: NewsReaction.like),
                  onHelpful: () => context
                      .read<NewsCubit>()
                      .react(feedId: item.id, reaction: NewsReaction.helpful),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
