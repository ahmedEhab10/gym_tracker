import 'package:get_it/get_it.dart';
import 'package:try_my_tracker/data/datasources/local/hive_service.dart';
import 'package:try_my_tracker/data/datasources/local/exercise_local_datasource.dart';
import 'package:try_my_tracker/data/repositories/exercise_repository_impl.dart';
import 'package:try_my_tracker/domain/repositories/exercise_repository.dart';
import 'package:try_my_tracker/domain/usecases/exercise/exercise_usecases.dart';
import 'package:try_my_tracker/domain/usecases/exercise/get_exercise_history.dart';
import 'package:try_my_tracker/features/Tracker/presentation/blocs/exercise/exercise_bloc.dart';
import 'package:try_my_tracker/features/Tracker/presentation/blocs/exercise_detail/exercise_detail_bloc.dart';

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

  // ! Core
  // NetworkInfo, etc.

  // ! External
  // Hive Boxes registration will go here
  final hiveService = HiveService();
  await hiveService.init();
  sl.registerLazySingleton(() => hiveService);
}
