import 'package:dio/dio.dart';
import 'package:wan_android/bean/pgy_update_bean.dart';
import 'package:wan_android/network/constant.dart';
import 'package:wan_android/network/interceptors/print_log_interceptor.dart';

class PgyDio {
  static PgyDio? _instance;

  PgyDio._() {
    // Dio 实例初始化，并配置拦截器和基本配置
    _dio = Dio(BaseOptions(
      baseUrl: pgyBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ));

    // 添加拦截器
    _dio.interceptors.add(PrintLogInterceptor());
  }

  static PgyDio getInstance() {
    return _instance ??= PgyDio._();
  }

  late Dio _dio;

  ///检查更新
  Future<PgyUpdateBean?> checkUpdate() async {
    Response response = await _dio.post(
      "apiv2/app/check",
      queryParameters: {
        "_api_key": pgyApiKey,
        "appKey": pgyAppKey,
      },
    );
    if (response.statusCode == 200) {
      return PgyUpdateBean.fromJson(response.data);
    } else {
      return null;
    }
  }
}
