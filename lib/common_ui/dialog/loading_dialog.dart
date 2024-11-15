import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///加载中对话框
///barrierDismissible 是否可以点击遮罩关闭
///barrierColor 遮罩颜色
///isWillPopScope 是否可以点击返回键关闭
///backgroundColor 对话框背景颜色
///radius 对话框圆角
///circularProgressColor 圆形进度条颜色
///text 提示文字
///textStyle 文字样式
class LoadingDialog {
  static void show(BuildContext context,
      {bool barrierDismissible = true,
      Color? barrierColor,
      bool isWillPopScope = true,
      Color backgroundColor = Colors.white,
      double radius = 10,
      Color circularProgressColor = Colors.grey,
      Color textColor = Colors.grey,
      double fontSize = 30,
      String text = "加载中...",
      TextStyle? textStyle}) {
    showDialog(
        context: context,
        // 点击遮罩不关闭
        barrierDismissible: barrierDismissible,
        // 遮罩颜色
        barrierColor: barrierColor ??
            Theme.of(context).dialogTheme.barrierColor ??
            Colors.black54,
        builder: (context) {
          return WillPopScope(
              child: Center(
                  child: Container(
                padding: EdgeInsets.all(50.r),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(radius.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: circularProgressColor),
                    SizedBox(height: 20.h),
                    Flexible(
                      child: Text(
                        text,
                        style: textStyle ??
                            TextStyle(
                                fontSize: fontSize.sp,
                                color: textColor,
                                overflow: TextOverflow.ellipsis,
                                //去掉黄线
                                decoration: TextDecoration.none),
                      ),
                    ),
                  ],
                ),
              )),
              onWillPop: () async => isWillPopScope);
        });
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }
}
