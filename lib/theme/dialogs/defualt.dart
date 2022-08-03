import 'package:flutter/material.dart';

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
  required void Function() launchInstaller,
  required void Function() dismissUpdate,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Flex(
        direction:
            Theme.of(context).useMaterial3 ? Axis.vertical : Axis.horizontal,
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
