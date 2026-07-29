import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();
String? _cachedAppTmpPath;
const _appDirName = '_app';

/// Returns `<tmp_dir>/_app`. If the directory does not exist, it will be created.
Future<String> initAppTmpDir({bool? skipCreation}) async {
  _cachedAppTmpPath ??= p.join(
    (await getTemporaryDirectory()).path,
    _appDirName,
  );
  if (skipCreation != true && !await Directory(_cachedAppTmpPath!).exists()) {
    await Directory(_cachedAppTmpPath!).create(recursive: true);
  }
  return _cachedAppTmpPath!;
}

/// Returns a temporary file name.
String tmpFileName() {
  return '${_uuid.v4().replaceAll('-', '')}${DateTime.now().millisecondsSinceEpoch}';
}

/// Returns a temporary path in the `<tmp_dir>/_app`. You can use that to create a temporary file or directory.
Future<String> createAppTmpPath({String prefix = ''}) async {
  final tmpName = tmpFileName();
  return p.join(await initAppTmpDir(), '$prefix$tmpName');
}

/// Cleans `<tmp_dir>/_app`. It deletes all files and directories in the temporary directory.
Future<void> cleanAppTmpDir() async {
  final appTmpDir = await initAppTmpDir(skipCreation: true);
  final dir = Directory(appTmpDir);
  if (await dir.exists()) {
    await dir.delete(recursive: true);
  }
  // Recreate the directory after deletion.
  await dir.create(recursive: true);
}

/// Cleans the app's root temporary directory. It deletes all files and directories in the temporary directory.
Future<void> cleanAppRootTmpDir() async {
  await _clearDirSilently(await getTemporaryDirectory());
}

/// Forces the `<tmp_dir>/_app` to be set to a specific path. This is useful for testing purposes.
void setAppTmpDir(String path) {
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
