#!/bin/bash
# Runs on the cloud Mac after "npx cap add ios" has generated the Xcode project.
# Adds the permission messages iOS requires for choosing a profile photo and
# installs the app icon.
set -e
PLIST="ios/App/App/Info.plist"
set_string () {
  /usr/libexec/PlistBuddy -c "Add :$1 string $2" "$PLIST" 2>/dev/null || /usr/libexec/PlistBuddy -c "Set :$1 $2" "$PLIST"
}
set_string NSCameraUsageDescription "'Take a photo to use as your profile picture.'"
set_string NSPhotoLibraryUsageDescription "'Choose a photo to use as your profile picture.'"

ICONSET="ios/App/App/Assets.xcassets/AppIcon.appiconset"
if [ -d "$ICONSET" ]; then
  for f in "$ICONSET"/*.png; do
    [ -e "$f" ] && cp resources/icon.png "$f"
  done
  echo "App icon installed"
else
  echo "WARNING: icon folder not found at $ICONSET; the default icon will be used"
fi
