import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/routes/app_routes.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/core/widgets/common/custom_button.dart';
import 'package:try_my_tracker/features/onboarding/Screens/screen_content/Screen_Model.dart';

class OnboardinScreens extends StatefulWidget {
  const OnboardinScreens({super.key});

  @override
  State<OnboardinScreens> createState() => _OnboardinScreensState();
}

class _OnboardinScreensState extends State<OnboardinScreens> {
  ScreenModel currentScreen = ScreenModel.screens[0];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(currentScreen.image, fit: BoxFit.cover),
          ),

          // Dark Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(
                0.6,
              ), // عدّل النسبة حسب اللي يعجبك
            ),
          ),

          // Your Content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Text(
                    currentScreen.title,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 42,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    currentScreen.description,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(3, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        width: currentIndex == index ? 22 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? const Color(0xFF7CFF00) // الأخضر
                              : Colors.grey.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 16.h),
                  CustomButton(
                    label: currentIndex == ScreenModel.screens.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onPressed: () {
                      setState(() {
                        if (currentIndex < ScreenModel.screens.length - 1) {
                          currentIndex++;
                          currentScreen = ScreenModel.screens[currentIndex];
                        } else {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.mainLayout,
                          );
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
