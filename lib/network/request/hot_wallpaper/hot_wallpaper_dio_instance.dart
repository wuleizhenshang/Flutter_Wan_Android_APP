import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:wan_android/bean/hot_wallpaper_list_bean.dart';
import 'package:wan_android/network/constant.dart';
import 'package:wan_android/network/interceptors/print_log_interceptor.dart';

class HotWallpaperDioInstance {
  static HotWallpaperDioInstance? _instance;

  HotWallpaperDioInstance._() {
    // Dio 实例初始化，并配置拦截器和基本配置
    _dio = Dio(BaseOptions(
      baseUrl: hotWallpaperBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ));

    // 添加拦截器
    _dio.interceptors.add(PrintLogInterceptor());
  }

  static HotWallpaperDioInstance getInstance() {
    return _instance ??= HotWallpaperDioInstance._();
  }

  late Dio _dio;

  /// 网络获取热门壁纸
  Future<List<Vertical>> getHotWallpaper() async {
    Response response = await _dio.get(
        "v1/vertical/vertical?limit=30&skip=180&adult=false&first=0&order=hot");
    if (response.statusCode == 200) {
      return HotWallpaperListBean.fromJson(response.data).res?.vertical ?? [];
    } else {
      return [];
    }
  }
}
