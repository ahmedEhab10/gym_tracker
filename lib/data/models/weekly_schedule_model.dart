import 'package:hive/hive.dart';
import '../../domain/entities/weekly_schedule.dart';

part 'weekly_schedule_model.g.dart';

@HiveType(typeId: 5)
class WeeklyScheduleModel extends HiveObject {
  @HiveField(0)
  final Map<int, String> dayNames;

  WeeklyScheduleModel({required this.dayNames});

  factory WeeklyScheduleModel.defaultSchedule() {
    return WeeklyScheduleModel(
      dayNames: {
        0: 'Rest Day', // Monday
        1: 'Rest Day', // Tuesday
        2: 'Rest Day', // Wednesday
        3: 'Rest Day', // Thursday
        4: 'Rest Day', // Friday
        5: 'Rest Day', // Saturday
        6: 'Rest Day', // Sunday
      },
    );
  }

  factory WeeklyScheduleModel.fromEntity(WeeklySchedule entity) {
    return WeeklyScheduleModel(
      dayNames: Map<int, String>.from(entity.dayNames),
    );
  }

  WeeklySchedule toEntity() {
    return WeeklySchedule(dayNames: Map<int, String>.from(dayNames));
  }
}
