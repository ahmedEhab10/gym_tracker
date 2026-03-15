import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/weekly_schedule/weekly_schedule_bloc.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/weekly_schedule/weekly_schedule_state.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/profile/profile_cubit.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/profile/profile_state.dart';

class HomeScreenApper extends StatelessWidget {
  const HomeScreenApper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeeklyScheduleBloc, WeeklyScheduleState>(
      builder: (context, state) {
        String dayName = 'TODAY';
        String workoutName = 'Loading...';

        if (state is WeeklyScheduleLoaded) {
          final todayIndex = DateTime.now().weekday - 1;
          final days = [
            'MONDAY',
            'TUESDAY',
            'WEDNESDAY',
            'THURSDAY',
            'FRIDAY',
            'SATURDAY',
            'SUNDAY',
          ];
          dayName = days[todayIndex];
          workoutName = state.schedule.dayNames[todayIndex] ?? 'Rest Day';
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, profileState) {
                String? profilePicPath;
                if (profileState is ProfileLoaded) {
                  profilePicPath = profileState.profile.profilePicturePath;
                }
                
                return Container(
                  padding: EdgeInsets.all(
                    2.w,
                  ), // Controls the thickness of the frame
                  decoration: BoxDecoration(
                    color: AppColors.primary, // The color of the frame
                    borderRadius: BorderRadius.circular(
                      100,
                    ), // Optional: rounds the corners
                  ),
                  child: ClipRRect(
                    // Clips the image to match the container's rounded corners
                    borderRadius: BorderRadius.circular(100),
                    child: profilePicPath != null && File(profilePicPath).existsSync()
                      ? Image.file(
                          File(profilePicPath),
                          width: 55.w,
                          height: 55.h,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/Ahmed_Ehab.jpg',
                          width: 55.w,
                          height: 55.h,
                          fit: BoxFit.cover,
                        ),
                  ),
                );
              },
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    dayName,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    workoutName,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.textPrimary),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.notifications),
              ),
            ),
          ],
        );
      },
    );
  }
}
