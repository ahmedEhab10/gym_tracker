// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_set_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseSetModelAdapter extends TypeAdapter<ExerciseSetModel> {
  @override
  final int typeId = 3;

  @override
  ExerciseSetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseSetModel(
      id: fields[0] as String,
      exerciseId: fields[1] as String,
      setNumber: fields[2] as int,
      reps: fields[3] as int,
      weight: fields[4] as double,
      isCompleted: fields[5] as bool,
      completedAt: fields[6] as DateTime?,
      workoutSessionId: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseSetModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.exerciseId)
      ..writeByte(2)
      ..write(obj.setNumber)
      ..writeByte(3)
      ..write(obj.reps)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.completedAt)
      ..writeByte(7)
      ..write(obj.workoutSessionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseSetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
