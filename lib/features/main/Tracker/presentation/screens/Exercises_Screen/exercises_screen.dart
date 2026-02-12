import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/core/di/injection_container.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/exercise_library/exercise_library_cubit.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/Exercises_Screen/widgets/exercises_screen_body.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExerciseLibraryCubit>(),
      child: const ExercisesScreenBody(),
    );
  }
}
