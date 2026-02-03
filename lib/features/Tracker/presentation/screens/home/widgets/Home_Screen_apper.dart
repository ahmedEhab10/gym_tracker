import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';

class HomeScreenApper extends StatelessWidget {
  const HomeScreenApper({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(2.w), // Controls the thickness of the frame
          decoration: BoxDecoration(
            color: AppColors.primary, // The color of the frame
            borderRadius: BorderRadius.circular(
              100,
            ), // Optional: rounds the corners
          ),
          child: ClipRRect(
            // Clips the image to match the container's rounded corners
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              'assets/images/onboard1.jpg', // Replace with your image asset path
              width: 55.w,
              height: 55.h,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'FRIDAY',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            Text(
              'Pull Day',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textPrimary),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(Icons.notifications),
          ),
        ),
      ],
    );
  }
}
