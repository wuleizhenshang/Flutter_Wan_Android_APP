import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter_test/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android_flutter_test/pages/home/home_page.dart';
import 'package:wan_android_flutter_test/pages/hot_point/hot_point_page.dart';
import 'package:wan_android_flutter_test/pages/system/system_study_page.dart';
import 'package:wan_android_flutter_test/pages/user/user_page.dart';
import 'package:wan_android_flutter_test/theme/color.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TabPageState();
  }
}

class _TabPageState extends State<TabPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child:
              //IndexedStack是类似帧布局的组件，可以让多个子组件堆叠在一起，通过index来控制显示哪个子组件
              IndexedStack(children: [
        HomePage(),
        HotPointPage(),
        SystemStudyPage(),
        UserPage()
      ], index: _currentIndex)),
      //底部导航栏
      bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              //设置底部导航栏的主题，去掉点击水波纹效果
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent),
          child: BottomNavigationBar(
              //设置选中和未选中文字颜色
              selectedLabelStyle: TextStyle(fontSize: 26.sp, color: blue87CEFA),
              unselectedLabelStyle:
                  TextStyle(fontSize: 26.sp, color: grayFFCDCDCD),
              //设置tab选中固定
              type: BottomNavigationBarType.fixed,
              //设置图标和文字颜色
              selectedItemColor: blue87CEFA,
              unselectedItemColor: grayFFCDCDCD,
              items: _bottomNavigationBarItems,
              onTap: (index) {
                //点击切换界面
                setState(() {
                  _currentIndex = index;
                });
              },
              currentIndex: _currentIndex)),
    );
  }

  ///底部导航栏的item
  List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    BottomNavigationBarItem(
      icon: Image.asset("assets/images/ic_tab_home_normal.png",
          width: 40.r, height: 40.r),
      activeIcon: Image.asset("assets/images/ic_tab_home_selected.png",
          width: 40.r, height: 40.r),
      label: "首页",
    ),
    BottomNavigationBarItem(
      icon: Image.asset("assets/images/ic_tab_hot_normal.png",
          width: 40.r, height: 40.r),
      activeIcon: Image.asset("assets/images/ic_tab_hot_selected.png",
          width: 40.r, height: 40.r),
      label: "分类",
    ),
    BottomNavigationBarItem(
      icon: Image.asset("assets/images/ic_tab_system_normal.png",
          width: 40.r, height: 40.r),
      activeIcon: Image.asset("assets/images/ic_tab_system_selected.png",
          width: 40.r, height: 40.r),
      label: "消息",
    ),
    BottomNavigationBarItem(
      icon: Image.asset("assets/images/ic_tab_user_normal.png",
          width: 40.r, height: 40.r),
      activeIcon: Image.asset("assets/images/ic_tab_user_selected.png",
          width: 40.r, height: 40.r),
      label: "我的",
    ),
  ];
}
