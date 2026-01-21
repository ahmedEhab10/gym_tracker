import 'package:hive/hive.dart';
import '../../domain/entities/workout_session.dart';

part 'workout_session_model.g.dart';

@HiveType(typeId: 4)
class WorkoutSessionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String trainingDayId;

  @HiveField(2)
  final DateTime startTime;

  @HiveField(3)
  final DateTime? endTime;

  @HiveField(4)
  final bool isCompleted;

  @HiveField(5)
  final String? notes;

  WorkoutSessionModel({
    required this.id,
    required this.trainingDayId,
    required this.startTime,
    this.endTime,
    required this.isCompleted,
    this.notes,
  });

  factory WorkoutSessionModel.fromEntity(WorkoutSession entity) {
    return WorkoutSessionModel(
      id: entity.id,
      trainingDayId: entity.trainingDayId,
      startTime: entity.startTime,
      endTime: entity.endTime,
      isCompleted: entity.isCompleted,
      notes: entity.notes,
    );
  }

  WorkoutSession toEntity() {
    return WorkoutSession(
      id: id,
      trainingDayId: trainingDayId,
      startTime: startTime,
      endTime: endTime,
      isCompleted: isCompleted,
      notes: notes,
    );
  }
}
