import 'package:wan_android/memory/drift/db/app_database.dart';

///获取数据库实例
class DatabaseProvider {
  // 静态实例
  static final AppDatabase _database = AppDatabase();

  // 提供一个访问实例的静态方法
  static AppDatabase get instance => _database;
}
