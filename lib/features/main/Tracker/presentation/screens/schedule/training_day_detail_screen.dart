import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/di/injection_container.dart';
import 'package:try_my_tracker/core/routes/app_routes.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise/exercise_bloc.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise/exercise_event.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise/exercise_state.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/workout_timer/workout_timer_cubit.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/workout_timer/workout_timer_state.dart';
import 'package:try_my_tracker/core/widgets/common/custom_button.dart';
import 'package:try_my_tracker/core/widgets/common/custom_text_field.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/widgets/exercise_card.dart';
import 'package:uuid/uuid.dart';
import 'package:try_my_tracker/domain/entities/exercise.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class TrainingDayDetailScreen extends StatelessWidget {
  final String dayName;
  final String dayId;

  const TrainingDayDetailScreen({
    super.key,
    required this.dayName,
    required this.dayId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ExerciseBloc>()..add(LoadExercises(dayId)),
        ),
        BlocProvider(create: (_) => WorkoutTimerCubit()),
      ],
      child: Scaffold(
        body: BlocBuilder<ExerciseBloc, ExerciseState>(
          builder: (context, state) {
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
                      dayName,
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _showAddExerciseDialog(context),
                    ),
                  ],
                ),
                if (state is ExerciseLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is ExerciseError)
                  SliverFillRemaining(child: Center(child: Text(state.message)))
                else if (state is ExerciseLoaded)
                  if (state.exercises.isEmpty)
                    SliverFillRemaining(child: _buildEmptyState(context))
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final exercise = state.exercises[index];
                          return ExerciseCard(
                            exercise: exercise,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.exerciseDetail,
                                arguments: exercise,
                              );
                            },
                          );
                        }, childCount: state.exercises.length),
                      ),
                    )
                else
                  SliverFillRemaining(child: _buildEmptyState(context)),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 80), // Bottom padding
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: _buildBottomBar(),
        floatingActionButton: Builder(
          builder: (ctx) {
            return FloatingActionButton(
              onPressed: () => _showAddExerciseDialog(ctx),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.black),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return BlocBuilder<WorkoutTimerCubit, WorkoutTimerState>(
      builder: (context, state) {
        if (state is WorkoutTimerInitial) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                label: 'Start Workout',
                onPressed: () {
                  context.read<WorkoutTimerCubit>().startWorkout();
                },
              ),
            ),
          );
        } else if (state is WorkoutInProgress) {
          final duration = state.durationSeconds;
          final minutes = (duration ~/ 60).toString().padLeft(2, '0');
          final seconds = (duration % 60).toString().padLeft(2, '0');

          return Container(
            color: AppColors.card,
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.timer,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$minutes:$seconds',
                          style: GoogleFonts.spaceMono(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      label: 'Finish',
                      onPressed: () {
                        context.read<WorkoutTimerCubit>().finishWorkout();
                        _showFinishDialog(context, duration);
                      },
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  void _showFinishDialog(BuildContext context, int duration) {
    final minutes = duration ~/ 60;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text(
          'Workout Finished!',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Great job! You worked out for $minutes minutes.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Close dialog
              context
                  .read<WorkoutTimerCubit>()
                  .reset(); // Reset timer to Initial
            },
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  // ... (rest of the file: _buildEmptyState, _showAddExerciseDialog)

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 40,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No exercises yet',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start building your workout',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: CustomButton(
              label: 'Add Exercise',
              onPressed: () => _showAddExerciseDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExerciseDialog(BuildContext context) {
    // Capture the bloc from the current context
    final exerciseBloc = context.read<ExerciseBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) =>
          _AddExerciseDialog(dayId: dayId, exerciseBloc: exerciseBloc),
    );
  }
}

class _AddExerciseDialog extends StatefulWidget {
  final String dayId;
  final ExerciseBloc exerciseBloc;

  const _AddExerciseDialog({required this.dayId, required this.exerciseBloc});

  @override
  State<_AddExerciseDialog> createState() => _AddExerciseDialogState();
}

class _AddExerciseDialogState extends State<_AddExerciseDialog> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final youtubeController = TextEditingController();
  final setsController = TextEditingController(text: '3');
  String? selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add Exercise',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      backgroundColor: AppColors.card,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final pickedFile = await picker.pickImage(
                  source: ImageSource.gallery,
                );

                if (pickedFile != null) {
                  setState(() {
                    selectedImagePath = pickedFile.path;
                  });
                }
              },
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.textHint.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  image: selectedImagePath != null
                      ? DecorationImage(
                          image: selectedImagePath!.startsWith('assets')
                              ? AssetImage(selectedImagePath!) as ImageProvider
                              : FileImage(
                                  File(selectedImagePath!),
                                ), // Handle local file
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: selectedImagePath == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo,
                            color: AppColors.textSecondary,
                          ),
                          Text(
                            'Add Image (Optional)',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: nameController,
              label: 'Exercise Name',
              hint: 'e.g., Bench Press',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: descriptionController,
              label: 'Description',
              hint: 'e.g., Focus on form',
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: youtubeController,
              label: 'YouTube Link (Optional)',
              hint: 'https://youtube.com/...',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: setsController,
              label: 'Number of Sets',
              hint: '3',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (nameController.text.isNotEmpty) {
              final newExercise = Exercise(
                id: const Uuid().v4(),
                trainingDayId: widget.dayId,
                name: nameController.text,
                description: descriptionController.text,
                orderIndex: 0,
                imagePath: selectedImagePath,
                youtubeLink: youtubeController.text.isEmpty
                    ? null
                    : youtubeController.text,
                defaultSetsCount: int.tryParse(setsController.text) ?? 3,
                lastUsedWeight: null,
              );

              widget.exerciseBloc.add(AddExerciseEvent(newExercise));
              Navigator.pop(context);
            }
          },
          child: const Text('Save', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }
}
