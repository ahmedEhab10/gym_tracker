import 'package:try_my_tracker/data/models/profile_model.dart';
import 'package:try_my_tracker/data/datasources/local/hive_service.dart';

abstract class ProfileLocalDataSource {
  Future<void> saveProfile(ProfileModel profile);
  Future<ProfileModel?> getProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final HiveService hiveService;
  static const String currentUserId = 'current_user';

  ProfileLocalDataSourceImpl({required this.hiveService});

  @override
  Future<void> saveProfile(ProfileModel profile) async {
    await hiveService.profileBox.put(currentUserId, profile);
  }

  @override
  Future<ProfileModel?> getProfile() async {
    return hiveService.profileBox.get(currentUserId);
  }
}
