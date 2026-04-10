# app_tmp_path

[![pub package](https://img.shields.io/pub/v/app_tmp_path.svg)](https://pub.dev/packages/app_tmp_path)

- Generate a unique path in app temporary directory.
- Generate a unique file name.
- Clear all contents in app temporary directory (Android and iOS only).

## Usage

```dart
import 'package:app_tmp_path/src/app_tmp_path.dart';

void main() async {
  // Generate a unique path in app temporary directory.
  print(await tmpPath());
  // /var/folders/q5/yvcxrtbn7mq5h4r4zvjhp_v40000gn/T/e8d9cbbcc1944c32a68d3d3739618dcb1679847188986

  // You can also specify a prefix for the generated path.
  print(await tmpPath(prefix: 'test'));
  // /var/folders/q5/yvcxrtbn7mq5h4r4zvjhp_v40000gn/T/test399b42ececa84e069cf582b0adf1cea61679847188991

  // If you want to generate a unique file name, you can use tmpFileName() function.
  print(tmpFileName() + '.txt');
  // 30937c061c944d059dfc298242ef1e211679847188991.txt

  // You can also clean the app's temporary directory (Android and iOS only).
  await cleanAppTmpDir();

  // To get the path of the app's temporary directory, you can use getAppTmpDir() function.
  // This calls getTemporaryDirectory() from path_provider package internally.
  print(await getAppTmpDir());
}
```
