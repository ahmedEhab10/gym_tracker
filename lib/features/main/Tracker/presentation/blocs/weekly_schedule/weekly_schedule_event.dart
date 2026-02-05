import 'package:equatable/equatable.dart';

abstract class WeeklyScheduleEvent extends Equatable {
  const WeeklyScheduleEvent();

  @override
  List<Object?> get props => [];
}

class LoadWeeklySchedule extends WeeklyScheduleEvent {
  const LoadWeeklySchedule();
}

class UpdateDayNameEvent extends WeeklyScheduleEvent {
  final int dayIndex;
  final String name;

  const UpdateDayNameEvent({required this.dayIndex, required this.name});

  @override
  List<Object?> get props => [dayIndex, name];
}

class ResetSchedule extends WeeklyScheduleEvent {
  const ResetSchedule();
}
