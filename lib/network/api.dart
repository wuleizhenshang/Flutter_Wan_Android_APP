import 'package:flutter/cupertino.dart';
import 'package:wan_android_flutter_test/bean/home_article_list_bean.dart';
import 'package:wan_android_flutter_test/bean/hot_search_word.dart';
import 'package:wan_android_flutter_test/bean/login_bean.dart';
import 'package:wan_android_flutter_test/bean/register_bean.dart';
import 'package:wan_android_flutter_test/bean/user_message_bean.dart';
import 'package:wan_android_flutter_test/bean/usually_use_website.dart';

import '../bean/HomeBannerBean.dart';
import 'dio_instance.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

///网络请求集合在这里，简化外部操作，内部使用Dio单例请求，外部只需要调用具体数据请求方法即可
///Api做网络请求和数据的解析，ViewModel负责获取数据通知页面更新
class Api {
  static Api? _instance;

  Api._();

  static Api getInstance() {
    return _instance ??= Api._();
  }

  ///网络请求
  ///获取Banner
  Future<List<HomeBannerItemData>> getBanner() async {
    Response response =
        await DioInstance.getInstance().get(path: "banner/json");
    return HomeBannerBean.fromJson(response.data).data ?? [];
  }

  ///获取首页文章列表
  Future<List<HomeArticleListData>> getHomeArticleList(int pageCount) async {
    Response response = await DioInstance.getInstance()
        .get(path: "article/list/$pageCount/json");
    return HomeArticleListBean.fromJson(response.data).datas ?? [];
  }

  ///获取常用网站
  Future<List<UsuallyUseWebsite>> getUsuallyUseWebSiteList() async {
    Response response =
        await DioInstance.getInstance().get(path: "friend/json");
    return UsuallyUseWebsiteBean.fromJson(response.data).list;
  }

  ///获取热搜词
  Future<List<HotSearchWord>> getHotSearchWordList() async {
    Response response =
        await DioInstance.getInstance().get(path: "hotkey/json");
    return HotSearchWordBean.fromJson(response.data).list;
  }

  ///注册
  Future<RegisterBean?> register(
      String username, String password, String repassword) async {
    Response response = await DioInstance.getInstance().post(
        path: "user/register",
        queryParameters: {
          "username": username,
          "password": password,
          "repassword": repassword
        });
    return response.data == null ? null : RegisterBean.fromJson(response.data);
  }

  ///登录
  Future<LoginBean?> login(String username, String password) async {
    Response response = await DioInstance.getInstance().post(
        path: "user/login",
        queryParameters: {"username": username, "password": password});
    return response.data == null ? null : LoginBean.fromJson(response.data);
  }

  ///获取用户信息
  ///头像字段是没有用的，网站没做，这个永远为""
  Future<UserMessageBean?> getUserMessage() async {
    Response response =
        await DioInstance.getInstance().get(path: "user/lg/userinfo/json");
    return response.data == null
        ? null
        : UserMessageBean.fromJson(response.data);
  }

  ///退出登录 清除cookie和本地保存的账号密码。。。
  Future<bool> logout() async {
    Response response =
        await DioInstance.getInstance().get(path: "user/logout/json");
    if (response.data == null) {
      return false;
    } else {
      return response.data;
    }
  }
}