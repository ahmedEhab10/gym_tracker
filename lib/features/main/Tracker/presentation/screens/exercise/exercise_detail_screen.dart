import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/core/di/injection_container.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/domain/entities/exercise.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise_detail/exercise_detail_bloc.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise_detail/exercise_detail_event.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise_detail/exercise_detail_state.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/exercise/widgets/current_session_section.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/exercise/widgets/history_comparison_section.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/exercise/widgets/stats_summary_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dots_indicator/dots_indicator.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  int _currentImageIndex = 0;

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
              final images = (state.exercise.imagePaths != null && state.exercise.imagePaths!.isNotEmpty)
                  ? state.exercise.imagePaths!
                  : (state.exercise.imagePath != null ? [state.exercise.imagePath!] : <String>[]);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (images.isNotEmpty) ...[
                      SizedBox(
                        height: 200,
                        child: PageView.builder(
                          itemCount: images.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final path = images[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: path.startsWith('assets')
                                  ? Image.asset(path, fit: BoxFit.cover)
                                  : Image.file(File(path), fit: BoxFit.cover),
                            );
                          },
                        ),
                      ),
                      if (images.length > 1) ...[
                        const SizedBox(height: 12),
                        Center(
                          child: DotsIndicator(
                            dotsCount: images.length,
                            position: _currentImageIndex.toDouble(),
                            decorator: DotsDecorator(
                              activeColor: AppColors.primary,
                              color: AppColors.textHint.withValues(alpha: 0.3),
                              size: const Size.square(6.0),
                              activeSize: const Size(18.0, 6.0),
                              activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                    StatsSummaryCard(
                      exercise: state.exercise,
                      history: state.history,
                    ),
                    const SizedBox(height: 24),
                    HistoryComparisonSection(history: state.history),
                    const SizedBox(height: 24),
                    CurrentSessionSection(
                      exercise: state.exercise,
                      currentSets: state.currentSets,
                      history: state.history,
                    ),
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
}
