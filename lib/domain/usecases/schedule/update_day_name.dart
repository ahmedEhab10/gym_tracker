import 'package:try_my_tracker/domain/repositories/weekly_schedule_repository.dart';

class UpdateDayName {
  final WeeklyScheduleRepository _repository;

  UpdateDayName(this._repository);

  Future<void> call(int dayIndex, String name) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Day name cannot be empty');
    }

    await _repository.updateDayName(dayIndex, name.trim());
  }
}
