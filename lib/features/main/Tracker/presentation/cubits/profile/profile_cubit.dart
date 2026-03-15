import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/domain/entities/profile_entity.dart';
import 'package:try_my_tracker/domain/usecases/profile_usecases.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/cubits/profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfile getProfileUseCase;
  final SaveProfile saveProfileUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.saveProfileUseCase,
  }) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await getProfileUseCase();
      if (profile != null) {
        emit(ProfileLoaded(profile));
      } else {
        // Fallback default user if not configured yet
        emit(ProfileLoaded(ProfileEntity(id: 'current_user', name: 'Ahmed Ehab')));
      }
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> saveProfile(ProfileEntity profile) async {
    emit(ProfileLoading());
    try {
      await saveProfileUseCase(profile);
      emit(ProfileSaveSuccess());
      await loadProfile(); // Immediately refresh the state globally
    } catch (e) {
      emit(ProfileError('Failed to save profile: ${e.toString()}'));
    }
  }
}
