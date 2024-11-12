import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SystemStudyPage extends StatefulWidget {
  const SystemStudyPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SystemStudyPageState();
  }
}

class _SystemStudyPageState extends State<SystemStudyPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Text("SystemStudyPage")),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
