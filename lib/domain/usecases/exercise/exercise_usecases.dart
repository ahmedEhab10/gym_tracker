import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/exercise.dart';
import '../../repositories/exercise_repository.dart';

class GetExercisesForDay implements UseCase<List<Exercise>, String> {
  final ExerciseRepository repository;

  GetExercisesForDay(this.repository);

  @override
  Future<Either<Failure, List<Exercise>>> call(String trainingDayId) async {
    return await repository.getExercisesForDay(trainingDayId);
  }
}

class AddExercise implements UseCase<void, Exercise> {
  final ExerciseRepository repository;

  AddExercise(this.repository);

  @override
  Future<Either<Failure, void>> call(Exercise exercise) async {
    return await repository.addExercise(exercise);
  }
}

class UpdateExercise implements UseCase<void, Exercise> {
  final ExerciseRepository repository;

  UpdateExercise(this.repository);

  @override
  Future<Either<Failure, void>> call(Exercise exercise) async {
    return await repository.updateExercise(exercise);
  }
}
