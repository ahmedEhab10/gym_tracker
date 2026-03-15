import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/core/widgets/common/custom_button.dart';
import 'package:try_my_tracker/domain/entities/profile_entity.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/profile/profile_cubit.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/profile/profile_state.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/profile/edit_profile_screen.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        String name = 'Ahmed Ehab'; // User Fallback
        String? profilePicPath;
        ProfileEntity? currentProfile;

        if (state is ProfileLoaded) {
          name = state.profile.name;
          profilePicPath = state.profile.profilePicturePath;
          currentProfile = state.profile;
        }

        return Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: 110.h,
                  width: 110.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.card,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 3.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                    image: profilePicPath != null && File(profilePicPath).existsSync()
                        ? DecorationImage(
                            image: FileImage(File(profilePicPath)),
                            fit: BoxFit.cover,
                          )
                        : const DecorationImage(
                            image: AssetImage('assets/images/Ahmed_Ehab.jpg'),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'PRO',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              name,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
        SizedBox(height: 4.h),
        Text(
          'Member since Jan 2023',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                label: 'Edit Profile',
                onPressed: () {
                  if (currentProfile != null) {
                    final profileCubit = context.read<ProfileCubit>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: profileCubit,
                          child: EditProfileScreen(currentProfile: currentProfile!),
                        ),
                      ),
                    );
                  }
                },
                borderradius: 25,
                height: 45.h,
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              height: 45.h,
              width: 45.h,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: IconButton(
                icon: const Icon(Icons.share, color: AppColors.primary, size: 20),
                onPressed: () {},
                splashRadius: 24,
              ),
            ),
          ],
        ),
      ],
    );
  },
);
  }
}
