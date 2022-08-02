library updat;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:updat/utils/file_handler.dart';
import 'package:updat/utils/open_link.dart';

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
    this.checkAggresively = false,
    this.updateDialogBuilder,
    this.getChangelog,
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

  /// This Function can be used to override the default chip shown when there is a new version available.
  final Widget Function({
    BuildContext context,
    String? latestVersion,
    String appVersion,
    UpdatStatus status,
    void Function() checkForUpdate,
    void Function() openDialog,
    void Function() startUpdate,
  })? updateChipBuilder;

  /// This Function can be used to override the default dialog shown when there is a new version available.
  final Widget Function({
    BuildContext context,
    String? latestVersion,
    UpdatStatus status,
    String? changelog,
    void Function() checkForUpdate,
    void Function() openDialog,
    void Function() startUpdate,
  })? updateDialogBuilder;

  /// This bool allows you to specify wether you'd like Updat to check for an update every time the widget is rerendered.
  final bool checkAggresively;

  final Future<String> Function(String? latestVersion) getBinaryUrl;

  final Future<File> Function(String? latestVersion)? getDownloadFileLocation;

  final String appName;

  final bool openOnDownload;

  final bool closeOnInstall;

  @override
  State<UpdatWidget> createState() => _UpdatWidgetState();
}

class _UpdatWidgetState extends State<UpdatWidget> {
  UpdatStatus status = UpdatStatus.idle;
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
    if (widget.checkAggresively && status != UpdatStatus.checking ||
        status == UpdatStatus.idle) {
      updateValues();
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
      );
    }

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
          onPressed: () {
            try {
              openInstaller(installerFile!);
              if (widget.closeOnInstall) exit(0);
            } catch (e) {
              setState(() {
                status = UpdatStatus.error;
              });
            }
          },
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
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Flex(
            direction: Theme.of(context).useMaterial3
                ? Axis.vertical
                : Axis.horizontal,
            children: const [
              Icon(Icons.update),
              Text('Update available'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('A new version of the app is available.'),
              const SizedBox(width: 10),
              Text('New Version: ${latestVersion!.toString()}'),
              const SizedBox(height: 10),
              if (status == UpdatStatus.availableWithChangelog) ...[
                Text(
                  'Changelog:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(changelog!),
                ),
              ],
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Later'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                startUpdate();
              },
              child: const Text('Update Now'),
            ),
          ],
        ),
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

      if (widget.openOnDownload) {
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
