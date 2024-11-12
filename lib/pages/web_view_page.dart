import 'package:flutter/material.dart';
import 'package:wan_android_flutter_test/route/RouteUtils.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  String? name;
  String? url;

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
          //更新页面
          _controller.loadRequest(Uri.parse(url ?? ""));
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
          appBar: AppBar(
            title: Text(name ?? ""),
            //自定义返回键，点击直接返回界面，绕过检查
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  //返回
                  RouteUtils.pop(context);
                }),
          ),
          body: SafeArea(
              child: Container(child: WebViewWidget(controller: _controller))),
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
