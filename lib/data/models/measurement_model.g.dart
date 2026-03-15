// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeasurementModelAdapter extends TypeAdapter<MeasurementModel> {
  @override
  final int typeId = 11;

  @override
  MeasurementModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeasurementModel(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      bodyWeight: fields[2] as double?,
      waist: fields[3] as double?,
      bodyFat: fields[4] as double?,
      leanBodyMass: fields[5] as double?,
      neck: fields[6] as double?,
      shoulder: fields[7] as double?,
      chest: fields[8] as double?,
      leftBicep: fields[9] as double?,
      rightBicep: fields[10] as double?,
      leftForearm: fields[11] as double?,
      rightForearm: fields[12] as double?,
      abdomen: fields[13] as double?,
      hips: fields[14] as double?,
      leftThigh: fields[15] as double?,
      rightThigh: fields[16] as double?,
      leftCalf: fields[17] as double?,
      rightCalf: fields[18] as double?,
      progressPicturePath: fields[19] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MeasurementModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.bodyWeight)
      ..writeByte(3)
      ..write(obj.waist)
      ..writeByte(4)
      ..write(obj.bodyFat)
      ..writeByte(5)
      ..write(obj.leanBodyMass)
      ..writeByte(6)
      ..write(obj.neck)
      ..writeByte(7)
      ..write(obj.shoulder)
      ..writeByte(8)
      ..write(obj.chest)
      ..writeByte(9)
      ..write(obj.leftBicep)
      ..writeByte(10)
      ..write(obj.rightBicep)
      ..writeByte(11)
      ..write(obj.leftForearm)
      ..writeByte(12)
      ..write(obj.rightForearm)
      ..writeByte(13)
      ..write(obj.abdomen)
      ..writeByte(14)
      ..write(obj.hips)
      ..writeByte(15)
      ..write(obj.leftThigh)
      ..writeByte(16)
      ..write(obj.rightThigh)
      ..writeByte(17)
      ..write(obj.leftCalf)
      ..writeByte(18)
      ..write(obj.rightCalf)
      ..writeByte(19)
      ..write(obj.progressPicturePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasurementModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
