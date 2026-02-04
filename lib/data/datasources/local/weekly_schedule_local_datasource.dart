import 'package:try_my_tracker/data/datasources/local/hive_service.dart';
import 'package:try_my_tracker/data/models/weekly_schedule_model.dart';

class WeeklyScheduleLocalDataSource {
  final HiveService _hiveService;
  static const String _scheduleKey = 'main_schedule';

  WeeklyScheduleLocalDataSource(this._hiveService);

  /// Get the weekly schedule, creating a default one if it doesn't exist
  WeeklyScheduleModel getWeeklySchedule() {
    final box = _hiveService.weeklyScheduleBox;

    if (box.isEmpty || !box.containsKey(_scheduleKey)) {
      final defaultSchedule = WeeklyScheduleModel.defaultSchedule();
      box.put(_scheduleKey, defaultSchedule);
      return defaultSchedule;
    }

    return box.get(_scheduleKey)!;
  }

  /// Update a specific day's name
  Future<void> updateDayName(int dayIndex, String name) async {
    if (dayIndex < 0 || dayIndex > 6) {
      throw ArgumentError('Day index must be between 0 and 6');
    }

    final schedule = getWeeklySchedule();
    final updatedDayNames = List<String>.from(schedule.dayNames);
    updatedDayNames[dayIndex] = name;

    final updatedSchedule = WeeklyScheduleModel(dayNames: updatedDayNames);
    await _hiveService.weeklyScheduleBox.put(_scheduleKey, updatedSchedule);
  }

  /// Reset all day names to default
  Future<void> resetToDefaults() async {
    final defaultSchedule = WeeklyScheduleModel.defaultSchedule();
    await _hiveService.weeklyScheduleBox.put(_scheduleKey, defaultSchedule);
  }

  /// Get a specific day's name
  String getDayName(int dayIndex) {
    if (dayIndex < 0 || dayIndex > 6) {
      throw ArgumentError('Day index must be between 0 and 6');
    }

    final schedule = getWeeklySchedule();
    return schedule.dayNames[dayIndex];
  }
}
