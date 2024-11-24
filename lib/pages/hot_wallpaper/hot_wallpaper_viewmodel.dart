import 'package:get/get.dart';
import 'package:wan_android/bean/hot_wallpaper_list_bean.dart';
import 'package:wan_android/memory/drift/db/app_database.dart';
import 'package:wan_android/repository/hot_wallpaper_repository.dart';

class HotWallpaperViewModel extends GetxController {
  //热门壁纸列表
  final RxList<Vertical> _hotWallpaperList = <Vertical>[].obs;

  RxList<Vertical> get hotWallpaperList => _hotWallpaperList;

  //是否第一次加载
  final RxBool _isFirstLoading = true.obs;

  RxBool get isFirstLoading => _isFirstLoading;

  //数据仓库
  final _repository = HotWallpaperRepository();

  //获取热门壁纸
  Future<void> getHotWallpaper() async {
    _hotWallpaperList.clear();
    _hotWallpaperList.addAll(await _repository.getHotWallpaperList());
    _isFirstLoading.value = false;
  }
}
