import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'workout_timer_state.dart';

class WorkoutTimerCubit extends Cubit<WorkoutTimerState> {
  Timer? _timer;
  int _duration = 0;
  String? _sessionId;

  WorkoutTimerCubit() : super(WorkoutTimerInitial());

  void startWorkout(String sessionId) {
    if (state is WorkoutInProgress) return;

    _duration = 0;
    _sessionId = sessionId;
    emit(WorkoutInProgress(_duration, _sessionId!));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _duration++;
      emit(WorkoutInProgress(_duration, _sessionId!));
    });
  }

  void finishWorkout() {
    _timer?.cancel();
    _timer = null;
    emit(WorkoutFinished(_duration, _sessionId ?? ''));
    // Reset after a delay or manual reset?
    // Usually finished state is shown, then user navigates away or resets.
    // We'll keep it simple: Stay in Finished until reset.
  }

  void reset() {
    _timer?.cancel();
    _duration = 0;
    emit(WorkoutTimerInitial());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
