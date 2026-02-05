import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';

class ExrciesContinar extends StatelessWidget {
  const ExrciesContinar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color.fromARGB(101, 255, 255, 255),
          width: 1.2.w,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        child: Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
