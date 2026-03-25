import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:try_my_tracker/core/routes/app_routes.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenBody extends StatefulWidget {
  const SplashScreenBody({super.key});

  @override
  State<SplashScreenBody> createState() => _SplashScreenBodyState();
}

class _SplashScreenBodyState extends State<SplashScreenBody> {
  @override
  void initState() {
    navigateToHome();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            'assets/images/splash_screen_logo.png',
            width: 350.w, // Adjust size as necessary
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Future<void> navigateToHome() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedSetup = prefs.getBool('has_completed_setup') ?? false;

    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      if (hasCompletedSetup) {
        Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.welcome);
      }
    }
  }
}
