import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

// Use [getAppTmpDir], which returns a cached path.
String? _dangerTmpPath;

/// Returns the app's temporary directory path. The path is cached, so it won't be fetched multiple times.
Future<String> getAppTmpDir() async {
  _dangerTmpPath ??= (await getTemporaryDirectory()).path;
  return _dangerTmpPath!;
}

/// Returns a temporary file name.
String tmpFileName() {
  return '${_uuid.v4().replaceAll('-', '')}${DateTime.now().millisecondsSinceEpoch}';
}

/// Returns a temporary path in the app's temporary directory. You can use that to create a temporary file or directory.
Future<String> tmpPath({String prefix = ''}) async {
  final tmpName = tmpFileName();
  return p.join(await getAppTmpDir(), '$prefix$tmpName');
}

/// Cleans the app's temporary directory. It deletes all files and directories in the temporary directory. It won't delete the temporary directory itself.
Future<void> cleanAppTmpDir() async {
  if (Platform.isAndroid || Platform.isIOS) {
    final tmpDir = await getAppTmpDir();
    await _cleanDirSilently(Directory(tmpDir));
  }
}

Future<void> _cleanDirSilently(Directory dir) async {
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
