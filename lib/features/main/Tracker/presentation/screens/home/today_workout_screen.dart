import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/core/di/injection_container.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';

import 'package:try_my_tracker/domain/entities/exercise.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise/exercise_bloc.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise/exercise_event.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise/exercise_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TodayWorkoutScreen extends StatelessWidget {
  const TodayWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate today's ID
    // DateTime.weekday returns 1 for Monday, ..., 7 for Sunday
    // Our convention in WeeklyScheduleScreen is 'temp_id_${index}' where index is 0 for Monday
    final now = DateTime.now();
    final dayIndex = now.weekday - 1; // 0-6
    final dayId = 'temp_id_$dayIndex';

    return BlocProvider(
      create: (_) => sl<ExerciseBloc>()..add(LoadExercises(dayId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Today's Workout"),
          automaticallyImplyActions: false,
        ),
        body: BlocBuilder<ExerciseBloc, ExerciseState>(
          builder: (context, state) {
            if (state is ExerciseLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExerciseLoaded) {
              if (state.exercises.isEmpty) {
                return _buildEmptyState();
              }
              return _buildExerciseList(state.exercises);
            } else if (state is ExerciseError) {
              return Center(child: Text(state.message));
            }
            return _buildEmptyState();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.fitness_center, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text(
            'No workout scheduled today',
            style: TextStyle(fontSize: 18.sp, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Enjoy your rest day!',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseList(List<Exercise> exercises) {
    return ListView.builder(
      itemCount: exercises.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/exercise-detail',
                arguments: exercise,
              );
            },
            title: Text(
              exercise.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(exercise.description),
            trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
          ),
        );
      },
    );
  }
}
