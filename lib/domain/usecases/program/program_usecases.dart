import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/program.dart';
import '../../entities/training_day.dart';
import '../../repositories/program_repository.dart';

class GetPrograms implements UseCase<List<Program>, NoParams> {
  final ProgramRepository repository;

  GetPrograms(this.repository);

  @override
  Future<Either<Failure, List<Program>>> call(NoParams params) async {
    return await repository.getAllPrograms();
  }
}

class CreateProgram implements UseCase<void, Program> {
  final ProgramRepository repository;

  CreateProgram(this.repository);

  @override
  Future<Either<Failure, void>> call(Program params) async {
    return await repository.createProgram(params);
  }
}

class UpdateProgram implements UseCase<void, Program> {
  final ProgramRepository repository;

  UpdateProgram(this.repository);

  @override
  Future<Either<Failure, void>> call(Program params) async {
    return await repository.updateProgram(params);
  }
}

class DeleteProgram implements UseCase<void, String> {
  final ProgramRepository repository;

  DeleteProgram(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.deleteProgram(params);
  }
}

class GetTrainingDaysForProgram implements UseCase<List<TrainingDay>, String> {
  final ProgramRepository repository;

  GetTrainingDaysForProgram(this.repository);

  @override
  Future<Either<Failure, List<TrainingDay>>> call(String programId) async {
    return await repository.getTrainingDaysForProgram(programId);
  }
}

class AddTrainingDay implements UseCase<void, TrainingDay> {
  final ProgramRepository repository;

  AddTrainingDay(this.repository);

  @override
  Future<Either<Failure, void>> call(TrainingDay params) async {
    return await repository.addTrainingDay(params);
  }
}

class UpdateTrainingDay implements UseCase<void, TrainingDay> {
  final ProgramRepository repository;

  UpdateTrainingDay(this.repository);

  @override
  Future<Either<Failure, void>> call(TrainingDay params) async {
    return await repository.updateTrainingDay(params);
  }
}

class DeleteTrainingDay implements UseCase<void, String> {
  final ProgramRepository repository;

  DeleteTrainingDay(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.deleteTrainingDay(params);
  }
}
