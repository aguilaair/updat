import 'package:flutter/material.dart';
import 'package:updat/theme/chips/default.dart';

import '../updat.dart';

Widget passthroughChip({
  required BuildContext context,
  required String? latestVersion,
  required String appVersion,
  required UpdatStatus status,
  required void Function() checkForUpdate,
  required void Function() openDialog,
  required void Function() startUpdate,
  required Future<void> Function() launchInstaller,
  required void Function() dismissUpdate,
  required Function({
    required BuildContext context,
    required String? latestVersion,
    required String appVersion,
    required UpdatStatus status,
    required void Function() checkForUpdate,
    required void Function() openDialog,
    required void Function() startUpdate,
    required Future<void> Function() launchInstaller,
    required void Function() dismissUpdate,
  })?
      updateChipBuilder,
  required Function setFunctions,
}) {
  setFunctions(
    checkForUpdate,
    openDialog,
    startUpdate,
    launchInstaller,
    dismissUpdate,
  );

  return updateChipBuilder?.call(
        context: context,
        latestVersion: latestVersion,
        appVersion: appVersion,
        status: status,
        checkForUpdate: checkForUpdate,
        openDialog: openDialog,
        startUpdate: startUpdate,
        launchInstaller: launchInstaller,
        dismissUpdate: dismissUpdate,
      ) ??
      defaultChip(
        context: context,
        latestVersion: latestVersion,
        appVersion: appVersion,
        status: status,
        checkForUpdate: checkForUpdate,
        openDialog: openDialog,
        startUpdate: startUpdate,
        launchInstaller: launchInstaller,
        dismissUpdate: dismissUpdate,
      );
}
