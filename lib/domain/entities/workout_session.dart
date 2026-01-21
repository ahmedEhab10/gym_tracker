import 'package:equatable/equatable.dart';

class WorkoutSession extends Equatable {
  final String id;
  final String trainingDayId;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isCompleted;
  final String? notes;

  const WorkoutSession({
    required this.id,
    required this.trainingDayId,
    required this.startTime,
    this.endTime,
    this.isCompleted = false,
    this.notes,
  });

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  @override
  List<Object?> get props => [
    id,
    trainingDayId,
    startTime,
    endTime,
    isCompleted,
    notes,
  ];
}
