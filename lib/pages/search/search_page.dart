import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter_test/bean/search_list_bean.dart';
import 'package:wan_android_flutter_test/common_ui/input_field/search_page_input_field.dart';
import 'package:wan_android_flutter_test/pages/search/search_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android_flutter_test/theme/color.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../common_ui/cache_network_image/cache_network_image.dart';
import '../../common_ui/input_field/input_field_with_icon_cancel_ui.dart';
import '../../route/route.dart';
import '../../route/route_utils.dart';
import '../webview/web_view_page.dart';

///搜索页面
class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.initKey});

  //key
  final String? initKey;

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  //空头像
  final String _emptyUserIconLink = "https://picsum.photos/300/300";

  //输入框控制器
  final TextEditingController controller = TextEditingController();

  //EasyRefresh控制器
  final EasyRefreshController _easyRefreshController = EasyRefreshController();

  //初始化viewModel，getx为全局单例，不会自动销毁
  final SearchViewModel viewModel = Get.put(SearchViewModel());

  //焦点状态
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    //设置ViewModel，不为空加载
    viewModel.setSearchKey(widget.initKey ?? "");
    controller.text = widget.initKey ?? "";
    if(widget.initKey?.isNotEmpty ?? false){
      viewModel.searchByKeyword();
    }

    controller.addListener(() {
      //监听输入框的值变化
      viewModel.setSearchKey(controller.text);
    });
  }

  //销毁，手动回收getx
  @override
  void dispose() {
    Get.delete<SearchViewModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Getx比Obx效率低一点，但是简洁
    //状态栏颜色
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: //页面
                SafeArea(
                    child: Column(
              children: [
                //顶部搜索ui
                SizedBox(height: 10.h),
                _searchEditUi(),
                SizedBox(height: 10.h),
                Container(
                    width: double.infinity, color: grayFF999999, height: 1.h),

                GetX<SearchViewModel>(builder: (viewModel) {
                  return Expanded(
                    ///isFirstLoading和isLoading都为true时，显示加载框
                    ///isFirstLoading为true，isLoading为false时，什么都不显示
                    ///isFirstLoading和isLoading都为false时，list为空，显示空布局
                    ///isFirstLoading为false，isLoading为true时，显示加载框
                    child: (viewModel.isFirstLoading.value &&
                            viewModel.isLoading.value)
                        ? Center(
                            child: CircularProgressIndicator(color: blue87CEFA))
                        : (viewModel.isFirstLoading.value
                            ? const SizedBox.shrink()
                            : (viewModel.searchResultTotal.value == 0
                                ? Center(
                                    child: Text("搜索结果为null",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 30.sp)))
                                //有搜索结果显示搜索结果
                                : EasyRefresh(
                                    controller: _easyRefreshController,
                                    enableControlFinishLoad: true,
                                    onLoad: () async {
                                      viewModel
                                          .searchByKeyword(isLoadMore: true)
                                          .then((value) {
                                        //为空加载到头了
                                        if (value.isNotEmpty) {
                                          _easyRefreshController.finishLoad();
                                        } else {
                                          _easyRefreshController.finishLoad(
                                              noMore: true);
                                        }
                                      });
                                    },
                                    child: ListView.builder(
                                        itemCount:
                                            viewModel.searchResultList.length,
                                        itemBuilder: (context, index) {
                                          return _listItemView(
                                              viewModel.searchResultList[index],
                                              index);
                                        })))),
                  );
                })
              ],
            ))));
  }

  ///搜索组件Ui
  Widget _searchEditUi() {
    return Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 返回
            SizedBox(width: 10.w),
            GestureDetector(
                onTap: () {
                  RouteUtils.pop(context);
                },
                child: Image.asset("assets/images/ic_back_999999.png",
                    width: 42.w, height: 42.w)),
            SizedBox(width: 10.w),
            // 中间部分为 SearchPageInputField 组件
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: grayFF999999, width: 1.r),
                    borderRadius: BorderRadius.circular(60.r),
                  ),
                  child: SearchPageInputField(
                    tint: "搜索...",
                    controller: controller,
                    focusNode: _focusNode,
                    //清除搜索
                    deleteCallBack: () {
                      viewModel.clearSearchData();
                    },
                  )),
            ),
            // 搜索按钮
            SizedBox(width: 10.w),
            GestureDetector(
                onTap: () {
                  viewModel.searchByKeyword();
                },
                child: Text("搜索",
                    style: TextStyle(color: blue87CEFA, fontSize: 32.sp))),
            SizedBox(width: 10.w),
            //Icon(Icons.settings, size: 30.w),
          ],
        ));
  }

  ///单个文章布局Item的UI
  Widget _listItemView(SearchItemBean data, int index) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: grayFF999999, width: 1.5.r),
            borderRadius: BorderRadius.circular(10.r)),
        //外边距
        margin: EdgeInsets.only(left: 8.r, right: 8.r, top: 10.r, bottom: 10.r),
        //手势监听，点击事件，GestureDetector是一种,InkWell是另一种，这个有水波纹效果
        child: InkWell(
            radius: 30.r,
            borderRadius: BorderRadius.circular(10.r),
            onTap: () {
              //点击事件，跳转前取消焦点
              _focusNode.unfocus();
              //跳转到WebViewPage页面,可以通过MaterialPageRoute传递参数，也可以通过构造函数传递参数
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              //   return const WebViewPage();
              // }));
              //那么可以用隐式路由
              //Navigator.pushNamed(context, RoutePath.webViewPage);
              RouteUtils.pushForNamed(context, RoutePath.webViewPage,
                  arguments: {
                    WebViewPage.name: data.title,
                    WebViewPage.url: data.link
                  });
            },
            child: Container(
                //内边距
                padding: EdgeInsets.all(10.r),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        //本地就.assets，网络就.network
                        // ClipRRect(
                        //     borderRadius: BorderRadius.circular(20.r),
                        //     child: CachedNetworkImage(
                        //       width: 30.r,
                        //       height: 30.r,
                        //       fit: BoxFit.cover,
                        //       imageUrl: "http://via.placeholder.com/350x150",
                        //       placeholder: (context, url) => CircularProgressIndicator(),
                        //       errorWidget: (context, url, error) => Icon(Icons.error),
                        //     )),
                        // Image.network没有缓存，用CachedNetworkImage第三方库
                        //变为圆角
                        CustomCacheNetworkImage(
                            imageUrl: _emptyUserIconLink,
                            width: 60,
                            height: 60,
                            radius: 30,
                            fit: BoxFit.cover),
                        //要设置间距，可以用SizedBox，也可以用Padding组件
                        SizedBox(width: 15.w),
                        Text(
                            data.author?.isEmpty ?? true
                                ? data.shareUser ?? "author"
                                : data.author ?? "author",
                            style: TextStyle(
                                color: Colors.black, fontSize: 22.sp)),
                        //SizedBox是一个widget，可以设置宽高，用来占位
                        const Expanded(child: SizedBox()),
                        //设置边距也可以这样
                        Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: Text(data.niceShareDate ?? "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.sp))),

                        ///置顶文字字样，type 0 是正常文章，1是置顶文章
                        (data.type?.toInt() == 1)
                            ? Text("置顶",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.sp))
                            : const SizedBox(),
                      ]),
                      SizedBox(height: 10.h),
                      Text(data.title ?? "",
                          style:
                              TextStyle(color: Colors.black, fontSize: 24.sp)),
                      Row(children: [
                        Text(data.chapterName ?? "",
                            style: TextStyle(
                                color: Colors.lightGreen, fontSize: 20.sp)),
                        const Expanded(child: SizedBox())
                      ])
                    ]))));
  }
}
