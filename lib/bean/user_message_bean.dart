/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

UserMessageBean userMessageBeanFromJson(String str) => UserMessageBean.fromJson(json.decode(str));

String userMessageBeanToJson(UserMessageBean data) => json.encode(data.toJson());

class UserMessageBean {
    UserMessageBean({
        required this.userInfo,
        required this.coinInfo,
        required this.collectArticleInfo,
    });

    UserInfo userInfo;
    CoinInfo coinInfo;
    CollectArticleInfo collectArticleInfo;

    factory UserMessageBean.fromJson(Map<dynamic, dynamic> json) => UserMessageBean(
        userInfo: UserInfo.fromJson(json["userInfo"]),
        coinInfo: CoinInfo.fromJson(json["coinInfo"]),
        collectArticleInfo: CollectArticleInfo.fromJson(json["collectArticleInfo"]),
    );

    Map<dynamic, dynamic> toJson() => {
        "userInfo": userInfo.toJson(),
        "coinInfo": coinInfo.toJson(),
        "collectArticleInfo": collectArticleInfo.toJson(),
    };
}

class CoinInfo {
    CoinInfo({
        required this.level,
        required this.nickname,
        required this.rank,
        required this.userId,
        required this.coinCount,
        required this.username,
    });

    int level;
    String nickname;
    String rank;
    int userId;
    int coinCount;
    String username;

    factory CoinInfo.fromJson(Map<dynamic, dynamic> json) => CoinInfo(
        level: json["level"],
        nickname: json["nickname"],
        rank: json["rank"],
        userId: json["userId"],
        coinCount: json["coinCount"],
        username: json["username"],
    );

    Map<dynamic, dynamic> toJson() => {
        "level": level,
        "nickname": nickname,
        "rank": rank,
        "userId": userId,
        "coinCount": coinCount,
        "username": username,
    };
}

class CollectArticleInfo {
    CollectArticleInfo({
        required this.count,
    });

    int count;

    factory CollectArticleInfo.fromJson(Map<dynamic, dynamic> json) => CollectArticleInfo(
        count: json["count"],
    );

    Map<dynamic, dynamic> toJson() => {
        "count": count,
    };
}

class UserInfo {
    UserInfo({
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

    factory UserInfo.fromJson(Map<dynamic, dynamic> json) => UserInfo(
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
