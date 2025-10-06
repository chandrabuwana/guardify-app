# Profile Feature Documentation

## Overview
Fitur Profile merupakan implementasi lengkap untuk manajemen profil user dalam aplikasi Guardify. Fitur ini dikembangkan menggunakan **Clean Architecture** dengan **BLoC pattern** untuk state management dan mengikuti prinsip **SOLID**.

## Struktur Folder

```
lib/features/profile/
├── data/
│   ├── datasources/
│   │   ├── profile_remote_datasource.dart           # Abstract remote data source
│   │   ├── profile_remote_datasource_impl.dart     # Implementation remote data source
│   │   └── profile_local_datasource.dart           # Local data source dengan SharedPreferences
│   ├── models/
│   │   └── profile_user_model.dart                 # Data model untuk serialization
│   └── repositories/
│       └── profile_repository_impl.dart            # Implementation repository
├── domain/
│   ├── entities/
│   │   └── profile_user.dart                       # Domain entity
│   ├── repositories/
│   │   └── profile_repository.dart                 # Repository interface
│   └── usecases/
│       ├── get_profile_details_usecase.dart        # Use case untuk get profile
│       ├── update_profile_details_usecase.dart     # Use case untuk update profile
│       ├── update_name_usecase.dart                # Use case untuk update nama
│       ├── update_profile_photo_usecase.dart       # Use case untuk update foto
│       └── logout_usecase.dart                     # Use case untuk logout
└── presentation/
    ├── bloc/
    │   ├── profile_bloc.dart                       # BLoC untuk state management
    │   ├── profile_event.dart                      # Events definition
    │   └── profile_state.dart                      # States definition
    ├── pages/
    │   ├── profile_screen.dart                     # Layar utama profil
    │   ├── profile_details_screen.dart             # Layar detail profil
    │   └── edit_name_screen.dart                   # Layar edit nama
    └── widgets/
        ├── profile_header.dart                     # Widget header profil
        ├── profile_menu_item.dart                  # Widget item menu
        └── profile_detail_item.dart                # Widget detail item
```

## Fitur yang Tersedia

### 1. ProfileScreen (Layar Utama)
- Menampilkan foto profil, nama, dan NRP user
- Menu navigasi ke:
  - **Profil Saya**: Detail lengkap profil
  - **Bantuan**: Fitur bantuan (placeholder)
  - **Keluar**: Logout dengan konfirmasi

### 2. ProfileDetailsScreen (Detail Profil)
- **Tab Info Pribadi**: Menampilkan data lengkap user
- **Tab Dokumen**: Manajemen dokumen user (KTP, KTA, Foto, dll)
- Edit nama dengan validation
- Upload foto profil (placeholder)

### 3. EditNameScreen (Edit Nama)
- Form validation untuk nama
- Konfirmasi perubahan data
- Success feedback

## State Management dengan BLoC

### Events
- `LoadProfileEvent`: Load data profil
- `RefreshProfileEvent`: Refresh data profil
- `UpdateProfileEvent`: Update profil lengkap
- `UpdateNameEvent`: Update nama
- `UpdateProfilePhotoEvent`: Update foto profil
- `UploadDocumentEvent`: Upload dokumen
- `LogoutEvent`: Logout user
- `ShowLogoutConfirmationEvent`: Show dialog konfirmasi logout
- `HideLogoutConfirmationEvent`: Hide dialog konfirmasi logout

### States
- `ProfileInitial`: State awal
- `ProfileLoading`: Loading data profil
- `ProfileLoaded`: Data profil berhasil dimuat
- `ProfileUpdateInProgress`: Sedang update profil
- `ProfileUpdateSuccess`: Update berhasil
- `ProfileUpdateFailure`: Update gagal
- `DocumentUploadInProgress`: Sedang upload dokumen
- `DocumentUploadSuccess`: Upload dokumen berhasil
- `DocumentUploadFailure`: Upload dokumen gagal
- `LogoutInProgress`: Sedang logout
- `LogoutSuccess`: Logout berhasil
- `LogoutFailure`: Logout gagal
- `ProfileError`: Error saat load profil

## API Integration

### Endpoints
- `GET /api/v1/profile/{userId}`: Get profile details
- `PUT /api/v1/profile/{userId}`: Update profile details
- `PATCH /api/v1/profile/{userId}/name`: Update nama
- `POST /api/v1/profile/{userId}/photo`: Upload foto profil
- `POST /api/v1/profile/{userId}/documents`: Upload dokumen
- `POST /api/v1/auth/logout`: Logout

### Error Handling
- Network errors dengan fallback ke cached data
- Validation errors dengan user-friendly messages
- Server errors dengan retry options

## Caching Strategy
- Profile data di-cache di SharedPreferences
- Auto fallback ke cached data jika network gagal
- Cache invalidation saat update berhasil

## Navigation
- Route: `/profile?userId={userId}`
- Deep linking support
- Back navigation handling untuk unsaved changes

## Komponen Global yang Digunakan
- `AppScaffold`: Layout scaffold global
- `InputPrimary`: Text input field global
- `UIButton`: Button component global
- `ConfirmDialog`: Dialog konfirmasi global

## Usage Example

### Navigasi ke Profile
```dart
Navigator.pushNamed(
  context,
  '/profile',
  arguments: {'userId': 'user123'},
);
```

### Menggunakan ProfileBloc
```dart
BlocProvider(
  create: (context) => getIt<ProfileBloc>()..add(LoadProfileEvent(userId)),
  child: ProfileScreen(userId: userId),
)
```

## Testing
- Unit tests untuk domain layer (use cases, entities)
- Widget tests untuk presentation layer
- Integration tests untuk complete user flows
- Mock implementations untuk testing

## Security Considerations
- Auth token management dengan secure storage
- Input validation dan sanitization
- File upload security dengan type checking
- Session management dengan auto logout

## Performance Optimizations
- Lazy loading dengan BLoC pattern
- Image caching untuk foto profil
- Debounced search untuk optimasi input
- Memory management dengan proper dispose

## Future Enhancements
- Photo upload dengan image picker
- Document viewer integration
- Biometric authentication
- Real-time profile sync
- Offline mode support

## Dependency Injection
Profile feature menggunakan GetIt untuk dependency injection:
```dart
// Data Sources
getIt.registerLazySingleton<ProfileRemoteDataSource>(
  () => ProfileRemoteDataSourceImpl(getIt<http.Client>()),
);

// Repository
getIt.registerLazySingleton<ProfileRepository>(
  () => ProfileRepositoryImpl(
    remoteDataSource: getIt<ProfileRemoteDataSource>(),
    localDataSource: getIt<ProfileLocalDataSource>(),
  ),
);

// Use Cases & BLoC
getIt.registerFactory<ProfileBloc>(() => ProfileBloc(...));
```