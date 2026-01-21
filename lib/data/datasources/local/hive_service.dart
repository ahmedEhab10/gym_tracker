import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:try_my_tracker/data/models/exercise_model.dart';

import 'package:try_my_tracker/data/models/exercise_set_model.dart';

import 'package:try_my_tracker/data/models/program_model.dart';

import 'package:try_my_tracker/data/models/training_day_model.dart';

import 'package:try_my_tracker/data/models/workout_session_model.dart';

class HiveService {
  static const String programBoxName = 'programs';
  static const String trainingDayBoxName = 'training_days';
  static const String exerciseBoxName = 'exercises';
  static const String exerciseSetBoxName = 'exercise_sets';
  static const String workoutSessionBoxName = 'workout_sessions';

  Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(ProgramModelAdapter());
    Hive.registerAdapter(TrainingDayModelAdapter());
    Hive.registerAdapter(ExerciseModelAdapter());
    Hive.registerAdapter(ExerciseSetModelAdapter());
    Hive.registerAdapter(WorkoutSessionModelAdapter());

    // Open Boxes
    await Future.wait([
      Hive.openBox<ProgramModel>(programBoxName),
      Hive.openBox<TrainingDayModel>(trainingDayBoxName),
      Hive.openBox<ExerciseModel>(exerciseBoxName),
      Hive.openBox<ExerciseSetModel>(exerciseSetBoxName),
      Hive.openBox<WorkoutSessionModel>(workoutSessionBoxName),
    ]);
  }

  Box<ProgramModel> get programBox => Hive.box<ProgramModel>(programBoxName);
  Box<TrainingDayModel> get trainingDayBox =>
      Hive.box<TrainingDayModel>(trainingDayBoxName);
  Box<ExerciseModel> get exerciseBox =>
      Hive.box<ExerciseModel>(exerciseBoxName);
  Box<ExerciseSetModel> get exerciseSetBox =>
      Hive.box<ExerciseSetModel>(exerciseSetBoxName);
  Box<WorkoutSessionModel> get workoutSessionBox =>
      Hive.box<WorkoutSessionModel>(workoutSessionBoxName);

  Future<void> close() async {
    await Hive.close();
  }
}
