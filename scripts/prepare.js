// Copies the two app fonts out of node_modules into www/fonts so the app
// works with no internet connection. If a file is missing the app still
// runs and falls back to the iPhone's system font.
const fs = require('fs');
const path = require('path');
const out = path.join(__dirname, '..', 'www', 'fonts');
fs.mkdirSync(out, { recursive: true });
const wanted = [
  ['@fontsource/bricolage-grotesque', 'bricolage-grotesque-latin-500-normal.woff2'],
  ['@fontsource/bricolage-grotesque', 'bricolage-grotesque-latin-700-normal.woff2'],
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
