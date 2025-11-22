import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;

  ProfileBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const ProfileInitial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileUpdateRequested>(_onUpdateRequested);
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
    } catch (e) {
      emit(ProfileError('Erro ao carregar perfil: $e'));
    }
  }

  Future<void> _onUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      await _authRepository.updateProfile(event.profile);
      emit(ProfileUpdateSuccess(event.profile));
      // Emit Loaded again to show the updated profile
      emit(ProfileLoaded(event.profile));
    } catch (e) {
      emit(ProfileError('Erro ao atualizar perfil: $e'));
    }
  }
}
