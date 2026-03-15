import 'package:try_my_tracker/data/datasources/local/measurement_local_datasource.dart';
import 'package:try_my_tracker/data/models/measurement_model.dart';
import 'package:try_my_tracker/domain/entities/measurement_entity.dart';
import 'package:try_my_tracker/domain/repositories/measurement_repository.dart';

class MeasurementRepositoryImpl implements MeasurementRepository {
  final MeasurementLocalDataSource localDataSource;

  MeasurementRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveMeasurement(MeasurementEntity measurement) async {
    final model = MeasurementModel(
      id: measurement.id,
      date: measurement.date,
      bodyWeight: measurement.bodyWeight,
      waist: measurement.waist,
      bodyFat: measurement.bodyFat,
      leanBodyMass: measurement.leanBodyMass,
      neck: measurement.neck,
      shoulder: measurement.shoulder,
      chest: measurement.chest,
      leftBicep: measurement.leftBicep,
      rightBicep: measurement.rightBicep,
      leftForearm: measurement.leftForearm,
      rightForearm: measurement.rightForearm,
      abdomen: measurement.abdomen,
      hips: measurement.hips,
      leftThigh: measurement.leftThigh,
      rightThigh: measurement.rightThigh,
      leftCalf: measurement.leftCalf,
      rightCalf: measurement.rightCalf,
      progressPicturePath: measurement.progressPicturePath,
    );
    await localDataSource.saveMeasurement(model);
  }

  @override
  Future<List<MeasurementEntity>> getMeasurements() async {
    final models = await localDataSource.getMeasurements();
    return models.map((model) => _mapToEntity(model)).toList();
  }

  @override
  Future<void> deleteMeasurement(String id) async {
    await localDataSource.deleteMeasurement(id);
  }

  MeasurementEntity _mapToEntity(MeasurementModel model) {
    return MeasurementEntity(
      id: model.id,
      date: model.date,
      bodyWeight: model.bodyWeight,
      waist: model.waist,
      bodyFat: model.bodyFat,
      leanBodyMass: model.leanBodyMass,
      neck: model.neck,
      shoulder: model.shoulder,
      chest: model.chest,
      leftBicep: model.leftBicep,
      rightBicep: model.rightBicep,
      leftForearm: model.leftForearm,
      rightForearm: model.rightForearm,
      abdomen: model.abdomen,
      hips: model.hips,
      leftThigh: model.leftThigh,
      rightThigh: model.rightThigh,
      leftCalf: model.leftCalf,
      rightCalf: model.rightCalf,
      progressPicturePath: model.progressPicturePath,
    );
  }
}
