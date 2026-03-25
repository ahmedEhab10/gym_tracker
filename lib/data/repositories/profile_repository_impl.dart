import 'package:try_my_tracker/data/datasources/local/profile_local_datasource.dart';
import 'package:try_my_tracker/data/models/profile_model.dart';
import 'package:try_my_tracker/domain/entities/profile_entity.dart';
import 'package:try_my_tracker/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveProfile(ProfileEntity profile) async {
    final model = ProfileModel(
      id: profile.id,
      name: profile.name,
      profilePicturePath: profile.profilePicturePath,
      age: profile.age,
      gender: profile.gender,
      goals: profile.goals,
    );
    await localDataSource.saveProfile(model);
  }

  @override
  Future<ProfileEntity?> getProfile() async {
    final model = await localDataSource.getProfile();
    if (model == null) return null;
    return MeasurementEntityMapper._mapToEntity(model);
  }
}

class MeasurementEntityMapper {
  static ProfileEntity _mapToEntity(ProfileModel model) {
    return ProfileEntity(
      id: model.id,
      name: model.name,
      profilePicturePath: model.profilePicturePath,
      age: model.age,
      gender: model.gender,
      goals: model.goals,
    );
  }
}
