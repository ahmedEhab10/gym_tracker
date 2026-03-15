import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:try_my_tracker/core/di/injection_container.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';
import 'package:try_my_tracker/domain/entities/measurement_entity.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/measurement/measurement_cubit.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/measurement/measurement_state.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/profile/measures/widgets/measurement_input_field.dart';

class LogMeasurementScreen extends StatefulWidget {
  final MeasurementEntity? existingMeasurement;

  const LogMeasurementScreen({super.key, this.existingMeasurement});

  @override
  State<LogMeasurementScreen> createState() => _LogMeasurementScreenState();
}

class _LogMeasurementScreenState extends State<LogMeasurementScreen> {
  final _bodyWeightController = TextEditingController();
  final _waistController = TextEditingController();
  final _bodyFatController = TextEditingController();
  final _leanBodyMassController = TextEditingController();
  final _neckController = TextEditingController();
  final _shoulderController = TextEditingController();
  final _chestController = TextEditingController();
  final _leftBicepController = TextEditingController();
  final _rightBicepController = TextEditingController();
  final _leftForearmController = TextEditingController();
  final _rightForearmController = TextEditingController();
  final _abdomenController = TextEditingController();
  final _hipsController = TextEditingController();
  final _leftThighController = TextEditingController();
  final _rightThighController = TextEditingController();
  final _leftCalfController = TextEditingController();
  final _rightCalfController = TextEditingController();

