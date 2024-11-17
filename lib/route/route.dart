//封装Route
import 'package:flutter/material.dart';

import '../pages/about_app/about_app_page.dart';
import '../pages/login/login_page.dart';
import '../pages/main_tab/tab_page.dart';
import '../pages/my_collect/my_collect_page.dart';
import '../pages/register/register_page.dart';
import '../pages/search/search_page.dart';
import '../pages/system/detail/system_study_detail_page.dart';
import '../pages/webview/web_view_page.dart';

//路由地址
class RoutePath {
  //定义所有路由地址

  //首页
  static const String mainTab = "/";

  //webView页面
  static const String webViewPage = "/web_view_page";

  //登录页面
  static const String loginPage = "/login_page";

  //注册页面
  static const String registerPage = "/register_page";

  //我的收藏界面
  static const String myCollectPage = "/collect_page";

  //体系学习详情页面
  static const String systemStudyDetailPage = "/system_study_detail_page";

  //搜索页面
  static const String searchPage = "/search_page";

  //关于App页面
  static const String aboutAppPage = "/about_app_page";
}

//路由管理类
class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.mainTab:
        //使用{}定义函数体，需要显氏return，如果要其他操作用{}，不然用=>即可
        return MaterialPageRoute(builder: (context) {
          return const TabPage();
        });
      case RoutePath.webViewPage:
        return pageRoute(const WebViewPage(), settings: settings);
      case RoutePath.loginPage:
        return pageRoute(const LoginPage(), settings: settings);
      case RoutePath.registerPage:
        return pageRoute(const RegisterPage(), settings: settings);
      case RoutePath.myCollectPage:
        return pageRoute(const MyCollectPage(), settings: settings);
      case RoutePath.systemStudyDetailPage:
        return pageRoute(const SystemStudyDetailPage(), settings: settings);
      case RoutePath.searchPage:
        return pageRoute(const SearchPage(), settings: settings);
      case RoutePath.aboutAppPage:
        return pageRoute(const AboutAppPage(), settings: settings);
      default:
      //使用 =>（也叫 "fat arrow"） 是 Dart 中的简写语法，适用于只有一行表达式的函数。
      //return MaterialPageRoute(builder: (context) => const HomePage());
    }
    //如果没有匹配到，返回一个空页面
    return pageRoute(Scaffold(
        body: SafeArea(child: Center(child: Text("路由：${settings.name} 不存在")))));
  }

  //包装一下，返回MaterialPageRoute，不用每次都写MaterialPageRoute
  static MaterialPageRoute pageRoute(Widget page,
      {
      //常用为page和settings，settings传递参数
      RouteSettings? settings,
      bool? fullscreenDialog,
      bool? maintainState,
      bool? allowSnapshotting}) {
    return MaterialPageRoute(
        builder: (context) => page,
        settings: settings,
        fullscreenDialog: fullscreenDialog ?? false,
        maintainState: maintainState ?? true,
        allowSnapshotting: allowSnapshotting ?? true);
  }
}
