import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:updat/l10n/updat_translations.dart';
import 'package:updat/l10n/updat_translations_scope.dart';
import 'package:updat/theme/chips/default.dart';
import 'package:updat/theme/dialogs/default.dart';
import 'package:updat/updat_builders.dart';
import 'package:updat/updat_status.dart';
import 'package:updat/utils/file_handler.dart';

export 'package:updat/l10n/updat_translations.dart';
export 'package:updat/updat_builders.dart';
export 'package:updat/updat_controller.dart';
export 'package:updat/updat_exception.dart';
export 'package:updat/updat_status.dart';

/// Imperative API for driving [UpdatWidget] and [UpdatWindowManager] from
/// outside the widget tree (e.g. after a backend push or socket event).
class UpdatController {
  UpdatStatus? _status;
  String? _latestVersion;

  Future<void> Function({bool notifyIfAvailable})? _checkForUpdate;
  void Function()? _openDialog;
  void Function()? _startUpdate;
  Future<void> Function()? _launchInstaller;
  void Function()? _dismissUpdate;

  /// The last known [UpdatStatus], updated whenever the widget state changes.
  UpdatStatus? get status => _status;

  /// The latest remote version string from the most recent check, if any.
  String? get latestVersion => _latestVersion;

  /// Re-run the version check.
  ///
  /// No-ops while a check or download is already in progress, or when no
  /// [UpdatWidget] is attached. Set [notifyIfAvailable] to `true` to open the
  /// update dialog automatically when a newer version is found.
  Future<void> checkForUpdate({bool notifyIfAvailable = false}) {
    return _checkForUpdate?.call(notifyIfAvailable: notifyIfAvailable) ??
        Future.value();
  }

  /// Open the update dialog for the current check result.
  void openDialog() => _openDialog?.call();

  /// Begin downloading the available update.
  void startUpdate() => _startUpdate?.call();

  /// Launch the downloaded installer.
  Future<void> launchInstaller() async {
    await _launchInstaller?.call();
  }

  /// Dismiss the pending update notification.
  void dismissUpdate() => _dismissUpdate?.call();

  void _attach({
    required Future<void> Function({bool notifyIfAvailable}) checkForUpdate,
    required void Function() openDialog,
    required void Function() startUpdate,
    required Future<void> Function() launchInstaller,
    required void Function() dismissUpdate,
    required UpdatStatus status,
    required String? latestVersion,
  }) {
    _checkForUpdate = checkForUpdate;
    _openDialog = openDialog;
    _startUpdate = startUpdate;
    _launchInstaller = launchInstaller;
    _dismissUpdate = dismissUpdate;
    _status = status;
    _latestVersion = latestVersion;
  }

  void _detach({
    required Future<void> Function({bool notifyIfAvailable}) checkForUpdate,
  }) {
    if (_checkForUpdate == checkForUpdate) {
      _checkForUpdate = null;
      _openDialog = null;
      _startUpdate = null;
      _launchInstaller = null;
      _dismissUpdate = null;
    }
  }

  void _sync({
    required UpdatStatus status,
    required String? latestVersion,
  }) {
    _status = status;
    _latestVersion = latestVersion;
  }
}

/// This widget is the default Updat widget, that will only be shown when a new
/// update is detected. An initial check runs on mount; use [controller] to
/// trigger additional checks later.
/// If you want a custom widget to be shown, you can pass it as the
/// [updateChipBuilder] parameter.
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
    this.translations,
    this.controller,
    super.key,
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

  /// Optional translations for the default UI widgets. When omitted, uses
  /// [UpdatGlobalOptions.translations].
  final UpdatTranslations? translations;

  @override
  State<UpdatWidget> createState() => _UpdatWidgetState();
}

class _UpdatWidgetState extends State<UpdatWidget> {
  UpdatStatus status = UpdatStatus.idle;
  Version? latestVersion;
  late Version appVersion;
  String? changelog;
  File? installerFile;
  BuildContext? _translationsContext;

  @override
  void initState() {
    super.initState();
    appVersion = Version.parse(widget.currentVersion);
    _attachController();
    _checkForUpdate();
  }

