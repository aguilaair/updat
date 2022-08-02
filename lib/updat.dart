library updat;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:updat/theme/chips/default.dart';
import 'package:updat/theme/dialogs/defualt.dart';
import 'package:updat/utils/file_handler.dart';

/// This widget is the defualt Updat widget, that will only be shown when a new update is detected (This is checked only once per widget initialization by default).
/// If you want a custom widget to be shown, you can pass it as the [updateChipBuilder] parameter.
class UpdatWidget extends StatefulWidget {
  const UpdatWidget({
    required this.currentVersion,
    required this.getLatestVersion,
    required this.getBinaryUrl,
    required this.appName,
    this.getDownloadFileLocation,
    this.updateChipBuilder,
    this.updateDialogBuilder,
    this.getChangelog,
    this.callback,
    this.openOnDownload = true,
    this.closeOnInstall = false,
    Key? key,
  }) : super(key: key);

  ///  This function will be invoked to ckeck if there is a new version available. The return string must be a semantic version.
  final Future<String?> Function() getLatestVersion;

  ///  This function will be invoked if there is a new release to get the changes.
  final Future<String?> Function(
    String latestVersion,
    String appVersion,
  )? getChangelog;

  /// Current version of the app. This will be used to compare the latest version. The String must be a semantic version.
  final String currentVersion;

  final void Function(UpdatStatus status)? callback;

  /// This Function can be used to override the default chip shown when there is a new version available.
  final Widget Function({
    BuildContext context,
    String? latestVersion,
    String appVersion,
    UpdatStatus status,
    void Function() checkForUpdate,
    void Function() openDialog,
    void Function() startUpdate,
    void Function() launchInstaller,
  })? updateChipBuilder;

  /// This Function can be used to override the default dialog shown when there is a new version available.
  final Widget Function({
    BuildContext context,
    String? latestVersion,
    UpdatStatus status,
    String? changelog,
    String appVersion,
    void Function() checkForUpdate,
    void Function() openDialog,
    void Function() startUpdate,
    void Function() launchInstaller,
  })? updateDialogBuilder;

  /// Get the url of the binary file to download provided with a certain version.
  final Future<String> Function(String? latestVersion) getBinaryUrl;

  /// Override the default download location.
  final Future<File> Function(String? latestVersion)? getDownloadFileLocation;

  /// The name of the app.
  final String appName;

  /// If true, the installer will be opened when the update is downloaded.
  final bool openOnDownload;

  /// If true, the app will be closed when the installer is launched.
  final bool closeOnInstall;

  @override
  State<UpdatWidget> createState() => _UpdatWidgetState();
}

class _UpdatWidgetState extends State<UpdatWidget> {
  UpdatStatus status = UpdatStatus.idle;
  UpdatStatus? lastStatus;
  Version? latestVersion;
  late Version appVersion;
  String? changelog;
  File? installerFile;

  @override
  void initState() {
    appVersion = Version.parse(widget.currentVersion);
    updateValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Check for update if we're not checking already and [checkAggresively] is set to `true`.
    if (status == UpdatStatus.idle) {
      updateValues();
    }

    if (status != lastStatus) {
      lastStatus = status;
      widget.callback?.call(status);
    }

    // Override default chip
    if (widget.updateChipBuilder != null) {
      return widget.updateChipBuilder!(
        context: context,
        latestVersion: latestVersion?.toString(),
        appVersion: widget.currentVersion,
        checkForUpdate: updateValues,
        openDialog: openDialog,
        status: status,
        startUpdate: startUpdate,
        launchInstaller: launchInstaller,
      );
    } else {
      return defaultChip(
        context: context,
        latestVersion: latestVersion?.toString(),
        appVersion: widget.currentVersion,
        checkForUpdate: updateValues,
        openDialog: openDialog,
        status: status,
        startUpdate: startUpdate,
        launchInstaller: launchInstaller,
      );
    }
  }

  void updateValues() {
    setState(() {
      status = UpdatStatus.checking;
    });
    widget.getLatestVersion().then((latestVersion) {
      if (latestVersion != null && mounted) {
        setState(() {
          this.latestVersion = Version.parse(latestVersion);
          if (this.latestVersion! > appVersion) {
            setState(() {
              status = UpdatStatus.available;
            });
            if (widget.getChangelog != null) {
              widget.getChangelog!(latestVersion, widget.currentVersion)
                  .then((changelogRec) {
                if (changelogRec != null && mounted) {
                  setState(() {
                    status = UpdatStatus.availableWithChangelog;
                    changelog = changelogRec;
                  });
                }
              }).catchError((_) {
                return;
              });
            }
          } else {
            setState(() {
              status = UpdatStatus.upToDate;
            });
          }
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          status = UpdatStatus.error;
        });
      }
    });
  }

  void openDialog() {
    if (widget.updateDialogBuilder != null) {
      widget.updateDialogBuilder!(
        context: context,
        latestVersion: latestVersion?.toString(),
        status: status,
        changelog: changelog,
        checkForUpdate: updateValues,
        openDialog: openDialog,
        startUpdate: startUpdate,
        launchInstaller: launchInstaller,
        appVersion: appVersion.toString(),
      );
    } else {
      defaultDialog(
        context: context,
        latestVersion: latestVersion?.toString(),
        status: status,
        changelog: changelog,
        checkForUpdate: updateValues,
        openDialog: openDialog,
        startUpdate: startUpdate,
        launchInstaller: launchInstaller,
        appVersion: appVersion.toString(),
      );
    }
  }

  void startUpdate() async {
    // Get the URL to download the file from.
    final url = await widget.getBinaryUrl(latestVersion!.toString());

    // Get the file location to download the file to.
    if (widget.getDownloadFileLocation != null) {
      installerFile =
          await widget.getDownloadFileLocation!(latestVersion!.toString());
    } else {
      installerFile = await getDownloadFileLocation(
        latestVersion!.toString(),
        widget.appName,
        url.split(".").last,
      );
    }

    if (installerFile != null) {
      // Download the file.
      setState(() {
        status = UpdatStatus.downloading;
      });
      try {
        await downloadRelease(installerFile!, url);
      } catch (e) {
        setState(() {
          status = UpdatStatus.error;
        });
        return;
      }

      setState(() {
        status = UpdatStatus.readyToInstall;
      });

      if (widget.openOnDownload) launchInstaller();
    }
  }

  void launchInstaller() {
    // Open the file.
    try {
      openInstaller(installerFile!);
      if (widget.closeOnInstall) exit(0);
    } catch (e) {
      setState(() {
        status = UpdatStatus.error;
      });
    }
  }
}

enum UpdatStatus {
  available,
  availableWithChangelog,
  checking,
  upToDate,
  error,
  idle,
  downloading,
  readyToInstall,
}
