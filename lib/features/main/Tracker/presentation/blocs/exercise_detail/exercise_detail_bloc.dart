import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:try_my_tracker/domain/repositories/exercise_repository.dart';
import 'package:try_my_tracker/domain/usecases/exercise/get_exercise_history.dart';
import 'package:try_my_tracker/domain/entities/exercise_history.dart';
import 'package:try_my_tracker/domain/entities/exercise_set.dart';
import 'package:try_my_tracker/domain/entities/workout_session.dart';
import 'exercise_detail_event.dart';
import 'exercise_detail_state.dart';

class ExerciseDetailBloc
    extends Bloc<ExerciseDetailEvent, ExerciseDetailState> {
  final GetExerciseHistory getExerciseHistory;
  final ExerciseRepository exerciseRepository;

  ExerciseDetailBloc({
    required this.getExerciseHistory,
    required this.exerciseRepository,
  }) : super(ExerciseDetailInitial()) {
    on<LoadExerciseDetail>(_onLoadExerciseDetail);
    on<AddSet>(_onAddSet);
    on<UpdateSet>(_onUpdateSet);
    on<DeleteSet>(_onDeleteSet);
    on<FinishExercise>(_onFinishExercise);
  }

  Future<void> _onLoadExerciseDetail(
    LoadExerciseDetail event,
    Emitter<ExerciseDetailState> emit,
  ) async {
    emit(ExerciseDetailLoading());

    final failureOrHistory = await getExerciseHistory(event.exercise.id);

    await failureOrHistory.fold(
      (failure) async =>
          emit(const ExerciseDetailError('Failed to load history')),
      (history) async {
        final now = DateTime.now();
        
        // 1. Identify and clear "stale" sets (sets from previous days with no session ID)
        final allSetsResult = await exerciseRepository.getSetsForExercise(event.exercise.id);
        allSetsResult.fold(
          (failure) => null,
          (allSets) async {
            final staleSetIds = allSets
                .where((s) => s.workoutSessionId == null && s.completedAt != null && !_isSameDay(s.completedAt!, now))
                .map((s) => s.id)
                .toList();
            
            if (staleSetIds.isNotEmpty) {
              await exerciseRepository.deleteSets(staleSetIds);
            }
          },
        );

        final todaySession = history.sessions
            .cast<ExerciseSession?>()
            .firstWhere(
              (s) => s != null && _isSameDay(s.date, now),
              orElse: () => null,
            );

        List<ExerciseSet> currentSets = todaySession?.sets ?? [];

        if (currentSets.isEmpty) {
          // Check for today's "loose" sets (sets added today but no session yet)
          final looseSetsResult = await exerciseRepository.getSetsForExercise(event.exercise.id);
          final todayLooseSets = looseSetsResult.getOrElse(() => [])
              .where((s) => s.workoutSessionId == null && (s.completedAt == null || _isSameDay(s.completedAt!, now)))
              .toList();
          
          if (todayLooseSets.isNotEmpty) {
            currentSets = todayLooseSets;
          } else {
            // Pre-populate with default sets count
            currentSets = List.generate(
              event.exercise.defaultSetsCount,
              (index) => ExerciseSet(
                id: 'temp_${DateTime.now().millisecondsSinceEpoch}_$index',
                exerciseId: event.exercise.id,
                setNumber: index + 1,
                reps: 10,
                weight: event.exercise.lastUsedWeight ?? 0,
                isCompleted: false,
              ),
            );
          }
        }

        emit(
          ExerciseDetailLoaded(
            exercise: event.exercise,
            history: history,
            currentSets: currentSets,
            sessionStartTime: DateTime.now(),
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _onAddSet(
    AddSet event,
    Emitter<ExerciseDetailState> emit,
  ) async {
    if (state is ExerciseDetailLoaded) {
      final loadedState = state as ExerciseDetailLoaded;
      final newSets = List<ExerciseSet>.from(loadedState.currentSets)
        ..add(event.set);

      emit(loadedState.copyWith(currentSets: newSets));

      await exerciseRepository.saveSets(loadedState.exercise.id, newSets);
    }
  }

  Future<void> _onUpdateSet(
    UpdateSet event,
    Emitter<ExerciseDetailState> emit,
  ) async {
    if (state is ExerciseDetailLoaded) {
      final loadedState = state as ExerciseDetailLoaded;
      
      // Auto-set completedAt if not already set and isCompleted is true
      var updatedSet = event.set;
      final oldSet = loadedState.currentSets.cast<ExerciseSet?>().firstWhere((s) => s?.id == event.set.id, orElse: () => null);
      
      if (updatedSet.isCompleted && (oldSet == null || !oldSet.isCompleted)) {
        updatedSet = updatedSet.copyWith(completedAt: DateTime.now());
      } else if (!updatedSet.isCompleted) {
        updatedSet = updatedSet.copyWith(completedAt: null);
      }

      final newSets = loadedState.currentSets
          .map((s) => s.id == updatedSet.id ? updatedSet : s)
          .toList();

      emit(loadedState.copyWith(currentSets: newSets));

      await exerciseRepository.updateSet(updatedSet);
    }
  }

  Future<void> _onDeleteSet(
    DeleteSet event,
    Emitter<ExerciseDetailState> emit,
  ) async {
    if (state is ExerciseDetailLoaded) {
      final loadedState = state as ExerciseDetailLoaded;
      final newSets = loadedState.currentSets
          .where((s) => s.id != event.setId)
          .toList();

      emit(loadedState.copyWith(currentSets: newSets));
      await exerciseRepository.saveSets(loadedState.exercise.id, newSets);
    }
  }

  Future<void> _onFinishExercise(
    FinishExercise event,
    Emitter<ExerciseDetailState> emit,
  ) async {
    if (state is ExerciseDetailLoaded) {
      final loadedState = state as ExerciseDetailLoaded;
      final now = DateTime.now();

      String sessionId = const Uuid().v4();
      if (loadedState.currentSets.isNotEmpty &&
          loadedState.currentSets.first.workoutSessionId != null &&
          !loadedState.currentSets.first.workoutSessionId!.startsWith('temp')) {
        sessionId = loadedState.currentSets.first.workoutSessionId!;
      }

      final session = WorkoutSession(
        id: sessionId,
        trainingDayId: loadedState.exercise.trainingDayId,
        startTime: loadedState.sessionStartTime,
        endTime: now,
        isCompleted: true,
      );

      final finishedSets = loadedState.currentSets
          .map(
            (s) => s.copyWith(
              workoutSessionId: sessionId,
              isCompleted: true,
              completedAt: s.completedAt ?? now,
            ),
          )
          .toList();

      double maxWeightToday = 0;
      for (var s in finishedSets) {
        if (s.weight > maxWeightToday) maxWeightToday = s.weight;
      }

      final updatedExercise = loadedState.exercise.copyWith(
        lastUsedWeight: maxWeightToday,
      );

      await exerciseRepository.saveWorkoutSession(session);
      await exerciseRepository.saveSets(updatedExercise.id, finishedSets);
      await exerciseRepository.updateExercise(updatedExercise);

      add(LoadExerciseDetail(updatedExercise));
    }
  }
}
