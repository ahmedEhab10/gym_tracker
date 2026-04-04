import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:try_my_tracker/features/main/Tracker/presentation/widgets/exercise_card.dart';
import 'package:uuid/uuid.dart';
import 'package:try_my_tracker/domain/entities/exercise.dart';
import 'package:try_my_tracker/domain/usecases/workout/workout_usecases.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/home/home_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrainingDayDetailScreen extends StatelessWidget {
  final String dayName;
  final String dayId;
  final int dayIndex;

  const TrainingDayDetailScreen({
    super.key,
    required this.dayName,
    required this.dayId,
    required this.dayIndex,
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
      child: _TrainingDayDetailView(dayName: dayName, dayId: dayId, dayIndex: dayIndex),
    );
  }
}

class _TrainingDayDetailView extends StatelessWidget {
  final String dayName;
  final String dayId;
  final int dayIndex;

  const _TrainingDayDetailView({required this.dayName, required this.dayId, required this.dayIndex});

  void _showAddExerciseSheet(BuildContext context) {
    final exerciseBloc = context.read<ExerciseBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditExerciseSheet(dayId: dayId, exerciseBloc: exerciseBloc),
    );
  }

  void _showEditExerciseSheet(BuildContext context, Exercise exercise) {
    final exerciseBloc = context.read<ExerciseBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditExerciseSheet(
        dayId: dayId, 
        exerciseBloc: exerciseBloc, 
        exercise: exercise,
      ),
    );
  }

  Future<void> _cancelDay(BuildContext context, List<Exercise> exercises) async {
    final act = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cancel Day?', style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text('This will revert the day to a Rest Day and remove any exercises scheduled here. Are you sure?', style: GoogleFonts.spaceGrotesk(color: AppColors.textSecondary)),
        actions: [
          TextButton(
             onPressed: () => Navigator.pop(ctx, false),
             child: const Text('No'),
          ),
          ElevatedButton(
             style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
             onPressed: () => Navigator.pop(ctx, true),
             child: const Text('Yes, Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      )
    );
    if (act == true && context.mounted) {
      final bloc = context.read<ExerciseBloc>();
      for (var ex in exercises) {
        bloc.add(DeleteExerciseEvent(ex.id, dayId));
      }
      Navigator.pop(context, 'cancel_day');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, state) {
          final exercises = state is ExerciseLoaded ? state.exercises : <Exercise>[];
          final hasExercises = exercises.isNotEmpty;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ─── App Bar ─────────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 140.0,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.background,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.error),
                    tooltip: 'Cancel Day',
                    onPressed: () => _cancelDay(context, exercises),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dayName,
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.bold,
                          fontSize: 26.sp,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (hasExercises)
                        Text(
                          '${exercises.length} exercise${exercises.length != 1 ? 's' : ''}',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12.sp,
                            color: AppColors.primary.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFF1A2A14),
                          AppColors.background,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ─── Content ──────────────────────────────────────────────────
              if (state is ExerciseLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              else if (state is ExerciseError)
                SliverFillRemaining(
                  child: _ErrorState(message: state.message),
                )
              else if (!hasExercises)
                SliverFillRemaining(
                  child: _EmptyState(
                    onAddPressed: () => _showAddExerciseSheet(context),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final exercise = exercises[index];
                        return ExerciseCard(
                          exercise: exercise,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.exerciseDetail,
                              arguments: exercise,
                            );
                          },
                          onEdit: () => _showEditExerciseSheet(context, exercise),
                        );
                      },
                      childCount: exercises.length,
                    ),
                  ),
                ),

              // Extra padding for FAB + bottom bar
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          );
        },
      ),

      // ─── FAB: single "add exercise" entry point ───────────────────────────
      floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddExerciseSheet(context),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.black,
            elevation: 4,
            icon: const Icon(Icons.add_rounded, size: 22),
            label: Text(
              'Add Exercise',
              style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
            ),
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // ─── Bottom Bar ───────────────────────────────────────────────────────
      bottomNavigationBar: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, exerciseState) {
          final hasExercises =
              exerciseState is ExerciseLoaded && exerciseState.exercises.isNotEmpty;

          return BlocBuilder<WorkoutTimerCubit, WorkoutTimerState>(
            builder: (context, timerState) {
              return _BottomBar(
                hasExercises: hasExercises,
                timerState: timerState,
                onStart: () async {
                  final startWorkout = sl<StartWorkout>();
                  final result = await startWorkout(dayId);
                  result.fold(
                    (failure) => null, // Potentially show error
                    (session) => context.read<WorkoutTimerCubit>().startWorkout(session.id),
                  );
                },
                onFinish: () async {
                  if (timerState is WorkoutInProgress) {
                    final duration = timerState.durationSeconds;
                    final sessionId = timerState.sessionId;
                    final completeWorkout = sl<CompleteWorkout>();
                    await completeWorkout(CompleteWorkoutParams(sessionId: sessionId));
                    
                    if (context.mounted) {
                      context.read<WorkoutTimerCubit>().finishWorkout();
                      _showFinishDialog(context, duration);
                      
                      // Refresh Home Data if possible (HomeBloc should be global)
                      try {
                        context.read<HomeBloc>().add(LoadHomeData());
                      } catch (_) {
                        // HomeBloc might not be in context yet if we haven't refactored it
                      }
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showFinishDialog(BuildContext context, int duration) {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    final label = minutes > 0
        ? '$minutes min ${seconds > 0 ? '$seconds sec' : ''}'
        : '$seconds sec';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Workout Complete!',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Great job! You worked out for $label.',
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    context.read<WorkoutTimerCubit>().reset();
                  },
                  child: Text(
                    'Close',
                    style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Bar
// ─────────────────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final bool hasExercises;
  final WorkoutTimerState timerState;
  final VoidCallback onStart;
  final VoidCallback onFinish;

  const _BottomBar({
    required this.hasExercises,
    required this.timerState,
    required this.onStart,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(
          top: BorderSide(
            color: AppColors.textHint.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      child: timerState is WorkoutInProgress
          ? _buildRunningBar(context, timerState as WorkoutInProgress)
          : _buildIdleBar(context),
    );
  }

  Widget _buildIdleBar(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!hasExercises) ...[
          Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: AppColors.warning, size: 16),
              const SizedBox(width: 6),
              Text(
                'Add exercises before starting a workout',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12.sp,
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: hasExercises ? onStart : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              disabledBackgroundColor: AppColors.surface,
              disabledForegroundColor: AppColors.textHint,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            icon: const Icon(Icons.play_arrow_rounded, size: 22),
            label: Text(
              'Start Workout',
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRunningBar(BuildContext context, WorkoutInProgress state) {
    final duration = state.durationSeconds;
    final hours = duration ~/ 3600;
    final minutes = ((duration % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration % 60).toString().padLeft(2, '0');
    final timeLabel = hours > 0
        ? '${hours.toString().padLeft(2, '0')}:$minutes:$seconds'
        : '$minutes:$seconds';

    return Row(
      children: [
        // Timer display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_rounded, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                timeLabel,
                style: GoogleFonts.spaceMono(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Finish button
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: onFinish,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error.withValues(alpha: 0.15),
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error.withValues(alpha: 0.4)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              icon: const Icon(Icons.stop_rounded, size: 20),
              label: Text(
                'Finish',
                style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty & Error States
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onAddPressed;

  const _EmptyState({required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.fitness_center_rounded,
                size: 44,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No exercises yet',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "Add Exercise" below to start building your workout plan.',
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48),
          const SizedBox(height: 12),
          Text(
            message,
            style: GoogleFonts.spaceGrotesk(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add Exercise Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _EditExerciseSheet extends StatefulWidget {
  final String dayId;
  final ExerciseBloc exerciseBloc;
  final Exercise? exercise;

  const _EditExerciseSheet({required this.dayId, required this.exerciseBloc, this.exercise});

  @override
  State<_EditExerciseSheet> createState() => _EditExerciseSheetState();
}

class _EditExerciseSheetState extends State<_EditExerciseSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController youtubeController;
  late final TextEditingController setsController;
  List<String> selectedImagePaths = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.exercise?.name);
    descriptionController = TextEditingController(text: widget.exercise?.description);
    youtubeController = TextEditingController(text: widget.exercise?.youtubeLink);
    setsController = TextEditingController(text: widget.exercise?.defaultSetsCount.toString() ?? '3');
    if (widget.exercise?.imagePaths != null) {
      selectedImagePaths = List.from(widget.exercise!.imagePaths!);
    } else if (widget.exercise?.imagePath != null) {
      selectedImagePaths = [widget.exercise!.imagePath!];
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    youtubeController.dispose();
    setsController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        selectedImagePaths.addAll(pickedFiles.map((f) => f.path));
      });
    }
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);

    if (widget.exercise != null) {
      final updatedExercise = widget.exercise!.copyWith(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        imagePath: selectedImagePaths.isNotEmpty ? selectedImagePaths.first : null,
        imagePaths: selectedImagePaths.isNotEmpty ? selectedImagePaths : null,
        youtubeLink: youtubeController.text.trim().isEmpty ? null : youtubeController.text.trim(),
        defaultSetsCount: int.tryParse(setsController.text) ?? 3,
      );
      widget.exerciseBloc.add(UpdateExerciseEvent(updatedExercise));
    } else {
      final newExercise = Exercise(
        id: const Uuid().v4(),
        trainingDayId: widget.dayId,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        orderIndex: 0,
        imagePath: selectedImagePaths.isNotEmpty ? selectedImagePaths.first : null,
        imagePaths: selectedImagePaths.isNotEmpty ? selectedImagePaths : null,
        youtubeLink: youtubeController.text.trim().isEmpty ? null : youtubeController.text.trim(),
        defaultSetsCount: int.tryParse(setsController.text) ?? 3,
        lastUsedWeight: null,
      );
      widget.exerciseBloc.add(AddExerciseEvent(newExercise));
    }
    
    Navigator.pop(context);
  }

  void _delete() {
    if (widget.exercise != null) {
      widget.exerciseBloc.add(DeleteExerciseEvent(widget.exercise!.id, widget.dayId));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ── Drag handle ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 4),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textHint.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // ── Header ───────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        widget.exercise != null ? 'Edit Exercise' : 'New Exercise',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          shape: const CircleBorder(),
                        ),
                        icon: const Icon(Icons.close_rounded,
                            color: AppColors.textSecondary, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                const Divider(color: Color(0xFF2C2C2C), height: 1),

                // ── Scrollable fields ─────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Images picker
                        _buildSectionLabel('Exercise Images (Optional)'),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 110,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              GestureDetector(
                                onTap: _pickImages,
                                child: Container(
                                  width: 110,
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.textHint.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_rounded,
                                        size: 36,
                                        color: AppColors.primary.withValues(alpha: 0.5),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Add Images',
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 12.sp,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ...selectedImagePaths.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final path = entry.value;
                                return Container(
                                  width: 110,
                                  margin: const EdgeInsets.only(left: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(
                                      image: FileImage(File(path)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedImagePaths.removeAt(idx);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          child: const Icon(
                                            Icons.close_rounded,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }), // Use .toList() if Dart complains, but map is usually fine
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Name field
                        _buildSectionLabel('Exercise Name *'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: nameController,
                          hint: 'e.g., Bench Press',
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                        ),

                        const SizedBox(height: 20),

                        // Description
                        _buildSectionLabel('Description'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: descriptionController,
                          hint: 'e.g., Focus on form, keep elbows tucked',
                          maxLines: 2,
                        ),

                        const SizedBox(height: 20),

                        // Sets + YouTube in a row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionLabel('Sets'),
                                  const SizedBox(height: 8),
                                  _buildTextField(
                                    controller: setsController,
                                    hint: '3',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (v) {
                                      final n = int.tryParse(v ?? '');
                                      if (n == null || n < 1) return 'Min 1';
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Flexible(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionLabel('YouTube Link'),
                                  const SizedBox(height: 8),
                                  _buildTextField(
                                    controller: youtubeController,
                                    hint: 'https://youtube.com/...',
                                    keyboardType: TextInputType.url,
                                    prefixIcon: const Icon(
                                      Icons.play_circle_outline_rounded,
                                      color: AppColors.textHint,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // ── Save button ───────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    MediaQuery.of(context).viewInsets.bottom +
                        MediaQuery.of(context).padding.bottom +
                        16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation(Colors.black)),
                            )
                          : Text(
                              'Save Exercise',
                              style: GoogleFonts.spaceGrotesk(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                    ),
                  ),
                ),
                if (widget.exercise != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      MediaQuery.of(context).viewInsets.bottom +
                          MediaQuery.of(context).padding.bottom +
                          16,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton(
                        onPressed: _delete,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          'Delete Exercise',
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.spaceGrotesk(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    Widget? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: GoogleFonts.spaceGrotesk(
        color: Colors.white,
        fontSize: 15.sp,
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon,
        hintStyle: GoogleFonts.spaceGrotesk(
          color: AppColors.textHint,
          fontSize: 14.sp,
        ),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.textHint.withValues(alpha: 0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
