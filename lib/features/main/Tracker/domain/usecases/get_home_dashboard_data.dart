import 'package:dartz/dartz.dart';
import 'package:try_my_tracker/core/errors/failures.dart';
import 'package:try_my_tracker/core/usecases/usecase.dart';
import 'package:try_my_tracker/domain/entities/home_dashboard_data.dart';
import 'package:try_my_tracker/domain/repositories/workout_repository.dart';
import 'package:try_my_tracker/domain/entities/workout_session.dart';
import 'package:try_my_tracker/domain/repositories/exercise_repository.dart';

class GetHomeDashboardData implements UseCase<HomeDashboardData, NoParams> {
  final WorkoutRepository workoutRepository;
  final ExerciseRepository exerciseRepository;

  GetHomeDashboardData(this.workoutRepository, this.exerciseRepository);

  @override
  Future<Either<Failure, HomeDashboardData>> call(NoParams params) async {
    // 1. Get Workout History (All)
    final historyResult = await workoutRepository.getWorkoutHistory();

    return historyResult.fold((failure) => Left(failure), (sessions) async {
      if (sessions.isEmpty) {
        return const Right(
          HomeDashboardData(
            totalWorkouts: 0,
            workoutsThisWeek: 0,
            totalDurationMinutes: 0,
            recentWorkouts: [],
          ),
        );
      }

      // 2. Calculate Stats
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 7));

      int workoutsThisWeek = sessions.where((s) {
        return s.startTime.isAfter(startOfWeek) &&
            s.startTime.isBefore(endOfWeek);
      }).length;

      int totalDuration = 0;
      for (var s in sessions) {
        totalDuration += s.duration.inMinutes;
      }

      // ... inside call method
      // 3. Group Sessions by Day
      final Map<DateTime, List<WorkoutSession>> sessionsByDay = {};
      for (var session in sessions) {
        final date = DateTime(
          session.startTime.year,
          session.startTime.month,
          session.startTime.day,
        );
        if (!sessionsByDay.containsKey(date)) {
          sessionsByDay[date] = [];
        }
        sessionsByDay[date]!.add(session);
      }

      // 4. Create RecentWorkoutData for each day (Sort by Date DESC)
      final sortedDates = sessionsByDay.keys.toList()
        ..sort((a, b) => b.compareTo(a));

      final recentDays = sortedDates.take(3).toList();
      final List<RecentWorkoutData> recentWorkoutsData = [];

      for (var date in recentDays) {
        final daySessions = sessionsByDay[date]!;

        // Aggregate Duration
        int dayDuration = 0;
        for (var s in daySessions) {
          dayDuration += s.duration.inMinutes;
        }

        // Aggregate Max Weight & Exercises
        double dayMaxWeight = 0;
        final Set<String> dayExerciseIds = {};

        // We need to fetch sets for ALL sessions in this day
        // This might be multiple async calls.
        for (var session in daySessions) {
          final setsResult = await workoutRepository.getSetsForSession(
            session.id,
          );
          if (setsResult.isRight()) {
            final sets = setsResult.getOrElse(() => []);
            for (var set in sets) {
              if (set.weight > dayMaxWeight) dayMaxWeight = set.weight;
              dayExerciseIds.add(set.exerciseId);
            }
          }
        }

        // Get Exercise Names
        List<String> exerciseNames = [];
        if (dayExerciseIds.isNotEmpty) {
          final exercisesResult = await exerciseRepository.getExercisesByIds(
            dayExerciseIds.toList(),
          );
          exercisesResult.fold((f) => null, (exercises) {
            final Map<String, String> nameMap = {
              for (var e in exercises) e.id: e.name,
            };
            // Show all exercises for the day (or limit if too many, but user asked for "all three" implying they want to see them)
            // Let's take all unique names
            exerciseNames = nameMap.values.toList();
          });
        }

        // Use the first session's ID as a placeholder if needed, or just empty string if not used for nav
        // We'll use the first session's ID
        final firstSession = daySessions.first;

        recentWorkoutsData.add(
          RecentWorkoutData(
            sessionId: firstSession.id,
            dayName: _getDayName(date.weekday),
            date: date,
            durationMinutes: dayDuration,
            maxWeight: dayMaxWeight,
            exerciseNames: exerciseNames,
          ),
        );
      }

      return Right(
        HomeDashboardData(
          totalWorkouts: sessions.length,
          workoutsThisWeek: workoutsThisWeek,
          totalDurationMinutes: totalDuration,
          recentWorkouts: recentWorkoutsData,
        ),
      );
    });
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}
