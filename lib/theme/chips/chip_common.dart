import 'package:flutter/material.dart';

import '../../l10n/updat_translations_scope.dart';
import '../../updat_status.dart';

enum UpdatChipVariant { elevated, flat }

Widget updatProgressIcon() {
  return const SizedBox(
    width: 15,
    height: 15,
    child: CircularProgressIndicator(
      strokeWidth: 2,
    ),
  );
}

void maybeStartSilentDownload(
  UpdatStatus status,
  void Function() startUpdate,
) {
  if (UpdatStatus.available == status ||
      UpdatStatus.availableWithChangelog == status) {
    startUpdate();
  }
}

Widget buildChipButton({
  required UpdatChipVariant variant,
  required VoidCallback? onPressed,
  required Widget icon,
  required Widget label,
}) {
  switch (variant) {
    case UpdatChipVariant.elevated:
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: label,
      );
    case UpdatChipVariant.flat:
      return TextButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: label,
      );
  }
}

bool _isStandardChipStatus(UpdatStatus status) {
  return UpdatStatus.available == status ||
      UpdatStatus.availableWithChangelog == status ||
      UpdatStatus.downloading == status ||
      UpdatStatus.readyToInstall == status ||
      UpdatStatus.error == status;
}

Widget buildStandardStatusChip({
  required BuildContext context,
  required String? latestVersion,
  required UpdatStatus status,
  required UpdatChipVariant variant,
  required void Function() openDialog,
  required void Function() startUpdate,
  required Future<void> Function() launchInstaller,
}) {
  final t = UpdatTranslationsScope.of(context);

  if (UpdatStatus.available == status ||
      UpdatStatus.availableWithChangelog == status) {
    return Tooltip(
      message: t.updateToVersion(latestVersion!.toString()),
      child: buildChipButton(
        variant: variant,
        onPressed: openDialog,
        icon: const Icon(Icons.system_update_alt_rounded),
        label: Text(t.updateAvailable),
      ),
    );
  }

  if (UpdatStatus.downloading == status) {
    return Tooltip(
      message: t.pleaseWait,
      child: buildChipButton(
        variant: variant,
        onPressed: () {},
        icon: updatProgressIcon(),
        label: Text(t.downloading),
      ),
    );
  }

  if (UpdatStatus.readyToInstall == status) {
    return Tooltip(
      message: t.clickToInstall,
      child: buildChipButton(
        variant: variant,
        onPressed: launchInstaller,
        icon: const Icon(Icons.check_circle),
        label: Text(t.readyToInstall),
      ),
    );
  }

  if (UpdatStatus.error == status) {
    return Tooltip(
      message: t.updateErrorTooltip,
      child: buildChipButton(
        variant: variant,
        onPressed: startUpdate,
        icon: const Icon(Icons.warning),
        label: Text(t.errorTryAgain),
      ),
    );
  }

  return Container();
}

Widget buildCheckForStatusChip({
  required BuildContext context,
  required String? latestVersion,
  required UpdatStatus status,
  required UpdatChipVariant variant,
  required void Function() checkForUpdate,
  required void Function() openDialog,
  required void Function() startUpdate,
  required Future<void> Function() launchInstaller,
}) {
  if (_isStandardChipStatus(status)) {
    return buildStandardStatusChip(
      context: context,
      latestVersion: latestVersion,
      status: status,
      variant: variant,
      openDialog: openDialog,
      startUpdate: startUpdate,
      launchInstaller: launchInstaller,
    );
  }

  final t = UpdatTranslationsScope.of(context);

  if (UpdatStatus.idle == status) {
    return Tooltip(
      message: t.clickToCheckForUpdates,
      child: buildChipButton(
        variant: variant,
        onPressed: checkForUpdate,
        icon: const Icon(Icons.refresh_rounded),
        label: Text(t.checkForUpdates),
      ),
    );
  }

  if (UpdatStatus.upToDate == status) {
    return Tooltip(
      message: t.clickToCheckForUpdates,
      child: buildChipButton(
        variant: variant,
        onPressed: checkForUpdate,
        icon: const Icon(Icons.check_circle),
        label: Text(t.upToDate),
      ),
    );
  }

  if (UpdatStatus.checking == status) {
    return Tooltip(
      message: t.pleaseWait,
      child: buildChipButton(
        variant: variant,
        onPressed: () {},
        icon: updatProgressIcon(),
        label: Text(t.checkingForUpdates),
      ),
    );
  }

  return Container();
}

Widget buildSilentDownloadReadyChip({
  required BuildContext context,
  required UpdatStatus status,
  required UpdatChipVariant variant,
  required void Function() startUpdate,
  required Future<void> Function() launchInstaller,
}) {
  maybeStartSilentDownload(status, startUpdate);

  if (UpdatStatus.readyToInstall != status) {
    return Container();
  }

  final t = UpdatTranslationsScope.of(context);

  return Tooltip(
    message: t.clickToInstall,
    child: buildChipButton(
      variant: variant,
      onPressed: launchInstaller,
      icon: const Icon(Icons.check_circle),
      label: Text(t.updateReadyToInstall),
    ),
  );
}
