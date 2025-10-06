import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_user.dart';

/// Abstract base class untuk semua profile events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Event untuk load profile details pertama kali
class LoadProfileEvent extends ProfileEvent {
  final String userId;

  const LoadProfileEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Event untuk refresh profile data
class RefreshProfileEvent extends ProfileEvent {
  final String userId;

  const RefreshProfileEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Event untuk update profile details
class UpdateProfileEvent extends ProfileEvent {
  final ProfileUser updatedProfile;

  const UpdateProfileEvent(this.updatedProfile);

  @override
  List<Object?> get props => [updatedProfile];
}

/// Event untuk update nama user
class UpdateNameEvent extends ProfileEvent {
  final String userId;
  final String newName;

  const UpdateNameEvent({
    required this.userId,
    required this.newName,
  });

  @override
  List<Object?> get props => [userId, newName];
}

/// Event untuk update foto profil
class UpdateProfilePhotoEvent extends ProfileEvent {
  final String userId;
  final String imagePath;

  const UpdateProfilePhotoEvent({
    required this.userId,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [userId, imagePath];
}

/// Event untuk upload dokumen
class UploadDocumentEvent extends ProfileEvent {
  final String userId;
  final String documentType;
  final String filePath;

  const UploadDocumentEvent({
    required this.userId,
    required this.documentType,
    required this.filePath,
  });

  @override
  List<Object?> get props => [userId, documentType, filePath];
}

/// Event untuk logout
class LogoutEvent extends ProfileEvent {
  const LogoutEvent();
}

/// Event untuk show logout confirmation dialog
class ShowLogoutConfirmationEvent extends ProfileEvent {
  const ShowLogoutConfirmationEvent();
}

/// Event untuk hide logout confirmation dialog
class HideLogoutConfirmationEvent extends ProfileEvent {
  const HideLogoutConfirmationEvent();
}