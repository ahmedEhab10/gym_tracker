import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/data/datasources/local/hive_service.dart';
import 'package:try_my_tracker/domain/repositories/workout_repository.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/workout_history/workout_history_state.dart';

class WorkoutHistoryCubit extends Cubit<WorkoutHistoryState> {
  final WorkoutRepository workoutRepository;
  final HiveService hiveService;

  WorkoutHistoryCubit({
    required this.workoutRepository,
    required this.hiveService,
  }) : super(WorkoutHistoryInitial());

  Future<void> loadHistory() async {
    emit(WorkoutHistoryLoading());
    try {
      final result = await workoutRepository.getWorkoutHistory();
      result.fold(
        (failure) => emit(WorkoutHistoryError(failure.toString())),
        (sessions) {
          // Build a quick lookup: trainingDayId -> name
          final dayNameMap = <String, String>{};
          for (final dayModel in hiveService.trainingDayBox.values) {
            dayNameMap[dayModel.id] = dayModel.name;
          }

          // Build map of distinct date -> day name
          final Map<DateTime, String> workoutDays = {};

          for (final session in sessions) {
            final date = DateTime(
              session.startTime.year,
              session.startTime.month,
              session.startTime.day,
            );
            if (!workoutDays.containsKey(date)) {
              final name = dayNameMap[session.trainingDayId] ?? '';
              workoutDays[date] = name;
            }
          }

          // Calculate week streak
          int streak = 0;
          final now = DateTime.now();
          for (int i = 0; i < 52; i++) {
            final weekStart = now.subtract(Duration(days: now.weekday - 1 + i * 7));
            final weekEnd = weekStart.add(const Duration(days: 7));
            final hasWorkout = workoutDays.keys.any(
              (d) => !d.isBefore(weekStart) && d.isBefore(weekEnd),
            );
            if (hasWorkout) {
              streak++;
            } else {
              break;
            }
          }

          // Calculate rest days (days in the last 30 days with no workout)
          int restDays = 0;
          for (int i = 0; i < 30; i++) {
            final day = DateTime(now.year, now.month, now.day)
                .subtract(Duration(days: i));
            if (!workoutDays.containsKey(day)) restDays++;
          }

          emit(WorkoutHistoryLoaded(
            workoutDays: workoutDays,
            totalWorkouts: sessions.length,
            restDays: restDays,
            weekStreak: streak,
          ));
        },
      );
    } catch (e) {
      emit(WorkoutHistoryError(e.toString()));
    }
  }
}
