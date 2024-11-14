import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter_test/common_ui/dialog/loading_dialog.dart';
import 'package:wan_android_flutter_test/pages/register/register_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wan_android_flutter_test/route/RouteUtils.dart';

import '../../common_ui/input_field/input_field_with_icon_cancel_ui.dart';
import '../../theme/color.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterViewModel viewModel = RegisterViewModel();

  //控制器
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 设置状态栏颜色为白色
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // 设置状态栏颜色为白色
      statusBarIconBrightness: Brightness.dark, // 设置状态栏图标为深色，适应白色背景
    ));
    // 监听输入框变化
    _userNameController.addListener(() {
      viewModel.setUsername(_userNameController.text);
    });
    _passwordController.addListener(() {
      viewModel.setPassword(_passwordController.text);
    });
    _rePasswordController.addListener(() {
      viewModel.setRepassword(_rePasswordController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          return viewModel;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("注册"),
            backgroundColor: Colors.white, // 设置AppBar背景为白色
            elevation: 0, // 设置AppBar下方的阴影为无
            //iconTheme: IconThemeData(color: Colors.black), // 设置AppBar图标颜色为黑色
          ),
          body: Container(
              color: grayFFF9F9F9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 130.h),
                  Container(color: grayFFCDCDCD, height: 1.r),
                  //账号输入框
                  Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: InputFieldWithStartIconAndCancelIconWidget(
                        tint: "请输入账号",
                        unSelectedIcon: Image.asset(
                            "assets/images/ic_input_username_un_focus.png",
                            width: 40.w,
                            height: 40.h),
                        selectedIcon: Image.asset(
                            "assets/images/ic_input_username_focus.png",
                            width: 40.w,
                            height: 40.h),
                        cancelIcon: Image.asset("assets/images/ic_cancel.png",
                            width: 40.w, height: 40.h),
                        controller: _userNameController,
                        inputFormatters: [
                          InputFieldWithStartIconAndCancelIconWidget
                              .limitOnlyNumberAndLetter()
                        ],
                      )),
                  Container(color: grayFFCDCDCD, height: 1.r),
                  //密码输入框
                  Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: InputFieldWithStartIconAndCancelIconWidget(
                        tint: "请输入密码",
                        unSelectedIcon: Image.asset(
                            "assets/images/ic_input_password_un_focus.png",
                            width: 40.w,
                            height: 40.h),
                        selectedIcon: Image.asset(
                            "assets/images/ic_input_password_focus.png",
                            width: 40.w,
                            height: 40.h),
                        cancelIcon: Image.asset("assets/images/ic_cancel.png",
                            width: 40.w, height: 40.h),
                        controller: _passwordController,
                        obscureText: true,
                        inputFormatters: [
                          InputFieldWithStartIconAndCancelIconWidget
                              .limitOnlyNumberAndLetter()
                        ],
                      )),
                  Container(color: grayFFCDCDCD, height: 1.r),
                  //再次输入密码输入框
                  Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: InputFieldWithStartIconAndCancelIconWidget(
                        tint: "请再次输入密码",
                        unSelectedIcon: Image.asset(
                            "assets/images/ic_input_repassword_un_focus.png",
                            width: 40.w,
                            height: 40.h),
                        selectedIcon: Image.asset(
                            "assets/images/ic_input_repassword_focus.png",
                            width: 40.w,
                            height: 40.h),
                        cancelIcon: Image.asset("assets/images/ic_cancel.png",
                            width: 40.w, height: 40.h),
                        controller: _rePasswordController,
                        obscureText: true,
                        inputFormatters: [
                          InputFieldWithStartIconAndCancelIconWidget
                              .limitOnlyNumberAndLetter()
                        ],
                      )),
                  Container(color: grayFFCDCDCD, height: 1.r),
                  SizedBox(height: 40.h),
                  //注册和登录按钮
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: _registerButton(onPressed: () {
                        //显示加载框
                        LoadingDialog.show(context,
                            barrierDismissible: false, isWillPopScope: false);

                        //注册
                        viewModel.register().then((value) {
                          if (value) {
                            LoadingDialog.dismiss(context);
                            Fluttertoast.showToast(msg: "注册成功,请登录");
                            RouteUtils.pop(context);
                          } else {
                            //隐藏加载框
                            LoadingDialog.dismiss(context);
                          }
                        });
                      }))
                ],
              )),
        ));
  }

  ///注册按钮
  Widget _registerButton({VoidCallback? onPressed}) {
    return Consumer<RegisterViewModel>(builder: (context, viewModel, child) {
      return InkWell(
        onTap: viewModel.username.isNotEmpty &&
                viewModel.password.isNotEmpty &&
                viewModel.repassword.isNotEmpty
            ? () {
                onPressed?.call();
              }
            : null,
        child: Container(
          //加圆角,不能同时指定decoration和color
          decoration: BoxDecoration(
            color: viewModel.username.isNotEmpty &&
                    viewModel.password.isNotEmpty &&
                    viewModel.repassword.isNotEmpty
                ? blue87CEFA
                : blue6687CEFA, // 背景颜色
            borderRadius: BorderRadius.circular(12.r), // 设置圆角半径
          ),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 25.h),
          child: Center(
              child: Text("注册",
                  style: TextStyle(
                      fontSize: 30.sp,
                      color: viewModel.username.isNotEmpty &&
                              viewModel.password.isNotEmpty
                          ? Colors.white
                          : white66FFFFFF))),
        ),
      );
    });
  }
}
