import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/domain/entities/home_dashboard_data.dart';
import 'package:intl/intl.dart';

class WorkOutInfoCard extends StatelessWidget {
  final RecentWorkoutData? lastWorkout;

  const WorkOutInfoCard({super.key, this.lastWorkout});

  @override
  Widget build(BuildContext context) {
    if (lastWorkout == null) {
      // Fallback UI if no workout exists
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color.fromARGB(101, 255, 255, 255),
            width: 0.9.w,
          ),
        ),
        child: Text(
          "No workouts yet",
          style: GoogleFonts.spaceGrotesk(color: AppColors.textSecondary),
        ),
      );
    }

    final workout = lastWorkout!;

    // Format date relative or absolute? Old UI said "Yasterday" [sic].
    // Let's use simple logic: Today, Yesterday, or Date.
    String dateString;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final workoutDate = DateTime(
      workout.date.year,
      workout.date.month,
      workout.date.day,
    );

    if (workoutDate == today) {
      dateString = "Today";
    } else if (workoutDate == today.subtract(const Duration(days: 1))) {
      dateString = "Yesterday";
    } else {
      dateString = DateFormat('MMM d').format(workout.date);
    }

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
            Text(
              'Last Workout',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),

            Row(
              children: [
                Text(
                  '${workout.durationMinutes}',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  ' min',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Text(
                  '$dateString.',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '  ${workout.dayName}', // e.g. "Back & Biceps" if we had it, but we have day name
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
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
