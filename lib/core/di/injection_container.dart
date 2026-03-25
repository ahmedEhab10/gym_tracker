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
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise/exercise_bloc.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/exercise_detail/exercise_detail_bloc.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/weekly_schedule/weekly_schedule_bloc.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/program/program_bloc.dart';
import 'package:try_my_tracker/domain/usecases/program/program_usecases.dart';
import 'package:try_my_tracker/domain/repositories/program_repository.dart';
import 'package:try_my_tracker/data/repositories/program_repository_impl.dart';
import 'package:try_my_tracker/data/datasources/local/program_local_datasource.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/home/home_bloc.dart';
import 'package:try_my_tracker/features/main/Tracker/domain/usecases/get_home_dashboard_data.dart';
import 'package:try_my_tracker/domain/repositories/workout_repository.dart';
import 'package:try_my_tracker/data/repositories/workout_repository_impl.dart';
import 'package:try_my_tracker/data/datasources/local/workout_local_datasource.dart';
import 'package:try_my_tracker/domain/usecases/measurement_usecases.dart';
import 'package:try_my_tracker/domain/repositories/measurement_repository.dart';
import 'package:try_my_tracker/data/repositories/measurement_repository_impl.dart';
import 'package:try_my_tracker/data/datasources/local/measurement_local_datasource.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/measurement/measurement_cubit.dart';
import 'package:try_my_tracker/domain/usecases/profile_usecases.dart';
import 'package:try_my_tracker/domain/repositories/profile_repository.dart';
import 'package:try_my_tracker/data/repositories/profile_repository_impl.dart';
import 'package:try_my_tracker/data/datasources/local/profile_local_datasource.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/profile/profile_cubit.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/workout_history/workout_history_cubit.dart';
import 'package:uuid/uuid.dart';

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

  // ! Features - Program
  // Bloc
  sl.registerFactory(
    () => ProgramBloc(
      getPrograms: sl(),
      createProgram: sl(),
      updateProgram: sl(),
      deleteProgram: sl(),
      getTrainingDaysForProgram: sl(),
      addTrainingDay: sl(),
      deleteTrainingDay: sl(),
      uuid: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetPrograms(sl()));
  sl.registerLazySingleton(() => CreateProgram(sl()));
  sl.registerLazySingleton(() => UpdateProgram(sl()));
  sl.registerLazySingleton(() => DeleteProgram(sl()));
  sl.registerLazySingleton(() => GetTrainingDaysForProgram(sl()));
  sl.registerLazySingleton(() => AddTrainingDay(sl()));
  sl.registerLazySingleton(() => UpdateTrainingDay(sl()));
  sl.registerLazySingleton(() => DeleteTrainingDay(sl()));

  // Repository
  sl.registerLazySingleton<ProgramRepository>(
    () => ProgramRepositoryImpl(localDataSource: sl()),
  );

  // ! Features - Home
  // Bloc
  sl.registerFactory(() => HomeBloc(getHomeDashboardData: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetHomeDashboardData(sl(), sl()));

  // ! Features - Workout
  // Repository
  sl.registerLazySingleton<WorkoutRepository>(
    () => WorkoutRepositoryImpl(
      workoutLocalDataSource: sl(),
      exerciseLocalDataSource: sl(),
      uuid: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<WorkoutLocalDataSource>(
    () => WorkoutLocalDataSourceImpl(hiveService: sl()),
  );

  // ! Features - Program
  // Data sources
  sl.registerLazySingleton<ProgramLocalDataSource>(
    () => ProgramLocalDataSourceImpl(hiveService: sl(), uuid: sl()),
  );

  // ! Features - Measures
  // Bloc / Cubit
  sl.registerFactory(
    () => MeasurementCubit(
      getMeasurementsUseCase: sl(),
      saveMeasurementUseCase: sl(),
      deleteMeasurementUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMeasurements(sl()));
  sl.registerLazySingleton(() => SaveMeasurement(sl()));
  sl.registerLazySingleton(() => DeleteMeasurement(sl()));

  // Repository
  sl.registerLazySingleton<MeasurementRepository>(
    () => MeasurementRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<MeasurementLocalDataSource>(
    () => MeasurementLocalDataSourceImpl(hiveService: sl()),
  );

  // ! Features - Profile
  // Bloc / Cubit
  sl.registerFactory(
    () => ProfileCubit(
      getProfileUseCase: sl(),
      saveProfileUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => SaveProfile(sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(hiveService: sl()),
  );

  // ! Features - Workout History
  sl.registerFactory(
    () => WorkoutHistoryCubit(workoutRepository: sl(), hiveService: sl()),
  );

  // ! Core
  sl.registerLazySingleton(() => const Uuid());

  // ! External
  // Hive Boxes registration will go here
  final hiveService = HiveService();
  await hiveService.init();
  sl.registerLazySingleton(() => hiveService);
}
