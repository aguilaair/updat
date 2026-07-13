import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:updat/updat.dart';

void main() {
  group('UpdatWidget', () {
    testWidgets('detects update on initial check', (tester) async {
      final controller = UpdatController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UpdatWidget(
              controller: controller,
              currentVersion: '1.0.0',
              getLatestVersion: () async => '2.0.0',
              getBinaryUrl: (_) async => 'https://example.com/app.exe',
              appName: 'Test App',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(controller.status, UpdatStatus.available);
      expect(controller.latestVersion, '2.0.0');
    });

    testWidgets('recheck from upToDate detects newer version', (tester) async {
      final controller = UpdatController();
      var remoteVersion = '1.0.0';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UpdatWidget(
              controller: controller,
              currentVersion: '1.0.0',
              getLatestVersion: () async => remoteVersion,
              getBinaryUrl: (_) async => 'https://example.com/app.exe',
              appName: 'Test App',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(controller.status, UpdatStatus.upToDate);

      remoteVersion = '2.0.0';
      await controller.checkForUpdate();
      await tester.pumpAndSettle();

      expect(controller.status, UpdatStatus.available);
      expect(controller.latestVersion, '2.0.0');
    });

    testWidgets('recheck from dismissed detects update again', (tester) async {
      final controller = UpdatController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UpdatWidget(
              controller: controller,
              currentVersion: '1.0.0',
              getLatestVersion: () async => '2.0.0',
              getBinaryUrl: (_) async => 'https://example.com/app.exe',
              appName: 'Test App',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      controller.dismissUpdate();
      await tester.pump();

      expect(controller.status, UpdatStatus.dismissed);

      await controller.checkForUpdate();
      await tester.pumpAndSettle();

      expect(controller.status, UpdatStatus.available);
    });

    testWidgets('null latest version sets error status', (tester) async {
      final controller = UpdatController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UpdatWidget(
              controller: controller,
              currentVersion: '1.0.0',
              getLatestVersion: () async => null,
              getBinaryUrl: (_) async => 'https://example.com/app.exe',
              appName: 'Test App',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(controller.status, UpdatStatus.error);
    });

    testWidgets('changelog failure falls back to available', (tester) async {
      final controller = UpdatController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UpdatWidget(
              controller: controller,
              currentVersion: '1.0.0',
              getLatestVersion: () async => '2.0.0',
              getChangelog: (_, _) async {
                throw Exception('changelog unavailable');
              },
              getBinaryUrl: (_) async => 'https://example.com/app.exe',
              appName: 'Test App',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(controller.status, UpdatStatus.available);
    });

    testWidgets('callback fires on status transitions', (tester) async {
      final controller = UpdatController();
      final statuses = <UpdatStatus>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UpdatWidget(
              controller: controller,
              currentVersion: '1.0.0',
              callback: statuses.add,
              getLatestVersion: () async => '1.0.0',
              getBinaryUrl: (_) async => 'https://example.com/app.exe',
              appName: 'Test App',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(statuses, isNotEmpty);
      expect(statuses.last, UpdatStatus.upToDate);
      expect(statuses.where((s) => s == UpdatStatus.upToDate).length, 1);
    });

    test('detached controller checkForUpdate is a no-op', () async {
      final controller = UpdatController();

      await controller.checkForUpdate();

      expect(controller.status, isNull);
    });
  });
}
