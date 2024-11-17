import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/pages/my_collect/my_collect_view_model.dart';

import '../../bean/home_article_list_bean.dart';
import '../../common_ui/cache_network_image/cache_network_image.dart';
import '../../common_ui/dialog/loading_dialog.dart';
import '../../route/route.dart';
import '../../route/route_utils.dart';
import '../../theme/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../webview/web_view_page.dart';

class MyCollectPage extends StatefulWidget {
  const MyCollectPage({super.key});

  @override
  _MyCollectPageState createState() => _MyCollectPageState();
}

class _MyCollectPageState extends State<MyCollectPage> {
  //空头像
  final String _emptyUserIconLink = "https://picsum.photos/300/300";

  //顶部
  static const double top = 0;

  //回到顶部动画时间
  static const Duration toTopAnimateDuration = Duration(seconds: 1);

  //出现回到顶部按钮的滑动距离
  static const double showToTopBtnOffset = 300;

  //viewModel
  MyCollectViewModel viewModel = MyCollectViewModel();

  //刷新控制器
  EasyRefreshController controller = EasyRefreshController();

  //滑动控制器
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    viewModel.getCollectArticleList();
    _addScrollerListener();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyCollectViewModel>(create: (context) {
      return viewModel;
    }, child:
        Consumer<MyCollectViewModel>(builder: (context, viewModel, child) {
      return viewModel.isFirstLoading
          ?
          //进度条
          Container(
              color: Colors.white,
              child:
                  Center(child: CircularProgressIndicator(color: blue87CEFA)))
          :
          //页面
          Scaffold(
              backgroundColor: Colors.white,
              //body部分在appBar后面，加了safeArea，不会被appBar遮挡，这个就没什么影响了
              //extendBodyBehindAppBar: true,
              appBar: AppBar(
                title: const Text("我的收藏"),
                backgroundColor: blue87CEFA,
                elevation: 0,
                //需要注意的是，在Flutter中appBar会影响状态栏样式，这是Scaffold架构的特性
                //并且会跳转后回来自动恢复，使用appbar就在appbar控制状态栏颜色(backgroundColor)
                //控制状态栏图标颜色(systemOverlayStyle)
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: blue87CEFA,
                    statusBarIconBrightness: Brightness.light),
              ),
              //悬浮按钮
              floatingActionButton:
                  Consumer<MyCollectViewModel>(builder: (context, vm, child) {
                return vm.showToTopBtn
                    ? FloatingActionButton(
                        backgroundColor: blue87CEFA,
                        onPressed: _scrollToTop,
                        child: Icon(Icons.arrow_upward, color: grayFFF9F9F9))
                    : const SizedBox.shrink();
              }),
              //SafeArea是一个widget，可以让其子widget避开屏幕的异形区域，比如刘海屏或者下方的Home Indicator
              //保证页面内容不会被遮挡
              body: SafeArea(
                child: EasyRefresh(
                    //控制器
                    controller: controller,
                    //支持下拉刷新
                    enableControlFinishRefresh: true,
                    onRefresh: () async {
                      //下拉刷新，Future是有回调的
                      viewModel.getCollectArticleList().then((value) {
                        controller.finishRefresh();
                      });
                    },
                    //支持上拉加载更多
                    enableControlFinishLoad: true,
                    onLoad: () async {
                      //上拉加载更多
                      if (await viewModel.getCollectArticleList(
                          isLoadMore: true)) {
                        //加载成功
                        controller.finishLoad();
                      } else {
                        //没有更多数据
                        controller.finishLoad(noMore: true);
                      }
                    },
                    //头部刷新样式
                    header: ClassicalHeader(),
                    //底部加载更多样式
                    footer: ClassicalFooter(),
                    child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            //列表//用Expanded包裹，让ListView占满剩余空间
                            // Expanded(child:
                            _articleListUi()
                            // )
                          ],
                        ))),
              ));
    }));
  }

  ///添加滑动监听
  void _addScrollerListener() {
    scrollController.addListener(() {
      //滑动监听
      viewModel.updateShowToTopBtn(
          scrollController.offset < showToTopBtnOffset ? false : true);
    });
  }

  ///回到顶部
  void _scrollToTop() {
    scrollController.animateTo(top,
        duration: toTopAnimateDuration, curve: Curves.easeOut);
  }

  ///整个文章List部分的UI
  Widget _articleListUi() {
    return Consumer<MyCollectViewModel>(builder: (context, vm, child) {
      return ListView.builder(
        //但是SingleChildScrollView需要知道子组件的高度，但是ListView不知道，可以设置shrinkWrap: true让ListView自适应
        shrinkWrap: true,
        //同时还需要禁用ListView的滑动，避免嵌套滑动冲突
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          //回调告诉内部有多少个item，长什么样
          return _listItemView(vm.collectArticleList[index], index);
        },
        itemCount: vm.collectArticleList.length,
      );
    });
  }

  ///单个文章布局Item的UI
  //不在上面堆太多了，这里写一个方法返回一个item布局
  Widget _listItemView(HomeArticleListData data, int index) {
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
              //点击事件
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
                        const Expanded(child: SizedBox()),
                        GestureDetector(
                            onTap: () {
                              //收藏或者取消收藏
                              if (data.id != null && data.id is int) {
                                LoadingDialog.show(context,
                                    circularProgressColor: grayFFBFBFBF,
                                    textColor: grayFFBFBFBF);
                                viewModel
                                    .cancelCollectArticle(data.id as int, index)
                                    .then((value) {
                                  LoadingDialog.dismiss(context);
                                });
                              }
                            },
                            child: Container(
                                padding: EdgeInsets.all(10.w),
                                child: Image.asset("assets/images/ic_like.png",
                                    width: 45.r, height: 45.r)))
                      ])
                    ]))));
  }
}
