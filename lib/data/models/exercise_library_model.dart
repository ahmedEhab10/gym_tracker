import 'package:hive/hive.dart';
import '../../domain/entities/exercise_library.dart';

part 'exercise_library_model.g.dart';

@HiveType(typeId: 10)
class ExerciseLibraryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String targetMuscle;

  @HiveField(4)
  final String image;

  @HiveField(5)
  final String? youtubeUrl;

  ExerciseLibraryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.targetMuscle,
    required this.image,
    this.youtubeUrl,
  });

  factory ExerciseLibraryModel.fromJson(Map<String, dynamic> json) {
    return ExerciseLibraryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      targetMuscle: json['targetMuscle'] as String,
      image: json['image'] as String,
      youtubeUrl: json['youtubeUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'targetMuscle': targetMuscle,
      'image': image,
      'youtubeUrl': youtubeUrl,
    };
  }

  ExerciseLibrary toEntity() {
    return ExerciseLibrary(
      id: id,
      name: name,
      description: description,
      targetMuscle: targetMuscle,
      image: image,
      youtubeUrl: youtubeUrl,
    );
  }

  factory ExerciseLibraryModel.fromEntity(ExerciseLibrary entity) {
    return ExerciseLibraryModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      targetMuscle: entity.targetMuscle,
      image: entity.image,
      youtubeUrl: entity.youtubeUrl,
    );
  }
}
