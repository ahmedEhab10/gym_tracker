import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/core/di/injection_container.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/domain/entities/exercise.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise_detail/exercise_detail_bloc.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise_detail/exercise_detail_event.dart';
import 'package:try_my_tracker/domain/entities/exercise_set.dart';
import 'package:try_my_tracker/domain/entities/exercise_history.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise_detail/exercise_detail_state.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/widgets/rest_timer_dialog.dart';
import 'package:uuid/uuid.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ExerciseDetailBloc>()..add(LoadExerciseDetail(widget.exercise)),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.exercise.name)),
        body: BlocBuilder<ExerciseDetailBloc, ExerciseDetailState>(
          builder: (context, state) {
            if (state is ExerciseDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExerciseDetailLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.exercise.imagePath != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: state.exercise.imagePath!.startsWith('assets')
                            ? Image.asset(
                                state.exercise.imagePath!,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(state.exercise.imagePath!),
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Text(
                      state.exercise.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.exercise.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (state.exercise.youtubeLink != null) ...[
                      ElevatedButton.icon(
                        icon: const Icon(Icons.play_circle_fill),
                        label: const Text('Watch Instructions'),
                        onPressed: () async {
                          final url = Uri.parse(state.exercise.youtubeLink!);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    _buildStatsSummary(state),
                    const SizedBox(height: 24),
                    _buildHistoryComparison(state),
                    const SizedBox(height: 24),
                    _buildCurrentSession(context, state),
                  ],
                ),
              );
            } else if (state is ExerciseDetailError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildStatsSummary(ExerciseDetailLoaded state) {
    final stats = state.history.stats;
    return Card(
      color: AppColors.card,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Best Ever', '${stats.maxWeightEver} kg'),
            _buildStatItem(
              'Last Session',
              '${state.exercise.lastUsedWeight ?? "-"} kg',
            ),
            _buildStatItem(
              'Avg (Last 3)',
              '${stats.avgWeightLast3Sessions.toStringAsFixed(1)} kg',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildHistoryComparison(ExerciseDetailLoaded state) {
    final sessions = state.history.sessions.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Most Recent Weights',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (sessions.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No history yet',
              style: TextStyle(
                color: AppColors.textHint,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          Table(
            border: TableBorder.all(
              color: AppColors.textHint.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            children: [
              const TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Date',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Best Set',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Volume',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              ...sessions.map((session) {
                // Calculate session volume
                final volume = session.sets.fold<double>(
                  0,
                  (sum, set) => sum + (set.reps * set.weight),
                );

                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        _formatDate(session.date),
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${session.maxWeight} kg',
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${volume.toStringAsFixed(0)} kg',
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }

  Widget _buildCurrentSession(
    BuildContext context,
    ExerciseDetailLoaded state,
  ) {
    double totalVolume = 0;
    for (var set in state.currentSets) {
      if (set.isCompleted) {
        totalVolume += (set.reps * set.weight);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Total Volume: ${totalVolume.toStringAsFixed(0)} kg',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.timer, color: AppColors.primary),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const RestTimerDialog(),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...state.currentSets
            .map((set) => _buildSetRow(context, set, state.history))
            .toList(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  final newSet = ExerciseSet(
                    id: const Uuid().v4(),
                    exerciseId: widget.exercise.id,
                    setNumber: state.currentSets.length + 1,
                    reps: 10,
                    weight: widget.exercise.lastUsedWeight ?? 0,
                    isCompleted: false,
                  );
                  context.read<ExerciseDetailBloc>().add(AddSet(newSet));
                },
                child: const Text('Add Set'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () {
                  context.read<ExerciseDetailBloc>().add(FinishExercise());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Exercise Finished and Saved!'),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  'Finish Exercise',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSetRow(
    BuildContext context,
    ExerciseSet set,
    ExerciseHistory history,
  ) {
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
        indicatorIcon = Icons.arrow_forward;
        indicatorColor = Colors.grey;
      }
    }

    final setVolume = set.reps * set.weight;

    return Card(
      color: AppColors.card,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '${set.setNumber}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Weight Input
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    initialValue: set.weight.toString(),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      suffixText: 'kg',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (val) {
                      final weight = double.tryParse(val) ?? 0;
                      context.read<ExerciseDetailBloc>().add(
                        UpdateSet(set.copyWith(weight: weight)),
                      );
                    },
                  ),
                ),
                if (indicatorIcon != null) ...[
                  const SizedBox(width: 4),
                  Icon(indicatorIcon, size: 16, color: indicatorColor),
                ],
                const SizedBox(width: 12),
                // Reps Input
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: set.reps.toString(),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      prefixText: 'x ',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (val) {
                      final reps = int.tryParse(val) ?? 0;
                      context.read<ExerciseDetailBloc>().add(
                        UpdateSet(set.copyWith(reps: reps)),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    set.isCompleted
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: set.isCompleted ? Colors.green : AppColors.textHint,
                  ),
                  onPressed: () {
                    context.read<ExerciseDetailBloc>().add(
                      UpdateSet(set.copyWith(isCompleted: !set.isCompleted)),
                    );
                  },
                ),
              ],
            ),
            if (setVolume > 0)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, right: 48),
                  child: Text(
                    '${setVolume.toStringAsFixed(1)} kg',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textHint.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
