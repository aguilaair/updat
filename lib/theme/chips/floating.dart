import 'package:flutter/material.dart';

import '../../updat.dart';

Widget floatingExtendedChip({
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
  if (status == UpdatStatus.available ||
      status == UpdatStatus.availableWithChangelog) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Update Available",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "Version ${latestVersion.toString()} is now available!",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "You are currently running version $appVersion.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "Update now to get the latest features and fixes.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (status == UpdatStatus.availableWithChangelog) ...[
              const SizedBox(height: 15),
              TextButton.icon(
                onPressed: openDialog,
                icon: const Text('Read The Changelog'),
                label: const Icon(Icons.chevron_right_rounded),
              ),
            ],
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: dismissUpdate,
                  child: const Text('Later'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: startUpdate,
                  icon: const Icon(Icons.system_update_alt_rounded),
                  label: const Text('Update available'),
                ),
              ],
            ),
          ],
        ),
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
