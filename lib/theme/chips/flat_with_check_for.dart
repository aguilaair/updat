import 'package:flutter/material.dart';

import '../../updat_status.dart';
import 'chip_common.dart';

Widget flatChipWithCheckFor({
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
  return buildCheckForStatusChip(
    context: context,
    latestVersion: latestVersion,
    status: status,
    variant: UpdatChipVariant.flat,
    checkForUpdate: checkForUpdate,
    openDialog: openDialog,
    startUpdate: startUpdate,
    launchInstaller: launchInstaller,
  );
}
