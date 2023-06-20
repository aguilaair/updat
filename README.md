# Updat - The simple-to-use, flutter-based desktop update package

![Logo](https://github.com/aguilaair/updat/blob/main/promo/banner.svg)

Updat is a simple-to-use reliable flutter-native updater that handles your application's updates. All you need is a place to host your files and a place to check for the latest version.

<div align="center">
  <a href="https://github.com/aguilaair/updat/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/aguilaair/updat?color=orange&style=flat-square"></a>
  <a href="https://pub.dev/packages/updat"><img alt="Pub.dev" src="https://img.shields.io/pub/v/updat.svg?label=Pub.dev&color=blue&style=flat-square"></a>
  <a href="https://github.com/aguilaair/updat/issues"><img alt="Github Issues" src="https://img.shields.io/github/issues/aguilaair/updat?label=Issues&color=green&style=flat-square"></a>
  <a href="https://github.com/aguilaair/updat/wiki"><img alt="Github Wiki" src="https://img.shields.io/badge/GitHub-Wiki-black"></a>
 </div>

## Demo

![demo](https://github.com/aguilaair/updat/blob/main/promo/demo.gif)

## Installing

To get started simply type `flutter pub add updat` in your terminal.

🎉 Done, It's that simple.

## Getting Started

Integration with your app requires just a few lines of code, add the following widget wherever you want your updat widget to be:

```dart
UpdatWidget(
  currentVersion: "1.0.0",
  getLatestVersion: () async {
    // Here you should fetch the latest version. It must be semantic versioning for update detection to work properly.
    return "1.0.1";
  },
  getBinaryUrl: (latestVersion) async {
    // Here you provide the link to the binary the user should download. Make sure it is the correct one for the platform!
    return "https://github.com/latest/release/bin.exe";
  },
  // Lastly, enter your app name so we know what to call your files.
  appName: "Updat Example",
),
```

That should get you up and running in just a few seconds ⚡️.

or use the `UpdatWindowManager`, and let updat handle everything on autopilot. Just place it right after your `MaterialApp`.

Want to learn how to integrate Updat in your app?

[Integration Instructions](https://github.com/aguilaair/updat/wiki/How-to-integrate-Updat)

## Configuration

### Available `UpdatWidget` arguments

| Parameter                     | Type                         | Value                                                                                                                | Default |
|:------------------------------|:-----------------------------|:---------------------------------------------------------------------------------------------------------------------|:--------|
| **`currentVersion`**          | `String`                     | **Required**. Must be a semantic version. This is the current package's version.                                     | N/A     |
| **`getLatestVersion`**        | `Future<String>`             | **Required**. Must be a semantic version. This should request the latest version to the server                       | N/A     |
| **`getBinaryUrl`**            | `Future<String>`             | **Required**. This should provide the link download the binary for a certain app version. Arguments: `latestVersion` | N/A     |
| **`appNme`**                  | `String`                     | **Required**. The Application's name. It is used to name the binaries when downloading.                              | N/A     |
| **`getChangelog`**            | `Future<String>`             | This will render a plain text view of the changelog.                                                                 | N/A     |
| **`callback`**                | `void Function(UpdatStatus)` | A callback that is called when the UpdatStatus gets updated.                                                         | N/A     |
| **`getDownloadFileLocation`** | `Future<File>`               | Choose where to download the update.                                                                                 | N/A     |
| **`updateChipBuilder`**       | `Widget Function(...)`       | Overrides the default update chip.                                                                                   | N/A     |
| **`updateDialogBuilder`**     | `Widget Function(...)`       | Overrides the default update dialog.                                                                                 | N/A     |
| **`openOnDownload`**          | `bool`                       | Whether Updat should open the installer automatically once it has been downloaded.                                   | `true`  |
| **`closeOnInstall`**          | `bool`                       | Whether Updat should close the application automatically once it has been downloaded.                                | `false` |

### Theming

![Logo](https://github.com/aguilaair/updat/blob/main/promo/banner-2.svg)

Updat is extremely easy to theme. We also use `updateChipBuilder` and `updateDialogBuilder` internally to design our widgets, so you have the same customizability we do. We provide a couple of themes to get you started.

To change the theme simply add the desired theme to the builder and you're set.

#### Chips

- `defaultChip` which is an elevatedButton that only shows when an update is available. Shown by default.
- `defaultChipWithCheckFor` which is an elevatedButton that shows under all conditions, allowing to recheck for updates.
- `defaultChipWithSilentDownload` which is an elevatedButton that only shows when an update is downloaded and ready to install.

- `flatChip` which is an textButton that only shows when an update is available
- `flatChipWithCheckFor` which is an textButton that shows under all condition, allowing to recheck for updates.
- `flatChipWithSilentDownload` which is an textButton that only shows when an update is downloaded and ready to install.

- `floatingExtendedChip` which is a compact version of the dialog, which is a bit bigger and grabs user's attention more easily.
- `floatingExtendedChipWithSilentDownload` which is a compact version of the dialog, which is a bit bigger and grabs user's attention more easily, and only shows when the update is ready to be installed.

#### Dialogs

- `defaultDialog` which is the default, M2 and M3 dialog that shows by default.

### Advanced Usage  
If you need to send additional HTTP headers when downloading a release asset, you may define your
headers by setting the `downloadReleaseHeaders` property of `UpdatGlobalOptions`, you should probably do this in the main function of your code.
```dart
UpdatGlobalOptions.downloadReleaseHeaders = {
  "Authorization": "Bearer gh_pat_1234567889abcdefghijklm",
}
```
