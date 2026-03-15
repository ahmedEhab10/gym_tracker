import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:try_my_tracker/core/di/injection_container.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/core/widgets/common/custom_button.dart';
import 'package:try_my_tracker/domain/entities/measurement_entity.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/measurement/measurement_cubit.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/measurement/measurement_state.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/profile/measures/log_measurement_screen.dart';

class MeasuresListScreen extends StatelessWidget {
  const MeasuresListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MeasurementCubit>()..loadMeasurements(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Measurements',
            style: GoogleFonts.spaceGrotesk(color: AppColors.textPrimary),
          ),
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LogMeasurementScreen(),
                  ),
                ).then((_) {
                  // Reload on pop if the user saved
                  // Although the Cubit used in Log is different instance, 
                  // we can just re-dispatch load. But to avoid issues, we should actually load it.
                });
              },
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<MeasurementCubit, MeasurementState>(
            builder: (context, state) {
              if (state is MeasurementLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              } else if (state is MeasurementLoaded) {
                if (state.measurements.isEmpty) {
                  return _buildEmptyState(context);
                }
                return _buildMeasurementsList(state.measurements);
              } else if (state is MeasurementError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              return _buildEmptyState(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.straighten_rounded,
              color: AppColors.primary,
              size: 64.sp,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Measurements Yet',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Track your physical changes over time by logging your body measurements and progress pictures.',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const Spacer(),
          CustomButton(
            label: 'Add Measurement',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LogMeasurementScreen(),
                ),
              ).then((_) {
                context.read<MeasurementCubit>().loadMeasurements();
              });
            },
            borderradius: 30,
            height: 56.h,
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildMeasurementsList(List<MeasurementEntity> measurements) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: measurements.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final measurement = measurements[index];
        final dateStr = DateFormat('MMM d, yyyy').format(measurement.date);
        
        return Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.textHint.withValues(alpha: 0.1),
            ),
          ),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LogMeasurementScreen(
                    existingMeasurement: measurement,
                  ),
                ),
              ).then((_) {
                context.read<MeasurementCubit>().loadMeasurements();
              });
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            leading: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.straighten_rounded,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ),
            title: Text(
              dateStr,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              measurement.bodyWeight != null 
                ? '${measurement.bodyWeight} kg • ${measurement.bodyFat != null ? '${measurement.bodyFat}% Fat' : 'No body fat logged'}'
                : 'Partial Log',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () {
                context.read<MeasurementCubit>().deleteMeasurement(measurement.id);
              },
            ),
          ),
        );
      },
    );
  }
}
