import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/routes/app_routes.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/core/widgets/common/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/Hobix_app_logo.png',
              height: 250.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 8.h),
            Text(
              'PERFORMANCE',
              style: GoogleFonts.spaceGrotesk(
                letterSpacing: 3.5,
                fontWeight: FontWeight.bold,
                fontSize: 40.sp,
                color: Colors.white,
              ),
            ),
            Text(
              'LAB',
              style: GoogleFonts.spaceGrotesk(
                letterSpacing: 3.5,
                fontWeight: FontWeight.bold,
                fontSize: 40.sp,
                color: AppColors.primary,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.5.w,
                    color: AppColors.textSecondary,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
                Text(
                  'Track, Analyze, Improve',
                  style: GoogleFonts.spaceGrotesk(
                    letterSpacing: 3.5,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.5.w,
                    color: AppColors.textSecondary,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: CustomButton(
                borderradius: 34.r,
                label: 'Get Started',
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.onboardingSlider,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
