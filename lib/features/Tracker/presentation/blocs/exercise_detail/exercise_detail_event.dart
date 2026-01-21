import 'package:equatable/equatable.dart';
import 'package:try_my_tracker/domain/entities/exercise.dart';
import 'package:try_my_tracker/domain/entities/exercise_set.dart';

abstract class ExerciseDetailEvent extends Equatable {
  const ExerciseDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadExerciseDetail extends ExerciseDetailEvent {
  final Exercise exercise;

  const LoadExerciseDetail(this.exercise);

  @override
  List<Object> get props => [exercise];
}

class AddSet extends ExerciseDetailEvent {
  final ExerciseSet set;

  const AddSet(this.set);

  @override
  List<Object> get props => [set];
}

class UpdateSet extends ExerciseDetailEvent {
  final ExerciseSet set;

  const UpdateSet(this.set);

  @override
  List<Object> get props => [set];
}

class DeleteSet extends ExerciseDetailEvent {
  final String setId;

  const DeleteSet(this.setId);

  @override
  List<Object> get props => [setId];
}

class FinishExercise extends ExerciseDetailEvent {
  const FinishExercise();
}
