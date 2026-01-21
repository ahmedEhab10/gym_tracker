import 'package:uuid/uuid.dart';
import '../../../../core/errors/exceptions.dart';
import '../../models/program_model.dart';
import '../../models/training_day_model.dart';
import 'hive_service.dart';

abstract class ProgramLocalDataSource {
  Future<List<ProgramModel>> getAllPrograms();
  Future<ProgramModel> getProgram(String id);
  Future<void> createProgram(ProgramModel program);
  Future<void> updateProgram(ProgramModel program);
  Future<void> deleteProgram(String id);
  Future<void> setActiveProgram(String id);

  Future<List<TrainingDayModel>> getTrainingDaysForProgram(String programId);
  Future<void> addTrainingDay(TrainingDayModel day);
  Future<void> updateTrainingDay(TrainingDayModel day);
  Future<void> deleteTrainingDay(String id);
}

class ProgramLocalDataSourceImpl implements ProgramLocalDataSource {
  final HiveService hiveService;
  final Uuid uuid;

  ProgramLocalDataSourceImpl({required this.hiveService, required this.uuid});

  @override
  Future<List<ProgramModel>> getAllPrograms() async {
    try {
      return hiveService.programBox.values.toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<ProgramModel> getProgram(String id) async {
    final program = hiveService.programBox.get(id);
    if (program != null) {
      return program;
    } else {
      throw CacheException('Program not found');
    }
  }

  @override
  Future<void> createProgram(ProgramModel program) async {
    try {
      await hiveService.programBox.put(program.id, program);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateProgram(ProgramModel program) async {
    try {
      await hiveService.programBox.put(program.id, program);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteProgram(String id) async {
    try {
      await hiveService.programBox.delete(id);

      // Also delete associated training days to keep clean
      final days = hiveService.trainingDayBox.values
          .where((day) => day.programId == id)
          .toList();

      for (var day in days) {
        await hiveService.trainingDayBox.delete(day.id);
        // Recursively delete exercises? (Implementation choice: yes, usually)
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> setActiveProgram(String id) async {
    try {
      final allPrograms = hiveService.programBox.values;
      for (var program in allPrograms) {
        // Create a copy via fields since HiveObjects can be tricky if modified in place
        // But here we just want to update the stored value
        final isNewActive = program.id == id;
        if (program.isActive != isNewActive) {
          // Re-creating model because our models are likely immutable (final fields)
          final updated = ProgramModel(
            id: program.id,
            name: program.name,
            description: program.description,
            trainingDayIds: program.trainingDayIds,
            isActive: isNewActive,
            createdAt: program.createdAt,
            updatedAt: DateTime.now(), // Update timestamp
          );
          await hiveService.programBox.put(program.id, updated);
        }
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<TrainingDayModel>> getTrainingDaysForProgram(
    String programId,
  ) async {
    try {
      return hiveService.trainingDayBox.values
          .where((day) => day.programId == programId)
          .toList()
        ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> addTrainingDay(TrainingDayModel day) async {
    try {
      await hiveService.trainingDayBox.put(day.id, day);

      // Update parent program to include this day ID
      final program = hiveService.programBox.get(day.programId);
      if (program != null) {
        final updatedIds = List<String>.from(program.trainingDayIds)
          ..add(day.id);
        final updatedProgram = ProgramModel(
          id: program.id,
          name: program.name,
          description: program.description,
          trainingDayIds: updatedIds,
          isActive: program.isActive,
          createdAt: program.createdAt,
          updatedAt: DateTime.now(),
        );
        await hiveService.programBox.put(program.id, updatedProgram);
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateTrainingDay(TrainingDayModel day) async {
    try {
      await hiveService.trainingDayBox.put(day.id, day);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteTrainingDay(String id) async {
    try {
      final day = hiveService.trainingDayBox.get(id);
      if (day != null) {
        await hiveService.trainingDayBox.delete(id);

        // Remove from program
        final program = hiveService.programBox.get(day.programId);
        if (program != null) {
          final updatedIds = List<String>.from(program.trainingDayIds)
            ..remove(id);
          final updatedProgram = ProgramModel(
            id: program.id,
            name: program.name,
            description: program.description,
            trainingDayIds: updatedIds,
            isActive: program.isActive,
            createdAt: program.createdAt,
            updatedAt: DateTime.now(),
          );
          await hiveService.programBox.put(program.id, updatedProgram);
        }
      }
    } catch (e) {
      throw CacheException();
    }
  }
}
