import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/exercise.dart';
import '../entities/exercise_set.dart';
import '../entities/exercise_history.dart';
import '../entities/workout_session.dart';

abstract class ExerciseRepository {
  // Sessions
  Future<Either<Failure, void>> saveWorkoutSession(WorkoutSession session);
  // History
  Future<Either<Failure, ExerciseHistory>> getExerciseHistory(
    String exerciseId,
  );

  // Exercises
  Future<Either<Failure, List<Exercise>>> getExercisesForDay(
    String trainingDayId,
  );
  Future<Either<Failure, List<Exercise>>> getExercisesByIds(List<String> ids);
  Future<Either<Failure, void>> addExercise(Exercise exercise);
  Future<Either<Failure, void>> updateExercise(Exercise exercise);
  Future<Either<Failure, void>> deleteExercise(String id);
  Future<Either<Failure, void>> reorderExercises(List<Exercise> exercises);

  // Sets
  Future<Either<Failure, List<ExerciseSet>>> getSetsForExercise(
    String exerciseId,
  );
  Future<Either<Failure, void>> saveSets(
    String exerciseId,
    List<ExerciseSet> sets,
  );
  Future<Either<Failure, void>> updateSet(ExerciseSet set);
}
