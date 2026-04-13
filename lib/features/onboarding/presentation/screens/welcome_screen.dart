import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/routes/app_routes.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/features/onboarding/data/models/onboarding_item.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final item in OnboardingItem.items) {
        precacheImage(AssetImage(item.image), context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),

              // Logo
              Center(
                child: Image.asset(
                  'assets/images/White_and_black_Fitness_gym_logo__1_-removebg-preview.png',
                  height: 180.h,
                  fit: BoxFit.contain,
                ),
              ).animate().fade(duration: 600.ms).scale(begin: const Offset(0.8, 0.8), duration: 600.ms, curve: Curves.easeOutBack),

              // Headline
              Text(
                'Train smarter.\nTrack everything.',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ).animate().fade(delay: 300.ms, duration: 500.ms).slideY(begin: 0.1, duration: 500.ms),

              SizedBox(height: 16.h),

              // Subtitle
              Text(
                'Log your workouts, monitor your body measurements, and watch your progress unfold — one session at a time.',
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.textSecondary,
                  fontSize: 15.sp,
                  height: 1.65,
                ),
              ).animate().fade(delay: 500.ms, duration: 500.ms).slideY(begin: 0.1, duration: 500.ms),

              SizedBox(height: 40.h),

              // Feature list
              const _FeatureRow(
                icon: Icons.fitness_center_rounded,
                title: 'Workout Tracking',
                subtitle: 'Log sets, reps, and weights with ease.',
              ).animate().fade(delay: 700.ms, duration: 500.ms).slideX(begin: 0.05, duration: 500.ms),
              SizedBox(height: 18.h),
              const _FeatureRow(
                icon: Icons.straighten_rounded,
                title: 'Body Measurements',
                subtitle: 'Track your body composition over time.',
              ).animate().fade(delay: 850.ms, duration: 500.ms).slideX(begin: 0.05, duration: 500.ms),
              SizedBox(height: 18.h),
              const _FeatureRow(
                icon: Icons.calendar_today_rounded,
                title: 'Workout History',
                subtitle: 'See every session on a clear calendar.',
              ).animate().fade(delay: 1000.ms, duration: 500.ms).slideX(begin: 0.05, duration: 500.ms),

              const Spacer(flex: 3),

              // CTA Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.onboardingSlider,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
              ).animate().fade(delay: 1200.ms, duration: 500.ms).slideY(begin: 0.2, duration: 500.ms),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22.sp),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.textSecondary,
                  fontSize: 13.sp,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
