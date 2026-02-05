import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';

class DayScheduleCard extends StatelessWidget {
  final String dayName;
  final String workoutName;
  final bool isRestDay;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const DayScheduleCard({
    super.key,
    required this.dayName,
    required this.workoutName,
    required this.isRestDay,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isRestDay
              ? AppColors.textHint.withOpacity(0.1)
              : AppColors.primary.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildDayIndicator(),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dayName,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        workoutName,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isRestDay ? AppColors.textHint : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: AppColors.textHint.withOpacity(0.5),
                    size: 20,
                  ),
                  onPressed: onEdit,
                  splashRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayIndicator() {
    return Container(
      width: 4,
      height: 40,
      decoration: BoxDecoration(
        color: isRestDay
            ? AppColors.textHint.withOpacity(0.3)
            : AppColors.primary,
        borderRadius: BorderRadius.circular(4),
        boxShadow: isRestDay
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 0),
                ),
              ],
      ),
    );
  }
}
