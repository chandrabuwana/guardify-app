import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_profile_details_usecase.dart';
import '../../domain/usecases/update_profile_details_usecase.dart';
import '../../domain/usecases/update_name_usecase.dart';
import '../../domain/usecases/update_profile_photo_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// BLoC untuk mengelola state profile
/// 
/// BLoC ini menangani semua business logic terkait dengan
/// manajemen profile seperti load, update, upload foto, dan logout.
@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileDetailsUseCase getProfileDetailsUseCase;
  final UpdateProfileDetailsUseCase updateProfileDetailsUseCase;
  final UpdateNameUseCase updateNameUseCase;
  final UpdateProfilePhotoUseCase updateProfilePhotoUseCase;
  final LogoutUseCase logoutUseCase;
  final ProfileRepository profileRepository;

  ProfileBloc({
    required this.getProfileDetailsUseCase,
    required this.updateProfileDetailsUseCase,
    required this.updateNameUseCase,
    required this.updateProfilePhotoUseCase,
    required this.logoutUseCase,
    required this.profileRepository,
  }) : super(const ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<RefreshProfileEvent>(_onRefreshProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<UpdateNameEvent>(_onUpdateName);
    on<UpdateProfilePhotoEvent>(_onUpdateProfilePhoto);
    on<UploadDocumentEvent>(_onUploadDocument);
    on<LogoutEvent>(_onLogout);
    on<ShowLogoutConfirmationEvent>(_onShowLogoutConfirmation);
    on<HideLogoutConfirmationEvent>(_onHideLogoutConfirmation);
  }

  /// Handler untuk load profile event
  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    
    try {
      final profile = await getProfileDetailsUseCase(event.userId);
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  /// Handler untuk refresh profile event
  Future<void> _onRefreshProfile(
    RefreshProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    // Tidak perlu emit loading untuk refresh
    try {
      final profile = await getProfileDetailsUseCase(event.userId);
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  /// Handler untuk update profile event
  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileUpdateInProgress(
        currentProfile: currentState.profile,
        updateMessage: 'Mengupdate profil...',
      ));
      
      try {
        final updatedProfile = await updateProfileDetailsUseCase(event.updatedProfile);
        emit(ProfileUpdateSuccess(
          updatedProfile: updatedProfile,
          successMessage: 'Profil berhasil diupdate',
        ));
        
        // Kembali ke loaded state dengan data terbaru
        emit(ProfileLoaded(profile: updatedProfile));
      } catch (e) {
        emit(ProfileUpdateFailure(
          currentProfile: currentState.profile,
          errorMessage: e.toString(),
        ));
        
        // Kembali ke loaded state dengan data lama
        emit(ProfileLoaded(profile: currentState.profile));
      }
    }
  }

  /// Handler untuk update name event
  Future<void> _onUpdateName(
    UpdateNameEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileUpdateInProgress(
        currentProfile: currentState.profile,
        updateMessage: 'Mengupdate nama...',
      ));
      
      try {
        final updatedProfile = await updateNameUseCase(event.userId, event.newName);
        emit(ProfileUpdateSuccess(
          updatedProfile: updatedProfile,
          successMessage: 'Nama berhasil diupdate',
        ));
        
        // Kembali ke loaded state dengan data terbaru
        emit(ProfileLoaded(profile: updatedProfile));
      } catch (e) {
        emit(ProfileUpdateFailure(
          currentProfile: currentState.profile,
          errorMessage: e.toString(),
        ));
        
        // Kembali ke loaded state dengan data lama
        emit(ProfileLoaded(profile: currentState.profile));
      }
    }
  }

  /// Handler untuk update profile photo event
  Future<void> _onUpdateProfilePhoto(
    UpdateProfilePhotoEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileUpdateInProgress(
        currentProfile: currentState.profile,
        updateMessage: 'Mengupload foto...',
      ));
      
      try {
        final updatedProfile = await updateProfilePhotoUseCase(event.userId, event.imagePath);
        emit(ProfileUpdateSuccess(
          updatedProfile: updatedProfile,
          successMessage: 'Foto profil berhasil diupdate',
        ));
        
        // Kembali ke loaded state dengan data terbaru
        emit(ProfileLoaded(profile: updatedProfile));
      } catch (e) {
        emit(ProfileUpdateFailure(
          currentProfile: currentState.profile,
          errorMessage: e.toString(),
        ));
        
        // Kembali ke loaded state dengan data lama
        emit(ProfileLoaded(profile: currentState.profile));
      }
    }
  }

  /// Handler untuk upload document event
  Future<void> _onUploadDocument(
    UploadDocumentEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(DocumentUploadInProgress(
        currentProfile: currentState.profile,
        documentType: event.documentType,
      ));
      
      try {
        final documentUrl = await profileRepository.uploadDocument(
          event.userId,
          event.documentType,
          event.filePath,
        );
        
        emit(DocumentUploadSuccess(
          currentProfile: currentState.profile,
          documentUrl: documentUrl,
          documentType: event.documentType,
        ));
        
        // Refresh profile untuk mendapatkan data dokumen terbaru
        add(RefreshProfileEvent(event.userId));
      } catch (e) {
        emit(DocumentUploadFailure(
          currentProfile: currentState.profile,
          errorMessage: e.toString(),
        ));
        
        // Kembali ke loaded state
        emit(ProfileLoaded(profile: currentState.profile));
      }
    }
  }

  /// Handler untuk logout event
  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const LogoutInProgress());
    
    try {
      await logoutUseCase();
      emit(const LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }

  /// Handler untuk show logout confirmation
  void _onShowLogoutConfirmation(
    ShowLogoutConfirmationEvent event,
    Emitter<ProfileState> emit,
  ) {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(currentState.copyWith(showLogoutConfirmation: true));
    }
  }

  /// Handler untuk hide logout confirmation
  void _onHideLogoutConfirmation(
    HideLogoutConfirmationEvent event,
    Emitter<ProfileState> emit,
  ) {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(currentState.copyWith(showLogoutConfirmation: false));
    }
  }
}