import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:try_my_tracker/core/usecases/usecase.dart';
import 'package:try_my_tracker/domain/entities/home_dashboard_data.dart';
import 'package:try_my_tracker/features/main/Tracker/domain/usecases/get_home_dashboard_data.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDashboardData getHomeDashboardData;

  HomeBloc({required this.getHomeDashboardData}) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    final result = await getHomeDashboardData(NoParams());
    result.fold(
      (failure) => emit(const HomeError("Failed to load home data")),
      (data) => emit(HomeLoaded(data)),
    );
  }
}
