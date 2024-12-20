import 'package:flutter/cupertino.dart';
import 'package:wan_android/bean/pgy_update_bean.dart';
import 'package:wan_android/network/request/pgy/pgy.dart';
import 'package:wan_android/network/request/wan_android/api.dart';
import '/bean/user_message_bean.dart';
import '/memory/sp/sp_key_constant.dart';
import '/memory/sp/sp_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UserMessageViewModel extends ChangeNotifier {
  //region 空数据
  //未登录
  final String _emptyNicknameWhileNoLogin = "未登录";

  //空昵称
  final String _emptyNickname = "";

  //空头像
  final String _emptyUserIconLink = "https://picsum.photos/300/300";

  //空积分
  final int _emptyCoinCount = 0;

  //空等级
  final int _emptyUserLevel = 0;

  //是否登录
  bool isLoginSuccess = false;

  //endregion

  UserMessage userMessage = UserMessage();
  UserMessageBean? userMessageBean;

  ///获取数据
  Future getUserMessage() async {
    getUserMessageFromLocal();
    //如果登录了，再去获取网络信息
    if (await isLogin()) {
      await getUserMessageFromInternet();
      await getUserMessageFromLocal();
    }
  }

  ///从网络获取个人信息
  ///登录后带上cookie
  ///需要先检查是否登录再走这个方法
  Future getUserMessageFromInternet() async {
    //请求网络的信息
    userMessageBean = await Api.getInstance().getUserMessage();
    //保存信息到sp
    SpUtils.saveInt(SpKey.userId, userMessageBean?.userInfo.id ?? 0);
    SpUtils.saveInt(SpKey.coinCount, userMessageBean?.coinInfo.coinCount ?? 0);
    SpUtils.saveInt(SpKey.userLevel, userMessageBean?.coinInfo.level ?? 0);
    SpUtils.saveString(
        SpKey.nickname, userMessageBean?.userInfo.nickname ?? "");
  }

  ///从本地获取信息
  Future getUserMessageFromLocal() async {
    userMessage.nickname = await isLogin()
        ? await SpUtils.getString(SpKey.nickname) ?? _emptyNickname
        : _emptyNicknameWhileNoLogin;
    userMessage.coinCount =
        await SpUtils.getInt(SpKey.coinCount) ?? _emptyCoinCount;
    userMessage.userLevel =
        await SpUtils.getInt(SpKey.userLevel) ?? _emptyUserLevel;
    userMessage.userIconLink =
        await SpUtils.getString(SpKey.userIconLink) ?? _emptyUserIconLink;
    notifyListeners();
    // Fluttertoast.showToast(
    //     msg:
    //         "isLogin:${await isLogin()} nickname: ${userMessage.nickname} \n coinCount: ${userMessage.coinCount} \n userLevel: ${userMessage.userLevel} \n userIconLink: ${userMessage.userIconLink}");
  }

  ///检查是否登录
  Future<bool> isLogin() async {
    isLoginSuccess = await SpUtils.getBool(SpKey.isLoginSuccess) ?? false;
    return isLoginSuccess;
  }

  ///退出登录
  Future<bool> logout() async {
    if (await isLogin()) {
      bool result = await Api.getInstance().logout();
      //清除登录信息
      SpUtils.saveBool(SpKey.isLoginSuccess, false);
      SpUtils.remove(SpKey.userId);
      SpUtils.remove(SpKey.coinCount);
      SpUtils.remove(SpKey.userLevel);
      SpUtils.remove(SpKey.nickname);
      SpUtils.remove(SpKey.userIconLink);
      SpUtils.remove(SpKey.cookie);
      //清除用户信息
      userMessage.nickname = _emptyNicknameWhileNoLogin;
      userMessage.coinCount = _emptyCoinCount;
      userMessage.userLevel = _emptyUserLevel;
      userMessage.userIconLink = _emptyUserIconLink;

      //设置登录未成功
      isLoginSuccess = false;
      notifyListeners();

      return result;
    }
    return false;
  }

  ///检查更新
  Future<String?> checkUpdate() async {
    var packageInfo = await PackageInfo.fromPlatform();
    //获取当前app版本的code
    var versionCode = packageInfo.buildNumber;

    //获取网络上的版本信息
    PgyUpdateBean? pgyBean = await PgyDio.getInstance().checkUpdate();

    String onlineVersionCode = pgyBean?.data.buildVersionNo ?? "0";

    //Fluttertoast.showToast(msg: "当前版本：$versionCode 线上版本：$onlineVersionCode");

    //如果当前版本小于线上版本，则提示更新，否则返回null
    try {
      if (int.parse(versionCode) < int.parse(onlineVersionCode)) {
        return pgyBean?.data.downloadUrl ?? null;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///跳转到外部链接
  Future jumpToOutLink(String? url) async {
    final uri = Uri.parse(url ?? "");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class UserMessage {
  String nickname;
  String userIconLink;
  int coinCount;
  int userLevel;

  UserMessage(
      {this.nickname = "",
      this.userIconLink = "",
      this.coinCount = 0,
      this.userLevel = 0});
}
