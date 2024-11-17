import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android/theme/color.dart';

class ShouldUpdateDialog {
  static void show(BuildContext context,
      {GestureTapCallback? dismissClick, GestureTapCallback? confirmClick}) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Container(
            //限制最大宽度
            constraints: BoxConstraints(maxWidth: 600.w),
            //外观
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            //内容
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                //padding
                Padding(
                    padding: EdgeInsets.only(top: 20.r, bottom: 50.r),
                    child: const Text("检测到新版本，是否跳转下载更新？")),
                //取消和确认按钮
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Expanded(
                      child: GestureDetector(
                          onTap: dismissClick,
                          child: Container(
                              padding: EdgeInsets.only(top: 30.r, bottom: 30.r),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20.r)),
                                  border: Border(
                                      top: BorderSide(
                                          color: grayFFCDCDCD, width: 1.w),
                                      right: BorderSide(
                                          color: grayFFCDCDCD, width: 1.w))),
                              child: Center(
                                  child: Text("取消",
                                      style: TextStyle(
                                          color: grayFF707070,
                                          fontWeight: FontWeight.w500,
                                          //去掉黄线
                                          decoration: TextDecoration.none,
                                          overflow: TextOverflow.ellipsis)))))),
                  Expanded(
                      child: GestureDetector(
                          onTap: confirmClick,
                          child: Container(
                              padding: EdgeInsets.only(top: 30.r, bottom: 30.r),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20.r)),
                                  border: Border(
                                      top: BorderSide(
                                          color: grayFFCDCDCD, width: 1.w))),
                              child: Center(
                                  child: Text("确认",
                                      style: TextStyle(
                                          color: blue87CEFA,
                                          fontWeight: FontWeight.bold,
                                          //去掉黄线
                                          decoration: TextDecoration.none,
                                          overflow: TextOverflow.ellipsis))))))
                ])
              ],
            ),
          ));
        });
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }
}
