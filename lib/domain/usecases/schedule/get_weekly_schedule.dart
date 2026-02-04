import 'package:try_my_tracker/domain/entities/weekly_schedule.dart';
import 'package:try_my_tracker/domain/repositories/weekly_schedule_repository.dart';

class GetWeeklySchedule {
  final WeeklyScheduleRepository _repository;

  GetWeeklySchedule(this._repository);

  WeeklySchedule call() {
    return _repository.getWeeklySchedule();
  }
}
