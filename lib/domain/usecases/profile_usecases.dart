import 'package:try_my_tracker/domain/entities/profile_entity.dart';
import 'package:try_my_tracker/domain/repositories/profile_repository.dart';

class SaveProfile {
  final ProfileRepository repository;

  SaveProfile(this.repository);

  Future<void> call(ProfileEntity profile) async {
    return repository.saveProfile(profile);
  }
}

class GetProfile {
  final ProfileRepository repository;

  GetProfile(this.repository);

  Future<ProfileEntity?> call() async {
    return repository.getProfile();
  }
}
