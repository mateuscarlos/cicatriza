import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_profile.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

class ProfileUpdateRequested extends ProfileEvent {
  final UserProfile profile;

  const ProfileUpdateRequested(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileImageUploadRequested extends ProfileEvent {
  final String imagePath;

  const ProfileImageUploadRequested(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}
