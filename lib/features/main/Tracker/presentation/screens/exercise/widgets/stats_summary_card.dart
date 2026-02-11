import 'package:flutter/material.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/domain/entities/exercise.dart';
import 'package:try_my_tracker/domain/entities/exercise_history.dart';

class StatsSummaryCard extends StatelessWidget {
  final Exercise exercise;
  final ExerciseHistory history;

  const StatsSummaryCard({
    super.key,
    required this.exercise,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    final stats = history.stats;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Best Ever', '${stats.maxWeightEver} kg'),
          Container(
            height: 40,
            width: 1,
            color: AppColors.textHint.withOpacity(0.2),
          ),
          _buildStatItem(
            'Last Session',
            '${exercise.lastUsedWeight ?? "-"} kg',
          ),
          Container(
            height: 40,
            width: 1,
            color: AppColors.textHint.withOpacity(0.2),
          ),
          _buildStatItem(
            'Avg (Last 3)',
            '${stats.avgWeightLast3Sessions.toStringAsFixed(1)} kg',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
