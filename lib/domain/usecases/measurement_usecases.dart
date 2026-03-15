import 'package:try_my_tracker/domain/entities/measurement_entity.dart';
import 'package:try_my_tracker/domain/repositories/measurement_repository.dart';

class SaveMeasurement {
  final MeasurementRepository repository;

  SaveMeasurement(this.repository);

  Future<void> call(MeasurementEntity measurement) async {
    return repository.saveMeasurement(measurement);
  }
}

class GetMeasurements {
  final MeasurementRepository repository;

  GetMeasurements(this.repository);

  Future<List<MeasurementEntity>> call() async {
    return repository.getMeasurements();
  }
}

class DeleteMeasurement {
  final MeasurementRepository repository;

  DeleteMeasurement(this.repository);

  Future<void> call(String id) async {
    return repository.deleteMeasurement(id);
  }
}
