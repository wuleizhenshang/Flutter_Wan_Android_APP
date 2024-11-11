//flutter万物皆为widget（组件），那么一个页面也是一个组件
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android_flutter_test/bean/home_article_list_bean.dart';
import 'package:wan_android_flutter_test/pages/home/home_view_model.dart';
import 'package:wan_android_flutter_test/pages/web_view_page.dart';
import 'package:wan_android_flutter_test/route/RouteUtils.dart';
import 'package:wan_android_flutter_test/route/route.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

///对应HomePage界面的状态，泛型为HomePage
///这样子就可以在HomePage中使用HomePageState的属性和方法
///_HomePageState是HomePage的私有类，只有HomePage可以访问，外部无法访问
class _HomePageState extends State<HomePage> {
  //顶部
  static const double top = 0;

  //回到顶部动画时间
  static const Duration toTopAnimateDuration = Duration(seconds: 1);

  //出现回到顶部按钮的滑动距离
  static const double showToTopBtnOffset = 300;

  HomeViewModel viewModel = HomeViewModel();
  EasyRefreshController controller = EasyRefreshController();

  //滑动控制器
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    viewModel.getBanner();
    viewModel.getHomeArticleList();
    _addScrollerListener();
  }

  @override
  Widget build(BuildContext context) {
    //使用Provider后返回ChangeNotifierProvider就好，这个本身继承Widget
    return ChangeNotifierProvider<HomeViewModel>(
        create: (context) {
          //返回ChangeNotifier
          return viewModel;
        },
        child: Scaffold(
            //悬浮按钮
            floatingActionButton:
                Consumer<HomeViewModel>(builder: (context, vm, child) {
              return vm.showToTopBtn
                  ? FloatingActionButton(
                      onPressed: _scrollToTop,
                      child: const Icon(Icons.arrow_upward))
                  : const SizedBox();
            }),
            //SafeArea是一个widget，可以让其子widget避开屏幕的异形区域，比如刘海屏或者下方的Home Indicator
            //保证页面内容不会被遮挡
            body: SafeArea(
                //要一起滑动，使用SingleChildScrollView，相当于Android原生的ScrollView
                child:
                    //easy_refresh，下拉刷新，上拉加载更多
                    EasyRefresh(
                        //控制器
                        controller: controller,
                        //支持下拉刷新
                        enableControlFinishRefresh: true,
                        onRefresh: () async {
                          //下拉刷新，Future是有回调的
                          //下面这样不是并行的，是串行的，要并行的话用Future.wait
                          // viewModel.getBanner().then((value) {
                          //   viewModel.getHomeArticleList().then((value) {
                          //     //刷新完成
                          //     controller.finishRefresh();
                          //   });
                          // });
                          Future.wait([
                            viewModel.getBanner(),
                            viewModel.getHomeArticleList()
                          ]).then((value) {
                            controller.finishRefresh();
                          });
                        },
                        //支持上拉加载更多
                        enableControlFinishLoad: true,
                        onLoad: () async {
                          //上拉加载更多
                          if (await viewModel.getHomeArticleList(
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
                                //轮播
                                _banner(),
                                //列表//用Expanded包裹，让ListView占满剩余空间
                                // Expanded(child:
                                _articleListUi()
                                // )
                              ],
                            ))))));
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

  ///写好一个组建可以单独抽一个方法出来，稍微解决嵌套问题
  //轮播图部分ui
  Widget _banner() {
    //这里监听数据变化，这里的value可以是ViewModel
    return Consumer<HomeViewModel>(builder: (context, vm, child) {
      return SizedBox(
        width: double.infinity,
        height: 200.h,
        child: Swiper(
          itemCount: vm.bannerList.length,
          itemBuilder: (context, index) {
            //margin:外边距 only可以设置上下左右的外边距，all指定所有的外边距
            //涉及上下左右用.r 高.h 宽.w
            // container是一个容器，可以设置很多属性，这里还没图片，这里先用container代替
            return ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.network(vm.bannerList[index].imagePath ?? '',
                    fit: BoxFit.fill));
          },
          pagination: const SwiperPagination(),
          control: const SwiperControl(),
          autoplay: true,
        ),
      );
    });
  }

  ///整个文章List部分的UI
  Widget _articleListUi() {
    return Consumer<HomeViewModel>(builder: (context, vm, child) {
      return ListView.builder(
        //但是SingleChildScrollView需要知道子组件的高度，但是ListView不知道，可以设置shrinkWrap: true让ListView自适应
        shrinkWrap: true,
        //同时还需要禁用ListView的滑动，避免嵌套滑动冲突
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          //回调告诉内部有多少个item，长什么样
          return _listItemView(vm.homeArticleList[index]);
        },
        itemCount: vm.homeArticleList.length,
      );
    });
  }

  ///单个文章布局Item的UI
  //不在上面堆太多了，这里写一个方法返回一个item布局
  Widget _listItemView(HomeArticleListData data) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1.5.r),
            borderRadius: BorderRadius.circular(5.r)),
        //外边距
        margin: EdgeInsets.only(left: 8.r, right: 8.r, top: 10.r, bottom: 10.r),
        //手势监听，点击事件，GestureDetector是一种,InkWell是另一种，这个有水波纹效果
        child: InkWell(
            onTap: () {
              //点击事件
              //跳转到WebViewPage页面,可以通过MaterialPageRoute传递参数，也可以通过构造函数传递参数
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              //   return const WebViewPage();
              // }));
              //那么可以用隐式路由
              //Navigator.pushNamed(context, RoutePath.webViewPage);
              RouteUtils.pushForNamed(context, RoutePath.webViewPage,
                  arguments: {"name": "使用路由传值"});
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
                        ClipRRect(
                            borderRadius: BorderRadius.circular(30.r),
                            child: Image.network(
                              "https://img.btstu.cn/api/images/5a2b8d420d355.jpg",
                              width: 60.r,
                              height: 60.r,
                              fit: BoxFit.cover,
                            )),
                        //要设置间距，可以用SizedBox，也可以用Padding组件
                        SizedBox(width: 15.w),
                        Text(
                            data.author?.isEmpty ?? true
                                ? data.shareUser ?? ""
                                : "",
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
                        Image.asset("assets/images/ic_unlike.png",
                            width: 45.r, height: 45.r),
                      ])
                    ]))));
  }
}
