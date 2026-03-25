class ProfileEntity {
  final String id;
  final String name;
  final String? profilePicturePath;
  final int? age;
  final String? gender;
  final List<String>? goals;

  ProfileEntity({
    required this.id,
    required this.name,
    this.profilePicturePath,
    this.age,
    this.gender,
    this.goals,
  });
}

