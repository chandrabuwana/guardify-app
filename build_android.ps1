#!/usr/bin/env pwsh

Write-Host "Starting Android build process..."

# Set error action
$ErrorActionPreference = "Continue"

# Clean project
Write-Host "Cleaning project..."
try {
    & flutter clean
    Write-Host "Clean completed successfully"
} catch {
    Write-Host "Clean failed: $_"
}

# Get dependencies
Write-Host "Getting dependencies..."
try {
    & flutter pub get
    Write-Host "Dependencies resolved successfully"
} catch {
    Write-Host "Dependencies failed: $_"
}

# Build APK
Write-Host "Building APK..."
try {
    & flutter build apk --debug --target lib/main_simple.dart
    Write-Host "APK build completed successfully"
} catch {
    Write-Host "APK build failed: $_"
}

# Install APK if build succeeded
$apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
if (Test-Path $apkPath) {
    Write-Host "APK found at: $apkPath"
    Write-Host "Installing APK to emulator..."
    try {
        & adb -s emulator-5554 install $apkPath
        Write-Host "APK installed successfully"
        
        # Launch app
        Write-Host "Launching app..."
        & adb -s emulator-5554 shell am start -n com.guardify.guardify_app/.MainActivity
        Write-Host "App launched successfully"
    } catch {
        Write-Host "Installation/Launch failed: $_"
    }
} else {
    Write-Host "APK not found at: $apkPath"
}

Write-Host "Android build process completed."
