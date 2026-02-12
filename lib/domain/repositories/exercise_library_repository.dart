import 'package:dartz/dartz.dart';
import 'package:try_my_tracker/core/errors/failures.dart';
import 'package:try_my_tracker/domain/entities/exercise_library.dart';

abstract class ExerciseLibraryRepository {
  Future<Either<Failure, List<ExerciseLibrary>>> getAllExercises();
  Future<Either<Failure, void>> seedExercises();
}
