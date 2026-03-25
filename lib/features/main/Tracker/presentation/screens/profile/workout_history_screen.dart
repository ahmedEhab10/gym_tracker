import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:try_my_tracker/core/di/injection_container.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/workout_history/workout_history_cubit.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/workout_history/workout_history_state.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WorkoutHistoryCubit>()..loadHistory(),
      child: const _WorkoutHistoryView(),
    );
  }
}

class _WorkoutHistoryView extends StatefulWidget {
  const _WorkoutHistoryView();

  @override
  State<_WorkoutHistoryView> createState() => _WorkoutHistoryViewState();
}

class _WorkoutHistoryViewState extends State<_WorkoutHistoryView> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Workout History',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<WorkoutHistoryCubit, WorkoutHistoryState>(
        builder: (context, state) {
          if (state is WorkoutHistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state is WorkoutHistoryError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              ),
            );
          }
          if (state is WorkoutHistoryLoaded) {
            return _CalendarBody(
              workoutDays: state.workoutDays,
              weekStreak: state.weekStreak,
              restDays: state.restDays,
              focusedDay: _focusedDay,
              onPageChanged: (day) => setState(() => _focusedDay = day),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CalendarBody extends StatelessWidget {
  final Map<DateTime, String> workoutDays;
  final int weekStreak;
  final int restDays;
  final DateTime focusedDay;
  final void Function(DateTime) onPageChanged;

  const _CalendarBody({
    required this.workoutDays,
    required this.weekStreak,
    required this.restDays,
    required this.focusedDay,
    required this.onPageChanged,
  });

  bool _isWorkoutDay(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return workoutDays.containsKey(normalized);
  }

  String? _labelFor(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return workoutDays[normalized];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Stats banner
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _StatTile(
                    emoji: '🔥',
                    value: '$weekStreak week${weekStreak != 1 ? 's' : ''}',
                    label: 'streak',
                  ),
                ),
                Container(width: 1, height: 50.h, color: Colors.white12),
                Expanded(
                  child: _StatTile(
                    emoji: '🌙',
                    value: '$restDays',
                    label: 'rest days',
                  ),
                ),
              ],
            ),
          ),

          // Table Calendar
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2100),
            focusedDay: focusedDay,
            onPageChanged: onPageChanged,
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: const Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
              rightChevronIcon: const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              headerPadding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: const BoxDecoration(color: Colors.transparent),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: GoogleFonts.spaceGrotesk(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
              weekendStyle: GoogleFonts.spaceGrotesk(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              defaultTextStyle: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 14.sp,
              ),
              weekendTextStyle: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 14.sp,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              todayTextStyle: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: GoogleFonts.spaceGrotesk(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              markerDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              markerSize: 6,
              markersMaxCount: 1,
              cellMargin: EdgeInsets.all(4.w),
            ),
            // Highlight workout days using calendarBuilders
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                if (_isWorkoutDay(day)) {
                  final label = _labelFor(day);
                  return _WorkoutDayCell(
                    day: day.day,
                    label: label,
                    isToday: false,
                  );
                }
                return null;
              },
              todayBuilder: (context, day, focusedDay) {
                if (_isWorkoutDay(day)) {
                  final label = _labelFor(day);
                  return _WorkoutDayCell(
                    day: day.day,
                    label: label,
                    isToday: true,
                  );
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutDayCell extends StatelessWidget {
  final int day;
  final String? label;
  final bool isToday;

  const _WorkoutDayCell({required this.day, this.label, required this.isToday});

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      maxHeight: double.infinity,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              border: isToday
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
            ),
            child: Center(
              child: Text(
                '$day',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (label != null)
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Text(
                label!.length > 9 ? '${label!.substring(0, 8)}…' : label!,
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.textSecondary,
                  fontSize: 10.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;

  const _StatTile({
    required this.emoji,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 20.sp)),
          SizedBox(width: 8.w),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$value ',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
                TextSpan(
                  text: label,
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
