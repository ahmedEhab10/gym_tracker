import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/program.dart';
import '../../domain/entities/training_day.dart';
import '../../domain/repositories/program_repository.dart';
import '../datasources/local/program_local_datasource.dart';
import '../models/program_model.dart';
import '../models/training_day_model.dart';

class ProgramRepositoryImpl implements ProgramRepository {
  final ProgramLocalDataSource localDataSource;

  ProgramRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Program>>> getAllPrograms() async {
    try {
      final programModels = await localDataSource.getAllPrograms();
      return Right(programModels.map((m) => m.toEntity()).toList());
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Program>> getProgram(String id) async {
    try {
      final model = await localDataSource.getProgram(id);
      return Right(model.toEntity());
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createProgram(Program program) async {
    try {
      final model = ProgramModel.fromEntity(program);
      return Right(await localDataSource.createProgram(model));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateProgram(Program program) async {
    try {
      final model = ProgramModel.fromEntity(program);
      return Right(await localDataSource.updateProgram(model));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProgram(String id) async {
    try {
      return Right(await localDataSource.deleteProgram(id));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> setActiveProgram(String id) async {
    try {
      return Right(await localDataSource.setActiveProgram(id));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<TrainingDay>>> getTrainingDaysForProgram(
    String programId,
  ) async {
    try {
      final models = await localDataSource.getTrainingDaysForProgram(programId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addTrainingDay(TrainingDay day) async {
    try {
      final model = TrainingDayModel.fromEntity(day);
      return Right(await localDataSource.addTrainingDay(model));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateTrainingDay(TrainingDay day) async {
    try {
      final model = TrainingDayModel.fromEntity(day);
      return Right(await localDataSource.updateTrainingDay(model));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTrainingDay(String id) async {
    try {
      return Right(await localDataSource.deleteTrainingDay(id));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }
}
