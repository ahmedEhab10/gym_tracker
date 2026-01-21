import 'package:equatable/equatable.dart';

class ExerciseSet extends Equatable {
  final String id;
  final String exerciseId;
  final int setNumber;
  final int reps;
  final double weight;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? workoutSessionId;

  const ExerciseSet({
    required this.id,
    required this.exerciseId,
    required this.setNumber,
    required this.reps,
    required this.weight,
    this.isCompleted = false,
    this.completedAt,
    this.workoutSessionId,
  });

  factory ExerciseSet.empty() {
    return const ExerciseSet(
      id: '',
      exerciseId: '',
      setNumber: 0,
      reps: 0,
      weight: 0,
    );
  }

  // Helper to create a copy with updated values
  ExerciseSet copyWith({
    String? id,
    String? exerciseId,
    int? setNumber,
    int? reps,
    double? weight,
    bool? isCompleted,
    DateTime? completedAt,
    String? workoutSessionId,
  }) {
    return ExerciseSet(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      workoutSessionId: workoutSessionId ?? this.workoutSessionId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    exerciseId,
    setNumber,
    reps,
    weight,
    isCompleted,
    completedAt,
    workoutSessionId,
  ];
}
