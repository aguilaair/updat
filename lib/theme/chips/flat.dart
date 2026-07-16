import 'package:flutter/material.dart';

import '../../l10n/updat_translations_scope.dart';
import '../../updat.dart';

Widget flatChip({
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
      child: TextButton.icon(
        onPressed: openDialog,
        icon: const Icon(Icons.system_update_alt_rounded),
        label: Text(t.updateAvailable),
      ),
    );
  }

  if (UpdatStatus.downloading == status) {
    return Tooltip(
      message: t.pleaseWait,
      child: TextButton.icon(
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
      child: TextButton.icon(
        onPressed: launchInstaller,
        icon: const Icon(Icons.check_circle),
        label: Text(t.readyToInstall),
      ),
    );
  }

  if (UpdatStatus.error == status) {
    return Tooltip(
      message: t.updateErrorTooltip,
      child: TextButton.icon(
        onPressed: startUpdate,
        icon: const Icon(Icons.warning),
        label: Text(t.errorTryAgain),
      ),
    );
  }

  return Container();
}
