/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

RegisterBean registerBeanFromJson(String str) => RegisterBean.fromJson(json.decode(str));

String registerBeanToJson(RegisterBean data) => json.encode(data.toJson());

class RegisterBean {
    RegisterBean({
        required this.icon,
        required this.admin,
        required this.type,
        required this.token,
        required this.password,
        required this.publicName,
        required this.chapterTops,
        required this.nickname,
        required this.collectIds,
        required this.id,
        required this.email,
        required this.coinCount,
        required this.username,
    });

    String icon;
    bool admin;
    int type;
    String token;
    String password;
    String publicName;
    List<dynamic> chapterTops;
    String nickname;
    List<dynamic> collectIds;
    int id;
    String email;
    int coinCount;
    String username;

    factory RegisterBean.fromJson(Map<dynamic, dynamic> json) => RegisterBean(
        icon: json["icon"],
        admin: json["admin"],
        type: json["type"],
        token: json["token"],
        password: json["password"],
        publicName: json["publicName"],
        chapterTops: List<dynamic>.from(json["chapterTops"].map((x) => x)),
        nickname: json["nickname"],
        collectIds: List<dynamic>.from(json["collectIds"].map((x) => x)),
        id: json["id"],
        email: json["email"],
        coinCount: json["coinCount"],
        username: json["username"],
    );

    Map<dynamic, dynamic> toJson() => {
        "icon": icon,
        "admin": admin,
        "type": type,
        "token": token,
        "password": password,
        "publicName": publicName,
        "chapterTops": List<dynamic>.from(chapterTops.map((x) => x)),
        "nickname": nickname,
        "collectIds": List<dynamic>.from(collectIds.map((x) => x)),
        "id": id,
        "email": email,
        "coinCount": coinCount,
        "username": username,
    };
}
