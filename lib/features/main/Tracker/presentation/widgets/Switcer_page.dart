import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:try_my_tracker/core/routes/app_routes.dart';
import 'package:try_my_tracker/core/widgets/common/custom_button.dart';

class SwitcerPage extends StatelessWidget {
  const SwitcerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              label: 'Weekly Schedule',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.weeklySchedule);
              },
              height: 80.h,
            ),
            SizedBox(height: 80.h),
            CustomButton(
              label: 'Custom Schedule',
              onPressed: () {},
              height: 80.h,
            ),
          ],
        ),
      ),
    );
  }
}
