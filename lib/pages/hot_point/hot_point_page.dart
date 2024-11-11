import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HotPointPage extends StatefulWidget {
  const HotPointPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HotPointPageState();
  }
}

class _HotPointPageState extends State<HotPointPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child:
              Text("HotPointPage")),
    );
  }
}
