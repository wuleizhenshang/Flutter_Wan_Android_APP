import 'package:dio/dio.dart';
import 'package:wan_android_flutter_test/bean/wan_android_base_bean.dart';
import 'package:fluttertoast/fluttertoast.dart';

///提前解析data，最外层套的部分没了，直接获取到data部分传递给下一层
class ResponseInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200) {
      //请求成功
      try {
        var data = WanAndroidBaseBean.fromJson(response.data);
        //这个errorCode跟后台约定的，玩安卓0表示成功.1001为登录失效
        if (data.errorCode == 0) {
          if (data.data == null) {
            handler.next(
                Response(requestOptions: response.requestOptions, data: true));
          } else {
            handler.next(Response(
                requestOptions: response.requestOptions, data: data.data));
          }
        } else if (data.errorCode == 1001) {
          //登录失效
          handler.reject(DioException(
              requestOptions: response.requestOptions, message: "登录失效"));
          Fluttertoast.showToast(msg: "登录失效");
        } else {
          //交给下层处理
          handler.next(Response(
              requestOptions: response.requestOptions, data: data.data));
        }
      } catch (e) {
        //请求失败
        handler.reject(DioException(
            requestOptions: response.requestOptions, message: "$e"));
      }
    } else {
      //请求失败
      handler.reject(DioException(requestOptions: response.requestOptions));
    }
  }
}
