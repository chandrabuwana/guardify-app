# Guardify Security App - Android Runner
Write-Host "Starting Guardify Security App on Android..." -ForegroundColor Green
Write-Host "Target Device: Android Emulator (emulator-5554)" -ForegroundColor Yellow
Write-Host "Entry Point: lib/main_simple.dart" -ForegroundColor Yellow
Write-Host ""

# Check if emulator is running
$devices = flutter devices
if ($devices -like "*emulator-5554*") {
    Write-Host "✅ Android emulator detected" -ForegroundColor Green
    flutter run -d emulator-5554 lib/main_simple.dart --android-skip-build-dependency-validation
} else {
    Write-Host "❌ Android emulator not found!" -ForegroundColor Red
    Write-Host "Please start your Android emulator first." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Available devices:" -ForegroundColor Cyan
    flutter devices
}
