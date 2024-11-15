import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:wan_android_flutter_test/bean/hot_search_word.dart';
import 'package:wan_android_flutter_test/network/api.dart';

import '../../bean/usually_use_website.dart';

class HotPointViewModel extends ChangeNotifier {
  //常用网站列表
  List<UsuallyUseWebsite> usuallyUseWebsiteList = [];

  //热词列表
  List<HotSearchWord> hotSearchWordList = [];

  //是否正在加载
  bool isUsuallyUseWebsiteFirstLoading = true;
  bool isHotSearchWordFirstLoading = true;

  ///获取数据
  Future fetchData() async {
    //一起获取数据
    Future.wait([_getUsuallyUseWebsiteList(), _getHotSearchWordList()])
        .then((value) {
      notifyListeners();
    });
  }

  ///获取常用网站
  Future _getUsuallyUseWebsiteList() async {
    usuallyUseWebsiteList = await Api.getInstance().getUsuallyUseWebSiteList();
    isUsuallyUseWebsiteFirstLoading = false;
  }

  ///获取热搜词
  Future _getHotSearchWordList() async {
    hotSearchWordList = await Api.getInstance().getHotSearchWordList();
    isHotSearchWordFirstLoading = false;
  }
}
