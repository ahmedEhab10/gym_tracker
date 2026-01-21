import 'package:equatable/equatable.dart';
import 'exercise_set.dart';

class ExerciseHistory extends Equatable {
  final List<ExerciseSession> sessions;
  final ExerciseStats stats;

  const ExerciseHistory({required this.sessions, required this.stats});

  @override
  List<Object?> get props => [sessions, stats];
}

class ExerciseSession extends Equatable {
  final String sessionId;
  final DateTime date;
  final List<ExerciseSet> sets;
  final bool isCompleted;

  const ExerciseSession({
    required this.sessionId,
    required this.date,
    required this.sets,
    required this.isCompleted,
  });

  // Helper to get max weight for this session
  double get maxWeight {
    if (sets.isEmpty) return 0;
    return sets.map((s) => s.weight).reduce((a, b) => a > b ? a : b);
  }

  @override
  List<Object?> get props => [sessionId, date, sets, isCompleted];
}

class ExerciseStats extends Equatable {
  final double maxWeightEver;
  final double bestVolume; // e.g. total volume calculation if needed
  final double avgWeightLast3Sessions;

  const ExerciseStats({
    required this.maxWeightEver,
    required this.bestVolume,
    required this.avgWeightLast3Sessions,
  });

  @override
  List<Object?> get props => [
    maxWeightEver,
    bestVolume,
    avgWeightLast3Sessions,
  ];
}
