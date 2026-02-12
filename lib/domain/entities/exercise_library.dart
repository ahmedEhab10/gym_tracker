import 'package:equatable/equatable.dart';

class ExerciseLibrary extends Equatable {
  final String id;
  final String name;
  final String description;
  final String targetMuscle;
  final String image;
  final String? youtubeUrl;

  const ExerciseLibrary({
    required this.id,
    required this.name,
    required this.description,
    required this.targetMuscle,
    required this.image,
    this.youtubeUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    targetMuscle,
    image,
    youtubeUrl,
  ];
}
