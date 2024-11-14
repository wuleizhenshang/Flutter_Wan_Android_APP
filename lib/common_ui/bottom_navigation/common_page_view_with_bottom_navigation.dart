import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android_flutter_test/common_ui/keep_alive/keep_alive_wrapper.dart';

///封装Navigation+PageView，可以左右滑动切换页面，
///但是需要子Widget实现AutomaticKeepAliveClientMixin
///**下面是子Widget的实现，后面优化了不侵入源码，最外层包裹一层就好**
///```dart
///import 'package:flutter/cupertino.dart';
/// import 'package:flutter/material.dart';
///
/// class UserPage extends StatefulWidget {
///   const UserPage({super.key});
///
///   @override
///   State<StatefulWidget> createState() {
///     return _UserPageState();
///   }
/// }
///
/// class _UserPageState extends State<UserPage> with AutomaticKeepAliveClientMixin {
///   @override
///   Widget build(BuildContext context) {
///     return const Scaffold(
///       body: SafeArea(
///         child: Text("UserPage"),
///       ),
///     );
///   }
///
///   @override
///   bool get wantKeepAlive => true;
/// }
///```
///**具体使用**
///```dart
///    return NavigationWithPageViewWidget(pages: const [
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
class NavigationWithPageViewWidget extends StatefulWidget {
  const NavigationWithPageViewWidget(
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
      this.showUnselectedLabels = true});

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

  @override
  State<StatefulWidget> createState() {
    return _NavigationWithPageViewWidgetState();
  }
}

class _NavigationWithPageViewWidgetState
    extends State<NavigationWithPageViewWidget> {
  //pageView的controller
  final PageController _pageController = PageController();

  //选中的tab
  // 使用 ValueNotifier 管理当前选中的索引
  //ValueNotifier配合ValueListenableBuilder可以监听值的变化，当值发生变化时，会自动刷新UI，适用简单的状态管理
  //ChangeNotifierProvider配合Consumer可以监听值的变化，当值发生变化时，会自动刷新UI，适用复杂的状态管理
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

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
      body: PageView(
          controller: _pageController,
          onPageChanged: (index) => _currentIndexNotifier.value = index,
          children: _generateKeepAliveWidgets()),
      //底部导航栏
      bottomNavigationBar: Theme(
          //根据传入的值设置是否有水波纹效果
          data: (widget.isShowRipple)
              ? Theme.of(context)
              : Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent),
          //使用 ValueListenableBuilder 监听当前选中的索引，
          // pageView由PageController控制，底部导航栏由 ValueNotifier 控制
          child: ValueListenableBuilder<int>(
            valueListenable: _currentIndexNotifier,
            builder: (context, index, child) {
              return BottomNavigationBar(
                  backgroundColor: Colors.white,
                  //设置选中和未选中文字颜色
                  selectedLabelStyle:
                      TextStyle(fontSize: widget.selectedTextSize.sp),
                  unselectedLabelStyle:
                      TextStyle(fontSize: widget.unSelectedTextSize.sp),
                  items: _generateBottomNavigationBarItems(),
                  currentIndex: index,
                  onTap: (index) {
                    _pageController.jumpToPage(index);
                    _currentIndexNotifier.value = index;
                  },
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: widget.selectedColor,
                  unselectedItemColor: widget.unSelectedColor,
                  showSelectedLabels: widget.showSelectedLabels,
                  showUnselectedLabels: widget.showUnselectedLabels);
            },
          )),
    );
  }

  ///根据传入的页面生成KeepAlive的Widget
  List<Widget> _generateKeepAliveWidgets() {
    List<Widget> keepAliveWidgets = [];
    for (int i = 0; i < widget.pages.length; i++) {
      keepAliveWidgets.add(KeepAliveWrapper(child: widget.pages[i]));
    }
    return keepAliveWidgets;
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
