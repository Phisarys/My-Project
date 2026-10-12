#!/bin/bash
# Runs in the cloud build after "npx cap add android".
# Replaces the default icon and splash screen with the app's own.
# If this step fails the app still builds, just with the default icon.
npx --yes @capacitor/assets generate --android --assetPath assets \
  || echo "WARNING: could not generate Android icons; the default icon will be used"
