import 'package:dio/dio.dart';
import 'package:wan_android_flutter_test/bean/home_banner_bean.dart';

class HomeViewModel {
  //Future做异步和耗时操作
  static Future<List<HomeBannerItemData>> getBanner() async {
    Dio dio = Dio();
    //做一些网络请求的配置信息
    dio.options = BaseOptions(
        //请求方法
        method: "GET",
        //请求地址
        baseUrl: "https://www.wanandroid.com/",
        //连接超时
        connectTimeout: const Duration(seconds: 30),
        //接收超时
        receiveTimeout: const Duration(seconds: 30),
        //发送超时
        sendTimeout: const Duration(seconds: 30));
    //等待请求结果，在异步中的同步操作
    Response response = await dio.get("banner/json");
    var homeBannerBean = HomeBannerBean.fromJson(response.data);
    return homeBannerBean.data ?? [];
  }
}
