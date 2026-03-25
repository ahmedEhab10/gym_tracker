import 'package:hive/hive.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 12)
class ProfileModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? profilePicturePath;

  @HiveField(3)
  final int? age;

  @HiveField(4)
  final String? gender;

  @HiveField(5)
  final List<String>? goals;

  ProfileModel({
    required this.id,
    required this.name,
    this.profilePicturePath,
    this.age,
    this.gender,
    this.goals,
  });
}
