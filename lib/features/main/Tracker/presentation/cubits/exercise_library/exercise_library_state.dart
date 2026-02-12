import 'package:equatable/equatable.dart';
import 'package:try_my_tracker/domain/entities/exercise_library.dart';

abstract class ExerciseLibraryState extends Equatable {
  const ExerciseLibraryState();

  @override
  List<Object?> get props => [];
}

class ExerciseLibraryInitial extends ExerciseLibraryState {}

class ExerciseLibraryLoading extends ExerciseLibraryState {}

class ExerciseLibraryLoaded extends ExerciseLibraryState {
  final List<ExerciseLibrary> exercises;
  final String? selectedMuscleGroup; // null means "All"

  const ExerciseLibraryLoaded(this.exercises, {this.selectedMuscleGroup});

  @override
  List<Object?> get props => [exercises, selectedMuscleGroup];

  // Get filtered exercises based on selected muscle group
  List<ExerciseLibrary> get filteredExercises {
    if (selectedMuscleGroup == null || selectedMuscleGroup == 'All') {
      return exercises;
    }
    return exercises
        .where((ex) => ex.targetMuscle == selectedMuscleGroup)
        .toList();
  }

  // Get unique muscle groups from all exercises
  List<String> get muscleGroups {
    final groups = exercises.map((ex) => ex.targetMuscle).toSet().toList();
    groups.sort();
    return ['All', ...groups];
  }
}

class ExerciseLibraryError extends ExerciseLibraryState {
  final String message;

  const ExerciseLibraryError(this.message);

  @override
  List<Object?> get props => [message];
}
