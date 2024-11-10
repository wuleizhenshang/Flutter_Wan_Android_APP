import 'package:flutter/material.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage> {
  String? name;

  @override
  void initState() {
    super.initState();
    //state的生命周期函数，当页面创建时调用，在build方法之前调用
    //这里需要在页面创建时获取传递过来的参数，使用WidgetsBinding.instance.addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //获取传递过来的参数
      var map = ModalRoute.of(context)?.settings.arguments;
      if (map is Map) {
        name = map["name"];
        //获取后刷新界面，一开始为空
        setState(() {
          //更新页面
        });
      }
    });
  }

  //有状态组件
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name ?? ""),
      ),
      body: SafeArea(
          child: Container(
        child: GestureDetector(
            onTap: () {
              //弹出就是手动回退
              Navigator.pop(context);
            },
            child: const Text('手动回退')),
      )),
    );
  }
}
