import 'package:wan_android_flutter_test/bean/home_article_list_bean.dart';
import 'package:wan_android_flutter_test/bean/hot_search_word.dart';
import 'package:wan_android_flutter_test/bean/usually_use_website.dart';

import '../bean/HomeBannerBean.dart';
import 'dio_instance.dart';
import 'package:dio/dio.dart';

///网络请求集合在这里，简化外部操作
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
}
