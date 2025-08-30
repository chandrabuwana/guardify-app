# Guardify App - Secure Flutter Application

Aplikasi Flutter dengan arsitektur yang aman menggunakan Clean Architecture, BLoC pattern, dan fitur keamanan tingkat enterprise.

## Fitur Keamanan

### 🔐 Autentikasi Multi-Layer
- **Login Email/Password** dengan validasi ketat
- **Autentikasi Biometrik** (fingerprint, face recognition)
- **PIN Authentication** sebagai fallback
- **Token-based Authentication** dengan refresh mechanism

### 🛡️ Enkripsi & Penyimpanan Aman
- **Flutter Secure Storage** untuk data sensitif
- **PBKDF2 Password Hashing** dengan salt
- **AES Encryption** untuk data tambahan
- **Keychain/Keystore Integration** platform-native

### 🌐 Network Security
- **SSL Pinning** untuk mencegah MITM attacks
- **Request Signing** untuk verifikasi integritas
- **Auto Token Refresh** dengan fallback logout
- **API Rate Limiting** protection

### 📱 Device Security
- **Device Binding** untuk session security
- **Jailbreak/Root Detection** (dapat ditambahkan)
- **App Signature Verification**
- **Screen Recording Protection** (dapat ditambahkan)

## Arsitektur

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
└── features/
    └── auth/
        ├── data/
        │   ├── datasources/  # API & local data sources
        │   ├── models/       # Data models & serialization
        │   └── repositories/ # Repository implementations
        ├── domain/
        │   ├── entities/     # Business entities
        │   ├── repositories/ # Repository contracts
        │   └── usecases/     # Business logic use cases
        └── presentation/
            ├── bloc/         # BLoC state management
            ├── pages/        # UI screens
            └── widgets/      # Reusable UI components
```

### State Management - BLoC Pattern
- **Events**: User actions (login, logout, register, biometric)
- **States**: UI states (loading, authenticated, error)
- **Cubits**: Simple state management untuk feature kecil

## Security Implementation

### Password Security
```dart
// Password requirements
- Minimum 8 karakter
- Maksimum 128 karakter  
- Harus mengandung: huruf besar, kecil, angka, simbol khusus
- PBKDF2 hashing dengan 100,000 iterations
```

### Biometric Authentication
```dart
// Biometric support check
- Availability detection
- Multiple biometric types support
- Graceful fallback ke PIN/password
- Platform-specific implementations
```

### Data Encryption
```dart
// Encryption layers
- Flutter Secure Storage (hardware-backed)
- Custom AES encryption untuk additional data
- Salt-based password hashing
- Secure key derivation
```

## Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- Android SDK 21+ / iOS 12.0+

### Installation
```bash
# Clone repository
git clone https://github.com/your-username/guardify-app.git
cd guardify-app

# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build

# Run app
flutter run
```

### Platform Setup

#### Android
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
<uses-permission android:name="android.permission.USE_FINGERPRINT" />
<uses-permission android:name="android.permission.INTERNET" />
```

#### iOS
```xml
<!-- ios/Runner/Info.plist -->
<key>NSFaceIDUsageDescription</key>
<string>Aplikasi ini menggunakan Face ID untuk autentikasi yang aman</string>
```

## Development

### Code Generation
```bash
# Generate all files
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (development)
flutter pub run build_runner watch
```

### Testing
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Coverage report
flutter test --coverage
```

### Build Production
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

## Security Best Practices

### ✅ Implemented
- [x] Secure password policies
- [x] Biometric authentication
- [x] Encrypted local storage
- [x] Network security (SSL, request signing)
- [x] Input validation & sanitization
- [x] Error handling without data leakage
- [x] Session management
- [x] Token refresh mechanism

### 🔄 Roadmap
- [ ] SSL Certificate pinning
- [ ] Root/Jailbreak detection
- [ ] Screen recording protection
- [ ] Advanced threat detection
- [ ] Security analytics
- [ ] Audit logging

## Dependencies

### Core
- `flutter_bloc` - State management
- `get_it` + `injectable` - Dependency injection
- `dartz` - Functional programming

### Security
- `flutter_secure_storage` - Secure storage
- `local_auth` - Biometric authentication
- `crypto` - Cryptographic functions
- `device_info_plus` - Device information

### Network
- `dio` - HTTP client
- `retrofit` - Type-safe HTTP client
- `json_annotation` - JSON serialization

### UI/UX
- Material Design 3
- Custom security-focused widgets
- Responsive design
- Accessibility support

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Security

If you discover any security vulnerabilities, please send an email to security@guardify.com instead of using the issue tracker.

---

**Note**: Ini adalah implementasi dasar yang dapat dikembangkan lebih lanjut sesuai kebutuhan keamanan spesifik aplikasi Anda.