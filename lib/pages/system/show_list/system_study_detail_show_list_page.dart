import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/pages/system/show_list/system_study_detail_show_list_view_model.dart';
import '/theme/color.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

import '../../../bean/system_detail_list_bean.dart';
import '../../../common_ui/cache_network_image/cache_network_image.dart';
import '../../../common_ui/dialog/loading_dialog.dart';
import '../../../route/route.dart';
import '../../../route/route_utils.dart';
import '../../webview/web_view_page.dart';

class SystemStudyDetailShowListPage extends StatefulWidget {
  final int id;

  const SystemStudyDetailShowListPage({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return _SystemStudyDetailShowListPageState();
  }
}

class _SystemStudyDetailShowListPageState
    extends State<SystemStudyDetailShowListPage> {
  //空头像
  final String _emptyUserIconLink = "https://picsum.photos/300/300";

  //uuid
  var uuid = const Uuid();

  //EasyRefreshController控制器
  EasyRefreshController controller = EasyRefreshController();

  //滑动控制器
  ScrollController scrollController = ScrollController();

  //ViewModel
  SystemStudyDetailShowListViewModel viewModel =
      SystemStudyDetailShowListViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.initId(widget.id);
    viewModel.getArticleList();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SystemStudyDetailShowListViewModel>(
        create: (context) {
      return viewModel;
    }, child: Consumer<SystemStudyDetailShowListViewModel>(
            builder: (context, viewModel, child) {
      return viewModel.isFirstLoad
          ? Container(
              color: Colors.white,
              child:
                  Center(child: CircularProgressIndicator(color: blue87CEFA)))
          : EasyRefresh(
              controller: controller,
              enableControlFinishLoad: true,
              onLoad: () async {
                //加载更多
                viewModel.getArticleList(isLoadMore: true).then((value) {
                  if (value) {
                    controller.finishLoad();
                  } else {
                    controller.finishLoad(noMore: true);
                  }
                });
              },
              enableControlFinishRefresh: true,
              onRefresh: () async {
                //刷新
                viewModel.getArticleList().then((value) {
                  controller.finishRefresh();
                });
              },
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (context, index) {
                  return _itemArticleUi(viewModel.articleList[index], index);
                },
                itemCount: viewModel.articleList.length,
              ));
    }));
  }

  ///单个文字item ui
  Widget _itemArticleUi(SystemDetailArticleBean bean, int index) {
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
                    WebViewPage.name: bean.title,
                    WebViewPage.url: bean.link
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
                            bean.author?.isEmpty ?? true
                                ? bean.shareUser ?? "author"
                                : bean.author ?? "author",
                            style: TextStyle(
                                color: Colors.black, fontSize: 22.sp)),
                        //SizedBox是一个widget，可以设置宽高，用来占位
                        const Expanded(child: SizedBox()),
                        //设置边距也可以这样
                        Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: Text(bean.niceShareDate ?? "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.sp))),

                        ///置顶文字字样，type 0 是正常文章，1是置顶文章
                        (bean.type?.toInt() == 1)
                            ? Text("置顶",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.sp))
                            : const SizedBox(),
                      ]),
                      SizedBox(height: 10.h),
                      Text(bean.title ?? "",
                          style:
                              TextStyle(color: Colors.black, fontSize: 24.sp)),
                      Row(children: [
                        Text(bean.chapterName ?? "",
                            style: TextStyle(
                                color: Colors.lightGreen, fontSize: 20.sp)),
                        const Expanded(child: SizedBox()),
                        GestureDetector(
                            onTap: () {
                              //收藏或者取消收藏
                              if (bean.id != null && bean.id is int) {
                                LoadingDialog.show(context,
                                    circularProgressColor: grayFFBFBFBF,
                                    textColor: grayFFBFBFBF);
                                viewModel
                                    .collect(bean.id as int, index)
                                    .then((value) {
                                  LoadingDialog.dismiss(context);
                                });
                              }
                            },
                            child: Container(
                                padding: EdgeInsets.all(10.w),
                                child: viewModel.articleList[index].collect ??
                                        false
                                    ? Image.asset("assets/images/ic_like.png",
                                        width: 45.r, height: 45.r)
                                    : Image.asset("assets/images/ic_unlike.png",
                                        width: 45.r, height: 45.r)))
                      ])
                    ]))));
  }
}
