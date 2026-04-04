import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/domain/entities/exercise.dart';
import 'package:try_my_tracker/domain/entities/exercise_set.dart';
import 'package:try_my_tracker/domain/entities/exercise_history.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise_detail/exercise_detail_bloc.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise_detail/exercise_detail_event.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/exercise/widgets/set_row_item.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/widgets/rest_timer_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentSessionSection extends StatelessWidget {
  final Exercise exercise;
  final List<ExerciseSet> currentSets;
  final ExerciseHistory history;

  const CurrentSessionSection({
    super.key,
    required this.exercise,
    required this.currentSets,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    double totalVolume = 0;
    for (var set in currentSets) {
      if (set.isCompleted) {
        totalVolume += (set.reps * set.weight);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Session',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total Volume: ${totalVolume.toStringAsFixed(0)} kg',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.timer_outlined,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const RestTimerDialog(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...currentSets.asMap().entries.map(
          (entry) =>
              SetRowItem(set: entry.value, history: history, index: entry.key),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 20),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.card,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final newSet = ExerciseSet(
                    id: const Uuid().v4(),
                    exerciseId: exercise.id,
                    setNumber: currentSets.length + 1,
                    reps: 10,
                    weight: exercise.lastUsedWeight ?? 0,
                    isCompleted: false,
                  );
                  context.read<ExerciseDetailBloc>().add(AddSet(newSet));
                },
                label: const Text(
                  'Add Set',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check, size: 20, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  context.read<ExerciseDetailBloc>().add(
                    const FinishExercise(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Exercise Finished and Saved!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                },
                label: const Text(
                  'Finish Exercise',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40), // Bottom padding
      ],
    );
  }
}
