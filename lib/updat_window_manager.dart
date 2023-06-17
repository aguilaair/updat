import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';
import 'package:updat/theme/chips/floating_with_silent_download.dart';
import 'package:updat/updat.dart';
import 'package:window_manager/window_manager.dart';

class UpdatWindowManager extends StatefulWidget {
  final Widget child;

  /// UpdatWindowManager is designed to make automatic update handling simple. The update is (by default) automatically
  /// downloaded and the user is notified that the update is ready. Then, the user may decide to install or dismiss the update.
  /// Even if the update is dismissed the installer will then launch just before the app is closed. This widget is ideal to use with
  /// silent installes such as `msi` on Windows as the update will start without user interaction in the bakground.
  const UpdatWindowManager({
    required this.currentVersion,
    required this.getLatestVersion,
    required this.getBinaryUrl,
    required this.appName,
    this.getDownloadFileLocation,
    this.updateChipBuilder,
    this.updateDialogBuilder,
    this.getChangelog,
    this.callback,
    this.openOnDownload = false,
    this.closeOnInstall = false,
    this.launchOnExit = true,
    Key? key,
    required this.child,
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
    required BuildContext context,
    required String? latestVersion,
    required String appVersion,
    required UpdatStatus status,
    required void Function() checkForUpdate,
    required void Function() openDialog,
    required void Function() startUpdate,
    required Future<void> Function() launchInstaller,
    required void Function() dismissUpdate,
  })? updateChipBuilder;

  /// This Function can be used to override the default dialog shown when there is a new version available. You must call `showDialog` yourself.
  final void Function({
    required BuildContext context,
    required String? latestVersion,
    required String appVersion,
    required UpdatStatus status,
    required String? changelog,
    required void Function() checkForUpdate,
    required void Function() openDialog,
    required void Function() startUpdate,
    required Future<void> Function() launchInstaller,
    required void Function() dismissUpdate,
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

  /// If true, the installer will be launched when the app is closed.
  final bool launchOnExit;

  @override
  State<UpdatWindowManager> createState() => _UpdatWindowManagerState();
}

class _UpdatWindowManagerState extends State<UpdatWindowManager>
    with WindowListener {
  final shouldRun =
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  @override
  void initState() {
    // Check if the app is running on Web
    if (shouldRun) {
      windowManager.addListener(this);
      _init();
    }

    super.initState();
  }

  @override
  void dispose() {
    if (shouldRun) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  void _init() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  UpdatStatus status = UpdatStatus.idle;

  void Function()? checkForUpdate;
  void Function()? openDialog;
  void Function()? startUpdate;
  Future<void> Function()? launchInstaller;
  void Function()? dismissUpdate;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: widget.child),
        Positioned(
          right: 10,
          bottom: 10,
          child: UpdatWidget(
            updateChipBuilder: shouldRun ? passthroughChip : mobileBypass,
            updateDialogBuilder: widget.updateDialogBuilder,
            appName: widget.appName,
            currentVersion: widget.currentVersion,
            getLatestVersion: widget.getLatestVersion,
            getBinaryUrl: widget.getBinaryUrl,
            getDownloadFileLocation: widget.getDownloadFileLocation,
            getChangelog: widget.getChangelog,
            openOnDownload: widget.openOnDownload,
            closeOnInstall: widget.closeOnInstall,
            callback: (status) {
              widget.callback?.call(status);
              this.status = status;
            },
          ),
        )
      ],
    );
  }

  @override
  void onWindowClose() async {
    if (widget.launchOnExit) {
      await windowManager.isPreventClose();
      await launchInstaller?.call();
      await windowManager.destroy();
    } else {
      await windowManager.destroy();
    }
  }

  Widget mobileBypass({
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
    return Container();
  }

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
  }) {
    this.startUpdate = startUpdate;
    this.launchInstaller = launchInstaller;
    this.dismissUpdate = dismissUpdate;
    this.checkForUpdate = checkForUpdate;
    this.openDialog = openDialog;

    return widget.updateChipBuilder?.call(
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
        floatingExtendedChipWithSilentDownload(
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
}
