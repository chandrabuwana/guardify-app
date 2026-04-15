#!/bin/bash
set -e

PUBSPEC_FILE="pubspec.yaml"

APP_ENV="${1:-prod}"

if [[ "$APP_ENV" != "prod" && "$APP_ENV" != "dev" ]]; then
  echo "Usage: $0 [prod|dev]"
  exit 1
fi

echo "🔢 Auto-incrementing version..."
current_version=$(grep "^version:" $PUBSPEC_FILE | sed 's/version: //')
version_name=$(echo $current_version | cut -d'+' -f1)
build_number=$(echo $current_version | cut -d'+' -f2)

# Split version name into major.minor.patch
major=$(echo $version_name | cut -d'.' -f1)
minor=$(echo $version_name | cut -d'.' -f2)
patch=$(echo $version_name | cut -d'.' -f3)

# Increment patch version
new_patch=$((patch + 1))
new_version_name="${major}.${minor}.${new_patch}"

# Increment build number
new_build_number=$((build_number + 1))
new_version="${new_version_name}+${new_build_number}"

sed -i '' "s/^version: .*/version: ${new_version}/" $PUBSPEC_FILE

echo "✅ Version updated: $current_version → $new_version"
echo "   Version Name: $version_name → $new_version_name"
echo "   Build Number: $build_number → $new_build_number"

echo ""
echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "📱 Building IPA (APP_ENV=$APP_ENV)..."
flutter build ipa \
  --release \
  --export-options-plist=ios/exportOptions.plist \
  --dart-define=APP_ENV=$APP_ENV
echo ""
echo "✅ Build complete!"
echo "   Version: $new_version"
echo "   IPA: build/ios/ipa/*.ipa"