  String? _imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.existingMeasurement != null) {
      final m = widget.existingMeasurement!;
      _bodyWeightController.text = m.bodyWeight?.toString() ?? '';
      _waistController.text = m.waist?.toString() ?? '';
      _bodyFatController.text = m.bodyFat?.toString() ?? '';
      _leanBodyMassController.text = m.leanBodyMass?.toString() ?? '';
      _neckController.text = m.neck?.toString() ?? '';
      _shoulderController.text = m.shoulder?.toString() ?? '';
      _chestController.text = m.chest?.toString() ?? '';
      _leftBicepController.text = m.leftBicep?.toString() ?? '';
      _rightBicepController.text = m.rightBicep?.toString() ?? '';
      _leftForearmController.text = m.leftForearm?.toString() ?? '';
      _rightForearmController.text = m.rightForearm?.toString() ?? '';
      _abdomenController.text = m.abdomen?.toString() ?? '';
      _hipsController.text = m.hips?.toString() ?? '';
      _leftThighController.text = m.leftThigh?.toString() ?? '';
      _rightThighController.text = m.rightThigh?.toString() ?? '';
      _leftCalfController.text = m.leftCalf?.toString() ?? '';
      _rightCalfController.text = m.rightCalf?.toString() ?? '';
      _imagePath = m.progressPicturePath;
    }
  }

  @override
  void dispose() {
    _bodyWeightController.dispose();
    _waistController.dispose();
    _bodyFatController.dispose();
    _leanBodyMassController.dispose();
    _neckController.dispose();
    _shoulderController.dispose();
    _chestController.dispose();
    _leftBicepController.dispose();
    _rightBicepController.dispose();
    _leftForearmController.dispose();
    _rightForearmController.dispose();
    _abdomenController.dispose();
    _hipsController.dispose();
    _leftThighController.dispose();
    _rightThighController.dispose();
    _leftCalfController.dispose();
    _rightCalfController.dispose();
    super.dispose();
  }

  double? _parseDouble(String value) {
    if (value.trim().isEmpty) return null;
    return double.tryParse(value);
  }

  void _saveMeasurement(BuildContext context) {
    // All inputs are optional
    final entity = MeasurementEntity(
      id: widget.existingMeasurement?.id ?? sl<Uuid>().v4(),
      date: widget.existingMeasurement?.date ?? DateTime.now(),
      bodyWeight: _parseDouble(_bodyWeightController.text),
      waist: _parseDouble(_waistController.text),
      bodyFat: _parseDouble(_bodyFatController.text),
      leanBodyMass: _parseDouble(_leanBodyMassController.text),
      neck: _parseDouble(_neckController.text),
      shoulder: _parseDouble(_shoulderController.text),
      chest: _parseDouble(_chestController.text),
      leftBicep: _parseDouble(_leftBicepController.text),
      rightBicep: _parseDouble(_rightBicepController.text),
      leftForearm: _parseDouble(_leftForearmController.text),
      rightForearm: _parseDouble(_rightForearmController.text),
      abdomen: _parseDouble(_abdomenController.text),
      hips: _parseDouble(_hipsController.text),
      leftThigh: _parseDouble(_leftThighController.text),
      rightThigh: _parseDouble(_rightThighController.text),
      leftCalf: _parseDouble(_leftCalfController.text),
      rightCalf: _parseDouble(_rightCalfController.text),
      progressPicturePath: _imagePath,
    );

    context.read<MeasurementCubit>().saveMeasurement(entity);
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = widget.existingMeasurement?.date ?? DateTime.now();
    final dateStr = DateFormat('d MMMM yyyy').format(displayDate);

    return BlocProvider(
      create: (context) => sl<MeasurementCubit>(),
      child: BlocConsumer<MeasurementCubit, MeasurementState>(
        listener: (context, state) {
          if (state is MeasurementSaveSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Measurement saved successfully!')),
            );
            Navigator.pop(context); // Go back to the list
          } else if (state is MeasurementError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: Text(
                widget.existingMeasurement == null ? 'Log Measurements' : 'Edit Measurements',
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                ),
              ),
              backgroundColor: AppColors.background,
              elevation: 0,
              centerTitle: true,
              leadingWidth: 80.w,
              leading: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.primary,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              actions: [
                if (state is MeasurementLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  )
                else
                  TextButton(
                    onPressed: () => _saveMeasurement(context),
                    child: Text(
                      'Save',
                      style: GoogleFonts.spaceGrotesk(
                        color: AppColors.primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Non-editable display row for Date
                      Container(
                        height: 56.h,
                        decoration: BoxDecoration(
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
                              child: Text(
                                'Date',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Text(
                              dateStr,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16.sp,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            SizedBox(width: 8.w),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 24.h),
                      _buildSectionTitle('Progress Picture', hasHelpIcon: true),
                      SizedBox(height: 12.h),
                      _buildProgressPictureButton(),
                      SizedBox(height: 32.h),
                      _buildSectionTitle('Measurements'),
                      SizedBox(height: 8.h),
                      
                      // Core
                      MeasurementInputField(label: 'Body Weight (kg)', controller: _bodyWeightController),
                      MeasurementInputField(label: 'Waist (cm)', controller: _waistController),
                      MeasurementInputField(label: 'Body Fat (%)', controller: _bodyFatController),
                      MeasurementInputField(label: 'Lean Body Mass (kg)', controller: _leanBodyMassController),
                      
                      // Upper Body
                      MeasurementInputField(label: 'Neck (cm)', controller: _neckController),
                      MeasurementInputField(label: 'Shoulder (cm)', controller: _shoulderController),
                      MeasurementInputField(label: 'Chest (cm)', controller: _chestController),
                      MeasurementInputField(label: 'Left Bicep (cm)', controller: _leftBicepController),
                      MeasurementInputField(label: 'Right Bicep (cm)', controller: _rightBicepController),
                      MeasurementInputField(label: 'Left Forearm (cm)', controller: _leftForearmController),
                      MeasurementInputField(label: 'Right Forearm (cm)', controller: _rightForearmController),
                      MeasurementInputField(label: 'Abdomen (cm)', controller: _abdomenController),
                      MeasurementInputField(label: 'Hips (cm)', controller: _hipsController),
                      
                      // Lower Body
                      MeasurementInputField(label: 'Left Thigh (cm)', controller: _leftThighController),
                      MeasurementInputField(label: 'Right Thigh (cm)', controller: _rightThighController),
                      MeasurementInputField(label: 'Left Calf (cm)', controller: _leftCalfController),
                      MeasurementInputField(label: 'Right Calf (cm)', controller: _rightCalfController),
                      
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, {bool hasHelpIcon = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
        if (hasHelpIcon)
          Icon(
            Icons.help_outline,
            color: AppColors.textSecondary,
            size: 16.sp,
          ),
      ],
    );
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String localPath = '${directory.path}/$fileName';
        
        final File file = File(pickedFile.path);
        await file.copy(localPath);
        
        setState(() {
          _imagePath = localPath;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Widget _buildProgressPictureButton() {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: double.infinity,
        height: _imagePath != null ? 300.h : null,
        padding: _imagePath == null ? EdgeInsets.symmetric(vertical: 24.h) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: const Color(0xFF141414), // Darker subtle card background
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
          ),
          image: _imagePath != null && File(_imagePath!).existsSync()
              ? DecorationImage(
                  image: FileImage(File(_imagePath!)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: _imagePath != null && File(_imagePath!).existsSync()
            ? Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        setState(() { _imagePath = null; });
                      },
                    ),
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.primary,
                    size: 28.sp,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Add Picture',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

