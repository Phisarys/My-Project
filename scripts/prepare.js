// Copies the two app fonts out of node_modules into www/fonts so the app
// works with no internet connection. If a file is missing the app still
// runs and falls back to the iPhone's system font.
const fs = require('fs');
const path = require('path');
const out = path.join(__dirname, '..', 'www', 'fonts');
fs.mkdirSync(out, { recursive: true });
const wanted = [
  ['@fontsource/barlow-condensed', 'barlow-condensed-latin-600-normal.woff2'],
  ['@fontsource/barlow-condensed', 'barlow-condensed-latin-700-normal.woff2'],
  ['@fontsource/barlow-condensed', 'barlow-condensed-latin-800-italic.woff2'],
  ['@fontsource/atkinson-hyperlegible', 'atkinson-hyperlegible-latin-400-normal.woff2'],
  ['@fontsource/atkinson-hyperlegible', 'atkinson-hyperlegible-latin-700-normal.woff2'],
];
for (const [pkg, file] of wanted) {
  const src = path.join(__dirname, '..', 'node_modules', pkg, 'files', file);
  if (fs.existsSync(src)) {
    fs.copyFileSync(src, path.join(out, file));
    console.log('copied', file);
  } else {
    console.warn('font not found, app will use the system font instead:', file);
  }
}

// Sign-in and online storage (Firebase). If a file is missing the app loads
// it from Google's servers instead.
const vendor = path.join(__dirname, '..', 'www', 'vendor');
fs.mkdirSync(vendor, { recursive: true });
for (const file of ['firebase-app-compat.js', 'firebase-auth-compat.js', 'firebase-firestore-compat.js']) {
  const src = path.join(__dirname, '..', 'node_modules', 'firebase', file);
  if (fs.existsSync(src)) {
    fs.copyFileSync(src, path.join(vendor, file));
    console.log('copied', file);
  } else {
    console.warn('not found, app will load it from the internet instead:', file);
  }
}

// Capacitor runtime, used only inside the iPhone and Android apps to reach
// native features such as Apple Health.
const capSrc = path.join(__dirname, '..', 'node_modules', '@capacitor', 'core', 'dist', 'capacitor.js');
if (fs.existsSync(capSrc)) {
  fs.copyFileSync(capSrc, path.join(vendor, 'capacitor.js'));
  console.log('copied capacitor.js');
} else {
  console.warn('capacitor.js not found');
}
