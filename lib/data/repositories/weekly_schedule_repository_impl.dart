import 'package:try_my_tracker/data/datasources/local/weekly_schedule_local_datasource.dart';
import 'package:try_my_tracker/domain/entities/weekly_schedule.dart';
import 'package:try_my_tracker/domain/repositories/weekly_schedule_repository.dart';

class WeeklyScheduleRepositoryImpl implements WeeklyScheduleRepository {
  final WeeklyScheduleLocalDataSource _localDataSource;

  WeeklyScheduleRepositoryImpl(this._localDataSource);

  @override
  WeeklySchedule getWeeklySchedule() {
    final model = _localDataSource.getWeeklySchedule();
    return model.toEntity();
  }

  @override
  Future<void> updateDayName(int dayIndex, String name) async {
    await _localDataSource.updateDayName(dayIndex, name);
  }

  @override
  Future<void> resetToDefaults() async {
    await _localDataSource.resetToDefaults();
  }

  @override
  String getDayName(int dayIndex) {
    return _localDataSource.getDayName(dayIndex);
  }
}
