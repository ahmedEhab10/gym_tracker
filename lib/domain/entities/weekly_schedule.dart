import 'package:equatable/equatable.dart';

class WeeklySchedule extends Equatable {
  final Map<int, String> dayNames;

  const WeeklySchedule({required this.dayNames});

  factory WeeklySchedule.defaultSchedule() {
    return const WeeklySchedule(
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

  WeeklySchedule copyWith({Map<int, String>? dayNames}) {
    return WeeklySchedule(dayNames: dayNames ?? this.dayNames);
  }

  @override
  List<Object?> get props => [dayNames];
}
