import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/domain/entities/exercise_set.dart';
import 'package:try_my_tracker/domain/entities/exercise_history.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise_detail/exercise_detail_bloc.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise_detail/exercise_detail_event.dart'; // Import Event

class SetRowItem extends StatelessWidget {
  final ExerciseSet set;
  final ExerciseHistory history;
  final int index;

  const SetRowItem({
    super.key,
    required this.set,
    required this.history,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final previousSession = history.sessions.isNotEmpty
        ? history.sessions.first
        : null;
    final previousSet = previousSession?.sets.firstWhere(
      (s) => s.setNumber == set.setNumber,
      orElse: () => ExerciseSet.empty(),
    );

    final hasPrevious = previousSet != null && previousSet.id.isNotEmpty;

    IconData? indicatorIcon;
    Color indicatorColor = Colors.grey;

    if (hasPrevious) {
      if (set.weight > previousSet.weight) {
        indicatorIcon = Icons.arrow_upward;
        indicatorColor = Colors.green;
      } else if (set.weight < previousSet.weight) {
        indicatorIcon = Icons.arrow_downward;
        indicatorColor = Colors.red;
      } else {
        indicatorIcon = Icons.remove;
        indicatorColor = Colors.grey.withOpacity(0.5);
      }
    }

    final setVolume = set.reps * set.weight;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: set.isCompleted
              ? AppColors.primary.withOpacity(0.5)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${set.setNumber}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Weight Input
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Weight",
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textHint,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        initialValue: set.weight.toString(),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          suffixText: 'kg',
                          suffixStyle: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textHint,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (val) {
                          final weight = double.tryParse(val) ?? 0;
                          context.read<ExerciseDetailBloc>().add(
                            UpdateSet(set.copyWith(weight: weight)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (indicatorIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(indicatorIcon, size: 16, color: indicatorColor),
                  const SizedBox(width: 8),
                ] else
                  const SizedBox(width: 32), // Spacer if no icon
                // Reps Input
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Reps",
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textHint,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        initialValue: set.reps.toString(),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (val) {
                          final reps = int.tryParse(val) ?? 0;
                          context.read<ExerciseDetailBloc>().add(
                            UpdateSet(set.copyWith(reps: reps)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    context.read<ExerciseDetailBloc>().add(
                      UpdateSet(set.copyWith(isCompleted: !set.isCompleted)),
                    );
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: set.isCompleted
                          ? AppColors.primary
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: set.isCompleted
                            ? Colors.transparent
                            : AppColors.textHint.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      color: set.isCompleted
                          ? Colors.white
                          : AppColors.textHint.withOpacity(0.5),
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            if (setVolume > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.fitness_center,
                      size: 10,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Vol: ${setVolume.toStringAsFixed(1)} kg',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textHint.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
