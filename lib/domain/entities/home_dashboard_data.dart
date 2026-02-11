import 'package:equatable/equatable.dart';

class HomeDashboardData extends Equatable {
  final int totalWorkouts;
  final int workoutsThisWeek;
  final int totalDurationMinutes;
  final List<RecentWorkoutData> recentWorkouts;

  const HomeDashboardData({
    required this.totalWorkouts,
    required this.workoutsThisWeek,
    required this.totalDurationMinutes,
    required this.recentWorkouts,
  });

  @override
  List<Object?> get props => [
    totalWorkouts,
    workoutsThisWeek,
    totalDurationMinutes,
    recentWorkouts,
  ];
}

class RecentWorkoutData extends Equatable {
  final String sessionId;
  final String dayName;
  final DateTime date;
  final int durationMinutes;
  final double maxWeight;
  final List<String> exerciseNames;

  const RecentWorkoutData({
    required this.sessionId,
    required this.dayName,
    required this.date,
    required this.durationMinutes,
    required this.maxWeight,
    required this.exerciseNames,
  });

  @override
  List<Object?> get props => [
    sessionId,
    dayName,
    date,
    durationMinutes,
    maxWeight,
    exerciseNames,
  ];
}
