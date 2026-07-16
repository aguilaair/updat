import 'package:flutter/material.dart';

import '../../l10n/updat_translations_scope.dart';
import '../../updat.dart';

Widget floatingExtendedChipWithSilentDownload({
  required BuildContext context,
  required String? latestVersion,
  required String appVersion,
  required UpdatStatus status,
  required void Function() checkForUpdate,
  required void Function() openDialog,
  required void Function() startUpdate,
  required Future<void> Function() launchInstaller,
  required void Function() dismissUpdate,
}) {
  final t = UpdatTranslationsScope.of(context);

  if (UpdatStatus.available == status ||
      UpdatStatus.availableWithChangelog == status) {
    startUpdate();
  }

  if (UpdatStatus.readyToInstall == status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.updateReady,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              t.versionReadyToInstall(latestVersion.toString()),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              t.currentlyRunningVersion(appVersion),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              t.updateNowForFeatures,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: dismissUpdate,
                  child: Text(t.later),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: startUpdate,
                  icon: const Icon(Icons.install_desktop_rounded),
                  label: Text(t.installNow),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  return Container();
}
