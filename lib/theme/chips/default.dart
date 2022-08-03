import 'package:flutter/material.dart';

import '../../updat.dart';

Widget defaultChip({
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
    return Tooltip(
      message: 'Update to version ${latestVersion!.toString()}',
      child: ElevatedButton.icon(
        onPressed: openDialog,
        icon: const Icon(Icons.system_update_alt_rounded),
        label: const Text('Update available'),
      ),
    );
  }

  if (UpdatStatus.downloading == status) {
    return Tooltip(
      message: 'Please Wait...',
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
        label: const Text('Downloading...'),
      ),
    );
  }

  if (UpdatStatus.readyToInstall == status) {
    return Tooltip(
      message: 'Click to Install',
      child: ElevatedButton.icon(
        onPressed: launchInstaller,
        icon: const Icon(Icons.check_circle),
        label: const Text('Ready to install'),
      ),
    );
  }

  if (UpdatStatus.error == status) {
    return Tooltip(
      message: 'There was an issue with the update. Please try again.',
      child: ElevatedButton.icon(
        onPressed: startUpdate,
        icon: const Icon(Icons.warning),
        label: const Text('Error. Try Again.'),
      ),
    );
  }

  return Container();
}
