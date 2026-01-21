import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/exercise_history.dart';
import '../../repositories/exercise_repository.dart';

class GetExerciseHistory implements UseCase<ExerciseHistory, String> {
  final ExerciseRepository repository;

  GetExerciseHistory(this.repository);

  @override
  Future<Either<Failure, ExerciseHistory>> call(String exerciseId) async {
    return await repository.getExerciseHistory(exerciseId);
  }
}
