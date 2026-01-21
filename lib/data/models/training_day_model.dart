import 'package:hive/hive.dart';
import '../../domain/entities/training_day.dart';

part 'training_day_model.g.dart';

@HiveType(typeId: 1)
class TrainingDayModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String programId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final int dayOfWeek;

  @HiveField(4)
  final List<String> exerciseIds;

  @HiveField(5)
  final int orderIndex;

  TrainingDayModel({
    required this.id,
    required this.programId,
    required this.name,
    required this.dayOfWeek,
    required this.exerciseIds,
    required this.orderIndex,
  });

  factory TrainingDayModel.fromEntity(TrainingDay entity) {
    return TrainingDayModel(
      id: entity.id,
      programId: entity.programId,
      name: entity.name,
      dayOfWeek: entity.dayOfWeek,
      exerciseIds: entity.exerciseIds,
      orderIndex: entity.orderIndex,
    );
  }

  TrainingDay toEntity() {
    return TrainingDay(
      id: id,
      programId: programId,
      name: name,
      dayOfWeek: dayOfWeek,
      exerciseIds: exerciseIds,
      orderIndex: orderIndex,
    );
  }
}
