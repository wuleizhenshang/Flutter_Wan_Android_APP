import 'package:dio/dio.dart';
import 'package:wan_android/bean/pgy_update_bean.dart';
import 'package:wan_android/network/constant.dart';
import 'package:wan_android/network/interceptors/print_log_interceptor.dart';

class PgyDio {
  static PgyDio? _instance;

  PgyDio._();

  static PgyDio getInstance() {
    return _instance ??= PgyDio._();
  }

  final Dio _dio = Dio();

  ///检查更新
  Future<PgyUpdateBean?> checkUpdate() async {
    _dio.options = BaseOptions(
      baseUrl: pgyBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    );
    _dio.interceptors.add(PrintLogInterceptor());

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
