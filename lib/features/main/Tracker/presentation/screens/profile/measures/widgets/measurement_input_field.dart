import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';

class MeasurementInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const MeasurementInputField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(
            color: const Color.fromARGB(255, 30, 30, 30),
            width: 1.h,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: TextFormField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              textAlign: TextAlign.right,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: '-',
                hintStyle: GoogleFonts.spaceGrotesk(
                  fontSize: 16.sp,
                  color: Colors.grey.shade600,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }
}
