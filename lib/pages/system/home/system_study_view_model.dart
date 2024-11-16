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
    if(knowledgeListModel != null){
      for(int i = 0; i < knowledgeListModel!.list.length; i++){
        //主标题
        String title = knowledgeListModel!.list[i]?.name ?? "";
        List<String> subtitleList = [];
        List<int> idList = [];
        knowledgeListModel!.list[i]?.children?.forEach((child) {
          subtitleList.add(child.name ?? "");
          //-1的话id有问题
          idList.add(child.id as int? ?? -1);
        });
        //String subtitle = subtitleList.join("  ");
        systemMainListBean.addSystemMainList(SystemMainBean(
            i,
            title,
            subtitleList,
            idList));
      }
    }
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
  List<String> subtitleList;
  List<int> idList;

  SystemMainBean(this.id, this.title, this.subtitleList, this.idList);
}
