import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/program.dart';
import '../entities/training_day.dart';

abstract class ProgramRepository {
  // Programs
  Future<Either<Failure, List<Program>>> getAllPrograms();
  Future<Either<Failure, Program>> getProgram(String id);
  Future<Either<Failure, void>> createProgram(Program program);
  Future<Either<Failure, void>> updateProgram(Program program);
  Future<Either<Failure, void>> deleteProgram(String id);
  Future<Either<Failure, void>> setActiveProgram(String id);

  // Training Days
  Future<Either<Failure, List<TrainingDay>>> getTrainingDaysForProgram(
    String programId,
  );
  Future<Either<Failure, void>> addTrainingDay(TrainingDay day);
  Future<Either<Failure, void>> updateTrainingDay(TrainingDay day);
  Future<Either<Failure, void>> deleteTrainingDay(String id);
}
