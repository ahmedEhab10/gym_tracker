import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/domain/entities/measurement_entity.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/measurement/measurement_cubit.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/measurement/measurement_state.dart';

class BodyStatsSection extends StatelessWidget {
  const BodyStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementCubit, MeasurementState>(
      builder: (context, state) {
        // Sort measurements newest-first so index 0 = latest, index 1 = previous
        final List<MeasurementEntity> sorted = switch (state) {
          MeasurementLoaded(:final measurements) => List.of(measurements)
            ..sort((a, b) => b.date.compareTo(a.date)),
          _ => [],
        };

        final latest = sorted.isNotEmpty ? sorted.first : null;
        final previous = sorted.length > 1 ? sorted[1] : null;
        final isLoading = state is MeasurementLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section header ──────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Body Stats',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (latest != null)
                  _ComparisonBadge(hasPrevious: previous != null),
              ],
            ),
            SizedBox(height: 16.h),

            // ── Stat cards ──────────────────────────────────────────────────
            if (isLoading)
              _buildSkeletonRow()
            else if (latest == null)
              _buildEmptyBanner()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatCard(
                    title: 'WEIGHT',
                    value: latest.bodyWeight,
                    previousValue: previous?.bodyWeight,
                    unit: 'kg',
                    // weight up = positive (muscle/bulk), weight down = negative
                    increaseIsPositive: true,
                  ),
                  _StatCard(
                    title: 'BODY FAT',
                    value: latest.bodyFat,
                    previousValue: previous?.bodyFat,
                    unit: '%',
                    // fat up = bad, fat down = good
                    increaseIsPositive: false,
                  ),
                  _StatCard(
                    title: 'LEAN MASS',
                    value: latest.leanBodyMass,
                    previousValue: previous?.leanBodyMass,
                    unit: 'kg',
                    // lean mass up = great
                    increaseIsPositive: true,
                    isLast: true,
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildSkeletonRow() {
    return Row(
      children: List.generate(3, (i) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 2 ? 12.w : 0),
            height: 110.h,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.straighten_rounded,
              color: AppColors.primary,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              'No measurements yet — log your first one to see your stats here.',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Comparison badge next to section title
// ─────────────────────────────────────────────────────────────────────────────

class _ComparisonBadge extends StatelessWidget {
  final bool hasPrevious;
  const _ComparisonBadge({required this.hasPrevious});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        hasPrevious ? 'vs Previous' : 'Latest Entry',
        style: GoogleFonts.spaceGrotesk(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual stat card
// ─────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String title;
  final double? value;
  final double? previousValue;
  final String unit;
  final bool increaseIsPositive;
  final bool isLast;

  const _StatCard({
    required this.title,
    required this.value,
    required this.previousValue,
    required this.unit,
    required this.increaseIsPositive,
    this.isLast = false,
  });

  /// Returns (icon, color) based on direction and semantic meaning.
  /// null = no comparison available
  (IconData, Color)? get _trend {
    if (value == null || previousValue == null) return null;
    final diff = value! - previousValue!;
    if (diff.abs() < 0.001) return null; // no meaningful change

    final isUp = diff > 0;
    // positive semantic = green, negative semantic = red
    final goodCondition = increaseIsPositive ? isUp : !isUp;
    final color = goodCondition ? AppColors.success : AppColors.accent;
    final icon = isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded;
    return (icon, color);
  }

  String get _displayValue {
    if (value == null) return '--';
    // Show one decimal only when needed
    final rounded = value!;
    return rounded % 1 == 0
        ? rounded.toInt().toString()
        : rounded.toStringAsFixed(1);
  }

  String get _changeLabel {
    if (value == null || previousValue == null) return '';
    final diff = value! - previousValue!;
    if (diff.abs() < 0.001) return '0$unit';
    final sign = diff > 0 ? '+' : '';
    return '$sign${diff.toStringAsFixed(1)}$unit';
  }

  @override
  Widget build(BuildContext context) {
    final trend = _trend;
    final changeLabel = _changeLabel;

    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: isLast ? 0 : 10.w),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16.r),
          border: trend != null
              ? Border.all(
                  color: trend.$2.withValues(alpha: 0.18),
                  width: 1,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Label ──────────────────────────────────────────────────────
            Text(
              title,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 8.h),

            // ── Value + unit ────────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(
                    _displayValue,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  unit,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // ── Trend indicator ─────────────────────────────────────────────
            if (trend != null)
              Row(
                children: [
                  Icon(trend.$1, size: 13.sp, color: trend.$2),
                  SizedBox(width: 3.w),
                  Flexible(
                    child: Text(
                      changeLabel,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: trend.$2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Icon(
                    Icons.remove_rounded,
                    size: 13.sp,
                    color: AppColors.textHint,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    previousValue == null ? 'No prev.' : 'No change',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
