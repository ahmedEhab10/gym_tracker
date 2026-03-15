import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/domain/entities/measurement_entity.dart';
import 'package:try_my_tracker/domain/usecases/measurement_usecases.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/measurement/measurement_state.dart';

class MeasurementCubit extends Cubit<MeasurementState> {
  final GetMeasurements getMeasurementsUseCase;
  final SaveMeasurement saveMeasurementUseCase;
  final DeleteMeasurement deleteMeasurementUseCase;

  MeasurementCubit({
    required this.getMeasurementsUseCase,
    required this.saveMeasurementUseCase,
    required this.deleteMeasurementUseCase,
  }) : super(MeasurementInitial());

  Future<void> loadMeasurements() async {
    emit(MeasurementLoading());
    try {
      final measurements = await getMeasurementsUseCase();
      emit(MeasurementLoaded(measurements));
    } catch (e) {
      emit(MeasurementError('Failed to load measurements: ${e.toString()}'));
    }
  }

  Future<void> saveMeasurement(MeasurementEntity measurement) async {
    emit(MeasurementLoading());
    try {
      await saveMeasurementUseCase(measurement);
      emit(MeasurementSaveSuccess());
      await loadMeasurements(); // Reload immediately
    } catch (e) {
      emit(MeasurementError('Failed to save measurement: ${e.toString()}'));
    }
  }

  Future<void> deleteMeasurement(String id) async {
    try {
      await deleteMeasurementUseCase(id);
      await loadMeasurements();
    } catch (e) {
      emit(MeasurementError('Failed to delete measurement: ${e.toString()}'));
    }
  }
}
