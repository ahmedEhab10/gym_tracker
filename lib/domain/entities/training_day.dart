import 'package:equatable/equatable.dart';

class TrainingDay extends Equatable {
  final String id;
  final String programId;
  final String name;
  final int dayOfWeek; // 0 = Monday, 6 = Sunday
  final List<String> exerciseIds;
  final int orderIndex;

  const TrainingDay({
    required this.id,
    required this.programId,
    required this.name,
    required this.dayOfWeek,
    this.exerciseIds = const [],
    required this.orderIndex,
  });

  @override
  List<Object?> get props => [
    id,
    programId,
    name,
    dayOfWeek,
    exerciseIds,
    orderIndex,
  ];
}
