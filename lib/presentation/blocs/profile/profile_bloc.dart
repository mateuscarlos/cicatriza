import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;
  final FirebaseStorage _firebaseStorage;

  ProfileBloc({
    required AuthRepository authRepository,
    FirebaseStorage? firebaseStorage,
  }) : _authRepository = authRepository,
       _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
       super(const ProfileInitial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileUpdateRequested>(_onUpdateRequested);
    on<ProfileImageUploadRequested>(_onImageUploadRequested);
  }

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final user = _authRepository.currentUser;
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(const ProfileError('Usuário não autenticado'));
      }
    } on Exception catch (e) {
      emit(ProfileError('Erro ao carregar perfil: $e'));
    }
  }

  Future<void> _onUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await _authRepository.updateProfile(event.profile);

    if (result.isSuccess) {
      emit(ProfileUpdateSuccess(event.profile));
      // Emit Loaded again to show the updated profile
      emit(ProfileLoaded(event.profile));
    } else {
      emit(ProfileError(result.error ?? 'Erro ao atualizar perfil'));
    }
  }

  Future<void> _onImageUploadRequested(
    ProfileImageUploadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final currentUser = _authRepository.currentUser;
      if (currentUser == null) {
        emit(const ProfileError('Usuário não autenticado'));
        return;
      }

      emit(const ProfileLoading());

      // Upload da imagem para Firebase Storage
      final file = File(event.imagePath);
      final storageRef = _firebaseStorage
          .ref()
          .child('user_profiles')
          .child('${currentUser.uid}.jpg');

      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Atualizar perfil com nova URL da foto
      final updatedProfile = currentUser.copyWith(photoURL: downloadUrl);
      final updateResult = await _authRepository.updateProfile(updatedProfile);

      if (updateResult.isSuccess) {
        emit(ProfileUpdateSuccess(updatedProfile));
        emit(ProfileLoaded(updatedProfile));
      } else {
        emit(
          ProfileError(
            updateResult.error ?? 'Erro ao atualizar perfil com nova foto',
          ),
        );
      }
    } on Exception catch (e) {
      emit(ProfileError('Erro ao fazer upload da imagem: $e'));
    }
  }
}
