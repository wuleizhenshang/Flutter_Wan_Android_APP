import 'package:flutter/cupertino.dart';
import 'package:wan_android_flutter_test/bean/system_list_bean.dart';
import 'package:wan_android_flutter_test/network/Api.dart';

class SystemViewModel extends ChangeNotifier {
  KnowledgeListModel? knowledgeListModel;
  SystemMainListBean systemMainListBean = SystemMainListBean();

  ///获取数据
  Future fetchData() async {
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
    //更新ui
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
