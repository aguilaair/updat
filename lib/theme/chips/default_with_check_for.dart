import 'package:flutter/material.dart';

import '../../l10n/updat_translations_scope.dart';
import '../../updat.dart';

Widget defaultChipWithCheckFor({
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
    return Tooltip(
      message: t.updateToVersion(latestVersion!.toString()),
      child: ElevatedButton.icon(
        onPressed: openDialog,
        icon: const Icon(Icons.system_update_alt_rounded),
        label: Text(t.updateAvailable),
      ),
    );
  }

  if (UpdatStatus.downloading == status) {
    return Tooltip(
      message: t.pleaseWait,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
        label: Text(t.downloading),
      ),
    );
  }

  if (UpdatStatus.readyToInstall == status) {
    return Tooltip(
      message: t.clickToInstall,
      child: ElevatedButton.icon(
        onPressed: launchInstaller,
        icon: const Icon(Icons.check_circle),
        label: Text(t.readyToInstall),
      ),
    );
  }

  if (UpdatStatus.error == status) {
    return Tooltip(
      message: t.updateErrorTooltip,
      child: ElevatedButton.icon(
        onPressed: startUpdate,
        icon: const Icon(Icons.warning),
        label: Text(t.errorTryAgain),
      ),
    );
  }

  if (UpdatStatus.idle == status) {
    return Tooltip(
      message: t.clickToCheckForUpdates,
      child: ElevatedButton.icon(
        onPressed: checkForUpdate,
        icon: const Icon(Icons.refresh_rounded),
        label: Text(t.checkForUpdates),
      ),
    );
  }

  if (UpdatStatus.upToDate == status) {
    return Tooltip(
      message: t.clickToCheckForUpdates,
      child: ElevatedButton.icon(
        onPressed: checkForUpdate,
        icon: const Icon(Icons.check_circle),
        label: Text(t.upToDate),
      ),
    );
  }

  if (UpdatStatus.checking == status) {
    return Tooltip(
      message: t.pleaseWait,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
        label: Text(t.checkingForUpdates),
      ),
    );
  }

  return Container();
}
