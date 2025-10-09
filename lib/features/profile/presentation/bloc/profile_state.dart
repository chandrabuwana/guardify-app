import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_user.dart';

/// Abstract base class untuk semua profile states
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state saat pertama kali BLoC dibuat
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// State ketika sedang loading data profile
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// State ketika profile berhasil dimuat
class ProfileLoaded extends ProfileState {
  final ProfileUser profile;
  final bool showLogoutConfirmation;
  final bool showDeleteAccountConfirmation;

  const ProfileLoaded({
    required this.profile,
    this.showLogoutConfirmation = false,
    this.showDeleteAccountConfirmation = false,
  });

  @override
  List<Object?> get props => [profile, showLogoutConfirmation, showDeleteAccountConfirmation];

  /// Copy with method untuk update state
  ProfileLoaded copyWith({
    ProfileUser? profile,
    bool? showLogoutConfirmation,
    bool? showDeleteAccountConfirmation,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      showLogoutConfirmation: showLogoutConfirmation ?? this.showLogoutConfirmation,
      showDeleteAccountConfirmation: showDeleteAccountConfirmation ?? this.showDeleteAccountConfirmation,
    );
  }
}

/// State ketika sedang proses update profile
class ProfileUpdateInProgress extends ProfileState {
  final ProfileUser currentProfile;
  final String? updateMessage;

  const ProfileUpdateInProgress({
    required this.currentProfile,
    this.updateMessage,
  });

  @override
  List<Object?> get props => [currentProfile, updateMessage];
}

/// State ketika update profile berhasil
class ProfileUpdateSuccess extends ProfileState {
  final ProfileUser updatedProfile;
  final String successMessage;

  const ProfileUpdateSuccess({
    required this.updatedProfile,
    required this.successMessage,
  });

  @override
  List<Object?> get props => [updatedProfile, successMessage];
}

/// State ketika update profile gagal
class ProfileUpdateFailure extends ProfileState {
  final ProfileUser currentProfile;
  final String errorMessage;

  const ProfileUpdateFailure({
    required this.currentProfile,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [currentProfile, errorMessage];
}

/// State ketika sedang proses upload dokumen
class DocumentUploadInProgress extends ProfileState {
  final ProfileUser currentProfile;
  final String documentType;

  const DocumentUploadInProgress({
    required this.currentProfile,
    required this.documentType,
  });

  @override
  List<Object?> get props => [currentProfile, documentType];
}

/// State ketika upload dokumen berhasil
class DocumentUploadSuccess extends ProfileState {
  final ProfileUser currentProfile;
  final String documentUrl;
  final String documentType;

  const DocumentUploadSuccess({
    required this.currentProfile,
    required this.documentUrl,
    required this.documentType,
  });

  @override
  List<Object?> get props => [currentProfile, documentUrl, documentType];
}

/// State ketika upload dokumen gagal
class DocumentUploadFailure extends ProfileState {
  final ProfileUser currentProfile;
  final String errorMessage;

  const DocumentUploadFailure({
    required this.currentProfile,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [currentProfile, errorMessage];
}

/// State ketika sedang proses logout
class LogoutInProgress extends ProfileState {
  const LogoutInProgress();
}

/// State ketika logout berhasil
class LogoutSuccess extends ProfileState {
  const LogoutSuccess();
}

/// State ketika logout gagal
class LogoutFailure extends ProfileState {
  final String errorMessage;

  const LogoutFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

/// State ketika terjadi error saat load profile
class ProfileError extends ProfileState {
  final String message;
  final String? errorCode;

  const ProfileError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

/// State ketika sedang proses hapus akun
class DeleteAccountInProgress extends ProfileState {
  const DeleteAccountInProgress();
}

/// State ketika hapus akun berhasil
class DeleteAccountSuccess extends ProfileState {
  const DeleteAccountSuccess();
}

/// State ketika hapus akun gagal
class DeleteAccountFailure extends ProfileState {
  final String errorMessage;

  const DeleteAccountFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}