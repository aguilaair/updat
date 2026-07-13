import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

import 'package:updat/updat_exception.dart';
import 'package:updat/utils/global_options.dart';
import 'package:updat/utils/open_link.dart';

bool isZipArchive(String path) => p.extension(path).toLowerCase() == '.zip';

File findInstallerInDirectory(Directory directory) {
  final entries = directory.listSync();
  if (entries.isEmpty) {
    throw UpdatException('No installer found in ${directory.path}');
  }

  if (Platform.isWindows) {
    for (final entry in entries) {
      if (entry is File && p.extension(entry.path).toLowerCase() == '.exe') {
        return entry;
      }
    }
    throw UpdatException('No Windows installer (.exe) found in ${directory.path}');
  }

  for (final entry in entries) {
    if (entry is File) {
      return entry;
    }
  }

  throw UpdatException('No installer file found in ${directory.path}');
}

Future<File> getDownloadFileLocation(
    String release, String appName, String extension) async {
  final downloadDir = await getDownloadsDirectory();
  if (downloadDir == null) {
    throw UpdatException('Unable to get downloads directory');
  }
  final filePath = p.join(
    downloadDir.absolute.path,
    '$appName-$release.$extension',
  );
  return File(filePath);
}

Future<File> downloadRelease(File file, String url, String appName) async {
  var res = await http.get(
    Uri.parse(url),
    headers: {
      ...UpdatGlobalOptions.downloadReleaseHeaders,
    },
  );
  if (res.statusCode == 200) {
    await file.writeAsBytes(res.bodyBytes);
    if (isZipArchive(file.path)) {
      final outDir = Directory(p.join(p.dirname(file.path), appName));
      outDir.createSync(recursive: true);
      extractFileToDisk(file.absolute.path, outDir.absolute.path);
    }
    return file;
  } else {
    throw UpdatException(
      'There was an issue downloading the file, please try again later.\n'
      'Code ${res.statusCode}',
    );
  }
}

Future<void> openInstaller(File file, String appName) async {
  if (!file.existsSync()) {
    throw const UpdatException(
      'Installer does not exist, you have to download it first',
    );
  }

  var installer = file;
  if (isZipArchive(file.path)) {
    final outDir = Directory(p.join(p.dirname(file.path), appName));
    installer = findInstallerInDirectory(outDir);
  }

  await openUri(Uri(path: installer.absolute.path, scheme: 'file'));
}
