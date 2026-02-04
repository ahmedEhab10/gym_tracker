import 'package:get_it/get_it.dart';
import 'package:try_my_tracker/data/datasources/local/hive_service.dart';
import 'package:try_my_tracker/data/datasources/local/exercise_local_datasource.dart';
import 'package:try_my_tracker/data/datasources/local/weekly_schedule_local_datasource.dart';
import 'package:try_my_tracker/data/repositories/exercise_repository_impl.dart';
import 'package:try_my_tracker/data/repositories/weekly_schedule_repository_impl.dart';
import 'package:try_my_tracker/domain/repositories/exercise_repository.dart';
import 'package:try_my_tracker/domain/repositories/weekly_schedule_repository.dart';
import 'package:try_my_tracker/domain/usecases/exercise/exercise_usecases.dart';
import 'package:try_my_tracker/domain/usecases/exercise/get_exercise_history.dart';
import 'package:try_my_tracker/domain/usecases/schedule/get_weekly_schedule.dart';
import 'package:try_my_tracker/domain/usecases/schedule/update_day_name.dart';
import 'package:try_my_tracker/features/Tracker/presentation/blocs/exercise/exercise_bloc.dart';
import 'package:try_my_tracker/features/Tracker/presentation/blocs/exercise_detail/exercise_detail_bloc.dart';
import 'package:try_my_tracker/features/Tracker/presentation/blocs/weekly_schedule/weekly_schedule_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Features - Exercise
  // Bloc
  // UseCases
  sl.registerLazySingleton(() => GetExercisesForDay(sl()));
  sl.registerLazySingleton(() => AddExercise(sl()));
  // Blocs
  sl.registerFactory(
    () => ExerciseBloc(getExercisesForDay: sl(), addExercise: sl()),
  );

  sl.registerFactory(
    () =>
        ExerciseDetailBloc(getExerciseHistory: sl(), exerciseRepository: sl()),
  );

  sl.registerLazySingleton(() => GetExerciseHistory(sl()));

  // Repository
  sl.registerLazySingleton<ExerciseRepository>(
    () => ExerciseRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ExerciseLocalDataSource>(
    () => ExerciseLocalDataSourceImpl(hiveService: sl()),
  );

  // ! Features - Weekly Schedule
  // Blocs
  sl.registerFactory(
    () => WeeklyScheduleBloc(getWeeklySchedule: sl(), updateDayName: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetWeeklySchedule(sl()));
  sl.registerLazySingleton(() => UpdateDayName(sl()));

  // Repository
  sl.registerLazySingleton<WeeklyScheduleRepository>(
    () => WeeklyScheduleRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton(() => WeeklyScheduleLocalDataSource(sl()));

  // ! Core
  // NetworkInfo, etc.

  // ! External
  // Hive Boxes registration will go here
  final hiveService = HiveService();
  await hiveService.init();
  sl.registerLazySingleton(() => hiveService);
}
