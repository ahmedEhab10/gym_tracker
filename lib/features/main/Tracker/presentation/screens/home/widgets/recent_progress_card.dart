import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/domain/entities/home_dashboard_data.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/home/widgets/exrcies_continar.dart';

class RecentProgressCard extends StatelessWidget {
  final RecentWorkoutData data;

  const RecentProgressCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color.fromARGB(101, 255, 255, 255),
          width: 1.w,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
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
                      data.dayName,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    Text(
                      DateFormat('MMMM d, y').format(data.date),
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
                      '${data.maxWeight.toStringAsFixed(1)} kg',
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

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ...data.exerciseNames.map(
                    (name) => Padding(
                      padding: EdgeInsets.only(right: 26.w),
                      child: ExrciesContinar(title: name),
                    ),
                  ),
                  if (data.exerciseNames.isEmpty)
                    Text(
                      "No exercises recorded",
                      style: GoogleFonts.spaceGrotesk(
                        color: AppColors.textHint,
                        fontSize: 12.sp,
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            Row(
              children: [
                const Icon(Icons.timer, color: AppColors.textHint),
                SizedBox(width: 8.w),
                Text(
                  '${data.durationMinutes} min total duration',
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
