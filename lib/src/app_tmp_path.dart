import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();
String? _cachedAppTmpPath;
const _appDirName = '_app';

/// Returns app tmp root dir, which is `<tmp_dir>/_app`.
Future<String> getAppTmpRootDir() async {
  _cachedAppTmpPath ??= p.join(
    (await getTemporaryDirectory()).path,
    _appDirName,
  );
  return _cachedAppTmpPath!;
}

/// Returns a temporary file name.
String tmpFileName() {
  return '${_uuid.v4().replaceAll('-', '')}${DateTime.now().millisecondsSinceEpoch}';
}

/// Creates a temporary directory in the app's root temporary directory.
Future<String> createAppTmpDir({String prefix = ''}) async {
  final tmpName = tmpFileName();
  final dir = p.join(await getAppTmpRootDir(), '$prefix$tmpName');
  await Directory(dir).create(recursive: true);
  return dir;
}

/// Creates a temporary file path. The directory is created if it does not exist. If `fileName` is provided, the file will be created in a unique temporary directory. Otherwise, the file will be created directly in the app's root temporary directory.
Future<String> createAppTmpFile({
  String prefix = '',
  String suffix = '',
  String? fileName,
}) async {
  final tmpName = fileName ?? '$prefix${tmpFileName()}$suffix';
  // If `fileName` is provided, we put the file in a unique tmp directory. Otherwise, we put the file directly in the app's root tmp directory.
  final dir = fileName != null
      ? p.join(await getAppTmpRootDir(), tmpFileName())
      : await getAppTmpRootDir();
  await Directory(dir).create(recursive: true);
  return p.join(dir, tmpName);
}

/// Cleans app temporary root directory. It deletes all files and directories in the temporary directory.
Future<void> cleanAppTmpRootDir() async {
  final appTmpDir = await getAppTmpRootDir();
  final dir = Directory(appTmpDir);
  if (await dir.exists()) {
    await dir.delete(recursive: true);
  }
  // Recreate the directory after deletion.
  await dir.create(recursive: true);
}

/// Cleans the OS root temporary directory. It deletes all files and directories in the temporary directory.
Future<void> cleanOSTmpDir() async {
  await _clearDirSilently(await getTemporaryDirectory());
}

/// Sets the app temporary root directory to a custom path. This is useful for testing purposes. The default app temporary root directory is `<tmp_dir>/_app`.
void setAppTmpRootDir(String path) {
  _cachedAppTmpPath = path;
}

Future<void> _clearDirSilently(Directory dir) async {
  try {
    final entities = await dir.list().toList();
    for (final entity in entities) {
      final path = entity.path;
      if (entity is File) {
        try {
          await entity.delete();
        } catch (err) {
          debugPrint('_cleanDirSilently: deleting file failed: $err, $path');
        }
      } else if (entity is Directory) {
        try {
          await entity.delete(recursive: true);
        } catch (err) {
          debugPrint(
            '_cleanDirSilently: deleting directory failed: $err, $path',
          );
        }
      }
    }
  } catch (err) {
    debugPrint('_cleanDirSilently failed: $err');
  }
}
