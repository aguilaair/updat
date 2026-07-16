import 'package:flutter/material.dart';

import '../../l10n/updat_translations_scope.dart';
import '../../updat.dart';

Widget flatChipWithSilentDownload({
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
    return Tooltip(
      message: t.clickToInstall,
      child: TextButton.icon(
        onPressed: launchInstaller,
        icon: const Icon(Icons.check_circle),
        label: Text(t.updateReadyToInstall),
      ),
    );
  }

  return Container();
}
