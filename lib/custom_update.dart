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
  status = UpdatStatus.downloading;
  File? installerFile = await getCustomDownloadFileLocation(
    _latestVersion!.toString(),
    'bridge',
  );

  try {
    await downloadRelease(installerFile!, url);
  } catch (e) {
    print(installerFile == null ? 'Installed location null' : (e));
    status = UpdatStatus.error;
    return;
  }

  if (status != UpdatStatus.available) {
    if (status == UpdatStatus.readyToInstall && status != UpdatStatus.downloading) {
      launchInstaller(closeOnInstall: closeOnInstall, installerFile: installerFile);
    }
    return;
  }

  status = UpdatStatus.readyToInstall;
  launchInstaller(closeOnInstall: closeOnInstall, installerFile: installerFile);
}

Future<void> launchInstaller({required bool closeOnInstall, required File installerFile}) async {
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
