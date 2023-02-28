library updat;

import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:updat/utils/file_handler.dart';

UpdatStatus status = UpdatStatus.idle;
Version? appVersion;
Version? _latestVersion;

bool? checkForUpdates({required String currentVersion, required String latestVersion}) {
  if (status == UpdatStatus.idle) {
    appVersion = Version.parse(currentVersion);
    _latestVersion = Version.parse(latestVersion);
    updateValues();

    return status == UpdatStatus.available ? true : false;
  } else if (status == UpdatStatus.readyToInstall) {
    return true;
  } else if (status == UpdatStatus.upToDate) {
    return false;
  } else {
    return null;
  }
}

void updateValues() {
  status = UpdatStatus.checking;
  if (_latestVersion == null || appVersion == null) {
    throw FormatException('Version.parse(latestVersion): $_latestVersion, Version.parse(appVersion): $appVersion');
  } else if (_latestVersion! > appVersion!) {
    status = UpdatStatus.available;
  } else {
    status = UpdatStatus.upToDate;
  }
}

startUpdate({required String url, bool closeOnInstall = true}) async {
  if (status == UpdatStatus.downloading) return;
  print("autoupdate: started");

  File? installerFile = await getDownloadFileLocation(
    _latestVersion!.toString(),
    'bridge',
    url.split(".").last,
  );
  print("autoupdate: getDownloadFileLocation success, $installerFile");

  if (status == UpdatStatus.readyToInstall) {
    launchInstaller(closeOnInstall: closeOnInstall, installerFile: installerFile);
    return;
  }

  try {
    print("autoupdate:  downloading");
    status = UpdatStatus.downloading;
    await downloadRelease(installerFile, url);
  } catch (e) {
    print(installerFile == null ? 'Installed location null' : (e));
    status = UpdatStatus.error;
    return;
  }

  status = UpdatStatus.readyToInstall;
  launchInstaller(closeOnInstall: closeOnInstall, installerFile: installerFile);
  print("autoupdate: download release done");
}

Future<void> launchInstaller({required bool closeOnInstall, required File installerFile}) async {
  print("autoupdate: launch installer");
  if (status != UpdatStatus.readyToInstall && status != UpdatStatus.dismissed) {
    return;
  }
  // Open the file.
  try {
    await openInstaller(installerFile);
    if (closeOnInstall) exit(0);
  } catch (e) {
    print("launch installer error");
    print(e);
    status = UpdatStatus.error;
  }
}

enum UpdatStatus {
  available,
  checking,
  upToDate,
  error,
  idle,
  downloading,
  readyToInstall,
  dismissed,
}
