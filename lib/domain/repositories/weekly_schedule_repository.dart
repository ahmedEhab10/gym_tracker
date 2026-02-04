import '../entities/weekly_schedule.dart';

abstract class WeeklyScheduleRepository {
  WeeklySchedule getWeeklySchedule();
  Future<void> updateDayName(int dayIndex, String name);
  Future<void> resetToDefaults();
  String getDayName(int dayIndex);
}
