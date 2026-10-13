# FiveArc

One project that produces three things from the same files:

1. **A public website** anyone can open from a link and pin to their phone's
   Home Screen, where it opens full screen like an app (iPhone and Android).
2. **An Android app** you can install on any Android phone for free.
3. **An iPhone App Store app** (later; needs the paid Apple membership).

Everything is built in the cloud by GitHub. You do not need a Mac or any
software on your computer.

Status: the app's web files were tested in a phone-sized browser, including
the Home Screen tip and offline support. The cloud builds (website publish and
Android build) have NOT been run yet, because they need your GitHub account.
The first run may need a small fix; if a build shows a red X, send the log to
Claude.

## Part A: website and Android app (free)

### 1. Put the project on GitHub
1. Create a free account at github.com.
2. Create a new repository. Make it **Public** (free website hosting needs a
   public repository; the code is visible, but no one's entries are, because
   entries are stored in each person's private online record).
3. Upload everything in this folder, including the hidden `.github` folder.
   Easiest way without tools: on the new repository page choose "uploading an
   existing file" and drag the folder contents in. If the `.github` folder
   does not upload, ask Claude to push the project for you instead.

### 2. Turn on the website
In the repository: Settings > Pages > Build and deployment > Source: choose
**GitHub Actions**. Then open the Actions tab and run the "Website" workflow
(or upload any change). When it finishes with a green check, your site is at

    https://YOUR-USERNAME.github.io/YOUR-REPOSITORY/

That link is what you share.

### 3. Pin it on a phone
- **iPhone:** open the link in Safari, tap the Share button, then "Add to Home
  Screen". The site shows this tip on its first screen.
- **Android:** open the link in Chrome and tap "Install app" when offered.

Accounts are online: the same email and password work on the website, the
Android app and any other phone, and a person's profile and entries follow
them. See "Accounts and online storage" below.

### 4. Get the Android app
The "Android app" workflow runs automatically. When it finishes, open the
repository's **Releases** page on an Android phone and download
`fivearc.apk`, then open it. Android asks once for permission to install
apps from your browser.

New builds install over the old one and keep your entries.

## Part B: later, for the stores

- **Google Play:** one-time US$25 developer account. New personal accounts
  must run a closed test with 12 testers for 14 days before going public.
  The store needs a private release signing key, not the test key in this
  project (`resources/debug.keystore`, which is public and for testing only).
- **Apple App Store:** yearly Apple Developer membership. `codemagic.yaml`
  and `scripts/ios-setup.sh` are ready for a cloud Mac build to TestFlight.
  Steps: register an App ID and app with Apple, create an App Store Connect
  API key, add it to Codemagic as `appstore-key`, generate a distribution
  certificate and fetch a provisioning profile in Codemagic, then run the
  workflow.
- **Apple Watch / Apple Health:** the iPhone app reads workouts from Apple
  Health (where Apple Watch saves them) and logs them in Fitness. When you
  register the App ID, tick the **HealthKit** capability *before* creating
  the provisioning profile, or the build will fail to sign. Apple also
  requires a privacy policy for apps that read Health data. The website and
  Android app cannot read Apple Health. Guide: https://docs.codemagic.io/yaml-quick-start/building-an-ionic-app/
- **Before any public store release:** a privacy policy.

## Accounts and online storage

Sign-in and saved data use the Firebase project `project-monarch1`.

- **Sign-in methods** are switched on in the Firebase console under
  Authentication > Sign-in method (Email/Password, and Google if wanted).
- **Google and Apple sign-in buttons were removed** (October 2026) because
  Google sign-in could not open from the iPhone Home Screen app. Email and
  password is the only way to sign in for now.
- **Database rules:** paste the contents of `firestore.rules` into Firestore
  Database > Rules and publish. They let each person read and write only
  their own record. Without them nothing can be saved.
- Each person has one record holding their profile, photo and entries.
  Deleting an account in the app erases that record.
- The Firebase settings inside `www/index.html` are not secret; the database
  rules are what protect the data.

## Names to change before a store release

- `appName` in `capacitor.config.json`, `short_name` in
  `www/manifest.webmanifest`, and `CFBundleDisplayName` in
  `scripts/ios-setup.sh`: the name under the icon, now "FiveArc"; about 12
  characters fit.
- `appId` in `capacitor.config.json` and `bundle_identifier` in
  `codemagic.yaml`: set to `com.phisarys.dailyfive`. It becomes permanent
  once the app is uploaded to a store, so do not change it after that.

## What is in here

| Path | What it is |
|---|---|
| `www/` | The app itself, plus the website's icons and offline support |
| `.github/workflows/` | The two cloud build recipes (website, Android) |
| `assets/`, `resources/` | Icon and splash images, and the Android test key |
| `scripts/` | Small helpers the builds run |
| `capacitor.config.json` | App name and ID |
| `codemagic.yaml` | iPhone build recipe for later |

## Updating the app

Replace `www/index.html` with the new version on GitHub. The website and the
Android app rebuild on their own.
