import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/profile/widgets/body_stats_section.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/profile/widgets/personal_records_section.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/profile/widgets/profile_header.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/profile/widgets/profile_menu_list.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
        physics: const BouncingScrollPhysics(),
        children: [
          const ProfileHeader(),
          SizedBox(height: 32.h),
          const BodyStatsSection(),
          SizedBox(height: 32.h),
          const PersonalRecordsSection(),
          SizedBox(height: 32.h),
          const ProfileMenuList(),
          SizedBox(height: 40.h), // Bottom padding
        ],
      ),
    );
  }
}
