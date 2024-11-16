import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wan_android_flutter_test/pages/system/system_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android_flutter_test/theme/color.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class SystemStudyPage extends StatefulWidget {
  const SystemStudyPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SystemStudyPageState();
  }
}

class _SystemStudyPageState extends State<SystemStudyPage> {
  //顶部
  static const double top = 0;

  //回到顶部动画时间
  static const Duration toTopAnimateDuration = Duration(seconds: 1);

  //出现回到顶部按钮的滑动距离
  static const double showToTopBtnOffset = 300;

  //ViewModel
  SystemViewModel viewModel = SystemViewModel();

  //EasyRefresh控制器
  final EasyRefreshController _controller = EasyRefreshController();

  //滑动控制器
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    viewModel.fetchData();
    _addScrollerListener();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: ChangeNotifierProvider<SystemViewModel>(
            create: (context) {
              return viewModel;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              //悬浮按钮
              floatingActionButton:
                  Consumer<SystemViewModel>(builder: (context, vm, child) {
                return vm.showToTopBtn
                    ? FloatingActionButton(
                        backgroundColor: blue87CEFA,
                        onPressed: _scrollToTop,
                        child: Icon(Icons.arrow_upward, color: grayFFF9F9F9))
                    : const SizedBox.shrink();
              }),
              body: SafeArea(child:
                  Consumer<SystemViewModel>(builder: (context, vm, child) {
                return Stack(children: [
                  // 页面内容
                  EasyRefresh(
                    controller: _controller,
                    // 刷新
                    onRefresh: () async {
                      viewModel.fetchData().then((value) {
                        _controller.finishRefresh();
                      });
                    },
                    child: vm.isLoading
                        ? const SizedBox.shrink() // 在加载时不显示列表内容
                        : ListView.builder(
                            controller: scrollController,
                            itemBuilder: (context, index) {
                              return _singleSystemMainListUi(viewModel
                                  .systemMainListBean.systemMainList[index]);
                            },
                            itemCount: viewModel
                                .systemMainListBean.systemMainList.length,
                          ),
                  ),
                  // 加载指示器居中
                  vm.isLoading
                      ?
                      //Positioned 通常用来控制子组件在 Stack 中的定位,fill 会填充满整个 Stack
                      Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(color: blue87CEFA),
                          ),
                        )
                      : const SizedBox.shrink()
                ]);
              })),
            )));
  }

  ///回到顶部
  void _scrollToTop() {
    scrollController.animateTo(top,
        duration: toTopAnimateDuration, curve: Curves.easeOut);
  }

  ///添加滑动监听
  void _addScrollerListener() {
    scrollController.addListener(() {
      //滑动监听
      viewModel.updateShowToTopBtn(
          scrollController.offset < showToTopBtnOffset ? false : true);
    });
  }

  ///单个体系主列表UI
  Widget _singleSystemMainListUi(SystemMainBean bean) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
            border: Border.all(color: grayFF999999, width: 1.w),
            borderRadius: BorderRadius.circular(10.r)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bean.title,
                    style: TextStyle(
                        fontSize: 30.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.h),
                Text(bean.subtitle, style: TextStyle(fontSize: 26.sp))
              ],
            )),
            SizedBox(width: 15.w),
            Image.asset("assets/images/ic_arrow_right.png",
                width: 40.w, height: 40.h)
          ],
        ));
  }
}
