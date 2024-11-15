import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:wan_android_flutter_test/bean/home_article_list_bean.dart';
import 'package:wan_android_flutter_test/common_ui/dialog/loading_dialog.dart';
import 'package:wan_android_flutter_test/memory/sp/sp_utils.dart';
import 'package:wan_android_flutter_test/network/api.dart';
import 'package:wan_android_flutter_test/network/dio_instance.dart';

import '../../bean/HomeBannerBean.dart';
import '../../memory/sp/sp_key_constant.dart';
import 'package:fluttertoast/fluttertoast.dart';

//首页的ViewModel
//provider简单使用
class HomeViewModel with ChangeNotifier {
  //第一页页码
  static const int firstPageCount = 0;

  //页码
  var pageCount = firstPageCount;

  //是否显示回到顶部按钮
  bool showToTopBtn = false;
  List<HomeBannerItemData> bannerList = [];
  List<HomeArticleListData> homeArticleList = [];

  //是否正在加载
  bool isBannerFirstLoading = true;
  bool isArticleFirstLoading = true;

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
    isBannerFirstLoading = false;
    //告诉监听者，数据发生了变化
    notifyListeners();
  }

  ///获取Home界面的文章list数据
  ///isLoadMore是否加载更多，默认false，不加载更多
  ///这里也可以用Flutter内部定义的一些回调，如VoidCallback，Function，valueChanged等
  Future<bool> getHomeArticleList({bool isLoadMore = false}) async {
    //加载更多就直接拼接，是刷新或者首次获取就直接清空然后重新获取第0页码
    if (isLoadMore) {
      pageCount++;
    } else {
      pageCount = firstPageCount;
      homeArticleList.clear();
    }
    List<HomeArticleListData> list =
        await Api.getInstance().getHomeArticleList(pageCount);
    if (list.isNotEmpty) {
      homeArticleList.addAll(list);
      isArticleFirstLoading = false;
      notifyListeners();
      return true;
    } else {
      //加载到头了
      pageCount--;
      return false;
    }
  }

  ///更新回到顶部的状态
  void updateShowToTopBtn(bool show) {
    showToTopBtn = show;
    notifyListeners();
  }

  ///是否收藏list中对应index的文章
  bool isCollectArticle(int index) {
    if (index < 0 || index >= homeArticleList.length) {
      return false;
    }
    return homeArticleList[index].collect ?? false;
  }

  ///收藏或取消收藏
  ///id:文章id
  ///index:文章在list中的位置
  Future<bool> collect(int id, int index) async {
    //如果没有登录，就不允许收藏和取消收藏
    if (await SpUtils.getBool(SpKey.isLoginSuccess) == false) {
      return false;
    }
    //如果已经收藏了，就取消收藏
    if (isCollectArticle(index)) {
      bool result = await Api.getInstance().unCollectArticle(id);
      if (result) {
        homeArticleList[index].collect = false;
      }
      Fluttertoast.showToast(
          msg: result ? "取消收藏成功" : "取消收藏失败", toastLength: Toast.LENGTH_SHORT);
      notifyListeners();
      return result;
    }
    //如果没有收藏，就收藏
    else {
      bool result = await Api.getInstance().collectArticle(id);
      if (result) {
        homeArticleList[index].collect = true;
      }
      Fluttertoast.showToast(
          msg: result ? "收藏成功" : "收藏失败", toastLength: Toast.LENGTH_SHORT);
      notifyListeners();
      return result;
    }
  }
}
