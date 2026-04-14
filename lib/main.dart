import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_my_tracker/core/routes/app_routes.dart';
import 'package:try_my_tracker/core/routes/router.dart';
import 'package:try_my_tracker/core/di/injection_container.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/home/home_bloc.dart';

import 'core/theme/app_theme.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Run DI init and SharedPreferences lookup in parallel
  final results = await Future.wait([
    di.init(),
    SharedPreferences.getInstance(),
  ]);

  // Determine initial route
  final prefs = results[1] as SharedPreferences;
  final hasCompletedSetup = prefs.getBool('has_completed_setup') ?? false;
  final initialRoute = hasCompletedSetup
      ? AppRoutes.mainLayout
      : AppRoutes.welcome;

  runApp(MyApp(initialRoute: initialRoute));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(373.6, 812),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [BlocProvider(create: (context) => di.sl<HomeBloc>())],
          child: MaterialApp(
            title: 'Hobix Tracker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            initialRoute: initialRoute,
            onGenerateRoute: RouteGenerator.generateRoute,
          ),
        );
      },
    );
  }
}
