// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_schedule_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeeklyScheduleModelAdapter extends TypeAdapter<WeeklyScheduleModel> {
  @override
  final int typeId = 5;

  @override
  WeeklyScheduleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeeklyScheduleModel(dayNames: (fields[0] as List).cast<String>());
  }

  @override
  void write(BinaryWriter writer, WeeklyScheduleModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.dayNames);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyScheduleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
