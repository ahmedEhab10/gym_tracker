import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/exercise_set.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/repositories/workout_repository.dart';
import '../datasources/local/workout_local_datasource.dart';
import '../datasources/local/exercise_local_datasource.dart';
import '../models/workout_session_model.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutLocalDataSource workoutLocalDataSource;
  final ExerciseLocalDataSource
  exerciseLocalDataSource; // Needed for exercise history
  final Uuid uuid;

  WorkoutRepositoryImpl({
    required this.workoutLocalDataSource,
    required this.exerciseLocalDataSource,
    required this.uuid,
  });

  @override
  Future<Either<Failure, List<ExerciseSet>>> getSetsForSession(
    String sessionId,
  ) async {
    try {
      final models = await workoutLocalDataSource.getSetsForSession(sessionId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WorkoutSession>> startSession(
    String trainingDayId,
  ) async {
    try {
      final newSession = WorkoutSession(
        id: uuid.v4(),
        trainingDayId: trainingDayId,
        startTime: DateTime.now(),
        isCompleted: false,
      );

      final model = WorkoutSessionModel.fromEntity(newSession);
      await workoutLocalDataSource.saveWorkoutSession(model);

      return Right(newSession);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> completeSession(
    String sessionId,
    String? notes,
  ) async {
    try {
      final model = await workoutLocalDataSource.getWorkoutSession(sessionId);
      if (model == null) return const Left(CacheFailure());

      final updatedModel = WorkoutSessionModel(
        id: model.id,
        trainingDayId: model.trainingDayId,
        startTime: model.startTime,
        endTime: DateTime.now(),
        isCompleted: true,
        notes: notes ?? model.notes,
      );

      await workoutLocalDataSource.updateWorkoutSession(updatedModel);
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> cancelSession(String sessionId) async {
    try {
      return Right(
        await workoutLocalDataSource.deleteWorkoutSession(sessionId),
      );
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<WorkoutSession>>> getWorkoutHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final models = await workoutLocalDataSource.getWorkoutHistory(
        startDate: startDate,
        endDate: endDate,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ExerciseSet>>> getExerciseHistory(
    String exerciseId,
  ) async {
    try {
      // In a real app we'd query all sets for this exercise ID across all time
      // The current datasource method getSetsForExercise gets CURRENT sets (configuration)
      // We need a history table or store history differently.
      // For this MVP, we might just look at all sets?
      // Or we reuse the 'exercise_sets' box which stores configuration?
      // Actually, standard Gym apps usually separate "Template" from "History Logs".
      // Our simple architecture uses 'ExerciseSet' for both?
      // The schema has `workoutSessionId`. If that is null, it's a template? If set, it's history?
      // Yes, `workoutSessionId` nullable in Entity suggests this.

      // So we need a query in datasource: getSetsForExercise where workoutSessionId != null
      // I will implement this logic later.
      return const Right([]);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }
}
