import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/route/route_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../theme/color.dart';

class WebViewPage extends StatefulWidget {
  static const String name = "name";
  static const String url = "url";

  const WebViewPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage> {
  //标题
  String? name;

  //url
  String? url;

  //加载状态
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);

  //webview控制器
  final WebViewController _controller = WebViewController();

  @override
  void initState() {
    super.initState();

    //state的生命周期函数，当页面创建时调用，在build方法之前调用
    //这里需要在页面创建时获取传递过来的参数，使用WidgetsBinding.instance.addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //获取传递过来的参数
      var map = ModalRoute.of(context)?.settings.arguments;
      if (map is Map) {
        name = map[WebViewPage.name];
        url = map[WebViewPage.url];
        //获取后刷新界面，一开始为空
        setState(() {
          _controller
            ..setJavaScriptMode(JavaScriptMode
                .unrestricted) //setJavaScriptMode是WebViewController的方法，设置JavaScript模式
            ..setNavigationDelegate(NavigationDelegate(
              onPageStarted: (url) {
                //页面开始加载
                _isLoading.value = true;
              },
              onPageFinished: (url) {
                //页面加载完成
                _isLoading.value = false;
              },
            )) //setNavigationDelegate是WebViewController的方法，设置导航代理
            ..loadRequest(
                Uri.parse(url ?? "")); //loadRequest是WebViewController的方法，加载url
        });
      }
    });
  }

  //有状态组件
  @override
  Widget build(BuildContext context) {
    //PopScope是一个用于监听返回键的组件，当用户点击返回键时，会调用onWillPop方法
    return WillPopScope(
        child: Scaffold(
          backgroundColor: blue87CEFA,
          appBar: AppBar(
            titleSpacing: 0,
            backgroundColor: blue87CEFA,
            title: Text(name ?? ""),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: blue87CEFA,
              statusBarIconBrightness: Brightness.light,
            ),
            //自定义返回键，点击直接返回界面，绕过检查
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  //返回
                  RouteUtils.pop(context);
                }),
          ),
          body: SafeArea(
              //加载对话框和WebView在一个stack中，重叠显示，webView渲染一次，后面渲染对话框就行
              child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              ValueListenableBuilder(
                  valueListenable: _isLoading,
                  builder: (context, value, child) {
                    return value
                        ? Center(
                            child: CircularProgressIndicator(color: blue87CEFA))
                        : const SizedBox.shrink(); // 使用空的 SizedBox 替代
                  })
            ],
          )),
        ),
        //返回拦截，返回栈有东西就返回栈返回，没有东西才让系统处理返回
        onWillPop: () async {
          if (await _controller.canGoBack()) {
            _controller.goBack();
            return false;
          } else {
            return true;
          }
        });
  }
}
