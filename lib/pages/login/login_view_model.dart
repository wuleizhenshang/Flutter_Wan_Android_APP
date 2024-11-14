import 'package:flutter/cupertino.dart';
import 'package:wan_android_flutter_test/bean/login_bean.dart';
import 'package:wan_android_flutter_test/network/Api.dart';

class LoginViewModel extends ChangeNotifier {
  String userName = "";
  String password = "";

  void setUserName(String userName) {
    this.userName = userName;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  ///登录
  Future<LoginBean?> login() async {
    //TODO 登录成功更多本地操作
    return await Api.getInstance().login(userName, password);
  }
}
