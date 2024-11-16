import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter_test/network/Api.dart';

import '../../bean/search_list_bean.dart';

///搜索页面的viewModel，使用getx
class SearchViewModel extends GetxController {
  //搜索关键词
  final _searchKey = "".obs;

  // 搜索结果列表
  final RxList<SearchItemBean> _searchResultList = <SearchItemBean>[].obs;

  // 暴露给外部的是可观察对象，UI可以自动监听变化
  RxList<SearchItemBean> get searchResultList => _searchResultList;

  // 搜索结果总数
  final RxInt _searchResultTotal = 0.obs;

  RxInt get searchResultTotal => _searchResultTotal;

  // 是否是第一次加载搜索关键词
  final RxBool _isFirstLoading = true.obs;

  RxBool get isFirstLoading => _isFirstLoading;

  //是否加载中
  final RxBool _isLoading = false.obs;

  RxBool get isLoading => _isLoading;

  //page
  var _page = 0;

  ///设置搜索关键词
  setSearchKey(String value) {
    _searchKey.value = value;
  }

  ///搜索
  ///isLoadMore:是否是加载更多
  ///不是加载更多就说明是新的一次搜索，要重置数据，page设置为0
  Future<List<SearchItemBean>> searchByKeyword(
      {bool isLoadMore = false}) async {
    _isLoading.value = true;
     //设置要加载的页码
    if (isLoadMore) {
      _page++;
    } else {
      _page = 0;
      _searchResultList.clear();
      _searchResultTotal.value = 0;
      _isFirstLoading.value= true;
    }
    //网络请求
    List<SearchItemBean> list =
        await Api.getInstance().searchByKeyword(_searchKey.value, _page);
    _isFirstLoading.value = false;
    _isLoading.value = false;
    //是搜索更多，但是没有内容了，说明结果到底了
    if (list.isEmpty && isLoadMore) {
      _page--;
    }
    _searchResultList.addAll(list);
    _searchResultTotal.value += list.length;
    return list;
  }

  ///清除搜索结果
  void clearSearchData() {
    _searchResultList.clear();
    _searchResultTotal.value = 0;
    _isFirstLoading.value = true;
  }
}
