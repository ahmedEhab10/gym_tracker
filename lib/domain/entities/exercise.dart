import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final String id;
  final String trainingDayId;
  final String name;
  final String description;
  final String? imagePath;
  final List<String>? imagePaths;
  final String? youtubeLink;
  final String? notes;
  final double? lastUsedWeight;
  final int orderIndex;
  final int defaultSetsCount;

  const Exercise({
    required this.id,
    required this.trainingDayId,
    required this.name,
    required this.description,
    this.imagePath,
    this.imagePaths,
    this.youtubeLink,
    this.notes,
    this.lastUsedWeight,
    required this.orderIndex,
    this.defaultSetsCount = 3,
  });

  @override
  List<Object?> get props => [
    id,
    trainingDayId,
    name,
    description,
    imagePath,
    imagePaths,
    youtubeLink,
    notes,
    lastUsedWeight,
    orderIndex,
    defaultSetsCount,
  ];

  Exercise copyWith({
    String? id,
    String? trainingDayId,
    String? name,
    String? description,
    String? imagePath,
    List<String>? imagePaths,
    String? youtubeLink,
    String? notes,
    double? lastUsedWeight,
    int? orderIndex,
    int? defaultSetsCount,
  }) {
    return Exercise(
      id: id ?? this.id,
      trainingDayId: trainingDayId ?? this.trainingDayId,
      name: name ?? this.name,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      imagePaths: imagePaths ?? this.imagePaths,
      youtubeLink: youtubeLink ?? this.youtubeLink,
      notes: notes ?? this.notes,
      lastUsedWeight: lastUsedWeight ?? this.lastUsedWeight,
      orderIndex: orderIndex ?? this.orderIndex,
      defaultSetsCount: defaultSetsCount ?? this.defaultSetsCount,
    );
  }
}
