import 'package:flutter/material.dart';

import '../../l10n/updat_translations_scope.dart';
import '../../updat.dart';

void defaultDialog({
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
}) {
  final t = UpdatTranslationsScope.of(context);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      scrollable: true,
      title: Flex(
        direction:
            Theme.of(context).useMaterial3 ? Axis.vertical : Axis.horizontal,
        children: [
          const Icon(Icons.update),
          Text(t.updateAvailable),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.newVersionAvailable),
          const SizedBox(width: 10),
          Text(t.newVersionLabel(latestVersion!.toString())),
          const SizedBox(height: 10),
          if (status == UpdatStatus.availableWithChangelog) ...[
            Text(
              t.changelog,
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
          child: Text(t.later),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            startUpdate();
          },
          child: Text(t.updateNow),
        ),
      ],
    ),
  );
}
