import 'package:flutter/cupertino.dart';

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
}