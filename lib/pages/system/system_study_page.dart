import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter_test/pages/system/system_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android_flutter_test/theme/color.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class SystemStudyPage extends StatefulWidget {
  const SystemStudyPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SystemStudyPageState();
  }
}

class _SystemStudyPageState extends State<SystemStudyPage> {
  SystemViewModel viewModel = SystemViewModel();
  final EasyRefreshController _controller = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    viewModel.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SystemViewModel>(
        create: (context) {
          return viewModel;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              child: Consumer<SystemViewModel>(builder: (context, vm, child) {
            return EasyRefresh(
                controller: _controller,
                //刷新
                onRefresh: () async {
                  viewModel.fetchData().then((value) {
                    _controller.finishRefresh();
                  });
                },
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return _singleSystemMainListUi(
                          viewModel.systemMainListBean.systemMainList[index]);
                    },
                    itemCount:
                        viewModel.systemMainListBean.systemMainList.length));
          })),
        ));
  }

  ///单个体系主列表UI
  Widget _singleSystemMainListUi(SystemMainBean bean) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
            border: Border.all(color: grayFF999999, width: 1.w),
            borderRadius: BorderRadius.circular(10.r)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bean.title, style: TextStyle(fontSize: 30.sp)),
                SizedBox(height: 10.h),
                Text(bean.subtitle, style: TextStyle(fontSize: 26.sp))
              ],
            )),
            SizedBox(width: 15.w),
            Image.asset("assets/images/ic_arrow_right.png",
                width: 40.w, height: 40.h)
          ],
        ));
  }
}
