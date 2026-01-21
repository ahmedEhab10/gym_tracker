import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_set.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../../domain/entities/exercise_history.dart';
import '../datasources/local/exercise_local_datasource.dart';
import '../models/exercise_model.dart';
import '../models/exercise_set_model.dart';
import '../models/workout_session_model.dart';
import '../../domain/entities/workout_session.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseLocalDataSource localDataSource;

  ExerciseRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> saveWorkoutSession(
    WorkoutSession session,
  ) async {
    try {
      final model = WorkoutSessionModel.fromEntity(session);
      return Right(await localDataSource.saveWorkoutSession(model));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Exercise>>> getExercisesForDay(
    String trainingDayId,
  ) async {
    try {
      final models = await localDataSource.getExercisesForDay(trainingDayId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addExercise(Exercise exercise) async {
    try {
      final model = ExerciseModel.fromEntity(exercise);
      return Right(await localDataSource.addExercise(model));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateExercise(Exercise exercise) async {
    try {
      final model = ExerciseModel.fromEntity(exercise);
      return Right(await localDataSource.updateExercise(model));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteExercise(String id) async {
    try {
      return Right(await localDataSource.deleteExercise(id));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> reorderExercises(
    List<Exercise> exercises,
  ) async {
    try {
      final models = exercises.map((e) => ExerciseModel.fromEntity(e)).toList();
      return Right(await localDataSource.reorderExercises(models));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ExerciseSet>>> getSetsForExercise(
    String exerciseId,
  ) async {
    try {
      final models = await localDataSource.getSetsForExercise(exerciseId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveSets(
    String exerciseId,
    List<ExerciseSet> sets,
  ) async {
    try {
      final models = sets.map((s) => ExerciseSetModel.fromEntity(s)).toList();
      return Right(await localDataSource.saveSets(exerciseId, models));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateSet(ExerciseSet set) async {
    try {
      final model = ExerciseSetModel.fromEntity(set);
      return Right(await localDataSource.updateSet(model));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ExerciseHistory>> getExerciseHistory(
    String exerciseId,
  ) async {
    try {
      // 1. Get all sets for this exercise
      final sets = await localDataSource.getSetsForExercise(exerciseId);

      // 2. Group by workoutSessionId
      final Map<String, List<ExerciseSetModel>> groupedSets = {};
      for (var set in sets) {
        if (set.workoutSessionId != null) {
          if (!groupedSets.containsKey(set.workoutSessionId)) {
            groupedSets[set.workoutSessionId!] = [];
          }
          groupedSets[set.workoutSessionId]!.add(set);
        }
      }

      // 3. Create ExerciseSessions
      final List<ExerciseSession> sessions = [];
      for (var sessionId in groupedSets.keys) {
        final sessionSets = groupedSets[sessionId]!;
        // Sort sets by set number
        sessionSets.sort((a, b) => a.setNumber.compareTo(b.setNumber));

        // Get session details for date
        final sessionModel = await localDataSource.getWorkoutSession(sessionId);
        if (sessionModel != null) {
          sessions.add(
            ExerciseSession(
              sessionId: sessionId,
              date: sessionModel.startTime,
              sets: sessionSets.map((m) => m.toEntity()).toList(),
              isCompleted: sessionModel.isCompleted,
            ),
          );
        }
      }

      // 4. Sort sessions by date descending (newest first)
      sessions.sort((a, b) => b.date.compareTo(a.date));

      // 5. Calculate Stats
      double maxWeightEver = 0;
      double avgWeightLast3 = 0;
      double sumWeightLast3 = 0;
      int countLast3 = 0;

      // Iterate all sessions/sets for global stats
      // Note: This iterates over the sessions in descending order
      for (var session in sessions) {
        double sessionMax = 0;
        for (var set in session.sets) {
          if (set.weight > sessionMax) sessionMax = set.weight;
          if (set.weight > maxWeightEver) maxWeightEver = set.weight;
        }

        // Avg of last 3 sessions (based on their max weight or avg? Usually max or working weight.
        // Requirement says "Average weight of last 3 sessions". Let's assume average of the MAX weight of those sessions or just avg of all sets?
        // Let's go with Average of the Session's Average Weight for simplicity or Average Max.
        // Common gym logic: "How much was I lifting?". Usually max or working sets.
        // Let's calculate the average of the *completed sets* weight for the last 3 sessions.

        if (countLast3 < 3 && session.sets.isNotEmpty) {
          // Let's take the max weight of the session as representative
          if (sessionMax > 0) {
            sumWeightLast3 += sessionMax;
            countLast3++;
          }
        }
      }

      if (countLast3 > 0) {
        avgWeightLast3 = sumWeightLast3 / countLast3;
      }

      final history = ExerciseHistory(
        sessions: sessions,
        stats: ExerciseStats(
          maxWeightEver: maxWeightEver,
          bestVolume: 0, // Placeholder
          avgWeightLast3Sessions: avgWeightLast3,
        ),
      );

      return Right(history);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }
}
