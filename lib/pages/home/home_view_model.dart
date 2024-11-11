import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:wan_android_flutter_test/bean/home_article_list_bean.dart';
import 'package:wan_android_flutter_test/network/dio_instance.dart';

import '../../bean/HomeBannerBean.dart';

//首页的ViewModel
//provider简单使用
class HomeViewModel with ChangeNotifier {
  List<HomeBannerItemData> bannerList = [];
  List<HomeArticleListData> homeArticleList = [];

  //Future做异步和耗时操作
  //请求Banner数据
  Future getBanner() async {
    // Dio dio = Dio();
    // //做一些网络请求的配置信息
    // dio.options = BaseOptions(
    //     //请求方法
    //     method: "GET",
    //     //请求地址
    //     baseUrl: "https://www.wanandroid.com/",
    //     //连接超时
    //     connectTimeout: const Duration(seconds: 30),
    //     //接收超时
    //     receiveTimeout: const Duration(seconds: 30),
    //     //发送超时
    //     sendTimeout: const Duration(seconds: 30));
    //等待请求结果，在异步中的同步操作
    Response response =
        await DioInstance.getInstance().get(path: "banner/json");
    var homeBannerBean = HomeBannerBean.fromJson(response.data);
    bannerList = homeBannerBean.data ?? [];
    //告诉监听者，数据发生了变化
    notifyListeners();
  }

  //获取Home界面的文章list数据
  Future getHomeArticleList() async {
    Response response =
        await DioInstance.getInstance().get(path: "article/list/0/json");
    var homeArticleListBean = HomeArticleListBean.fromJson(response.data);
    homeArticleList = homeArticleListBean.datas ?? [];
    notifyListeners();
  }
}
