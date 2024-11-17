import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android/route/route.dart';
import 'package:wan_android/route/route_utils.dart';
import 'package:wan_android/theme/color.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../webview/web_view_page.dart';

class AboutAppPage extends StatefulWidget {
  const AboutAppPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AboutAppPageState();
  }
}

class _AboutAppPageState extends State<AboutAppPage> {
  String _versionName = "";
  String html = '''<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>应用介绍</title>
</head>
<body>
    <h1>应用介绍</h1>
        <p>这是一个用Flutter开发的应用，借助于玩Android网站提供的API进行开发，API具体网址如下：
        <a href="https://www.wanandroid.com" target="_blank">www.wanandroid.com</a>
        </p>
    
    <h2>功能介绍</h2>
    <ul>
        <li>博客浏览、搜索、收藏</li>
        <li>搜索热词、常用网站</li>
        <li>按照体系阅览文章</li>
        <li>登录注册，个人信息</li>
    </ul>

    <h2>源码位置</h2>
    <p>应用的完整源码已开源，欢迎访问 GitHub 仓库查看：</p>
    <a href="https://github.com/wuleizhenshang/Flutter_Wan_Android_APP" target="_blank">点击这里查看源码</a>
</body>
</html>
''';

  @override
  void initState() {
    super.initState();
    //页面加载完再获取版本号
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      getVersion();
    });
  }

  ///获取版本号
  Future getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _versionName = packageInfo.version; // 更新版本号
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text("关于App"),
            centerTitle: true,
            backgroundColor: Colors.white),
        body: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              SizedBox(width: double.infinity, height: 20.h),
              //图标
              ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Image.asset("assets/images/ic_launcher.png",
                    width: 150.r, height: 150.r),
              ),
              //版本号
              SizedBox(height: 10.h),
              Text("v$_versionName",
                  style: TextStyle(
                      fontSize: 30.sp,
                      color: grayFF999999,
                      fontWeight: FontWeight.w500)),
              //介绍
              Html(
                  data: html,
                  onLinkTap: (url, attributes, element) {
                    //webview加载
                    RouteUtils.pushForNamed(context,RoutePath.webViewPage,
                        arguments: {WebViewPage.name: "应用介绍", WebViewPage.url: url});
                  }),
            ])));
  }
}
