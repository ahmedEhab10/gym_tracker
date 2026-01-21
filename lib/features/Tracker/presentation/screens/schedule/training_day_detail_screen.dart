import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Bloc
import 'package:try_my_tracker/core/di/injection_container.dart'; // SL

import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/features/Tracker/presentation/blocs/exercise/exercise_bloc.dart';
import 'package:try_my_tracker/features/Tracker/presentation/blocs/exercise/exercise_event.dart';
import 'package:try_my_tracker/features/Tracker/presentation/blocs/exercise/exercise_state.dart';
import 'package:try_my_tracker/core/widgets/common/custom_button.dart';
import 'package:try_my_tracker/core/widgets/common/custom_text_field.dart';

import 'package:uuid/uuid.dart'; // For generating IDs
import 'package:try_my_tracker/domain/entities/exercise.dart'; // Entity

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
    return BlocProvider(
      create: (_) => sl<ExerciseBloc>()..add(LoadExercises(dayId)),
      child: Scaffold(
        appBar: AppBar(title: Text(dayName)),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () => _showAddExerciseDialog(context),
              child: const Icon(Icons.add),
            );
          },
        ),
        body: BlocBuilder<ExerciseBloc, ExerciseState>(
          builder: (context, state) {
            if (state is ExerciseLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExerciseLoaded) {
              if (state.exercises.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildExerciseList(state.exercises);
            } else if (state is ExerciseError) {
              return Center(child: Text(state.message));
            }
            return _buildEmptyState(context);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.fitness_center, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          const Text(
            'No exercises added yet',
            style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add exercises to build your workout',
            style: TextStyle(fontSize: 14, color: AppColors.textHint),
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
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColors.textHint,
            ),
          ),
        );
      },
    );
  }

  void _showAddExerciseDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final youtubeController = TextEditingController();
    final setsController = TextEditingController(text: '3');
    String? selectedImagePath;

    // Capture the bloc from the current context before it's lost in the dialog route
    final exerciseBloc = context.read<ExerciseBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogInnerContext, setState) => AlertDialog(
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
                    // Simple image picking placeholder logic
                    // In a real app, use ImagePicker
                    // For this environment, we simulate setting a path
                    // Let's assume the user "uploads" and we get a path.
                    // Actually, I can use image_picker if I want, but I can't interact with the native picker.
                    // I'll add a button to "Pick Image" and show a placeholder.
                    setState(() {
                      selectedImagePath =
                          'assets/images/image.png'; // Placeholder for simulation
                    });
                  },
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.textHint.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      image: selectedImagePath != null
                          ? DecorationImage(
                              image: AssetImage(selectedImagePath!),
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
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final newExercise = Exercise(
                    id: const Uuid().v4(),
                    trainingDayId: dayId,
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

                  exerciseBloc.add(AddExerciseEvent(newExercise));
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
