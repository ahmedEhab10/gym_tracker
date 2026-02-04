import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/di/injection_container.dart';
import 'package:try_my_tracker/core/routes/app_routes.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/features/Tracker/presentation/blocs/exercise/exercise_bloc.dart';
import 'package:try_my_tracker/features/Tracker/presentation/blocs/exercise/exercise_event.dart';
import 'package:try_my_tracker/features/Tracker/presentation/blocs/exercise/exercise_state.dart';
import 'package:try_my_tracker/core/widgets/common/custom_button.dart';
import 'package:try_my_tracker/core/widgets/common/custom_text_field.dart';
import 'package:try_my_tracker/features/Tracker/presentation/widgets/exercise_card.dart';
import 'package:uuid/uuid.dart';
import 'package:try_my_tracker/domain/entities/exercise.dart';

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
        floatingActionButton: Builder(
          builder: (ctx) {
            // Use Builder to get context with BlocProvider
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
