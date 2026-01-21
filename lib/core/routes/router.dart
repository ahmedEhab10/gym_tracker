import 'package:flutter/material.dart';
import 'package:try_my_tracker/core/routes/app_routes.dart';
import 'package:try_my_tracker/features/Splash/spalsh_screen.dart';
import 'package:try_my_tracker/features/Tracker/presentation/screens/program/program_list_screen.dart';
import 'package:try_my_tracker/features/Tracker/presentation/screens/schedule/training_day_detail_screen.dart';
import 'package:try_my_tracker/features/Tracker/presentation/screens/schedule/weekly_schedule_screen.dart';
import 'package:try_my_tracker/features/Tracker/presentation/screens/exercise/exercise_detail_screen.dart';
import 'package:try_my_tracker/features/main/main_layout.dart';
import 'package:try_my_tracker/features/onboarding/Screens/onboardin_Screens.dart';
import 'package:try_my_tracker/features/onboarding/onboarding.dart';
import 'package:try_my_tracker/domain/entities/exercise.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.mainLayout:
        return MaterialPageRoute(builder: (_) => const MainLayout());

      case AppRoutes.onboardinScreens:
        return MaterialPageRoute(builder: (_) => const OnboardinScreens());

      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const Onboarding());
      case AppRoutes.home:
        // For now, home can be TodayWorkout or ProgramList, defaulting to ProgramList based on previous user flow/edits
        // The user last changed home to ProgramListScreen in main.dart
        return MaterialPageRoute(builder: (_) => const ProgramListScreen());
      case AppRoutes.programList:
        return MaterialPageRoute(builder: (_) => const ProgramListScreen());
      case AppRoutes.weeklySchedule:
        return MaterialPageRoute(builder: (_) => const WeeklyScheduleScreen());
      case AppRoutes.trainingDayDetail:
        // Expected arguments: {'dayName': String, 'dayId': String}
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => TrainingDayDetailScreen(
            dayName: args['dayName'],
            dayId: args['dayId'],
          ),
        );
      case AppRoutes.exerciseDetail:
        final exercise = settings.arguments as Exercise;
        return MaterialPageRoute(
          builder: (_) => ExerciseDetailScreen(exercise: exercise),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('ERROR: Route not found')),
        );
      },
    );
  }
}
