import '../../../../core/errors/exceptions.dart';
import '../../models/workout_session_model.dart';
import 'hive_service.dart';

abstract class WorkoutLocalDataSource {
  Future<void> saveWorkoutSession(WorkoutSessionModel session);
  Future<void> updateWorkoutSession(WorkoutSessionModel session);
  Future<void> deleteWorkoutSession(String id);
  Future<List<WorkoutSessionModel>> getWorkoutHistory({
    DateTime? startDate,
    DateTime? endDate,
  });
}

class WorkoutLocalDataSourceImpl implements WorkoutLocalDataSource {
  final HiveService hiveService;

  WorkoutLocalDataSourceImpl({required this.hiveService});

  @override
  Future<void> saveWorkoutSession(WorkoutSessionModel session) async {
    try {
      await hiveService.workoutSessionBox.put(session.id, session);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateWorkoutSession(WorkoutSessionModel session) async {
    try {
      await hiveService.workoutSessionBox.put(session.id, session);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteWorkoutSession(String id) async {
    try {
      await hiveService.workoutSessionBox.delete(id);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<WorkoutSessionModel>> getWorkoutHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = hiveService.workoutSessionBox.values.toList();

      if (startDate != null) {
        query = query
            .where((session) => session.startTime.isAfter(startDate))
            .toList();
      }

      if (endDate != null) {
        query = query
            .where((session) => session.startTime.isBefore(endDate))
            .toList();
      }

      // Sort by date desc
      query.sort((a, b) => b.startTime.compareTo(a.startTime));

      return query;
    } catch (e) {
      throw CacheException();
    }
  }
}
