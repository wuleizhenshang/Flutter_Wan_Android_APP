import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///封装Navigation+IndexStack，对页面Widget没有要求，就是没有左右滑动手势
///**具体使用**
///```dart
///    return NavigationWithIndexStackWidget(pages: const [
///       HomePage(),
///       HotPointPage(),
///       SystemStudyPage(),
///       UserPage()
///     ], unSelectedIcons: [
///       Image.asset("assets/images/ic_tab_home_normal.png",
///           width: 40.w, height: 40.h),
///       Image.asset("assets/images/ic_tab_hot_normal.png",
///           width: 40.w, height: 40.h),
///       Image.asset("assets/images/ic_tab_system_normal.png",
///           width: 40.w, height: 40.h),
///       Image.asset("assets/images/ic_tab_user_normal.png",
///           width: 40.w, height: 40.h)
///     ], selectedIcons: [
///       Image.asset("assets/images/ic_tab_home_selected.png",
///           width: 40.w, height: 40.h),
///       Image.asset("assets/images/ic_tab_hot_selected.png",
///           width: 40.w, height: 40.h),
///       Image.asset("assets/images/ic_tab_system_selected.png",
///           width: 40.w, height: 40.h),
///       Image.asset("assets/images/ic_tab_user_selected.png",
///           width: 40.w, height: 40.h)
///     ], bottomNavigationBarItemsText: const [
///       "首页",
///       "热点",
///       "体系",
///       "我的"
///     ], unSelectedColor: grayFFCDCDCD, selectedColor: blue87CEFA);
///```
class NavigationWithIndexStackWidget extends StatefulWidget {
  const NavigationWithIndexStackWidget(
      {super.key,
      required this.pages,
      required this.unSelectedIcons,
      required this.selectedIcons,
      required this.bottomNavigationBarItemsText,
      this.isShowRipple = false,
      this.unSelectedTextSize = 26,
      this.selectedTextSize = 26,
      this.unSelectedColor = Colors.grey,
      this.selectedColor = Colors.blue,
      this.showSelectedLabels = true,
      this.showUnselectedLabels = true,
      this.onIndexChanged});

  //具体页面
  final List<Widget> pages;

  //未选中的图标
  final List<Widget> unSelectedIcons;

  //选中的图标
  final List<Widget> selectedIcons;

  //底部导航栏的文字
  final List<String> bottomNavigationBarItemsText;

  //是否显示水波纹
  final bool isShowRipple;

  //文字未选中大小
  final double unSelectedTextSize;

  //文字选中大小
  final double selectedTextSize;

  //未选中颜色
  final Color unSelectedColor;

  //选中颜色
  final Color selectedColor;

  //是否显示选中的标签
  final bool showSelectedLabels;

  //是否显示未选中的标签
  final bool showUnselectedLabels;

  //页面索引
  final ValueChanged<int>? onIndexChanged;

  @override
  State<StatefulWidget> createState() {
    return _NavigationWithIndexStackWidgetState();
  }
}

class _NavigationWithIndexStackWidgetState
    extends State<NavigationWithIndexStackWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    //看传入的页面数量是否和底部导航栏的数量一致，不一致则抛出异常
    if (widget.pages.length != widget.bottomNavigationBarItemsText.length ||
        widget.pages.length != widget.unSelectedIcons.length ||
        widget.pages.length != widget.selectedIcons.length) {
      throw Exception("页面数量和底部导航栏的数量不一致");
    }
    if (widget.pages.isEmpty ||
        widget.bottomNavigationBarItemsText.isEmpty ||
        widget.unSelectedIcons.isEmpty ||
        widget.selectedIcons.isEmpty) {
      throw Exception("页面数量和底部导航栏数量不能为0");
    }
    return Scaffold(
      body: SafeArea(
          child:
              //IndexedStack是类似帧布局的组件，可以让多个子组件堆叠在一起，通过index来控制显示哪个子组件
              IndexedStack(index: _currentIndex, children: widget.pages)),
      bottomNavigationBar: Theme(
          //根据传入的值设置是否有水波纹效果
          data: (widget.isShowRipple)
              ? Theme.of(context)
              : Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent),
          child: BottomNavigationBar(
              //设置选中和未选中文字颜色
              selectedLabelStyle:
                  TextStyle(fontSize: widget.selectedTextSize.sp),
              unselectedLabelStyle:
                  TextStyle(fontSize: widget.unSelectedTextSize.sp),
              //设置tab选中固定
              type: BottomNavigationBarType.fixed,
              //设置图标和文字颜色
              selectedItemColor: widget.selectedColor,
              unselectedItemColor: widget.unSelectedColor,
              showSelectedLabels: widget.showSelectedLabels,
              showUnselectedLabels: widget.showUnselectedLabels,
              items: _generateBottomNavigationBarItems(),
              onTap: (index) {
                //点击切换界面
                setState(() {
                  _currentIndex = index;
                  widget.onIndexChanged?.call(index);
                });
              },
              currentIndex: _currentIndex)),
    );
  }

  ///根据传入的值生成底部导航栏的item
  List<BottomNavigationBarItem> _generateBottomNavigationBarItems() {
    List<BottomNavigationBarItem> items = [];
    for (int i = 0; i < widget.bottomNavigationBarItemsText.length; i++) {
      items.add(BottomNavigationBarItem(
        icon: widget.unSelectedIcons[i],
        activeIcon: widget.selectedIcons[i],
        label: widget.bottomNavigationBarItemsText[i],
      ));
    }
    return items;
  }
}
