import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '/network/Api.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../bean/search_list_bean.dart';
import '../../memory/sp/sp_key_constant.dart';
import '../../memory/sp/sp_utils.dart';

/// 搜索页面的viewModel，使用GetX
class SearchViewModel extends GetxController {
  // 搜索关键词
  final _searchKey = "".obs;

  // 搜索结果列表，保存普通的 SearchItemBean 数据
  final RxList<ObservableSearchItemBean> _searchResultList =
      <ObservableSearchItemBean>[].obs;

// 暴露给外部的是可观察对象，UI可以自动监听变化
  RxList<ObservableSearchItemBean> get searchResultList => _searchResultList;

  //是否收藏

  // 搜索结果总数
  final RxInt _searchResultTotal = 0.obs;

  RxInt get searchResultTotal => _searchResultTotal;

  // 是否是第一次加载搜索关键词
  final RxBool _isFirstLoading = true.obs;

  RxBool get isFirstLoading => _isFirstLoading;

  // 是否加载中
  final RxBool _isLoading = false.obs;

  RxBool get isLoading => _isLoading;

  // page
  var _page = 0;

  /// 设置搜索关键词
  setSearchKey(String value) {
    _searchKey.value = value;
  }

  /// 搜索
  Future<List<SearchItemBean>> searchByKeyword(
      {bool isLoadMore = false}) async {
    _isLoading.value = true;

    // 设置要加载的页码
    if (isLoadMore) {
      _page++;
    } else {
      _page = 0;
      _searchResultList.clear();
      _searchResultTotal.value = 0;
      _isFirstLoading.value = true;
    }

    // 网络请求
    List<SearchItemBean> list =
        await Api.getInstance().searchByKeyword(_searchKey.value, _page);

    // 如果没有内容就返回
    if (list.isEmpty && isLoadMore) {
      _page--;
    }

    // 更新状态
    _isFirstLoading.value = false;
    _isLoading.value = false;

    // 将数据转换为可观察的数据
    _searchResultList.addAll(list.map((item) {
      return ObservableSearchItemBean(
        item: item, // 原始数据
        collect: RxBool(item.collect ?? false), // 默认值为 false
      );
    }).toList());

    // 更新总数
    _searchResultTotal.value += list.length;

    return list;
  }

  /// 清除搜索结果
  void clearSearchData() {
    _searchResultList.clear();
    _searchResultTotal.value = 0;
    _isFirstLoading.value = true;

    // 显式通知刷新
    _searchResultList.refresh();
  }

  /// 收藏或取消收藏
  Future<bool> collect(int id, int index) async {
    // 如果没有登录，就不允许收藏和取消收藏
    if (await SpUtils.getBool(SpKey.isLoginSuccess) == false) {
      return false;
    }

    bool result;
    // 如果已经收藏了，就取消收藏
    if (isCollectArticle(index)) {
      result = await Api.getInstance().unCollectArticle(id);
      if (result) {
        _searchResultList[index].item.collect = false;
        _searchResultList[index].collect.value = false;
      }
      Fluttertoast.showToast(
          msg: result ? "取消收藏成功" : "取消收藏失败", toastLength: Toast.LENGTH_SHORT);
    } else {
      result = await Api.getInstance().collectArticle(id);
      if (result) {
        _searchResultList[index].item.collect = true;
        _searchResultList[index].collect.value = true;
      }
      Fluttertoast.showToast(
          msg: result ? "收藏成功" : "收藏失败", toastLength: Toast.LENGTH_SHORT);
    }

    _searchResultList.refresh();

    return result;
  }

  /// 判断是否收藏 list 中对应 index 的文章
  bool isCollectArticle(int index) {
    if (index < 0 || index >= _searchResultTotal.value) {
      return false;
    }
    return _searchResultList[index].item.collect ?? false;
  }
}

/// 扩展为可观察的搜索结果项
class ObservableSearchItemBean {
  final SearchItemBean item; // 原始的 SearchItemBean
  final RxBool collect; // 响应式 collect 字段

  ObservableSearchItemBean({required this.item, required this.collect});

  // 使用 copyWith 方法创建副本，并修改 collect 字段
  ObservableSearchItemBean copyWith({bool? collect}) {
    return ObservableSearchItemBean(
      item: item,
      collect: collect != null ? RxBool(collect) : this.collect,
    );
  }
}
