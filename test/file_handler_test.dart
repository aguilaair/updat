import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:updat/updat_exception.dart';
import 'package:updat/utils/file_handler.dart';

void main() {
  group('file_handler', () {
    test('isZipArchive is case-insensitive', () {
      expect(isZipArchive('/tmp/app.zip'), isTrue);
      expect(isZipArchive('/tmp/app.ZIP'), isTrue);
      expect(isZipArchive('/tmp/app.Zip'), isTrue);
      expect(isZipArchive('/tmp/app.exe'), isFalse);
    });

    test('findInstallerInDirectory throws when directory is empty', () {
      final dir = Directory.systemTemp.createTempSync('updat_empty_');

      expect(
        () => findInstallerInDirectory(dir),
        throwsA(isA<UpdatException>()),
      );

      dir.deleteSync(recursive: true);
    });

    test('findInstallerInDirectory returns first file on non-Windows', () {
      final dir = Directory.systemTemp.createTempSync('updat_files_');
      final installer = File('${dir.path}/installer.AppImage')
        ..createSync(recursive: true);

      expect(findInstallerInDirectory(dir).path, installer.path);

      dir.deleteSync(recursive: true);
    });
  });
}
