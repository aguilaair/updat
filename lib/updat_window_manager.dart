import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';
import 'package:updat/l10n/updat_translations_scope.dart';
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
    this.handleWindowClose = true,
    this.onBeforeClose,
    this.translations,
    this.controller,
    super.key,
    required this.child,
  });

  ///  This function will be invoked to check if there is a new version available. The return string must be a semantic version.
  final Future<String?> Function() getLatestVersion;

  ///  This function will be invoked if there is a new release to get the changes.
  final Future<String?> Function(
    String latestVersion,
    String appVersion,
  )? getChangelog;

  /// Current version of the app. This will be used to compare the latest version. The String must be a semantic version.
  final String currentVersion;

  final void Function(UpdatStatus status)? callback;

  /// Optional controller for programmatic access to update actions.
  final UpdatController? controller;

  /// This Function can be used to override the default chip shown when there is a new version available.
  final UpdatChipBuilder? updateChipBuilder;

  /// This Function can be used to override the default dialog shown when there is a new version available. You must call `showDialog` yourself.
  final UpdatDialogBuilder? updateDialogBuilder;

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

  /// If false, [UpdatWindowManager] will not register a [WindowListener] or
  /// intercept the native close signal. Use this when you handle window close
  /// yourself via `window_manager`.
  final bool handleWindowClose;

  /// Optional callback invoked before closing the window. Return `true` to
  /// proceed with closing (and launching the installer when [launchOnExit] is
  /// true), or `false` to cancel. When not provided and other
  /// [WindowListener]s are registered, the close event is deferred to them.
  final Future<bool> Function()? onBeforeClose;

  /// Optional translations for the default UI widgets. When omitted, uses
  /// [UpdatGlobalOptions.translations].
  final UpdatTranslations? translations;

  @override
  State<UpdatWindowManager> createState() => _UpdatWindowManagerState();
}

class _UpdatWindowManagerState extends State<UpdatWindowManager>
    with WindowListener {
  final shouldRun =
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  late final UpdatController _controller =
      widget.controller ?? UpdatController();

  UpdatController get effectiveController =>
      widget.controller ?? _controller;

  @override
  void initState() {
    if (shouldRun && widget.handleWindowClose) {
      windowManager.addListener(this);
      _init();
    }

    super.initState();
  }

  @override
  void dispose() {
    if (shouldRun && widget.handleWindowClose) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  void _init() async {
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final content = Stack(
      children: [
        Positioned.fill(child: widget.child),
        Positioned(
          right: 10,
          bottom: 10,
          child: UpdatWidget(
            controller: effectiveController,
            updateChipBuilder:
                shouldRun ? _buildUpdateChip : _mobileBypass,
            updateDialogBuilder: widget.updateDialogBuilder,
            appName: widget.appName,
            currentVersion: widget.currentVersion,
            getLatestVersion: widget.getLatestVersion,
            getBinaryUrl: widget.getBinaryUrl,
            getDownloadFileLocation: widget.getDownloadFileLocation,
            getChangelog: widget.getChangelog,
            openOnDownload: widget.openOnDownload,
            closeOnInstall: widget.closeOnInstall,
            callback: widget.callback,
          ),
        )
      ],
    );

    if (widget.translations == null) {
      return content;
    }

    return UpdatTranslationsScope(
      translations: widget.translations!,
      child: content,
    );
  }

  @override
  void onWindowClose() async {
    if (!widget.handleWindowClose) return;

    if (widget.onBeforeClose != null) {
      final shouldClose = await widget.onBeforeClose!();
      if (!shouldClose) return;
    } else if (await windowManager.isPreventClose() &&
        windowManager.listeners.length > 1) {
      return;
    }

    if (widget.launchOnExit) {
      await effectiveController.launchInstaller();
    }
    await windowManager.setPreventClose(false);
    await windowManager.destroy();
  }

  Widget _mobileBypass({
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

  Widget _buildUpdateChip({
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
