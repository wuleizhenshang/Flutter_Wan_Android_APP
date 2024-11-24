import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'dart:ffi';
import 'package:sqlite3/open.dart';

//加密版本的数据库需要覆盖打开数据库的方法，初始化需要用到
setupDatabases() {
  open
    ..overrideFor(OperatingSystem.android, openCipherOnAndroid)
    ..overrideFor(OperatingSystem.iOS, DynamicLibrary.process);
  // 其他平台不需要覆盖
}