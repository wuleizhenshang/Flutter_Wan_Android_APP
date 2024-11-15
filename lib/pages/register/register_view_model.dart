import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wan_android_flutter_test/network/api.dart';

class RegisterViewModel extends ChangeNotifier {
  String username = "";
  String password = "";
  String repassword = "";

  setUsername(String username) {
    this.username = username;
    notifyListeners();
  }

  setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  setRepassword(String repassword) {
    this.repassword = repassword;
    notifyListeners();
  }

  ///注册
  Future<bool> register() async {
    //不会为空其实，因为为空按钮点击不了，但是为了保险起见还是判断一下
    if (username.isEmpty || password.isEmpty || repassword.isEmpty) {
      Fluttertoast.showToast(msg: "用户名或密码不能为空");
      return false;
    }
    //为true则注册成功；为空则注册失败，显示toast提示
    var bool = await Api.getInstance().register(username, password, repassword);
    //有data则注册成功，否则注册失败，内容应该没什么用，因为后续登录还会拿到内容
    return bool == null ? false : true;
  }
}
