import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/workout_session.dart';
import '../entities/exercise_set.dart';

abstract class WorkoutRepository {
  // Active Session
  Future<Either<Failure, WorkoutSession>> startSession(String trainingDayId);
  Future<Either<Failure, void>> completeSession(
    String sessionId,
    String? notes,
  );
  Future<Either<Failure, void>> cancelSession(String sessionId);

  // History
  Future<Either<Failure, List<WorkoutSession>>> getWorkoutHistory({
    DateTime? startDate,
    DateTime? endDate,
  });

  // Progress
  Future<Either<Failure, List<ExerciseSet>>> getExerciseHistory(
    String exerciseId,
  );
}
