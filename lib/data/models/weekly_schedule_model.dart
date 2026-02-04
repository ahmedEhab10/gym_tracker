import 'package:hive/hive.dart';
import '../../domain/entities/weekly_schedule.dart';

part 'weekly_schedule_model.g.dart';

@HiveType(typeId: 5)
class WeeklyScheduleModel extends HiveObject {
  @HiveField(0)
  final List<String> dayNames;

  WeeklyScheduleModel({required this.dayNames});

  factory WeeklyScheduleModel.defaultSchedule() {
    return WeeklyScheduleModel(
      dayNames: [
        'Rest Day', // Monday (index 0)
        'Rest Day', // Tuesday (index 1)
        'Rest Day', // Wednesday (index 2)
        'Rest Day', // Thursday (index 3)
        'Rest Day', // Friday (index 4)
        'Rest Day', // Saturday (index 5)
        'Rest Day', // Sunday (index 6)
      ],
    );
  }

  factory WeeklyScheduleModel.fromEntity(WeeklySchedule entity) {
    // Convert Map to List
    final list = List<String>.filled(7, 'Rest Day');
    entity.dayNames.forEach((index, name) {
      if (index >= 0 && index < 7) {
        list[index] = name;
      }
    });
    return WeeklyScheduleModel(dayNames: list);
  }

  WeeklySchedule toEntity() {
    // Convert List to Map
    final map = <int, String>{};
    for (int i = 0; i < dayNames.length && i < 7; i++) {
      map[i] = dayNames[i];
    }
    return WeeklySchedule(dayNames: map);
  }
}
