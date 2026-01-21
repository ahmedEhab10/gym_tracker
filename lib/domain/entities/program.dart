import 'package:equatable/equatable.dart';

class Program extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> trainingDayIds;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Program({
    required this.id,
    required this.name,
    required this.description,
    this.trainingDayIds = const [],
    this.isActive = false,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    trainingDayIds,
    isActive,
    createdAt,
    updatedAt,
  ];
}
