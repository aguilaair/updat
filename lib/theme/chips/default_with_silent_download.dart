import 'package:flutter/material.dart';

import '../../updat.dart';

Widget defaultChipWithSilentDownload({
  required BuildContext context,
  required String? latestVersion,
  required String appVersion,
  required UpdatStatus status,
  required void Function() checkForUpdate,
  required void Function() openDialog,
  required void Function() startUpdate,
  required void Function() launchInstaller,
  required void Function() dismissUpdate,
}) {
  if (UpdatStatus.available == status ||
      UpdatStatus.availableWithChangelog == status) {
    startUpdate();
  }

  if (UpdatStatus.readyToInstall == status) {
    return Tooltip(
      message: 'Click to Install',
      child: ElevatedButton.icon(
        onPressed: launchInstaller,
        icon: const Icon(Icons.check_circle),
        label: const Text('Update Ready to install'),
      ),
    );
  }

  return Container();
}
