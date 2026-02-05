import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/features/Tracker/presentation/screens/home/widgets/exrcies_continar.dart';

class RecentProgressCard extends StatelessWidget {
  const RecentProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color.fromARGB(101, 255, 255, 255),
          width: 0.9.w,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Antarior A',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    Text(
                      'june 5, 2026',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '150 kg',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),

                    Text(
                      'Max Weight',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ExrciesContinar(title: 'Deadlift'),

                ExrciesContinar(title: 'Squat'),

                ExrciesContinar(title: 'Bench Press'),
              ],
            ),
            SizedBox(height: 12.h),

            Row(
              children: [
                Icon(Icons.timer, color: AppColors.textHint),
                SizedBox(width: 8.w),
                Text(
                  '45 min total duration',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
