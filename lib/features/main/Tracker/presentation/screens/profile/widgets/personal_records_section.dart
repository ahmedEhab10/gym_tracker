import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';

class PersonalRecordsSection extends StatelessWidget {
  const PersonalRecordsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Records',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildRecordCard(Icons.emoji_events, 'BENCH PRESS', '225 lbs'),
              SizedBox(width: 16.w),
              _buildRecordCard(Icons.fitness_center, 'SQUAT', '315 lbs'),
              SizedBox(width: 16.w),
              _buildRecordCard(Icons.arrow_upward, 'DEADLIFT', '405 lbs'), // Just adding an extra record for horizontal scroll indication
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecordCard(IconData icon, String exercise, String weight) {
    return Container(
      width: 140.w,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          SizedBox(height: 16.h),
          Text(
            exercise,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            weight,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
