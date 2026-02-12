import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/exercise_library/exercise_library_cubit.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/exercise_library/exercise_library_state.dart';

class MuscleGroupFilter extends StatelessWidget {
  const MuscleGroupFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseLibraryCubit, ExerciseLibraryState>(
      builder: (context, state) {
        if (state is! ExerciseLibraryLoaded) {
          return const SizedBox.shrink();
        }

        final muscleGroups = state.muscleGroups;
        final selectedGroup = state.selectedMuscleGroup ?? 'All';

        return Container(
          height: 42,
          margin: const EdgeInsets.only(top: 12, bottom: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: muscleGroups.length,
            itemBuilder: (context, index) {
              final group = muscleGroups[index];
              final isSelected = group == selectedGroup;

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _MuscleGroupChip(
                  label: group,
                  isSelected: isSelected,
                  onTap: () {
                    context.read<ExerciseLibraryCubit>().setMuscleGroupFilter(
                      group == 'All' ? null : group,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _MuscleGroupChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MuscleGroupChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_MuscleGroupChip> createState() => _MuscleGroupChipState();
}

class _MuscleGroupChipState extends State<_MuscleGroupChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.9),
                      AppColors.primary.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.isSelected ? null : AppColors.card,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primary.withOpacity(0.3)
                  : AppColors.textHint.withOpacity(0.15),
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: [
              if (widget.isSelected)
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              BoxShadow(
                color: Colors.black.withOpacity(widget.isSelected ? 0.1 : 0.03),
                blurRadius: widget.isSelected ? 8 : 4,
                offset: Offset(0, widget.isSelected ? 3 : 2),
              ),
            ],
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            style: TextStyle(
              color: widget.isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 13,
              letterSpacing: 0.3,
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
