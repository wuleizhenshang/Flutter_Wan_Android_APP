import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wan_android_flutter_test/common_ui/bottom_navigation/common_index_stack_with_bottom_navigation.dart';
import 'package:wan_android_flutter_test/common_ui/bottom_navigation/common_page_view_with_bottom_navigation.dart';
import 'package:wan_android_flutter_test/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android_flutter_test/pages/home/home_page.dart';
import 'package:wan_android_flutter_test/pages/hot_point/hot_point_page.dart';
import 'package:wan_android_flutter_test/pages/system/system_study_page.dart';
import 'package:wan_android_flutter_test/pages/user/user_message_page.dart';
import 'package:wan_android_flutter_test/theme/color.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TabPageState();
  }
}

class _TabPageState extends State<TabPage> {

  @override
  Widget build(BuildContext context) {
    // return NavigationWithIndexStackWidget(pages: const [
    //   HomePage(),
    //   HotPointPage(),
    //   SystemStudyPage(),
    //   UserPage()
    // ], unSelectedIcons: [
    //   Image.asset("assets/images/ic_tab_home_normal.png",
    //       width: 40.w, height: 40.h),
    //   Image.asset("assets/images/ic_tab_hot_normal.png",
    //       width: 40.w, height: 40.h),
    //   Image.asset("assets/images/ic_tab_system_normal.png",
    //       width: 40.w, height: 40.h),
    //   Image.asset("assets/images/ic_tab_user_normal.png",
    //       width: 40.w, height: 40.h)
    // ], selectedIcons: [
    //   Image.asset("assets/images/ic_tab_home_selected.png",
    //       width: 40.w, height: 40.h),
    //   Image.asset("assets/images/ic_tab_hot_selected.png",
    //       width: 40.w, height: 40.h),
    //   Image.asset("assets/images/ic_tab_system_selected.png",
    //       width: 40.w, height: 40.h),
    //   Image.asset("assets/images/ic_tab_user_selected.png",
    //       width: 40.w, height: 40.h)
    // ], bottomNavigationBarItemsText: const [
    //   "首页",
    //   "热点",
    //   "体系",
    //   "我的"
    // ], unSelectedColor: grayFFCDCDCD, selectedColor: blue87CEFA);
    return NavigationWithPageViewWidget(pages: const [
      HomePage(),
      HotPointPage(),
      SystemStudyPage(),
      UserPage()
    ], unSelectedIcons: [
      Image.asset("assets/images/ic_tab_home_normal.png",
          width: 40.w, height: 40.h),
      Image.asset("assets/images/ic_tab_hot_normal.png",
          width: 40.w, height: 40.h),
      Image.asset("assets/images/ic_tab_system_normal.png",
          width: 40.w, height: 40.h),
      Image.asset("assets/images/ic_tab_user_normal.png",
          width: 40.w, height: 40.h)
    ], selectedIcons: [
      Image.asset("assets/images/ic_tab_home_selected.png",
          width: 40.w, height: 40.h),
      Image.asset("assets/images/ic_tab_hot_selected.png",
          width: 40.w, height: 40.h),
      Image.asset("assets/images/ic_tab_system_selected.png",
          width: 40.w, height: 40.h),
      Image.asset("assets/images/ic_tab_user_selected.png",
          width: 40.w, height: 40.h)
    ], bottomNavigationBarItemsText: const [
      "首页",
      "热点",
      "体系",
      "我的"
    ], unSelectedColor: grayFFCDCDCD, selectedColor: blue87CEFA,
    onIndexChanged: (index) {
      // //下标变化，切换状态栏
      // if(index == 0) {
      //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      //     statusBarColor: Colors.white,
      //     statusBarIconBrightness: Brightness.dark,
      //   ));
      // }else if(index ==1){
      //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //     statusBarColor: grayFFF5F5F5,
      //     statusBarIconBrightness: Brightness.dark,
      //   ));
      // }else if(index ==2){
      //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      //     statusBarColor: Colors.white,
      //     statusBarIconBrightness: Brightness.dark,
      //   ));
      // }else if(index ==3){
      //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //     statusBarColor: blue87CEFA,
      //     statusBarIconBrightness: Brightness.dark,
      //   ));
      // }
    });
  }
}
