import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android_flutter_test/common_ui/input_field/input_field_with_icon_cancel_ui.dart';
import 'package:wan_android_flutter_test/pages/login/login_view_model.dart';
import 'package:wan_android_flutter_test/theme/color.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  LoginViewModel viewModel = LoginViewModel();

  //控制器
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
      viewModel.setUserName(_userNameController.text);
    });
    _passwordController.addListener(() {
      viewModel.setPassword(_passwordController.text);
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
            title: const Text("登录"),
            backgroundColor: Colors.white, // 设置AppBar背景为白色
            elevation: 0, // 设置AppBar下方的阴影为无
            //iconTheme: IconThemeData(color: Colors.black), // 设置AppBar图标颜色为黑色
          ),
          body: Container(
              color: grayFFF9F9F9,
              child: Column(
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
                  SizedBox(height: 40.h),
                  //注册和登录按钮
                  Row(
                    children: [
                      SizedBox(width: 20.w),
                      Expanded(child: _registerButton(() {
                        Fluttertoast.showToast(msg: "注册");
                      })),
                      SizedBox(width: 20.w),
                      Expanded(child: _loginButton(() {
                        Fluttertoast.showToast(msg: "登录");
                      })),
                      SizedBox(width: 20.w),
                    ],
                  )
                ],
              )),
        ));
  }

  Widget _registerButton(VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: blue87CEFA, width: 1.r)),
        padding: EdgeInsets.symmetric(vertical: 23.h), // 调整padding，避免覆盖边框
        child: Center(
            child: Text("注册",
                style: TextStyle(fontSize: 30.sp, color: blue87CEFA))),
      ),
    );
  }

  ///登录按钮
  Widget _loginButton(VoidCallback onPressed) {
    return Consumer<LoginViewModel>(builder: (context, viewModel, child) {
      return InkWell(
        onTap: viewModel.userName.isNotEmpty && viewModel.password.isNotEmpty
            ? () {
                onPressed.call();
              }
            : null,
        child: Container(
          color: viewModel.userName.isNotEmpty && viewModel.password.isNotEmpty
              ? blue87CEFA
              : blue6687CEFA,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 25.h),
          child: Center(
              child: Text("登录",
                  style: TextStyle(
                      fontSize: 30.sp,
                      color: viewModel.userName.isNotEmpty &&
                              viewModel.password.isNotEmpty
                          ? Colors.white
                          : white66FFFFFF))),
        ),
      );
    });
  }
}
