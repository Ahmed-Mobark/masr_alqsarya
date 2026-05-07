import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/features/home/domain/usecases/get_recent_activities_usecase.dart';
import 'package:masr_al_qsariya/features/home/presentation/cubit/home_recent_activities_state.dart';

class HomeRecentActivitiesCubit extends Cubit<HomeRecentActivitiesState> {
  HomeRecentActivitiesCubit(this._getRecentActivities)
      : super(const HomeRecentActivitiesState());

  final GetRecentActivitiesUseCase _getRecentActivities;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: HomeRecentActivitiesStatus.loading,
        clearError: true,
      ),
    );

    final result = await _getRecentActivities();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HomeRecentActivitiesStatus.failure,
          error: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: HomeRecentActivitiesStatus.success,
          activities: data.activities,
          calls: data.calls,
        ),
      ),
    );
  }
}
