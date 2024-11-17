import 'package:flutter/cupertino.dart';
import '/bean/system_detail_list_bean.dart';
import '/network/Api.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../memory/sp/sp_key_constant.dart';
import '../../../memory/sp/sp_utils.dart';


///体系详情页面的每个tab页面下的文章列表的ViewModel
class SystemStudyDetailShowListViewModel extends ChangeNotifier {
  //第一页
  static const int firstPage = 0;

  //当前页码
  int _curPage = firstPage;

  int get curPage => _curPage;

  //是否第一次加载
  bool _isFirstLoad = true;

  bool get isFirstLoad => _isFirstLoad;

  //体系id
  int _id = -1;

  //文章列表
  final List<SystemDetailArticleBean> _articleList = [];

  List<SystemDetailArticleBean> get articleList => _articleList;

  ///初始化id
  void initId(int id) {
    _id = id;
  }

  ///获取文章列表
  Future<bool> getArticleList({bool isLoadMore = false}) async {
    if (_id == -1) {
      return false;
    }
    //根据是否是加载更多和刷新来设置页码
    if (isLoadMore) {
      _curPage++;
    } else {
      _curPage = firstPage;
      _articleList.clear();
    }
    //网络请求加载
    List<SystemDetailArticleBean> list =
    await Api.getInstance().getSystemDetailListById(_id, _curPage);
    if (list.isNotEmpty) {
      _articleList.addAll(list);
      _isFirstLoad = false;
      notifyListeners();
      return true;
    } else {
      //没得加载了
      _curPage--;
      notifyListeners();
      return false;
    }
  }
  ///是否收藏list中对应index的文章
  bool isCollectArticle(int index) {
    if (index < 0 || index >= _articleList.length) {
      return false;
    }
    return _articleList[index].collect ?? false;
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
        _articleList[index].collect = false;
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
        _articleList[index].collect = true;
      }
      Fluttertoast.showToast(
          msg: result ? "收藏成功" : "收藏失败", toastLength: Toast.LENGTH_SHORT);
      notifyListeners();
      return result;
    }
  }

}
