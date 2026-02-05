import 'package:equatable/equatable.dart';

abstract class WorkoutTimerState extends Equatable {
  const WorkoutTimerState();

  @override
  List<Object> get props => [];
}

class WorkoutTimerInitial extends WorkoutTimerState {}

class WorkoutInProgress extends WorkoutTimerState {
  final int durationSeconds;

  const WorkoutInProgress(this.durationSeconds);

  @override
  List<Object> get props => [durationSeconds];
}

class WorkoutFinished extends WorkoutTimerState {
  final int totalDuration;

  const WorkoutFinished(this.totalDuration);

  @override
  List<Object> get props => [totalDuration];
}
