import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:try_my_tracker/core/errors/exceptions.dart';
import 'package:try_my_tracker/data/models/exercise_library_model.dart';
import 'package:try_my_tracker/data/datasources/local/hive_service.dart';

abstract class StaticExerciseDataSource {
  Future<void> seedExercisesIfNeeded();
  Future<List<ExerciseLibraryModel>> getAllExercises();
}

class StaticExerciseDataSourceImpl implements StaticExerciseDataSource {
  final HiveService hiveService;
  static const String _jsonPath = 'assets/data/exercises.json';
  static const String _seedKey = 'exercises_seeded';

  StaticExerciseDataSourceImpl({required this.hiveService});

  @override
  Future<void> seedExercisesIfNeeded() async {
    try {
      // Check if exercises have already been seeded
      final box = hiveService.exerciseLibraryBox;
      final metadata = hiveService.metadataBox;

      final alreadySeeded = metadata.get(_seedKey, defaultValue: false);

      if (!alreadySeeded && box.isEmpty) {
        // Load JSON file
        final String jsonString = await rootBundle.loadString(_jsonPath);
        final List<dynamic> jsonData = json.decode(jsonString);

        // Convert to models and store in Hive
        final exercises = jsonData
            .map((json) => ExerciseLibraryModel.fromJson(json))
            .toList();

        // Store all exercises
        for (var exercise in exercises) {
          await box.put(exercise.id, exercise);
        }

        // Mark as seeded
        await metadata.put(_seedKey, true);
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<ExerciseLibraryModel>> getAllExercises() async {
    try {
      final box = hiveService.exerciseLibraryBox;
      return box.values.toList();
    } catch (e) {
      throw CacheException();
    }
  }
}
