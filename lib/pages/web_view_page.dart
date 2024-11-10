import 'package:flutter/material.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView'),
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
