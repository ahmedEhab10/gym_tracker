import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:try_my_tracker/data/models/exercise_model.dart';

import 'package:try_my_tracker/data/models/exercise_set_model.dart';

import 'package:try_my_tracker/data/models/program_model.dart';

import 'package:try_my_tracker/data/models/training_day_model.dart';

import 'package:try_my_tracker/data/models/workout_session_model.dart';

import 'package:try_my_tracker/data/models/weekly_schedule_model.dart';

import 'package:try_my_tracker/data/models/exercise_library_model.dart';

class HiveService {
  static const String programBoxName = 'programs';
  static const String trainingDayBoxName = 'training_days';
  static const String exerciseBoxName = 'exercises';
  static const String exerciseSetBoxName = 'exercise_sets';
  static const String workoutSessionBoxName = 'workout_sessions';
  static const String weeklyScheduleBoxName = 'weekly_schedule';
  static const String exerciseLibraryBoxName = 'exercise_library';
  static const String metadataBoxName = 'metadata';

  Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(ProgramModelAdapter());
    Hive.registerAdapter(TrainingDayModelAdapter());
    Hive.registerAdapter(ExerciseModelAdapter());
    Hive.registerAdapter(ExerciseSetModelAdapter());
    Hive.registerAdapter(WorkoutSessionModelAdapter());

    // Register ExerciseLibraryModel adapter
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(ExerciseLibraryModelAdapter());
    }

    // Register WeeklyScheduleModel adapter with error handling
    try {
      if (!Hive.isAdapterRegistered(5)) {
        Hive.registerAdapter(WeeklyScheduleModelAdapter());
      }
    } catch (e) {
      print('Error registering WeeklyScheduleModelAdapter: $e');
    }

    // Open Boxes
    await Future.wait([
      Hive.openBox<ProgramModel>(programBoxName),
      Hive.openBox<TrainingDayModel>(trainingDayBoxName),
      Hive.openBox<ExerciseModel>(exerciseBoxName),
      Hive.openBox<ExerciseSetModel>(exerciseSetBoxName),
      Hive.openBox<WorkoutSessionModel>(workoutSessionBoxName),
      Hive.openBox<ExerciseLibraryModel>(exerciseLibraryBoxName),
      Hive.openBox(metadataBoxName), // For storing seeding flags
    ]);

    // Open WeeklySchedule box with error handling for migration
    try {
      await Hive.openBox<WeeklyScheduleModel>(weeklyScheduleBoxName);
    } catch (e) {
      print('Error opening weekly schedule box, deleting old data: $e');
      // Delete the corrupted box and create a new one
      await Hive.deleteBoxFromDisk(weeklyScheduleBoxName);
      await Hive.openBox<WeeklyScheduleModel>(weeklyScheduleBoxName);
    }
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
  Box<WeeklyScheduleModel> get weeklyScheduleBox =>
      Hive.box<WeeklyScheduleModel>(weeklyScheduleBoxName);
  Box<ExerciseLibraryModel> get exerciseLibraryBox =>
      Hive.box<ExerciseLibraryModel>(exerciseLibraryBoxName);
  Box get metadataBox => Hive.box(metadataBoxName);

  Future<void> close() async {
    await Hive.close();
  }
}
