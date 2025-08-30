# Guardify Security App - Android Setup Guide

## ✅ Android Configuration Complete!

Your Flutter security app is now configured to run on Android with the following setup:

### 🔧 **Android Configuration**

#### **Manifest Permissions** (`android/app/src/main/AndroidManifest.xml`)
```xml
<!-- Internet & Network -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

<!-- Biometric Authentication -->
<uses-permission android:name="android.permission.USE_FINGERPRINT" />
<uses-permission android:name="android.permission.USE_BIOMETRIC" />

<!-- Device Information -->
<uses-permission android:name="android.permission.READ_PHONE_STATE" />

<!-- Secure Storage -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" 
                 android:maxSdkVersion="28" />
```

#### **App Configuration**
- **App Name**: "Guardify Security"
- **Package ID**: `com.guardify.guardify_app`
- **Min SDK**: 23 (Android 6.0) - Required for biometric authentication
- **Target SDK**: Latest Flutter target

#### **Build System**
- **Gradle Version**: 8.5 (compatible with Java 21)
- **Android Gradle Plugin**: Latest from Flutter

### 🚀 **Running on Android**

#### **Method 1: Using VS Code**
1. Open the project in VS Code
2. Press `F5` or go to Run → Start Debugging
3. Select "Flutter (Android)" from the dropdown

#### **Method 2: Using Terminal**
```powershell
flutter run -d emulator-5554 lib/main_simple.dart
```

#### **Method 3: Using Scripts**
```powershell
# PowerShell
.\run_android.ps1

# Or Batch
.\run_android.bat
```

### 📱 **Target Device**
- **Device ID**: `emulator-5554`
- **Platform**: Android SDK built for x86
- **API Level**: 29 (Android 10)

### 🔐 **Security Features Available on Android**

#### **Biometric Authentication**
- Fingerprint recognition
- Face recognition (if supported by device)
- Pattern/PIN fallback

#### **Secure Storage**
- Android Keystore integration
- Encrypted shared preferences
- Secure file storage

#### **Network Security**
- Certificate pinning capability
- Encrypted communication
- Request/response interceptors

#### **Device Security**
- Root detection capability
- App integrity verification
- Secure session management

### 🛠️ **Development Setup**

#### **Hot Reload**
- Press `r` in terminal for hot reload
- Press `R` for hot restart
- Press `q` to quit

#### **Debug Tools**
- Flutter Inspector available
- Android Studio profiler compatible
- VS Code debugging support

### 📂 **Project Structure**
```
android/
├── app/
│   ├── src/main/
│   │   ├── AndroidManifest.xml     # App permissions & config
│   │   ├── kotlin/                 # Native Android code
│   │   └── res/                    # App resources & icons
│   └── build.gradle                # App-level build config
├── build.gradle                    # Project-level build config
└── gradle/wrapper/
    └── gradle-wrapper.properties   # Gradle version config
```

### 🎯 **Next Steps**

1. **Test Security Features**: Run the app and test biometric authentication
2. **Customize UI**: Modify Material Design 3 theme for your brand
3. **Add More Features**: Implement additional security modules
4. **Performance Testing**: Profile app performance on different devices
5. **Production Build**: Create signed APK for distribution

### 🔍 **Troubleshooting**

#### **Common Issues**
- **Gradle Build Fails**: Check Java/Gradle version compatibility
- **Permissions Denied**: Verify manifest permissions
- **Biometrics Not Working**: Ensure device has biometric hardware
- **Network Issues**: Check internet connectivity

#### **Debug Commands**
```powershell
flutter doctor          # Check Flutter installation
flutter devices         # List available devices
flutter clean           # Clean build cache
flutter pub get         # Update dependencies
```

---

**Your Guardify Security App is ready for Android development! 🚀🔐**
