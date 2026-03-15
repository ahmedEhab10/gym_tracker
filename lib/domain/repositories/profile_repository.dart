import 'package:try_my_tracker/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<void> saveProfile(ProfileEntity profile);
  Future<ProfileEntity?> getProfile();
}
