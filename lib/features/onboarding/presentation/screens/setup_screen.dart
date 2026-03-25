import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/core/routes/app_routes.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/profile/profile_cubit.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/measurement/measurement_cubit.dart';
import 'package:try_my_tracker/domain/entities/profile_entity.dart';
import 'package:try_my_tracker/domain/entities/measurement_entity.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/profile/profile_state.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form Data
  String _name = '';
  int? _age;
  String? _gender;
  double? _weight;
  final List<String> _goals = [];

  final List<String> _availableGoals = [
    'Lose Weight',
    'Build Muscle',
    'Improve Endurance',
    'Learn Basics',
    'Stay Healthy',
    'Increase Strength'
  ];

  final OutlineInputBorder _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16.r),
    borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3), width: 1.5),
  );

  final OutlineInputBorder _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16.r),
    borderSide: const BorderSide(color: AppColors.primary, width: 2),
  );

  void _nextPage() {
    FocusScope.of(context).unfocus();
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      _finishSetup();
    }
  }

  void _previousPage() {
    FocusScope.of(context).unfocus();
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  Future<void> _finishSetup() async {
    // 1. Mark setup as complete
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_setup', true);

    if (!mounted) return;

    // 2. Save profile
    final profileCubit = context.read<ProfileCubit>();
    final currentState = profileCubit.state;
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    String? picturePath;

    if (currentState is ProfileLoaded) {
      id = currentState.profile.id;
      picturePath = currentState.profile.profilePicturePath;
    }

    profileCubit.saveProfile(ProfileEntity(
      id: id,
      name: _name.trim().isEmpty ? 'Athlete' : _name.trim(),
      profilePicturePath: picturePath,
      age: _age,
      gender: _gender,
      goals: _goals,
    ));

      // 3. Save initial weight
    if (_weight != null) {
      final measurementCubit = context.read<MeasurementCubit>();
      final measurement = MeasurementEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        bodyWeight: _weight,
      );
      measurementCubit.saveMeasurement(measurement);
    }

    // 4. Navigate
    Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                      onPressed: _previousPage,
                    )
                  else
                    const SizedBox(width: 48), // Placeholder for alignment
                  
                  Expanded(
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          'Step ${_currentPage + 1} of 5',
                          key: ValueKey(_currentPage),
                          style: GoogleFonts.spaceGrotesk(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 48),
                ],
              ),
            ),
            
            // Progress Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (_currentPage + 1) / 5,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 6.h,
                ),
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildNamePage(),
                  _buildAgePage(),
                  _buildGenderPage(),
                  _buildWeightPage(),
                  _buildGoalsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Pages ---

  Widget _buildPageContainer({
    required String title,
    required String subtitle,
    required Widget content,
    bool isNextEnabled = true,
    String? nextLabel,
  }) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20.h),
          Text(
            title,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            subtitle,
            style: GoogleFonts.spaceGrotesk(
              color: AppColors.textSecondary,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 50.h),
          
          Expanded(child: content),

          // Next Button
          SizedBox(
            height: 56.h,
            child: ElevatedButton(
              onPressed: isNextEnabled ? _nextPage : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                elevation: 0,
              ),
              child: Text(
                nextLabel ?? 'Continue',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isNextEnabled ? Colors.black : AppColors.textHint,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  // 1. Name
  Widget _buildNamePage() {
    return _buildPageContainer(
      title: "What represents\nyou?",
      subtitle: "Let's start with your name or nickname.",
      isNextEnabled: _name.trim().isNotEmpty,
      content: Align(
        alignment: Alignment.topCenter,
        child: TextField(
          autofocus: true,
          style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 18.sp),
          decoration: InputDecoration(
            hintText: 'e.g. John Doe',
            hintStyle: GoogleFonts.spaceGrotesk(color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.surface,
            border: _border,
            enabledBorder: _border,
            focusedBorder: _focusedBorder,
            prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
          ),
          onChanged: (val) => setState(() => _name = val),
        ),
      ),
    );
  }

  // 2. Age
  Widget _buildAgePage() {
    return _buildPageContainer(
      title: "How old are\nyou?",
      subtitle: "This helps us tailor your fitness journey.",
      isNextEnabled: _age != null && _age! > 0,
      content: Align(
        alignment: Alignment.topCenter,
        child: TextField(
          autofocus: true,
          keyboardType: TextInputType.number,
          style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 18.sp),
          decoration: InputDecoration(
            hintText: 'e.g. 25',
            hintStyle: GoogleFonts.spaceGrotesk(color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.surface,
            border: _border,
            enabledBorder: _border,
            focusedBorder: _focusedBorder,
            prefixIcon: const Icon(Icons.cake_outlined, color: AppColors.primary),
            suffixText: 'years',
            suffixStyle: GoogleFonts.spaceGrotesk(color: AppColors.textHint),
          ),
          onChanged: (val) {
            setState(() {
              _age = int.tryParse(val);
            });
          },
        ),
      ),
    );
  }

  // 3. Gender
  Widget _buildGenderPage() {
    return _buildPageContainer(
      title: "What's your\ngender?",
      subtitle: "This is used for body metrics calculations.",
      isNextEnabled: _gender != null,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _GenderCard(
            label: 'Male',
            svgPath: 'assets/svg/male-svgrepo-com.svg',
            isSelected: _gender == 'Male',
            onTap: () => setState(() => _gender = 'Male'),
          ),
          SizedBox(width: 20.w),
          _GenderCard(
            label: 'Female',
            svgPath: 'assets/svg/female-svgrepo-com.svg',
            isSelected: _gender == 'Female',
            onTap: () => setState(() => _gender = 'Female'),
          ),
        ],
      ),
    );
  }

  // 4. Weight
  Widget _buildWeightPage() {
    return _buildPageContainer(
      title: "What's your\ncurrent weight?",
      subtitle: "We'll save this as your first measurement.",
      isNextEnabled: _weight != null && _weight! > 0,
      content: Align(
        alignment: Alignment.topCenter,
        child: TextField(
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 18.sp),
          decoration: InputDecoration(
            hintText: 'e.g. 75.5',
            hintStyle: GoogleFonts.spaceGrotesk(color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.surface,
            border: _border,
            enabledBorder: _border,
            focusedBorder: _focusedBorder,
            prefixIcon: const Icon(Icons.monitor_weight_outlined, color: AppColors.primary),
            suffixText: 'kg',
            suffixStyle: GoogleFonts.spaceGrotesk(color: AppColors.textHint),
          ),
          onChanged: (val) {
            setState(() {
              _weight = double.tryParse(val);
            });
          },
        ),
      ),
    );
  }

  // 5. Goals
  Widget _buildGoalsPage() {
    return _buildPageContainer(
      title: "What are your\nmain goals?",
      subtitle: "Select all that apply to you.",
      isNextEnabled: _goals.isNotEmpty,
      nextLabel: "Finish Setup",
      content: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
        ),
        itemCount: _availableGoals.length,
        itemBuilder: (context, index) {
          final goal = _availableGoals[index];
          final isSelected = _goals.contains(goal);
          
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _goals.remove(goal);
                } else {
                  _goals.add(goal);
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.15) : AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  goal,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    color: isSelected ? AppColors.primary : Colors.white,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final String label;
  final String svgPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.label,
    required this.svgPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 140.w,
        height: 160.h,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.15) : AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgPath,
              width: 60.w,
              height: 60.w,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.primary : AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                color: isSelected ? AppColors.primary : Colors.white,
                fontSize: 18.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
