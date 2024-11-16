import 'package:flutter/cupertino.dart';
import 'package:wan_android_flutter_test/bean/system_list_bean.dart';
import 'package:wan_android_flutter_test/network/Api.dart';

class SystemViewModel extends ChangeNotifier {
  KnowledgeListModel? knowledgeListModel;
  SystemMainListBean systemMainListBean = SystemMainListBean();

  //是否在加载
  bool isFirstLoading = true;

  //是否显示回到顶部按钮
  bool showToTopBtn = false;

  ///获取数据
  Future fetchData() async {
    //不用再显示加载,由下拉提示
    //notifyListeners();
    knowledgeListModel = await Api.getInstance().getKnowledgeList();
    knowledgeListModel?.list.forEach((element) {
      //主标题
      String title = element?.name ?? "";
      List<String> subtitleList = [];
      element?.children?.forEach((child) {
        subtitleList.add(child.name ?? "");
      });
      String subtitle = subtitleList.join("  ");
      systemMainListBean.addSystemMainList(SystemMainBean(
          systemMainListBean.systemMainList.length, title, subtitle));
    });
    isFirstLoading = false;
    //更新ui
    notifyListeners();
  }

  ///更新回到顶部的状态
  void updateShowToTopBtn(bool show) {
    showToTopBtn = show;
    notifyListeners();
  }
}

class SystemMainListBean {
  List<SystemMainBean> systemMainList = [];

  void setSystemMainList(List<SystemMainBean> list) {
    systemMainList = list;
  }

  void addSystemMainList(SystemMainBean bean) {
    systemMainList.add(bean);
  }
}

class SystemMainBean {
  //标记点击哪一个
  int id;
  String title;
  String subtitle;

  SystemMainBean(this.id, this.title, this.subtitle);
}
