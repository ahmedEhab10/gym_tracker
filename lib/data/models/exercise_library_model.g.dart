// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_library_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseLibraryModelAdapter extends TypeAdapter<ExerciseLibraryModel> {
  @override
  final int typeId = 10;

  @override
  ExerciseLibraryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseLibraryModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      targetMuscle: fields[3] as String,
      image: fields[4] as String,
      youtubeUrl: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseLibraryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.targetMuscle)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.youtubeUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseLibraryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
