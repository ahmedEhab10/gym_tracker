import 'package:try_my_tracker/domain/entities/measurement_entity.dart';

abstract class MeasurementRepository {
  Future<void> saveMeasurement(MeasurementEntity measurement);
  Future<List<MeasurementEntity>> getMeasurements();
  Future<void> deleteMeasurement(String id);
}
