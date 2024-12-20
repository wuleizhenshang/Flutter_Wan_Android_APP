import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:wan_android/common_ui/dialog/dialog_factory.dart';
import 'package:wan_android/common_ui/dialog/loading_dialog.dart';
import 'package:wan_android/common_ui/dialog/should_update_app_dialog.dart';
import 'package:wan_android/network/request/pgy/pgy.dart';
import '../webview/web_view_page.dart';
import '/common_ui/bottom_navigation/common_index_stack_with_bottom_navigation.dart';
import '/common_ui/cache_network_image/cache_network_image.dart';
import '/pages/main_tab/tab_page.dart';
import '/pages/user/user_message_view_model.dart';
import '/route/route.dart';
import '/route/route_utils.dart';
import '/theme/color.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../memory/sp/sp_key_constant.dart';
import '../../memory/sp/sp_utils.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage> {
  UserMessageViewModel viewModel = UserMessageViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.isLogin();
    viewModel.getUserMessage();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: blue87CEFA,
            statusBarIconBrightness: Brightness.light),
        child: ChangeNotifierProvider(
            create: (context) {
              return viewModel;
            },
            child: Scaffold(
                extendBodyBehindAppBar: true,
                body: SafeArea(
                  child: Container(
                      color: grayFFF5F5F5,
                      child: Column(
                          children: [_userMessageUi(), _selectOptionUi()])),
                ))));
  }

  ///用户信息
  Widget _userMessageUi() {
    return Consumer<UserMessageViewModel>(builder: (context, vm, child) {
      return Container(
          color: blue87CEFA,
          child: Column(
            children: [
              SizedBox(height: 35.h),
              GestureDetector(
                  onTap: () {
                    //未登录就跳转登录界面
                    viewModel.isLogin().then((value) async {
                      if (!value) {
                        // Navigator.pushNamed(
                        //     context, RoutePath.loginPage);
                        //可以拿到返回值，看是否登录成功
                        bool isLoginSuccess = await RouteUtils.pushForNamed(
                            RouteUtils.context, RoutePath.loginPage);
                        if (isLoginSuccess) {
                          // 登录成功，刷新用户信息
                          viewModel.getUserMessage();
                          RouteUtils.pushAndRemoveUntil(
                              RouteUtils.context, const TabPage());
                        }
                      }
                    });
                  },
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 20.w),
                        //头像
                        CustomCacheNetworkImage(
                            imageUrl: vm.userMessage.userIconLink,
                            width: 150,
                            height: 150,
                            radius: 75,
                            errorWidget: Image.asset(
                                "assets/images/ic_head_picture_default.png",
                                fit: BoxFit.cover)),
                        SizedBox(width: 20.w),
                        //昵称、积分数量、等级
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //昵称
                              Text(vm.userMessage.nickname,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 35.sp,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 15.h),
                              Row(children: [
                                Text("积分：${vm.userMessage.coinCount}",
                                    style: TextStyle(
                                        color: grayFFF5F5F5, fontSize: 25.sp)),
                                SizedBox(width: 20.w),
                                Text("等级：${vm.userMessage.userLevel}",
                                    style: TextStyle(
                                        color: grayFFF5F5F5, fontSize: 25.sp)),
                              ])
                            ])
                      ])),
              SizedBox(height: 35.h)
            ],
          ));
    });
  }

  ///选项集合
  Widget _selectOptionUi() {
    return Column(
      children: [
        _singleOptionUi("我的收藏", () {
          //未登录就跳转登录界面，登录成功跳转收藏页面
          viewModel.isLogin().then((value) async {
            if (!value) {
              bool isLoginSuccess = await RouteUtils.pushForNamed(
                  RouteUtils.context, RoutePath.loginPage);
              if (isLoginSuccess) {
                // 登录成功，刷新用户信息
                viewModel.getUserMessage();
                RouteUtils.pushAndRemoveUntil(
                    RouteUtils.context, const TabPage());
              }
            } else {
              RouteUtils.pushForNamed(
                  RouteUtils.context, RoutePath.myCollectPage);
            }
          });
        }),
        Container(width: double.infinity, height: 1, color: grayFFCDCDCD),
        _singleOptionUi("热门壁纸（Drift数据库框架实现）", () {
          RouteUtils.pushForNamed(context, RoutePath.hotWallpaperPage);
        }),
        SizedBox(height: 30.h),
        _singleOptionUi("关于App", () {
          RouteUtils.pushForNamed(context, RoutePath.aboutAppPage);
        }),
        Container(width: double.infinity, height: 1, color: grayFFCDCDCD),
        _singleOptionUi("关于开发者", () {
          //跳到个人博客
          RouteUtils.pushForNamed(context, RoutePath.webViewPage, arguments: {
            WebViewPage.name: "无泪真伤",
            WebViewPage.url: "https://wuleizhenshang.github.io"
          });
        }),
        Container(width: double.infinity, height: 1, color: grayFFCDCDCD),
        _singleOptionUi("检查更新", () {
          //检查更新
          LoadingDialog.show(context);
          PgyDio.getInstance().checkUpdate().then((value) {
            viewModel.checkUpdate().then((value) {
              LoadingDialog.dismiss(context);

              //不为空并且有更新
              if (value != null && value.isNotEmpty) {
                // DialogFactory.instance.showNeedUpdateDialog(
                //     context: context,
                //     //点击取消
                //     dismissClick: () {
                //       //不更新，显示小红点
                //     },
                //     //点击确认
                //     confirmClick: () {
                //       viewModel.jumpToOutLink(value);
                //     });
                ShouldUpdateDialog.show(context, dismissClick: () {
                  ShouldUpdateDialog.dismiss(context);
                }, confirmClick: () {
                  viewModel.jumpToOutLink(value).then((value) {
                    ShouldUpdateDialog.dismiss(context);
                  });
                });
              } else {
                Fluttertoast.showToast(msg: "已经是最新版本");
              }
            });
          });
        }),
        SizedBox(height: 30.h),
        _logoutButton(() {
          //退出登录
          viewModel.logout().then((value) {
            //退出登录弹出栈重新加载整个页面，以刷新列表的状态
            RouteUtils.pushAndRemoveUntil(RouteUtils.context, const TabPage());
          });
        })
      ],
    );
  }

  ///退出登录按钮
  Widget _logoutButton(VoidCallback onPressed) {
    return Consumer<UserMessageViewModel>(builder: (context, viewModel, child) {
      return viewModel.isLoginSuccess
          ? InkWell(
              splashColor: gray60CDCDCD,
              onTap: () {
                onPressed.call();
              },
              child: Container(
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.only(top: 25.h, bottom: 25.h),
                child: Center(
                    child: Text("退出登录",
                        style: TextStyle(
                            fontSize: 30.sp, fontWeight: FontWeight.w600))),
              ),
            )
          : const SizedBox.shrink();
    });
  }

  ///单个选项
  Widget _singleOptionUi(String text, VoidCallback onTap) {
    return InkWell(
        splashColor: gray60CDCDCD,
        onTap: () {
          onTap.call();
        },
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(25.r),
            child: Row(
              children: [
                Text(text),
                SizedBox(width: 20.w),
                const Expanded(child: SizedBox()),
                Image.asset("assets/images/ic_arrow_right.png",
                    width: 30.w, height: 30.h),
              ],
            )));
  }
}
