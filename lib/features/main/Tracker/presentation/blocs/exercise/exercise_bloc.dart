import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/domain/usecases/exercise/exercise_usecases.dart';

import 'exercise_event.dart';
import 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final GetExercisesForDay getExercisesForDay;
  final AddExercise addExercise;

  ExerciseBloc({required this.getExercisesForDay, required this.addExercise})
    : super(ExerciseInitial()) {
    on<LoadExercises>(_onLoadExercises);
    on<AddExerciseEvent>(_onAddExercise);
  }

  Future<void> _onLoadExercises(
    LoadExercises event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    final result = await getExercisesForDay(event.trainingDayId);
    result.fold(
      (failure) => emit(ExerciseError(_mapFailureToMessage(failure))),
      (exercises) => emit(ExerciseLoaded(exercises)),
    );
  }

  Future<void> _onAddExercise(
    AddExerciseEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    // Optimistic update or reload? Let's reload for simplicity for now.
    // Or we can emit loading, add, then reload.
    // Ideally we preserve the current loaded state if possible, but let's go simple.

    // We need to know the trainingDayId to reload.
    // Since we don't store it in the state, we assume the UI will trigger reload or we can pass it in event.
    // But wait, the exercise HAS the trainingDayId.

    emit(ExerciseLoading());
    final result = await addExercise(event.exercise);
    await result.fold(
      (failure) async => emit(ExerciseError(_mapFailureToMessage(failure))),
      (_) async {
        // Reload exercises for the day
        final loadResult = await getExercisesForDay(
          event.exercise.trainingDayId,
        );
        loadResult.fold(
          (failure) => emit(ExerciseError(_mapFailureToMessage(failure))),
          (exercises) => emit(ExerciseLoaded(exercises)),
        );
      },
    );
  }

  String _mapFailureToMessage(dynamic failure) {
    // Simple mapping
    return 'An error occurred';
  }
}
