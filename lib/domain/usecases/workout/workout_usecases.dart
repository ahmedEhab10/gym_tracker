import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/workout_session.dart';
import '../../repositories/workout_repository.dart';

class StartWorkout implements UseCase<WorkoutSession, String> {
  final WorkoutRepository repository;

  StartWorkout(this.repository);

  @override
  Future<Either<Failure, WorkoutSession>> call(String trainingDayId) async {
    return await repository.startSession(trainingDayId);
  }
}

class CompleteWorkoutParams {
  final String sessionId;
  final String? notes;

  CompleteWorkoutParams({required this.sessionId, this.notes});
}

class CompleteWorkout implements UseCase<void, CompleteWorkoutParams> {
  final WorkoutRepository repository;

  CompleteWorkout(this.repository);

  @override
  Future<Either<Failure, void>> call(CompleteWorkoutParams params) async {
    return await repository.completeSession(params.sessionId, params.notes);
  }
}
