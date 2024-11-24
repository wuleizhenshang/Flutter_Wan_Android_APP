import 'package:flutter/cupertino.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:wan_android/bean/home_article_list_bean.dart';
import 'package:wan_android/network/request/wan_android/api.dart';

class MyCollectViewModel extends ChangeNotifier {
  //第一页页码
  static const int firstPageCount = 0;

  //页码
  var pageCount = firstPageCount;

  //是否显示回到顶部按钮
  bool showToTopBtn = false;

  //是否第一次加载
  bool isFirstLoading = true;

  //列表
  List<HomeArticleListData> collectArticleList = [];

  ///获取收藏文章列表
  Future<bool> getCollectArticleList({bool isLoadMore = false}) async {
    //加载更多页码增加请求，不是就清空重新加载
    if (isLoadMore) {
      pageCount++;
    } else {
      pageCount = firstPageCount;
      collectArticleList.clear();
    }

    //网络请求
    List<HomeArticleListData> list =
        await Api.getInstance().getCollectArticleList(pageCount);
    //有数据说明不是最后一页，还能请求
    if (list.isNotEmpty) {
      collectArticleList.addAll(list);
      isFirstLoading = false;
      notifyListeners();
      return true;
    }
    //最后一页，加载到头了
    else {
      pageCount--;
      return false;
    }
  }

  ///更新回到顶部的状态
  void updateShowToTopBtn(bool show) {
    showToTopBtn = show;
    notifyListeners();
  }

  ///取消收藏文章
  Future<bool> cancelCollectArticle(int id, int index) async {
    bool result = await Api.getInstance().unCollectArticle(id);
    if (result) {
      //取消收藏成功，移除对应的文章
      collectArticleList.removeAt(index);
    }
    Fluttertoast.showToast(
        msg: result ? "取消收藏成功" : "取消收藏失败", toastLength: Toast.LENGTH_SHORT);
    notifyListeners();
    return result;
  }
}
