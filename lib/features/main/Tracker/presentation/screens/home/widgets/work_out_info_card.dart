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
      return const _EmptyWorkoutStateCard();
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

class _EmptyWorkoutStateCard extends StatefulWidget {
  const _EmptyWorkoutStateCard();

  @override
  State<_EmptyWorkoutStateCard> createState() => _EmptyWorkoutStateCardState();
}

class _EmptyWorkoutStateCardState extends State<_EmptyWorkoutStateCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1 * _opacityAnimation.value),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2 * _opacityAnimation.value),
                        blurRadius: 16,
                        spreadRadius: 4,
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.directions_run_rounded,
                    color: AppColors.primary,
                    size: 40.sp,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 24.h),
          Text(
            "No Workouts Yet",
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Your fitness journey begins today.\nTap 'Start Workout' above to crush your goals!",
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
