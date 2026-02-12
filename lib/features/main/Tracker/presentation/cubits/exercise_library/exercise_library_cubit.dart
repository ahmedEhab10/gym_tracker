import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/domain/usecases/get_exercise_library.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/exercise_library/exercise_library_state.dart';

class ExerciseLibraryCubit extends Cubit<ExerciseLibraryState> {
  final GetExerciseLibrary getExerciseLibrary;

  ExerciseLibraryCubit({required this.getExerciseLibrary})
    : super(ExerciseLibraryInitial()) {
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    emit(ExerciseLibraryLoading());

    final result = await getExerciseLibrary();

    result.fold(
      (failure) => emit(const ExerciseLibraryError('Failed to load exercises')),
      (exercises) => emit(ExerciseLibraryLoaded(exercises)),
    );
  }

  void setMuscleGroupFilter(String? muscleGroup) {
    final currentState = state;
    if (currentState is ExerciseLibraryLoaded) {
      emit(
        ExerciseLibraryLoaded(
          currentState.exercises,
          selectedMuscleGroup: muscleGroup,
        ),
      );
    }
  }

  void refresh() {
    _loadExercises();
  }
}
