import 'package:equatable/equatable.dart';
import 'package:try_my_tracker/domain/entities/weekly_schedule.dart';

abstract class WeeklyScheduleState extends Equatable {
  const WeeklyScheduleState();

  @override
  List<Object?> get props => [];
}

class WeeklyScheduleInitial extends WeeklyScheduleState {
  const WeeklyScheduleInitial();
}

class WeeklyScheduleLoading extends WeeklyScheduleState {
  const WeeklyScheduleLoading();
}

class WeeklyScheduleLoaded extends WeeklyScheduleState {
  final WeeklySchedule schedule;

  const WeeklyScheduleLoaded(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

class WeeklyScheduleError extends WeeklyScheduleState {
  final String message;

  const WeeklyScheduleError(this.message);

  @override
  List<Object?> get props => [message];
}
