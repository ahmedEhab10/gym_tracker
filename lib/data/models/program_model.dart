import 'package:hive/hive.dart';
import '../../domain/entities/program.dart';

part 'program_model.g.dart';

@HiveType(typeId: 0)
class ProgramModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final List<String> trainingDayIds;

  @HiveField(4)
  final bool isActive;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  ProgramModel({
    required this.id,
    required this.name,
    required this.description,
    required this.trainingDayIds,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProgramModel.fromEntity(Program entity) {
    return ProgramModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      trainingDayIds: entity.trainingDayIds,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Program toEntity() {
    return Program(
      id: id,
      name: name,
      description: description,
      trainingDayIds: trainingDayIds,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
