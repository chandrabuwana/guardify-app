#!/bin/bash
set -e

PUBSPEC_FILE="pubspec.yaml"

if [ ! -f "$PUBSPEC_FILE" ]; then
  echo "❌ pubspec.yaml not found"
  exit 1
fi

echo "🔢 Auto-incrementing Android build number (versionCode)..."
current_version=$(grep "^version:" "$PUBSPEC_FILE" | sed 's/version: //')
version_name=$(echo "$current_version" | cut -d'+' -f1)
build_number=$(echo "$current_version" | cut -d'+' -f2)

if [ -z "$build_number" ]; then
  build_number=1
fi

new_build_number=$((build_number + 1))
new_version="${version_name}+${new_build_number}"

sed -i '' "s/^version: .*/version: ${new_version}/" "$PUBSPEC_FILE"

echo "✅ Version updated: $current_version → $new_version"
echo "   Version Name: $version_name"
echo "   Build Number: $build_number → $new_build_number"

echo ""
echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "📦 Building Android App Bundle (.aab)..."
flutter build appbundle --release --build-name="$version_name" --build-number="$new_build_number"

echo ""
echo "✅ Build complete!"
echo "   Version: $new_version"
echo "   AAB: build/app/outputs/bundle/release/app-release.aab"
