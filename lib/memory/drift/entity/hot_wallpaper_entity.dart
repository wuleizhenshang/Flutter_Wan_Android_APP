import 'package:drift/drift.dart';


///表对象
///热门壁纸
class HotWallpaperTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get description => text()();

  TextColumn get imgUrl => text()();
}