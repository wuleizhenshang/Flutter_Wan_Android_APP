import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter_test/bean/hot_search_word.dart';
import 'package:wan_android_flutter_test/bean/usually_use_website.dart';
import 'package:wan_android_flutter_test/common_ui/bottom_navigation/common_index_stack_with_bottom_navigation.dart';
import 'package:wan_android_flutter_test/pages/hot_point/hot_point_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android_flutter_test/pages/web_view_page.dart';
import 'package:wan_android_flutter_test/route/route_utils.dart';
import 'package:wan_android_flutter_test/route/route.dart';
import 'package:wan_android_flutter_test/theme/color.dart';

class HotPointPage extends StatefulWidget {
  const HotPointPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HotPointPageState();
  }
}

class _HotPointPageState extends State<HotPointPage> {
  HotPointViewModel viewModel = HotPointViewModel();
  EasyRefreshController controller = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    //设置状态栏颜色
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: grayFFF5F5F5,
      statusBarIconBrightness: Brightness.dark,
    ));
    //获取数据
    viewModel.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: grayFFF5F5F5, statusBarIconBrightness: Brightness.dark),
      child: ChangeNotifierProvider<HotPointViewModel>(
        create: (context) {
          return viewModel;
        },
        child: Consumer<HotPointViewModel>(builder: (context, viewModel, child) {
          return (viewModel.isUsuallyUseWebsiteFirstLoading ||
              viewModel.isHotSearchWordFirstLoading)
          //加载中
              ? Container(
              color: grayFFF5F5F5,
              child:
              Center(child: CircularProgressIndicator(color: blue87CEFA)))
          //具体内容
              : Scaffold(
            backgroundColor: grayFFF5F5F5,
            body: SafeArea(
                child: EasyRefresh(
                    controller: controller,
                    //下拉重新获取数据
                    enableControlFinishRefresh: true,
                    onRefresh: () async {
                      await viewModel.fetchData().then((value) {
                        controller.finishRefresh();
                      });
                    },
                    //两个部分数据
                    child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _searchHotWordWidget(),
                            _usuallyUseWebsitesWidget(),
                          ],
                        )))),
          );
        }),
      )
    );
  }

  ///整个搜索热词列表Ui
  Widget _searchHotWordWidget() {
    return Consumer<HotPointViewModel>(
        builder: (context, HotPointViewModel viewModel, child) {
      return Column(
        children: [
          //线
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey,
            margin: EdgeInsets.only(top: 10.h, bottom: 15.h),
          ),
          Row(
            children: [
              SizedBox(width: 20.w),
              Text("搜索热词",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold)),
              const Expanded(child: SizedBox()),
              Image.asset("assets/images/ic_search.png",
                  width: 45.w, height: 45.h),
              SizedBox(width: 20.w)
            ],
          ),
          //线
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey,
            margin: EdgeInsets.only(top: 15.h, bottom: 20.h),
          ),
          GridView.builder(
              //加边距
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
              //去掉GridView的滚动
              physics: const NeverScrollableScrollPhysics(),
              //在一个无边界(滚动方向上)的容器中时，shrinkWrap必须为true
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 15.h,
                  crossAxisSpacing: 20.w,
                  childAspectRatio: 2),
              itemBuilder: (context, index) {
                return _singleSearchHotWordItemWidget(
                    viewModel.hotSearchWordList[index], callback: (name) {
                  //TODO 点击事件，跳转搜索
                });
              },
              itemCount: viewModel.hotSearchWordList.length)
        ],
      );
    });
  }

  ///单个搜索热词Ui
  ///callback是点击事件的回调
  Widget _singleSearchHotWordItemWidget(HotSearchWord bean,
      {ValueChanged<String?>? callback}) {
    return InkWell(
        //水波纹大小
        radius: 20.r,
        //边界
        borderRadius: BorderRadius.circular(10.r),
        onTap: (() {
          callback?.call(bean.name);
        }),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.grey, width: 1)),
          child: Center(
            child: Text(bean.name ?? "",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.normal)),
          ),
        ));
  }

  ///整个常用网站列表Ui
  Widget _usuallyUseWebsitesWidget() {
    return Consumer<HotPointViewModel>(
        builder: (context, HotPointViewModel viewModel, child) {
      return Column(
        children: [
          //线
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey,
            margin: EdgeInsets.only(bottom: 15.h),
          ),
          Row(
            children: [
              SizedBox(width: 20.w, height: 45.h),
              Text("常用网站",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold))
            ],
          ),
          //线
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey,
            margin: EdgeInsets.only(top: 15.h, bottom: 25.h),
          ),
          GridView.builder(
              //加边距
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
              //去掉GridView的滚动
              physics: const NeverScrollableScrollPhysics(),
              //在一个无边界(滚动方向上)的容器中时，shrinkWrap必须为true
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 15.h,
                  crossAxisSpacing: 20.w,
                  childAspectRatio: 2),
              itemBuilder: (context, index) {
                return _singleUsuallyUseWebsitesWidget(
                    viewModel.usuallyUseWebsiteList[index], callback: (map) {
                  //点击事件
                  RouteUtils.pushForNamed(context, RoutePath.webViewPage,
                      arguments: map);
                });
              },
              itemCount: viewModel.usuallyUseWebsiteList.length)
        ],
      );
    });
  }

  ///单个常用网站Ui
  Widget _singleUsuallyUseWebsitesWidget(UsuallyUseWebsite bean,
      {ValueChanged<Map<String, String?>>? callback}) {
    return InkWell(
        radius: 20.r,
        borderRadius: BorderRadius.circular(10.r),
        onTap: () {
          //点击事件
          callback
              ?.call({WebViewPage.name: bean.name, WebViewPage.url: bean.link});
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: grayFF999999, width: 1)),
          child: Center(
            child: Text(bean.name ?? "",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.normal)),
          ),
        ));
  }
}
