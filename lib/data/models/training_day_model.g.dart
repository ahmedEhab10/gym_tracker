// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_day_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrainingDayModelAdapter extends TypeAdapter<TrainingDayModel> {
  @override
  final int typeId = 1;

  @override
  TrainingDayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrainingDayModel(
      id: fields[0] as String,
      programId: fields[1] as String,
      name: fields[2] as String,
      dayOfWeek: fields[3] as int,
      exerciseIds: (fields[4] as List).cast<String>(),
      orderIndex: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TrainingDayModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.programId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.dayOfWeek)
      ..writeByte(4)
      ..write(obj.exerciseIds)
      ..writeByte(5)
      ..write(obj.orderIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainingDayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
