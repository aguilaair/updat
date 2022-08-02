# Updat - The simple-to-use, flutter-based desktop update package

![Logo](https://github.com/aguilaair/updat/blob/main/promo/logo.svg)

Updat is a simple-to-use reliable flutter-native updater that handles your application's updates. All you need is a place to host your files and a place to check for the latest version.

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

## Configuration

### Available `Updat` arguments

| Parameter           | Type      | Value                                                                                                                                    | Default   |
| :------------------ | :-------- | :--------------------------------------------------------------------------------------------------------------------------------------- | :-------- |
| **`currentVersion`**         | `String`   | **Required**. Must be a semantic version. This is the current package's version.                                                                 | N/A       |
| **`getLatestVersion`**    | `Future<String>`  | **Required**. Must be a semantic version. This should request the latest version to the server                                  | N/A |
| **`getBinaryUrl`** | `Future<String>` | **Required**. This should provide the link download the binary for a certain app version. Arguments: `latestVersion` | N/A       |
| **`appNme`** | `String` | **Required**. The Application's name. It is used to name the binaries when downloading. | N/A       |
| **`getChangelog`** | `Future<String>` | This will render a plain text view of the changelog. | N/A       |
| **`callback`** | `void Function(UpdatStatus)` | A callback that is called when the UpdatStatus gets updated. | N/A       |
| **`getDownloadFileLocation`** | `Future<File>` | Choose where to download the update. | N/A       |
| **`updateChipBuilder`** | `Widget Function(...)` | Overrides the default update chip. | N/A       |
| **`updateDialogBuilder`** | `Widget Function(...)` | Overrides the default update dialog. | N/A       |
| **`openOnDownload`** | `bool` | Whether Updat should open the installer automatically once it has been downloaded. | `true`      |
| **`closeOnInstall`** | `bool` | Whether Updat should close the application automatically once it has been downloaded. | `false`      |
