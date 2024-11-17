/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

PgyUpdateBean pgyUpdateBeanFromJson(String str) => PgyUpdateBean.fromJson(json.decode(str));

String pgyUpdateBeanToJson(PgyUpdateBean data) => json.encode(data.toJson());

class PgyUpdateBean {
    PgyUpdateBean({
        required this.code,
        required this.data,
        required this.message,
    });

    int code;
    Data data;
    String message;

    factory PgyUpdateBean.fromJson(Map<dynamic, dynamic> json) => PgyUpdateBean(
        code: json["code"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
    );

    Map<dynamic, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
    };
}

class Data {
    Data({
        required this.buildVersion,
        required this.buildName,
        required this.buildHaveNewVersion,
        required this.forceUpdateVersion,
        required this.buildUpdateDescription,
        required this.downloadUrl,
        required this.buildKey,
        required this.buildFileKey,
        required this.appURl,
        required this.buildFileSize,
        required this.buildVersionNo,
        required this.buildDescription,
        required this.needForceUpdate,
        required this.appKey,
        required this.buildBuildVersion,
        required this.forceUpdateVersionNo,
        required this.buildIcon,
    });

    String buildVersion;
    String buildName;
    bool buildHaveNewVersion;
    String forceUpdateVersion;
    String buildUpdateDescription;
    String downloadUrl;
    String buildKey;
    String buildFileKey;
    String appURl;
    String buildFileSize;
    String buildVersionNo;
    String buildDescription;
    bool needForceUpdate;
    String appKey;
    String buildBuildVersion;
    String forceUpdateVersionNo;
    String buildIcon;

    factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        buildVersion: json["buildVersion"],
        buildName: json["buildName"],
        buildHaveNewVersion: json["buildHaveNewVersion"],
        forceUpdateVersion: json["forceUpdateVersion"],
        buildUpdateDescription: json["buildUpdateDescription"],
        downloadUrl: json["downloadURL"],
        buildKey: json["buildKey"],
        buildFileKey: json["buildFileKey"],
        appURl: json["appURl"],
        buildFileSize: json["buildFileSize"],
        buildVersionNo: json["buildVersionNo"],
        buildDescription: json["buildDescription"],
        needForceUpdate: json["needForceUpdate"],
        appKey: json["appKey"],
        buildBuildVersion: json["buildBuildVersion"],
        forceUpdateVersionNo: json["forceUpdateVersionNo"],
        buildIcon: json["buildIcon"],
    );

    Map<dynamic, dynamic> toJson() => {
        "buildVersion": buildVersion,
        "buildName": buildName,
        "buildHaveNewVersion": buildHaveNewVersion,
        "forceUpdateVersion": forceUpdateVersion,
        "buildUpdateDescription": buildUpdateDescription,
        "downloadURL": downloadUrl,
        "buildKey": buildKey,
        "buildFileKey": buildFileKey,
        "appURl": appURl,
        "buildFileSize": buildFileSize,
        "buildVersionNo": buildVersionNo,
        "buildDescription": buildDescription,
        "needForceUpdate": needForceUpdate,
        "appKey": appKey,
        "buildBuildVersion": buildBuildVersion,
        "forceUpdateVersionNo": forceUpdateVersionNo,
        "buildIcon": buildIcon,
    };
}
