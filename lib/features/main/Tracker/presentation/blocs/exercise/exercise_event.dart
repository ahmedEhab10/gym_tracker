import 'package:equatable/equatable.dart';
import 'package:try_my_tracker/domain/entities/exercise.dart';

abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object> get props => [];
}

class LoadExercises extends ExerciseEvent {
  final String trainingDayId;

  const LoadExercises(this.trainingDayId);

  @override
  List<Object> get props => [trainingDayId];
}

class AddExerciseEvent extends ExerciseEvent {
  final Exercise exercise;

  const AddExerciseEvent(this.exercise);

  @override
  List<Object> get props => [exercise];
}

class UpdateExerciseEvent extends ExerciseEvent {
  final Exercise exercise;

  const UpdateExerciseEvent(this.exercise);

  @override
  List<Object> get props => [exercise];
}

class DeleteExerciseEvent extends ExerciseEvent {
  final String exerciseId;
  final String trainingDayId;

  const DeleteExerciseEvent(this.exerciseId, this.trainingDayId);

  @override
  List<Object> get props => [exerciseId, trainingDayId];
}
