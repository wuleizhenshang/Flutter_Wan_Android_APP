import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../../bean/wan_android_base_bean.dart';
import '../../memory/sp/sp_key_constant.dart';
import '../../memory/sp/sp_utils.dart';
import '../../pages/main_tab/tab_page.dart';
import '../../route/route_utils.dart';

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
            //为空说明有请求成功，但是没有数据，那就把整个data返回，需要根据errorCode和Message判断
            handler.next(
                Response(requestOptions: response.requestOptions, data: true));
          } else {
            handler.next(Response(
                requestOptions: response.requestOptions, data: data.data));
          }
        } else if (data.errorCode == 1001) {
          //登录失效
          //清除登录信息
          SpUtils.saveBool(SpKey.isLoginSuccess, false);
          SpUtils.remove(SpKey.userId);
          SpUtils.remove(SpKey.coinCount);
          SpUtils.remove(SpKey.userLevel);
          SpUtils.remove(SpKey.nickname);
          SpUtils.remove(SpKey.userIconLink);
          SpUtils.remove(SpKey.cookie);
          //重载界面
          //退出登录弹出栈重新加载整个页面，以刷新列表的状态
          RouteUtils.pushAndRemoveUntil(RouteUtils.context, const TabPage());
          //返回登录失效
          handler.reject(DioException(
              requestOptions: response.requestOptions,
              message: data.errorMsg ?? "还未登录，请先登录"));
          Fluttertoast.showToast(msg: data.errorMsg ?? "还未登录，请先登录");
        } else if (data.errorCode == -1) {
          //登录注册等请求失败
          Fluttertoast.showToast(msg: data.errorMsg ?? "请求异常，请稍后再试");
          //-1为有异常的，data全变成null传出去，获取为null不解析，就知道异常了，不为空就解析
          handler.next(
              Response(requestOptions: response.requestOptions, data: null));
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
