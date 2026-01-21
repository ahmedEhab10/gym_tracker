import 'package:hive/hive.dart';
import '../../domain/entities/exercise_set.dart';

part 'exercise_set_model.g.dart';

@HiveType(typeId: 3)
class ExerciseSetModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String exerciseId;

  @HiveField(2)
  final int setNumber;

  @HiveField(3)
  final int reps;

  @HiveField(4)
  final double weight;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final DateTime? completedAt;

  @HiveField(7)
  final String? workoutSessionId;

  ExerciseSetModel({
    required this.id,
    required this.exerciseId,
    required this.setNumber,
    required this.reps,
    required this.weight,
    required this.isCompleted,
    this.completedAt,
    this.workoutSessionId,
  });

  factory ExerciseSetModel.fromEntity(ExerciseSet entity) {
    return ExerciseSetModel(
      id: entity.id,
      exerciseId: entity.exerciseId,
      setNumber: entity.setNumber,
      reps: entity.reps,
      weight: entity.weight,
      isCompleted: entity.isCompleted,
      completedAt: entity.completedAt,
      workoutSessionId: entity.workoutSessionId,
    );
  }

  ExerciseSet toEntity() {
    return ExerciseSet(
      id: id,
      exerciseId: exerciseId,
      setNumber: setNumber,
      reps: reps,
      weight: weight,
      isCompleted: isCompleted,
      completedAt: completedAt,
      workoutSessionId: workoutSessionId,
    );
  }
}
