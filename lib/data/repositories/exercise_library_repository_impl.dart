import 'package:dartz/dartz.dart';
import 'package:try_my_tracker/core/errors/exceptions.dart';
import 'package:try_my_tracker/core/errors/failures.dart';
import 'package:try_my_tracker/data/datasources/local/static_exercise_datasource.dart';
import 'package:try_my_tracker/domain/entities/exercise_library.dart';
import 'package:try_my_tracker/domain/repositories/exercise_library_repository.dart';

class ExerciseLibraryRepositoryImpl implements ExerciseLibraryRepository {
  final StaticExerciseDataSource dataSource;

  ExerciseLibraryRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, void>> seedExercises() async {
    try {
      await dataSource.seedExercisesIfNeeded();
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ExerciseLibrary>>> getAllExercises() async {
    try {
      final models = await dataSource.getAllExercises();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException {
      return const Left(CacheFailure());
    }
  }
}
