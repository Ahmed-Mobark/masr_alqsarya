import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/features/news/domain/entities/news_feed.dart';
import 'package:masr_al_qsariya/features/news/domain/usecases/delete_reaction_usecase.dart';
import 'package:masr_al_qsariya/features/news/domain/usecases/get_news_feeds_usecase.dart';
import 'package:masr_al_qsariya/features/news/domain/usecases/react_to_feed_usecase.dart';
import 'package:masr_al_qsariya/features/news/presentation/cubit/news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit(this._getNewsFeeds, this._reactToFeed, this._deleteReaction)
      : super(const NewsState());

  final GetNewsFeedsUseCase _getNewsFeeds;
  final ReactToFeedUseCase _reactToFeed;
  final DeleteReactionUseCase _deleteReaction;

  NewsFeedItem _copyItem(
    NewsFeedItem item, {
    int? likesCount,
    int? helpfulCount,
    NewsReaction? myReaction,
  }) {
    return NewsFeedItem(
      id: item.id,
      title: item.title,
      content: item.content,
      publishDate: item.publishDate,
      type: item.type,
      likesCount: likesCount ?? item.likesCount,
      helpfulCount: helpfulCount ?? item.helpfulCount,
      myReaction: myReaction,
      category: item.category,
      persona: item.persona,
      postedByUser: item.postedByUser,
      attachments: item.attachments,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );
  }

  Future<void> react({
    required int feedId,
    required NewsReaction reaction,
  }) async {
    if (state.reacting.containsKey(feedId)) return;

    final idx = state.items.indexWhere((e) => e.id == feedId);
    if (idx == -1) return;
    final current = state.items[idx];
    final previousReaction = current.myReaction;

    // Optimistic update (toggle or switch)
    int likes = current.likesCount;
    int helpful = current.helpfulCount;
    NewsReaction? nextReaction;

    if (previousReaction == reaction) {
      // toggle off
      nextReaction = null;
      if (reaction == NewsReaction.like) likes = (likes - 1).clamp(0, 1 << 30);
      if (reaction == NewsReaction.helpful) {
        helpful = (helpful - 1).clamp(0, 1 << 30);
      }
    } else {
      // switch / set
      nextReaction = reaction;
      if (previousReaction == NewsReaction.like) {
        likes = (likes - 1).clamp(0, 1 << 30);
      } else if (previousReaction == NewsReaction.helpful) {
        helpful = (helpful - 1).clamp(0, 1 << 30);
      }
      if (reaction == NewsReaction.like) likes = likes + 1;
      if (reaction == NewsReaction.helpful) helpful = helpful + 1;
    }

    final updatedItem = _copyItem(
      current,
      likesCount: likes,
      helpfulCount: helpful,
      myReaction: nextReaction,
    );

    final nextItems = [...state.items];
    nextItems[idx] = updatedItem;
    final nextReacting = {...state.reacting, feedId: reaction};
    emit(state.copyWith(items: nextItems, reacting: nextReacting));

    final isTogglingOff = previousReaction == reaction;
    final apiReaction =
        reaction == NewsReaction.like ? 'like' : 'helpful';
    final result = isTogglingOff
        ? await _deleteReaction(feedId)
        : await _reactToFeed(
            ReactToFeedParams(feedId: feedId, reaction: apiReaction),
          );

    result.fold(
      (_) {
        // rollback on failure
        final rollbackItems = [...state.items];
        final rollbackIdx = rollbackItems.indexWhere((e) => e.id == feedId);
        if (rollbackIdx != -1) {
          rollbackItems[rollbackIdx] = _copyItem(
            rollbackItems[rollbackIdx],
            likesCount: current.likesCount,
            helpfulCount: current.helpfulCount,
            myReaction: previousReaction,
          );
        }
        final reacting = {...state.reacting}..remove(feedId);
        emit(state.copyWith(items: rollbackItems, reacting: reacting));
      },
      (_) {
        final reacting = {...state.reacting}..remove(feedId);
        emit(state.copyWith(reacting: reacting));
      },
    );
  }

  GetNewsFeedsParams _buildParams({int page = 1}) {
    return GetNewsFeedsParams(
      page: page,
      perPage: state.perPage,
      search: state.search,
      type: state.selectedType,
      sortDirection: state.sortDirection,
    );
  }

  Future<void> loadInitial() async {
    emit(state.copyWith(status: NewsStatus.loading, clearError: true));
    final result = await _getNewsFeeds(_buildParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: NewsStatus.failure, error: failure.message),
      ),
      (feed) => emit(
        state.copyWith(
          status: NewsStatus.success,
          items: feed.items,
          currentPage: feed.currentPage,
          lastPage: feed.lastPage,
          perPage: feed.perPage,
        ),
      ),
    );
  }

  Future<void> refresh() async {
    final result = await _getNewsFeeds(_buildParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: NewsStatus.failure, error: failure.message),
      ),
      (feed) => emit(
        state.copyWith(
          status: NewsStatus.success,
          items: feed.items,
          currentPage: feed.currentPage,
          lastPage: feed.lastPage,
          perPage: feed.perPage,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore) return;
    if (state.status == NewsStatus.loadingMore) return;

    emit(state.copyWith(status: NewsStatus.loadingMore, clearError: true));
    final nextPage = state.currentPage + 1;

    final result = await _getNewsFeeds(_buildParams(page: nextPage));
    result.fold(
      (failure) => emit(
        state.copyWith(status: NewsStatus.failure, error: failure.message),
      ),
      (feed) => emit(
        state.copyWith(
          status: NewsStatus.success,
          items: [...state.items, ...feed.items],
          currentPage: feed.currentPage,
          lastPage: feed.lastPage,
          perPage: feed.perPage,
        ),
      ),
    );
  }

  Future<void> applyFilters({
    String? search,
    String? type,
    String? sortDirection,
  }) async {
    emit(state.copyWith(
      search: search,
      selectedType: type,
      sortDirection: sortDirection,
      clearSearch: search == null,
      clearType: type == null,
      clearSort: sortDirection == null,
    ));
    await loadInitial();
  }

  Future<void> resetFilters() async {
    emit(state.copyWith(
      clearSearch: true,
      clearType: true,
      clearSort: true,
    ));
    await loadInitial();
  }
}

