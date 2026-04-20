import 'package:get_it/get_it.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/news/data/datasources/news_remote_data_source.dart';
import 'package:masr_al_qsariya/features/news/data/repositories/news_repository_impl.dart';
import 'package:masr_al_qsariya/features/news/domain/repositories/news_repository.dart';
import 'package:masr_al_qsariya/features/news/domain/usecases/get_news_feeds_usecase.dart';
import 'package:masr_al_qsariya/features/news/domain/usecases/delete_reaction_usecase.dart';
import 'package:masr_al_qsariya/features/news/domain/usecases/react_to_feed_usecase.dart';
import 'package:masr_al_qsariya/features/news/presentation/cubit/news_cubit.dart';

Future<void> initNewsInjection(GetIt sl) async {
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(sl<ApiBaseHelper>()),
  );

  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(sl<NewsRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetNewsFeedsUseCase>(
    () => GetNewsFeedsUseCase(sl<NewsRepository>()),
  );

  sl.registerLazySingleton<ReactToFeedUseCase>(
    () => ReactToFeedUseCase(sl<NewsRepository>()),
  );

  sl.registerLazySingleton<DeleteReactionUseCase>(
    () => DeleteReactionUseCase(sl<NewsRepository>()),
  );

  sl.registerFactory<NewsCubit>(
    () => NewsCubit(
      sl<GetNewsFeedsUseCase>(),
      sl<ReactToFeedUseCase>(),
      sl<DeleteReactionUseCase>(),
    ),
  );
}

