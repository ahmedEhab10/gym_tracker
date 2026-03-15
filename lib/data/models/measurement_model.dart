import 'package:hive/hive.dart';

part 'measurement_model.g.dart';

@HiveType(typeId: 11)
class MeasurementModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final double? bodyWeight;

  @HiveField(3)
  final double? waist;

  @HiveField(4)
  final double? bodyFat;

  @HiveField(5)
  final double? leanBodyMass;

  @HiveField(6)
  final double? neck;

  @HiveField(7)
  final double? shoulder;

  @HiveField(8)
  final double? chest;

  @HiveField(9)
  final double? leftBicep;

  @HiveField(10)
  final double? rightBicep;

  @HiveField(11)
  final double? leftForearm;

  @HiveField(12)
  final double? rightForearm;

  @HiveField(13)
  final double? abdomen;

  @HiveField(14)
  final double? hips;

  @HiveField(15)
  final double? leftThigh;

  @HiveField(16)
  final double? rightThigh;

  @HiveField(17)
  final double? leftCalf;

  @HiveField(18)
  final double? rightCalf;

  @HiveField(19)
  final String? progressPicturePath;

  MeasurementModel({
    required this.id,
    required this.date,
    this.bodyWeight,
    this.waist,
    this.bodyFat,
    this.leanBodyMass,
    this.neck,
    this.shoulder,
    this.chest,
    this.leftBicep,
    this.rightBicep,
    this.leftForearm,
    this.rightForearm,
    this.abdomen,
    this.hips,
    this.leftThigh,
    this.rightThigh,
    this.leftCalf,
    this.rightCalf,
    this.progressPicturePath,
  });
}
