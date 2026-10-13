#!/bin/bash
# Runs on the cloud Mac after "npx cap add ios" has generated the Xcode project.
# Adds the permission messages iOS requires for choosing a profile photo and
# installs the app icon.
set -e
PLIST="ios/App/App/Info.plist"
set_string () {
  /usr/libexec/PlistBuddy -c "Add :$1 string $2" "$PLIST" 2>/dev/null || /usr/libexec/PlistBuddy -c "Set :$1 $2" "$PLIST"
}
# Name shown under the icon on the home screen.
set_string CFBundleDisplayName FiveArc
set_string NSCameraUsageDescription "'Take a photo to use as your profile picture.'"
set_string NSPhotoLibraryUsageDescription "'Choose a photo to use as your profile picture.'"
set_string NSHealthShareUsageDescription "'Reads your workouts from Apple Health and Apple Watch so they are logged in Fitness automatically.'"
# The app only reads from Apple Health, so it asks for no permission to write.
/usr/libexec/PlistBuddy -c "Delete :NSHealthUpdateUsageDescription" "$PLIST" 2>/dev/null || true
# Only standard HTTPS encryption is used, so TestFlight needs no export paperwork.
/usr/libexec/PlistBuddy -c "Add :ITSAppUsesNonExemptEncryption bool false" "$PLIST" 2>/dev/null || /usr/libexec/PlistBuddy -c "Set :ITSAppUsesNonExemptEncryption false" "$PLIST"

# HealthKit and Declared Age Range entitlements (the App ID must also have
# both capabilities switched on, and the provisioning profile must be created
# after that).
cat > ios/App/App/App.entitlements <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>com.apple.developer.healthkit</key>
  <true/>
  <key>com.apple.developer.healthkit.access</key>
  <array/>
  <key>com.apple.developer.declared-age-range</key>
  <true/>
</dict>
</plist>
PLIST
PBX="ios/App/App.xcodeproj/project.pbxproj"
if ! grep -q "CODE_SIGN_ENTITLEMENTS" "$PBX"; then
  perl -0pi -e 's|INFOPLIST_FILE = App/Info.plist;|INFOPLIST_FILE = App/Info.plist;\n\t\t\t\tCODE_SIGN_ENTITLEMENTS = App/App.entitlements;|g' "$PBX"
fi
grep -c "CODE_SIGN_ENTITLEMENTS = App/App.entitlements" "$PBX" | xargs echo "Entitlements set in build configurations:"

# iPhone only: no iPad version (device family 1 = iPhone, 2 = iPad).
perl -pi -e 's/TARGETED_DEVICE_FAMILY = "?[0-9,]+"?;/TARGETED_DEVICE_FAMILY = 1;/g' "$PBX"
/usr/libexec/PlistBuddy -c "Delete :UISupportedInterfaceOrientations~ipad" "$PLIST" 2>/dev/null || true
grep -c "TARGETED_DEVICE_FAMILY = 1;" "$PBX" | xargs echo "iPhone-only set in build configurations:"

ICONSET="ios/App/App/Assets.xcassets/AppIcon.appiconset"
if [ -d "$ICONSET" ]; then
  for f in "$ICONSET"/*.png; do
    [ -e "$f" ] && cp resources/icon.png "$f"
  done
  echo "App icon installed"
else
  echo "WARNING: icon folder not found at $ICONSET; the default icon will be used"
fi
