# Guardify App

Aplikasi Flutter dengan fitur keamanan tinggi menggunakan Clean Architecture dan BLoC pattern.

## Arsitektur Project

### Clean Architecture Structure
```
lib/
├── core/
│   ├── constants/       # App constants & configuration
│   ├── di/             # Dependency injection setup
│   ├── error/          # Error handling & exceptions
│   ├── network/        # Network configuration & interceptors
│   ├── security/       # Security utilities & managers
│   └── utils/          # Validators, logger, helpers
├── features/
│   └── auth/
│       ├── data/
│       │   ├── datasources/  # API & local data sources
│       │   ├── models/       # Data models & serialization
│       │   └── repositories/ # Repository implementations
│       ├── domain/
│       │   ├── entities/     # Business entities
│       │   ├── repositories/ # Repository contracts
│       │   └── usecases/     # Business logic use cases
│       └── presentation/
│           ├── bloc/         # BLoC state management
│           ├── pages/        # UI screens
│           └── widgets/      # Reusable UI components
└── shared/
    └── widgets/         # Shared UI components
```

### Design Patterns
- **Clean Architecture**: Separation of concerns dengan layer yang jelas
- **BLoC Pattern**: State management untuk reactive programming
- **Repository Pattern**: Abstraksi data sources
- **Dependency Injection**: Menggunakan GetIt untuk IoC container

## Spesifikasi Project

### Platform Support
- **Android**: API Level 21+ (Android 5.0)
- **iOS**: iOS 12.0+
- **Web**: Progressive Web App support
- **Desktop**: Windows, macOS, Linux

### Technical Requirements
- **Flutter SDK**: 3.10.0 atau lebih baru
- **Dart SDK**: 3.0.0 atau lebih baru
- **Android Studio**: 2022.2.1 atau lebih baru
- **Xcode**: 14.0+ (untuk iOS development)

### Dependencies Utama
```yaml
dependencies:
  flutter: sdk
  flutter_bloc: ^8.1.3          # State management
  get_it: ^7.6.4                # Dependency injection
  injectable: ^2.3.2            # Code generation untuk DI
  dio: ^5.3.2                   # HTTP client
  flutter_secure_storage: ^9.0.0 # Secure storage
  local_auth: ^2.1.6            # Biometric authentication
  device_info_plus: ^9.1.0      # Device information
  package_info_plus: ^4.2.0     # App information
  permission_handler: ^11.0.1   # Permissions management
```

### Fitur Utama
- **Authentication**: Login, register, biometric auth
- **Security**: Encrypted storage, secure networking
- **Cross-platform**: Support untuk multiple platform
- **Responsive UI**: Adaptive design untuk berbagai ukuran layar

## Cara Menjalankan Project

### 1. Persiapan Environment
```bash
# Pastikan Flutter sudah terinstall
flutter doctor

# Clone repository
git clone <repository-url>
cd guardify-app
```

### 2. Install Dependencies
```bash
# Install dependencies
flutter pub get

# Generate code (jika ada)
flutter pub run build_runner build
```

### 3. Platform Setup

#### Android
Tambahkan permissions di `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
<uses-permission android:name="android.permission.USE_FINGERPRINT" />
<uses-permission android:name="android.permission.INTERNET" />
```

#### iOS
Tambahkan konfigurasi di `ios/Runner/Info.plist`:
```xml
<key>NSFaceIDUsageDescription</key>
<string>App ini menggunakan Face ID untuk autentikasi</string>
```

### 4. Menjalankan Aplikasi
```bash
# Development mode
flutter run

# Pilih device
flutter run -d <device-id>

# Debug mode dengan hot reload
flutter run --debug

# Release mode
flutter run --release
```

### 5. Build untuk Production
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

### 6. Testing
```bash
# Unit tests
flutter test

# Widget tests
flutter test test/

# Generate coverage report
flutter test --coverage
```

### 7. Troubleshooting
```bash
# Clean build artifacts
flutter clean

# Reinstall dependencies
flutter pub get

# Rebuild generated files
flutter pub run build_runner build --delete-conflicting-outputs
```


./build-ios-auto.sh prod