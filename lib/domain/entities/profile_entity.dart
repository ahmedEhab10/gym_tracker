class ProfileEntity {
  final String id;
  final String name;
  final String? profilePicturePath;

  ProfileEntity({
    required this.id,
    required this.name,
    this.profilePicturePath,
  });
}
