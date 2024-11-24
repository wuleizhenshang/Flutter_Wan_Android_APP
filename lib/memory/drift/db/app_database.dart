import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:wan_android/memory/drift/entity/hot_wallpaper_entity.dart';

//会报错，执行flutter pub run build_runner build生成代码
//part 语句中的文件名应该与自动生成的文件名一致
part 'app_database.g.dart';

//数据库密码
const _encryptionPassword = 'password';

///数据库对象
@DriftDatabase(tables: [HotWallpaperTable])
class AppDatabase extends _$AppDatabase {
  //调用父类的构造函数
  AppDatabase() : super(_openConnection());

  //数据库版本
  @override
  int get schemaVersion => 1;
}

///自定义打开数据库的方法
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    //通过路径提供器获取目录以存放数据库文件
    final dbFolder = (Platform.isMacOS || Platform.isIOS)
        ? await getApplicationDocumentsDirectory()
        : await getApplicationSupportDirectory();

    //获取数据库文件路径
    final dbFile = p.join(dbFolder.path, 'databases', 'wan_android_flutter.db');
    Logger().d("数据库路径：${dbFile}");

    // 使用 sqlcipher_flutter_libs 创建加密的数据库连接
    // final db = await openDatabase(
    //   file.path,
    //   // 确保数据库连接是单一实例
    //   singleInstance: true,
    // );

    return NativeDatabase(File(dbFile), setup: (db) {
      //这个语法检查数据库是否已经加密
      final result = db.select('pragma cipher_version');
      if (result.isEmpty) {
        throw UnsupportedError(
          'this database needs to run with sqlcipher, but that library is '
          'not available!',
        );
      } else {
        Logger().d("数据库已加密");
      }

      //通过密码打开数据库
      db.execute("pragma key = '$_encryptionPassword'");
    });
    //return NativeDatabase.createInBackground(file);用于在后台线程中创建一个数据库文件并返回一个数据库实例。
    // 它的主要作用是异步创建数据库文件，以避免在主线程中执行耗时的数据库创建操作，从而确保应用的响应性能。
  });
}




