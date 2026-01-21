import 'package:equatable/equatable.dart';
import 'package:try_my_tracker/domain/entities/exercise.dart';
import 'package:try_my_tracker/domain/entities/exercise_history.dart';
import 'package:try_my_tracker/domain/entities/exercise_set.dart';

abstract class ExerciseDetailState extends Equatable {
  const ExerciseDetailState();

  @override
  List<Object?> get props => [];
}

class ExerciseDetailInitial extends ExerciseDetailState {}

class ExerciseDetailLoading extends ExerciseDetailState {}

class ExerciseDetailLoaded extends ExerciseDetailState {
  final Exercise exercise;
  final ExerciseHistory history;
  final List<ExerciseSet> currentSets;

  const ExerciseDetailLoaded({
    required this.exercise,
    required this.history,
    required this.currentSets,
  });

  ExerciseDetailLoaded copyWith({
    Exercise? exercise,
    ExerciseHistory? history,
    List<ExerciseSet>? currentSets,
  }) {
    return ExerciseDetailLoaded(
      exercise: exercise ?? this.exercise,
      history: history ?? this.history,
      currentSets: currentSets ?? this.currentSets,
    );
  }

  @override
  List<Object?> get props => [exercise, history, currentSets];
}

class ExerciseDetailError extends ExerciseDetailState {
  final String message;

  const ExerciseDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
