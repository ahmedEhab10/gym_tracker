import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/domain/usecases/schedule/get_weekly_schedule.dart';
import 'package:try_my_tracker/domain/usecases/schedule/update_day_name.dart';

import 'weekly_schedule_event.dart';
import 'weekly_schedule_state.dart';

class WeeklyScheduleBloc
    extends Bloc<WeeklyScheduleEvent, WeeklyScheduleState> {
  final GetWeeklySchedule getWeeklySchedule;
  final UpdateDayName updateDayName;

  WeeklyScheduleBloc({
    required this.getWeeklySchedule,
    required this.updateDayName,
  }) : super(const WeeklyScheduleInitial()) {
    on<LoadWeeklySchedule>(_onLoadWeeklySchedule);
    on<UpdateDayNameEvent>(_onUpdateDayName);
  }

  Future<void> _onLoadWeeklySchedule(
    LoadWeeklySchedule event,
    Emitter<WeeklyScheduleState> emit,
  ) async {
    try {
      emit(const WeeklyScheduleLoading());
      final schedule = getWeeklySchedule();
      emit(WeeklyScheduleLoaded(schedule));
    } catch (e) {
      emit(WeeklyScheduleError(e.toString()));
    }
  }

  Future<void> _onUpdateDayName(
    UpdateDayNameEvent event,
    Emitter<WeeklyScheduleState> emit,
  ) async {
    try {
      await updateDayName(event.dayIndex, event.name);
      // Reload the schedule after update
      final schedule = getWeeklySchedule();
      emit(WeeklyScheduleLoaded(schedule));
    } catch (e) {
      emit(WeeklyScheduleError(e.toString()));
    }
  }
}