  @override
  void didUpdateWidget(covariant UpdatWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(checkForUpdate: _checkForUpdate);
      _attachController();
    }
  }

  @override
  void dispose() {
    widget.controller?._detach(checkForUpdate: _checkForUpdate);
    super.dispose();
  }

  void _attachController() {
    widget.controller?._attach(
      checkForUpdate: _checkForUpdate,
      openDialog: openDialog,
      startUpdate: startUpdate,
      launchInstaller: launchInstaller,
      dismissUpdate: dismiss,
      status: status,
      latestVersion: latestVersion?.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buildContent(BuildContext scopedContext) {
      if (widget.updateChipBuilder != null) {
        return widget.updateChipBuilder!(
          context: scopedContext,
          latestVersion: latestVersion?.toString(),
          appVersion: widget.currentVersion,
          checkForUpdate: () => _checkForUpdate(),
          openDialog: openDialog,
          status: status,
          startUpdate: startUpdate,
          launchInstaller: launchInstaller,
          dismissUpdate: dismiss,
        );
      }

      return defaultChip(
        context: scopedContext,
        latestVersion: latestVersion?.toString(),
        appVersion: widget.currentVersion,
        checkForUpdate: () => _checkForUpdate(),
        openDialog: openDialog,
        status: status,
        startUpdate: startUpdate,
        launchInstaller: launchInstaller,
        dismissUpdate: dismiss,
      );
    }

    if (widget.translations == null) {
      _translationsContext = null;
      return buildContent(context);
    }

    return UpdatTranslationsScope(
      translations: widget.translations!,
      child: Builder(
        builder: (scopedContext) {
          _translationsContext = scopedContext;
          return buildContent(scopedContext);
        },
      ),
    );
  }

  BuildContext get _uiContext => _translationsContext ?? context;

  void _setStatus(UpdatStatus newStatus) {
    if (status == newStatus) return;
    setState(() {
      status = newStatus;
    });
    widget.controller?._sync(
      status: status,
      latestVersion: latestVersion?.toString(),
    );
    widget.callback?.call(status);
  }

  Future<void> _checkForUpdate({bool notifyIfAvailable = false}) async {
    if (status == UpdatStatus.checking || status == UpdatStatus.downloading) {
      return;
    }

    _setStatus(UpdatStatus.checking);
    changelog = null;

    try {
      final latestVersionStr = await widget.getLatestVersion();
      if (!mounted) return;

      if (latestVersionStr == null) {
        _setStatus(UpdatStatus.error);
        return;
      }

      latestVersion = Version.parse(latestVersionStr);

      if (latestVersion! > appVersion) {
        if (widget.getChangelog != null) {
          try {
            final changelogRec = await widget.getChangelog!(
              latestVersionStr,
              widget.currentVersion,
            );
            if (!mounted) return;
            if (changelogRec != null) {
              changelog = changelogRec;
              _setStatus(UpdatStatus.availableWithChangelog);
            } else {
              _setStatus(UpdatStatus.available);
            }
          } catch (_) {
            if (!mounted) return;
            _setStatus(UpdatStatus.available);
          }
        } else {
          _setStatus(UpdatStatus.available);
        }

        if (notifyIfAvailable) {
          openDialog();
        }
      } else {
        _setStatus(UpdatStatus.upToDate);
      }
    } catch (_) {
      if (!mounted) return;
      _setStatus(UpdatStatus.error);
    }
  }

  void openDialog() {
    if (widget.updateDialogBuilder != null) {
      widget.updateDialogBuilder!(
        context: _uiContext,
        latestVersion: latestVersion?.toString(),
        status: status,
        changelog: changelog,
        checkForUpdate: () => _checkForUpdate(),
        openDialog: openDialog,
        startUpdate: startUpdate,
        launchInstaller: launchInstaller,
        appVersion: appVersion.toString(),
        dismissUpdate: dismiss,
      );
    } else {
      defaultDialog(
        context: _uiContext,
        latestVersion: latestVersion?.toString(),
        status: status,
        changelog: changelog,
        checkForUpdate: () => _checkForUpdate(),
        openDialog: openDialog,
        startUpdate: startUpdate,
        launchInstaller: launchInstaller,
        appVersion: appVersion.toString(),
        dismissUpdate: dismiss,
      );
    }
  }

  void dismiss() {
    _setStatus(UpdatStatus.dismissed);
  }

  void startUpdate() async {
    if (status != UpdatStatus.available &&
        status != UpdatStatus.availableWithChangelog) {
      if (status == UpdatStatus.readyToInstall) {
        launchInstaller();
      }
      return;
    }
    _setStatus(UpdatStatus.downloading);
    final url = await widget.getBinaryUrl(latestVersion!.toString());

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
      try {
        await downloadRelease(installerFile!, url, widget.appName);
      } catch (e) {
        _setStatus(UpdatStatus.error);
        return;
      }

      _setStatus(UpdatStatus.readyToInstall);

      if (widget.openOnDownload) launchInstaller();
    }
  }

  Future<void> launchInstaller() async {
    if (status != UpdatStatus.readyToInstall &&
        status != UpdatStatus.dismissed) {
      return;
    }
    if (installerFile == null) {
      return;
    }
    try {
      await openInstaller(installerFile!, widget.appName);
      if (widget.closeOnInstall) exit(0);
    } catch (e) {
      _setStatus(UpdatStatus.error);
    }
  }
}
