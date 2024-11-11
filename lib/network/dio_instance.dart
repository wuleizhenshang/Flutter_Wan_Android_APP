import 'package:dio/dio.dart';
import 'package:wan_android_flutter_test/network/interceptors/print_log_interceptor.dart';
import 'package:wan_android_flutter_test/network/interceptors/response_interceptor.dart';

import 'http_method.dart';

class DioInstance {
  static DioInstance? _instance;

  //这里是dart特性表示私有静态构造方法
  DioInstance._();

  static DioInstance getInstance() {
    //Dart语法糖，为null时执行后面的代码，不为null时直接返回
    return _instance ??= DioInstance._();
  }

  final Dio _dio = Dio();

  final _defaultTime = const Duration(seconds: 30);

  void initDio(
      {required String baseUrl,
      String? httpMethod = HttpMethod.GET,
      Duration? connectTimeout,
      Duration? receiveTimeout,
      Duration? sendTimeout,
      ResponseType? responseType,
      String? contentType}) {
    {
      //做一些网络请求的配置信息
      _dio.options = BaseOptions(
          //请求方法
          method: httpMethod,
          //请求地址
          baseUrl: baseUrl,
          //连接超时
          connectTimeout: connectTimeout ?? _defaultTime,
          //接收超时
          receiveTimeout: receiveTimeout ?? _defaultTime,
          //发送超时
          sendTimeout: sendTimeout ?? _defaultTime,
          //返回数据类型
          responseType: responseType,
          //内容类型
          contentType: contentType);

      //加入拦截器
      _dio.interceptors.add(PrintLogInterceptor());
      //有先后顺序的
      _dio.interceptors.add(ResponseInterceptor());
    }
  }

  ///get请求
  Future<Response> get(
      {required String path,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken}) async {
    return await _dio.get(path,
        queryParameters: queryParameters,
        options: options ??
            Options(
                method: HttpMethod.GET,
                receiveTimeout: _defaultTime,
                sendTimeout: _defaultTime),
        cancelToken: cancelToken);
  }

  ///post请求
  Future<Response> post(
      {required String path,
      //提交json数据
      Object? data,
      //提交表单数据
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken}) async {
    return await _dio.post(path,
        data: data,
        queryParameters: queryParameters,
        options: options ??
            Options(
                method: HttpMethod.POST,
                receiveTimeout: _defaultTime,
                sendTimeout: _defaultTime),
        cancelToken: cancelToken);
  }
}
