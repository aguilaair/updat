import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as p;

import 'package:http/http.dart' as http;

import 'open_link.dart';

Future<File?> getCustomDownloadFileLocation(String release, String appName) async {
  final downloadDir = await getDownloadsDirectory();
  if (downloadDir == null) {
    throw Exception('Unable to get downloads directory, release: $release');
  }
  final filePath = p.join(
    downloadDir.absolute.path,
    '$appName-$release',
  );
  return File(filePath);
}

Future<File> getDownloadFileLocation(String release, String appName, String extension) async {
  final downloadDir = await getDownloadsDirectory();
  if (downloadDir == null) {
    throw Exception('Unable to get downloads directory');
  }
  final filePath = p.join(
    downloadDir.absolute.path,
    '$appName-$release.$extension',
  );
  return File(filePath);
}

Future<File> downloadRelease(File file, String url) async {
  var res = await http.get(
    Uri.parse(url),
  );
  if (res.statusCode == 200) {
    print("autoupdate: download res.statusCode 200");
    await file.writeAsBytes(res.bodyBytes);
    print("file: $file");
    // Return with new installed status
    return file;
  } else {
    print(
      'There was an issue downloading the file, plese try again later.\n'
      'Code ${res.statusCode}',
    );
    throw Exception(
      'There was an issue downloading the file, plese try again later.\n'
      'Code ${res.statusCode}',
    );
  }
}

Future<void> openInstaller(File file) async {
  if (file.existsSync()) {
    print('autoupdater: pre - open installer. path: ${file.absolute.path}');
    await openUri(Uri(path: file.absolute.path, scheme: 'file'));
  } else {
    print('Installer does not exists, you have to download it first');
    throw Exception(
      'Installer does not exists, you have to download it first',
    );
  }
}
