import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/routes/app_routes.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/weekly_schedule/weekly_schedule_bloc.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/weekly_schedule/weekly_schedule_event.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/weekly_schedule/weekly_schedule_state.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/widgets/day_schedule_card.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/widgets/edit_day_name_dialog.dart';

class WeeklyScheduleScreen extends StatelessWidget {
  const WeeklyScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WeeklyScheduleBloc, WeeklyScheduleState>(
        builder: (context, state) {
          if (state is WeeklyScheduleLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WeeklyScheduleError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is WeeklyScheduleLoaded) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 120.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppColors.background,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                    title: Text(
                      'Your Weekly Plan',
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final days = [
                        'Monday',
                        'Tuesday',
                        'Wednesday',
                        'Thursday',
                        'Friday',
                        'Saturday',
                        'Sunday',
                      ];

                      final day = days[index];
                      final workoutName =
                          state.schedule.dayNames[index] ?? 'Rest Day';
                      final isRestDay = workoutName.toLowerCase().contains(
                        'rest',
                      );

                      return DayScheduleCard(
                        dayName: day,
                        workoutName: workoutName,
                        isRestDay: isRestDay,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.trainingDayDetail,
                            arguments: {
                              'dayName': day,
                              'dayId': 'temp_id_$index',
                            },
                          );
                        },
                        onEdit: () =>
                            _showEditDialog(context, index, day, workoutName),
                      );
                    }, childCount: 7),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    int dayIndex,
    String dayName,
    String currentName,
  ) async {
    final newName = await showDialog<String>(
      context: context,
      builder: (context) =>
          EditDayNameDialog(currentName: currentName, dayName: dayName),
    );

    if (newName != null && context.mounted) {
      context.read<WeeklyScheduleBloc>().add(
        UpdateDayNameEvent(dayIndex: dayIndex, name: newName),
      );
    }
  }
}
