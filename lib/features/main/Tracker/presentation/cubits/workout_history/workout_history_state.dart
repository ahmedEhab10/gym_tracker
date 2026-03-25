import 'package:equatable/equatable.dart';

abstract class WorkoutHistoryState extends Equatable {
  const WorkoutHistoryState();
  @override
  List<Object?> get props => [];
}

class WorkoutHistoryInitial extends WorkoutHistoryState {}

class WorkoutHistoryLoading extends WorkoutHistoryState {}

class WorkoutHistoryLoaded extends WorkoutHistoryState {
  /// Map from date (year/month/day only) to day name label
  final Map<DateTime, String> workoutDays;
  final int totalWorkouts;
  final int restDays;
  final int weekStreak;

  const WorkoutHistoryLoaded({
    required this.workoutDays,
    required this.totalWorkouts,
    required this.restDays,
    required this.weekStreak,
  });

  @override
  List<Object?> get props => [workoutDays, totalWorkouts, restDays, weekStreak];
}

class WorkoutHistoryError extends WorkoutHistoryState {
  final String message;
  const WorkoutHistoryError(this.message);
  @override
  List<Object?> get props => [message];
}
