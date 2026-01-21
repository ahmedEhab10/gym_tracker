import 'package:hive/hive.dart';
import '../../domain/entities/exercise.dart';

part 'exercise_model.g.dart';

@HiveType(typeId: 2)
class ExerciseModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String trainingDayId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String? imagePath;

  @HiveField(5)
  final String? youtubeLink;

  @HiveField(6)
  final String? notes;

  @HiveField(7)
  final double? lastUsedWeight;

  @HiveField(8)
  final int orderIndex;

  @HiveField(9)
  final int defaultSetsCount;

  ExerciseModel({
    required this.id,
    required this.trainingDayId,
    required this.name,
    required this.description,
    this.imagePath,
    this.youtubeLink,
    this.notes,
    this.lastUsedWeight,
    required this.orderIndex,
    this.defaultSetsCount = 3,
  });

  factory ExerciseModel.fromEntity(Exercise entity) {
    return ExerciseModel(
      id: entity.id,
      trainingDayId: entity.trainingDayId,
      name: entity.name,
      description: entity.description,
      imagePath: entity.imagePath,
      youtubeLink: entity.youtubeLink,
      notes: entity.notes,
      lastUsedWeight: entity.lastUsedWeight,
      orderIndex: entity.orderIndex,
      defaultSetsCount: entity.defaultSetsCount,
    );
  }

  Exercise toEntity() {
    return Exercise(
      id: id,
      trainingDayId: trainingDayId,
      name: name,
      description: description,
      imagePath: imagePath,
      youtubeLink: youtubeLink,
      notes: notes,
      lastUsedWeight: lastUsedWeight,
      orderIndex: orderIndex,
      defaultSetsCount: defaultSetsCount,
    );
  }
}
