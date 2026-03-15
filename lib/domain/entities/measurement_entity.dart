class MeasurementEntity {
  final String id;
  final DateTime date;
  final double? bodyWeight;
  final double? waist;
  final double? bodyFat;
  final double? leanBodyMass;
  final double? neck;
  final double? shoulder;
  final double? chest;
  final double? leftBicep;
  final double? rightBicep;
  final double? leftForearm;
  final double? rightForearm;
  final double? abdomen;
  final double? hips;
  final double? leftThigh;
  final double? rightThigh;
  final double? leftCalf;
  final double? rightCalf;
  final String? progressPicturePath;

  MeasurementEntity({
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
