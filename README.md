![Logo](promo/logo.svg)

# Updat - The simple-to-use, flutter-based desktop update package



Update is a simple-to-use reliable flutter-native updated that handles your application's updates. All you need is a place to host your files and a place to check for the latest version.

# Getting Started

```dart
UpdatWidget(
  currentVersion: "1.0.0",
  getLatestVersion: () async {
    return "1.0.1";
  },
  getBinaryUrl: (latestVersion) async {
    return "https://github.com/latest/release/bin.exe";
  },
  appName: "Updat Example",
  closeOnInstall: false,
  openOnDownload: true,
  getChangelog: (latestVersion, appVersion) async {
    return "This is a changelog";
  },
),
```

