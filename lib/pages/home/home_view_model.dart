import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:wan_android_flutter_test/bean/home_article_list_bean.dart';
import 'package:wan_android_flutter_test/network/Api.dart';
import 'package:wan_android_flutter_test/network/dio_instance.dart';

import '../../bean/HomeBannerBean.dart';

//首页的ViewModel
//provider简单使用
class HomeViewModel with ChangeNotifier {
  //第一页页码
  static const int firstPageCount = 0;

  //页码
  var pageCount = firstPageCount;
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
    bannerList = await Api.getInstance().getBanner();
    //告诉监听者，数据发生了变化
    notifyListeners();
  }

  ///获取Home界面的文章list数据
  ///isLoadMore是否加载更多，默认false，不加载更多
  Future getHomeArticleList({bool isLoadMore = false}) async {
    //加载更多就直接拼接，是刷新或者首次获取就直接清空然后重新获取第0页码
    if (isLoadMore) {
      pageCount++;
    } else {
      pageCount = firstPageCount;
      homeArticleList.clear();
    }
    homeArticleList
        .addAll(await Api.getInstance().getHomeArticleList(pageCount));
    notifyListeners();
  }
}
