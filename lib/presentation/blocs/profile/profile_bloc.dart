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
      final user = await _authRepository.getCurrentUserAsync();
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
      final currentUser = await _authRepository.getCurrentUserAsync();
      if (currentUser == null) {
        emit(const ProfileError('Usuário não autenticado'));
        return;
      }

      emit(const ProfileLoading());

      // Verificar se o arquivo existe
      final file = File(event.imagePath);
      if (!await file.exists()) {
        emit(const ProfileError('Arquivo de imagem não encontrado'));
        return;
      }

      // Upload da imagem para Firebase Storage com timeout
      final storageRef = _firebaseStorage
          .ref()
          .child('user_profiles')
          .child(currentUser.uid)
          .child('profile.jpg');

      final uploadTask = storageRef.putFile(file);

      // Adicionar timeout de 30 segundos
      final snapshot = await uploadTask.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          uploadTask.cancel();
          throw Exception('Timeout no upload da imagem');
        },
      );

      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Atualizar perfil com nova URL da foto
      final updatedProfile = currentUser.copyWith(photoURL: downloadUrl);
      final updateResult = await _authRepository.updateProfile(updatedProfile);

      if (updateResult.isSuccess) {
        emit(ProfileUpdateSuccess(updatedProfile));
        // Recarregar o perfil atual do Firestore para garantir dados atualizados
        final refreshedProfile = await _authRepository.getCurrentUserAsync();
        if (refreshedProfile != null) {
          emit(ProfileLoaded(refreshedProfile));
        } else {
          emit(ProfileLoaded(updatedProfile));
        }
      } else {
        emit(
          ProfileError(
            updateResult.error ?? 'Erro ao atualizar perfil com nova foto',
          ),
        );
      }
    } on Exception catch (e) {
      // Limpar cache do arquivo se houver erro
      try {
        final file = File(event.imagePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {
        // Ignorar erro de limpeza
      }

      String errorMessage = 'Erro ao fazer upload da imagem';

      if (e.toString().contains('Permission denied') ||
          e.toString().contains('-13021')) {
        errorMessage = 'Erro de permissão. Verifique se você está logado.';
      } else if (e.toString().contains('Timeout')) {
        errorMessage = 'Upload cancelado por timeout. Verifique sua conexão.';
      } else if (e.toString().contains('App attestation failed')) {
        errorMessage = 'Erro de autenticação. Tente fazer login novamente.';
      }

      emit(ProfileError(errorMessage));
    }
  }
}
