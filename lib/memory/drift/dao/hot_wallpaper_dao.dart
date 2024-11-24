import 'package:drift/drift.dart';
import 'package:wan_android/memory/drift/db/app_database.dart';
import 'package:wan_android/memory/drift/db/database_provider.dart';
import 'package:wan_android/memory/drift/entity/hot_wallpaper_entity.dart';

///Dao
@DriftAccessor(tables: [HotWallpaperTable]) // 标记为表的访问器
class HotWallpaperDao extends DatabaseAccessor<AppDatabase> {
  // 必须通过构造函数传入数据库对象
  HotWallpaperDao(super.attachedDatabase);

  // 获取所有壁纸,select传入一个表对象，这里DatabaseProvider提供db，hotWallpaperTable是表对象
  Future<List<HotWallpaperTableData>> getAllWallpapers() =>
      select(db.hotWallpaperTable).get();

  // 批量插入壁纸数据，传入为生成的用于插入的数据类型
  Future<void> insertHotWallpapers(
      List<HotWallpaperTableCompanion> insertList) async {
    //batch是事务，下面插入多条需要转换就map处理后转换为list进行后续操作
    await DatabaseProvider.instance.batch((batch) {
      batch.insertAll(db.hotWallpaperTable, insertList);
    });
  }

  // 更新壁纸数据
  Future<bool> updateWallpaper(HotWallpaperTableCompanion entry) {
    return update(db.hotWallpaperTable).replace(entry);
  }

  // 删除壁纸
  Future<int> deleteWallpaper(int id) {
    return (delete(db.hotWallpaperTable)
      ..where((t) => t.id.equals(id)))
        .go();
  }

  // 删除所有壁纸
  Future<int> deleteAllWallpapers() {
    return delete(db.hotWallpaperTable).go();
  }
}