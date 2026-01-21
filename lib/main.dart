import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:try_my_tracker/core/routes/app_routes.dart';
import 'package:try_my_tracker/core/routes/router.dart';
import 'package:try_my_tracker/core/di/injection_container.dart' as di;
import 'package:try_my_tracker/features/Tracker/presentation/screens/home/today_workout_screen.dart';

import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(373.6, 812),
      child: MaterialApp(
        title: 'Gym Progress Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,

        initialRoute: AppRoutes.splash,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
