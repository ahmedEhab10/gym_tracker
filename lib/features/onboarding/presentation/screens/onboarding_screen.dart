import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/routes/app_routes.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:try_my_tracker/core/widgets/common/custom_button.dart';
import 'package:try_my_tracker/features/onboarding/data/models/onboarding_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final item in OnboardingItem.items) {
        precacheImage(AssetImage(item.image), context);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < OnboardingItem.items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.setup);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: OnboardingItem.items.length,
            itemBuilder: (context, index) {
              final item = OnboardingItem.items[index];
              return _buildOnboardingPage(item);
            },
          ),
          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: _buildBottomSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingItem item) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            item.image,
            fit: BoxFit.cover,
          ),
        ),
        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.9),
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
        ),
        // Content
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  item.title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 42.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ).animate(key: ValueKey('title_${item.title}')).fade(duration: 400.ms).slideY(begin: 0.1, duration: 400.ms),
                SizedBox(height: 8.h),
                Text(
                  item.description,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ).animate(key: ValueKey('desc_${item.title}')).fade(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, duration: 400.ms, delay: 100.ms),
                SizedBox(height: 120.h), // Space for bottom section
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
            OnboardingItem.items.length,
            (index) => _buildPageIndicator(index),
          ),
        ),
        SizedBox(height: 16.h),
        CustomButton(
          label: _currentPage == OnboardingItem.items.length - 1
              ? 'Get Started'
              : 'Next',
          onPressed: _nextPage,
        ),
      ],
    );
  }

  Widget _buildPageIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 6),
      width: _currentPage == index ? 22 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? AppColors.primary
            : Colors.grey.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
