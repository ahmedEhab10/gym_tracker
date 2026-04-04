import 'package:equatable/equatable.dart';

abstract class WorkoutTimerState extends Equatable {
  const WorkoutTimerState();

  @override
  List<Object> get props => [];
}

class WorkoutTimerInitial extends WorkoutTimerState {}

class WorkoutInProgress extends WorkoutTimerState {
  final int durationSeconds;
  final String sessionId;

  const WorkoutInProgress(this.durationSeconds, this.sessionId);

  @override
  List<Object> get props => [durationSeconds, sessionId];
}

class WorkoutFinished extends WorkoutTimerState {
  final int totalDuration;
  final String sessionId;

  const WorkoutFinished(this.totalDuration, this.sessionId);

  @override
  List<Object> get props => [totalDuration, sessionId];
}
