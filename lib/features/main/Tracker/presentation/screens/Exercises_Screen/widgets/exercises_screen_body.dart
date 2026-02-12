import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/exercise_library/exercise_library_cubit.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/exercise_library/exercise_library_state.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/Exercises_Screen/widgets/exercise_list_item.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/Exercises_Screen/widgets/muscle_group_filter.dart';

class ExercisesScreenBody extends StatelessWidget {
  const ExercisesScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: BlocBuilder<ExerciseLibraryCubit, ExerciseLibraryState>(
          builder: (context, state) {
            if (state is ExerciseLibraryLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            } else if (state is ExerciseLibraryError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ExerciseLibraryCubit>().refresh();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is ExerciseLibraryLoaded) {
              final filteredExercises = state.filteredExercises;

              return Column(
                children: [
                  const MuscleGroupFilter(),
                  if (filteredExercises.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'No exercises found for this muscle group',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<ExerciseLibraryCubit>().refresh();
                        },
                        color: AppColors.primary,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: filteredExercises.length,
                          itemBuilder: (context, index) {
                            final exercise = filteredExercises[index];
                            return ExerciseListItem(
                              exercise: exercise,
                              onTap: () {
                                // TODO: Navigate to exercise detail screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Selected: ${exercise.name}'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
