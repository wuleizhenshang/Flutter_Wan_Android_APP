import 'package:flutter/cupertino.dart';
import 'package:wan_android_flutter_test/bean/login_bean.dart';
import 'package:wan_android_flutter_test/memory/sp/sp_key_constant.dart';
import 'package:wan_android_flutter_test/memory/sp/sp_utils.dart';
import 'package:wan_android_flutter_test/network/api.dart';

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
    LoginBean? response = await Api.getInstance().login(userName, password);
    if (response != null) {
      //登录成功，保存登录信息
      SpUtils.saveBool(SpKey.isLoginSuccess, true);
      //保存用户id
      SpUtils.saveInt(SpKey.userId, response.id);
      //保存昵称
      SpUtils.saveString(SpKey.nickname, response.nickname);
      //保存积分
      SpUtils.saveInt(SpKey.coinCount, response.coinCount);
      //保存头像
      SpUtils.saveString(
          SpKey.userIconLink,
          response.icon.isEmpty
              ? "https://api.multiavatar.com/${response.id}.png"
              : response.icon);
    }
    return response;
  }
}
