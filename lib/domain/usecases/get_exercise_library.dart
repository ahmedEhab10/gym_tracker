import 'package:dartz/dartz.dart';
import 'package:try_my_tracker/core/errors/failures.dart';
import 'package:try_my_tracker/domain/entities/exercise_library.dart';
import 'package:try_my_tracker/domain/repositories/exercise_library_repository.dart';

class GetExerciseLibrary {
  final ExerciseLibraryRepository repository;

  GetExerciseLibrary(this.repository);

  Future<Either<Failure, List<ExerciseLibrary>>> call() async {
    // First, ensure exercises are seeded
    await repository.seedExercises();

    // Then get all exercises
    return await repository.getAllExercises();
  }
}
