import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/core/widgets/common/custom_button.dart';
import 'package:try_my_tracker/features/Tracker/presentation/screens/home/widgets/Home_Screen_apper.dart';
import 'package:try_my_tracker/features/Tracker/presentation/screens/home/widgets/work_out_info_card.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeScreenApper(),
          SizedBox(height: 20.h),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Welcome back, ',
                  style: GoogleFonts.spaceGrotesk(
                    letterSpacing: -1,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextSpan(
                  text: 'Ahmed ',
                  style: GoogleFonts.spaceGrotesk(
                    letterSpacing: -1,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // Dynamic Daily Schedule
          Text(
            'Ready to crush your goals today?',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),

          CustomButton(
            height: 60.h,
            label: 'Start Workout',
            onPressed: () {},
            borderradius: 80.r,
          ),
          SizedBox(height: 16.h),

          Text(
            'Quick Stats',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),

          WorkOutInfoCard(),
        ],
      ),
    );
  }
}



 // Container(
            //   height: 80.h,
            //   width: 80.w,
            //   decoration: BoxDecoration(
            //     border: Border.all(),
            //     color: AppColors.primary,
            //     borderRadius: BorderRadius.circular(100.r),
            //   ),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(100.r),
            //     child: Image.asset(
            //       width: 60.w,
            //       height: 60.h,
            //       'assets/images/onboard1.jpg',
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),