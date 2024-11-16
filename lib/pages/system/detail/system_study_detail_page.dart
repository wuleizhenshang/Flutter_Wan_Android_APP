import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter_test/pages/system/show_list/system_study_detail_show_list_page.dart';
import 'package:wan_android_flutter_test/theme/color.dart';

import '../../../common_ui/keep_alive/keep_alive_wrapper.dart';
import '../home/system_study_view_model.dart';

class SystemStudyDetailPage extends StatefulWidget {
  const SystemStudyDetailPage({super.key, this.systemMainBean, this.index});

  final SystemMainBean? systemMainBean;
  final int? index;

  @override
  State<StatefulWidget> createState() {
    return _SystemStudyDetailPageState();
  }
}

class _SystemStudyDetailPageState extends State<SystemStudyDetailPage>
    with SingleTickerProviderStateMixin {
  //tab列表
  final List<Tab> tabs = [];

  //tab控制器
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    if (widget.systemMainBean != null) {
      for (int i = 0; i < widget.systemMainBean!.subtitleList.length; i++) {
        tabs.add(Tab(text: widget.systemMainBean!.subtitleList[i]));
      }
    }
    tabController = TabController(
        initialIndex: widget.index ?? 0, length: tabs.length, vsync: this);
  }

  ///TabBar+TabBarView
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.systemMainBean?.title ?? ""),
        //AppBar下面显示TabBar，显示tab列表
        bottom: TabBar(
          tabs: tabs,
          controller: tabController,
          //是否可以滚动
          isScrollable: true,
          //偏左，避免可滚动中间偏大
          tabAlignment: TabAlignment.start,
          //指示器
          indicatorColor: blue87CEFA,
          //选中文字颜色
          labelColor: blue87CEFA,
          //未选中文字颜色
          unselectedLabelColor: grayFF999999,
        ),
      ),
      //body为TabBarView，用于展示TabBar对应的内容
      body: TabBarView(
        controller: tabController,
        children: List.generate(tabs.length, (index) {
          return KeepAliveWrapper(
              child: SystemStudyDetailShowListPage(
            id: widget.systemMainBean?.idList[index] ?? -1,
          ));
        }),
      ),
    );
  }
}
