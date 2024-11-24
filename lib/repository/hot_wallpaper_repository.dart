import 'package:logger/logger.dart';
import 'package:wan_android/bean/hot_wallpaper_list_bean.dart';
import 'package:wan_android/memory/drift/dao/hot_wallpaper_dao.dart';
import 'package:wan_android/memory/drift/db/app_database.dart';
import 'package:wan_android/memory/drift/db/database_provider.dart';
import 'package:wan_android/memory/sp/sp_key_constant.dart';
import 'package:wan_android/memory/sp/sp_utils.dart';
import 'package:wan_android/network/request/hot_wallpaper/hot_wallpaper_dio_instance.dart';
import 'package:wan_android/repository/i_hot_wallpaper_repository.dart';
import 'package:wan_android/utils/date_utils.dart';

///热门壁纸数据仓库
class HotWallpaperRepository implements IHotWallpaperRepository {
  //Logger
  var logger = Logger();

  //热门壁纸的Dao
  var dao = HotWallpaperDao(DatabaseProvider.instance);

  ///从本地获取热门壁纸
  Future<List<Vertical>> getHotWallpaperFromLocal() async {
    var list = await dao.getAllWallpapers();
    return list.map((e) {
      return Vertical(desc: e.description, thumb: e.imgUrl);
    }).toList();
  }

  ///从网络获取热门壁纸
  Future<List<Vertical>> getHotWallpaperFromInternet() async {
    return HotWallpaperDioInstance.getInstance().getHotWallpaper();
  }

  ///保存热门壁纸到本地
  Future<void> saveHotWallpaperToLocal(List<Vertical> list) async {
    //先清除所有数据
    await dao.deleteAllWallpapers();

    dao.insertHotWallpapers(list.map((bean) {
      return HotWallpaperTableCompanion.insert(
        description: bean.desc ?? "",
        imgUrl: bean.thumb ?? "",
      );
    }).toList());
    //记录下次加载时间
    SpUtils.saveInt(
        SpKey.nextLoadHotWallpaperTime, DateUtils.getNextMidnightTimestamp());
  }

  ///获取热门壁纸列表
  @override
  Future<List<Vertical>> getHotWallpaperList() async {
    int? nextLoadTime = await SpUtils.getInt(SpKey.nextLoadHotWallpaperTime);

    //重新从网络获取
    if (nextLoadTime == null ||
        DateTime.now().millisecondsSinceEpoch >= nextLoadTime) {

      List<Vertical> list = await getHotWallpaperFromInternet();
      await saveHotWallpaperToLocal(list);
      logger.i("重新从网络获取热门壁纸列表\n${list.length}");
      return list;

    }

    //从本地获取
    else {
      List<Vertical> list = await getHotWallpaperFromLocal();

      logger.i("从本地获取热门壁纸数据列表\n${list.length}");

      return list;
    }
  }
}
