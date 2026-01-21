import 'package:flutter/material.dart';
import 'package:try_my_tracker/core/routes/app_routes.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';

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
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "My Tracker",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
  }
}
