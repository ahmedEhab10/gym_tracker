import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/domain/entities/exercise.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;
  final VoidCallback? onEdit;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Top Image & Overlays ──────────────────────────────────────────
              SizedBox(
                height: 190,
                child: Stack(
                  children: [
                    // Base Image
                    Positioned.fill(
                      child: _buildCoverImage(),
                    ),
                    // Gradient Fade
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.card.withValues(alpha: 0.8),
                              AppColors.card,
                            ],
                            stops: const [0.4, 0.85, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Bookmark / Action Icon
                    if (onEdit != null)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Material(
                          color: Colors.black45,
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: onEdit,
                            customBorder: const CircleBorder(),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Title & Description
                    Positioned(
                      left: 16,
                      right: 64, // leave room for bookmark
                      bottom: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise.name,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (exercise.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              exercise.description,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Bottom Section ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Stats Row
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 14,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${exercise.defaultSetsCount} SETS',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textHint,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.trending_up,
                          size: 14,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          exercise.lastUsedWeight != null
                              ? '${exercise.lastUsedWeight} KG'
                              : 'NO DATA',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textHint,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    // View Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.8),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'VIEW EXERCISE',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    String? imagePath;
    if (exercise.imagePaths != null && exercise.imagePaths!.isNotEmpty) {
      imagePath = exercise.imagePaths!.first;
    } else if (exercise.imagePath != null) {
      imagePath = exercise.imagePath;
    }

    if (imagePath != null) {
      if (imagePath.startsWith('assets')) {
        return Image.asset(imagePath, fit: BoxFit.cover);
      } else {
        return Image.file(File(imagePath), fit: BoxFit.cover);
      }
    }

    // Static placeholder if no image exists
    return Container(
      color: Colors.black26,
      child: const Center(
        child: Icon(
          Icons.fitness_center_rounded,
          size: 64,
          color: Colors.white24,
        ),
      ),
    );
  }
}
