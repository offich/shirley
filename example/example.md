## Getting Started

Before running shirley on devtool extensions, you should execute below commands.
Since this extension is standalone, `import 'package:shirley/shirley.dart';` statement is not necessary.

```txt
$ cd /path/to/root/of/this/repository
$ fvm dart run devtools_extensions build_and_copy --source=. --dest=./example/extension/devtools
$ cd example
$ fvm flutter run
```
