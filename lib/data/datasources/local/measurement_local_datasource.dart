import 'package:try_my_tracker/data/models/measurement_model.dart';
import 'package:try_my_tracker/data/datasources/local/hive_service.dart';

abstract class MeasurementLocalDataSource {
  Future<void> saveMeasurement(MeasurementModel measurement);
  Future<List<MeasurementModel>> getMeasurements();
  Future<void> deleteMeasurement(String id);
}

class MeasurementLocalDataSourceImpl implements MeasurementLocalDataSource {
  final HiveService hiveService;

  MeasurementLocalDataSourceImpl({required this.hiveService});

  @override
  Future<void> saveMeasurement(MeasurementModel measurement) async {
    await hiveService.measurementBox.put(measurement.id, measurement);
  }

  @override
  Future<List<MeasurementModel>> getMeasurements() async {
    return hiveService.measurementBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Newest first
  }

  @override
  Future<void> deleteMeasurement(String id) async {
    await hiveService.measurementBox.delete(id);
  }
}
