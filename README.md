# app_tmp_path

[![pub package](https://img.shields.io/pub/v/app_tmp_path.svg)](https://pub.dev/packages/app_tmp_path)

- Create a unique file path or directory in app temporary directory.
- Clear all contents in app temporary directory.

## Usage

```dart
import 'package:app_tmp_path/app_tmp_path.dart';

void main() async {
  // Create a unique directory in app temporary directory.
  print(await createAppTmpDir());

  // Create a unique file in app temporary directory.
  // The parent directory will be created automatically if it does not exist.
  print(await createAppTmpFile());

  // You can also specify a custom file name.
  // In that case, a unique parent directory will be created automatically.
  print(await createAppTmpFile(fileName: 'my_file.txt'));

  // If you want to generate a unique file name, you can use tmpFileName() function.
  print(tmpFileName() + '.txt');
  // 30937c061c944d059dfc298242ef1e211679847188991.txt

  // You can also clean the app's temporary directory.
  await cleanAppTmpRootDir();
}
```
