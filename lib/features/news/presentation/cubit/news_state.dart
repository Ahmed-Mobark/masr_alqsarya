import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/news/domain/entities/news_feed.dart';

enum NewsStatus { initial, loading, success, failure, loadingMore }

class NewsState extends Equatable {
  const NewsState({
    this.status = NewsStatus.initial,
    this.items = const [],
    this.error,
    this.currentPage = 0,
    this.lastPage = 1,
    this.perPage = 5,
    this.reacting = const {},
  });

  final NewsStatus status;
  final List<NewsFeedItem> items;
  final String? error;
  final int currentPage;
  final int lastPage;
  final int perPage;
  /// Map of feedId -> currently running reaction (like/helpful).
  final Map<int, NewsReaction> reacting;

  bool get hasMore => currentPage < lastPage;

  NewsState copyWith({
    NewsStatus? status,
    List<NewsFeedItem>? items,
    String? error,
    int? currentPage,
    int? lastPage,
    int? perPage,
    Map<int, NewsReaction>? reacting,
    bool clearError = false,
  }) {
    return NewsState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: clearError ? null : error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
      reacting: reacting ?? this.reacting,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        error,
        currentPage,
        lastPage,
        perPage,
        reacting,
      ];
}

