import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/core/widgets/common/custom_button.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/home/home_bloc.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/home/widgets/Home_Screen_apper.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/home/widgets/recent_progress_card.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/home/widgets/work_out_info_card.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is HomeError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is HomeLoaded) {
          final data = state.data;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
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
                          text: 'Ahmed ', // TODO: Make dynamic later
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
                  SizedBox(height: 12.h),

                  WorkOutInfoCard(
                    lastWorkout: data.recentWorkouts.isNotEmpty
                        ? data.recentWorkouts.first
                        : null,
                  ),

                  SizedBox(height: 12.h),

                  if (data.recentWorkouts.isNotEmpty) ...[
                    Text(
                      'Recent Progress',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ...data.recentWorkouts.map(
                      (workout) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: RecentProgressCard(data: workout),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
