/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

SearchBean searchBeanFromJson(String str) => SearchBean.fromJson(json.decode(str));

String searchBeanToJson(SearchBean data) => json.encode(data.toJson());

class SearchBean {
    SearchBean({
        required this.over,
        required this.pageCount,
        required this.total,
        required this.curPage,
        required this.offset,
        required this.size,
        required this.datas,
    });

    bool over;
    int pageCount;
    int total;
    int curPage;
    int offset;
    int size;
    List<Data> datas;

    factory SearchBean.fromJson(Map<dynamic, dynamic> json) => SearchBean(
        over: json["over"],
        pageCount: json["pageCount"],
        total: json["total"],
        curPage: json["curPage"],
        offset: json["offset"],
        size: json["size"],
        datas: List<Data>.from(json["datas"].map((x) => Data.fromJson(x))),
    );

    Map<dynamic, dynamic> toJson() => {
        "over": over,
        "pageCount": pageCount,
        "total": total,
        "curPage": curPage,
        "offset": offset,
        "size": size,
        "datas": List<dynamic>.from(datas.map((x) => x.toJson())),
    };
}

class Data {
    Data({
        required this.shareDate,
        required this.projectLink,
        required this.prefix,
        required this.canEdit,
        required this.origin,
        required this.link,
        required this.title,
        required this.type,
        required this.selfVisible,
        required this.apkLink,
        required this.envelopePic,
        required this.audit,
        required this.chapterId,
        required this.host,
        required this.realSuperChapterId,
        required this.id,
        required this.courseId,
        required this.superChapterName,
        required this.descMd,
        required this.publishTime,
        required this.niceShareDate,
        required this.visible,
        required this.niceDate,
        required this.author,
        required this.zan,
        required this.chapterName,
        required this.userId,
        required this.adminAdd,
        required this.isAdminAdd,
        required this.tags,
        required this.superChapterId,
        required this.fresh,
        required this.collect,
        required this.shareUser,
        required this.desc,
    });

    int shareDate;
    String projectLink;
    String prefix;
    bool canEdit;
    String origin;
    String link;
    String title;
    int type;
    int selfVisible;
    String apkLink;
    String envelopePic;
    int audit;
    int chapterId;
    String host;
    int realSuperChapterId;
    int id;
    int courseId;
    Name superChapterName;
    String descMd;
    int publishTime;
    String niceShareDate;
    int visible;
    String niceDate;
    Author author;
    int zan;
    ChapterName chapterName;
    int userId;
    bool adminAdd;
    bool isAdminAdd;
    List<Tag> tags;
    int superChapterId;
    bool fresh;
    bool collect;
    String shareUser;
    String desc;

    factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        shareDate: json["shareDate"],
        projectLink: json["projectLink"],
        prefix: json["prefix"],
        canEdit: json["canEdit"],
        origin: json["origin"],
        link: json["link"],
        title: json["title"],
        type: json["type"],
        selfVisible: json["selfVisible"],
        apkLink: json["apkLink"],
        envelopePic: json["envelopePic"],
        audit: json["audit"],
        chapterId: json["chapterId"],
        host: json["host"],
        realSuperChapterId: json["realSuperChapterId"],
        id: json["id"],
        courseId: json["courseId"],
        superChapterName: nameValues.map[json["superChapterName"]]!,
        descMd: json["descMd"],
        publishTime: json["publishTime"],
        niceShareDate: json["niceShareDate"],
        visible: json["visible"],
        niceDate: json["niceDate"],
        author: authorValues.map[json["author"]]!,
        zan: json["zan"],
        chapterName: chapterNameValues.map[json["chapterName"]]!,
        userId: json["userId"],
        adminAdd: json["adminAdd"],
        isAdminAdd: json["isAdminAdd"],
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
        superChapterId: json["superChapterId"],
        fresh: json["fresh"],
        collect: json["collect"],
        shareUser: json["shareUser"],
        desc: json["desc"],
    );

    Map<dynamic, dynamic> toJson() => {
        "shareDate": shareDate,
        "projectLink": projectLink,
        "prefix": prefix,
        "canEdit": canEdit,
        "origin": origin,
        "link": link,
        "title": title,
        "type": type,
        "selfVisible": selfVisible,
        "apkLink": apkLink,
        "envelopePic": envelopePic,
        "audit": audit,
        "chapterId": chapterId,
        "host": host,
        "realSuperChapterId": realSuperChapterId,
        "id": id,
        "courseId": courseId,
        "superChapterName": nameValues.reverse[superChapterName],
        "descMd": descMd,
        "publishTime": publishTime,
        "niceShareDate": niceShareDate,
        "visible": visible,
        "niceDate": niceDate,
        "author": authorValues.reverse[author],
        "zan": zan,
        "chapterName": chapterNameValues.reverse[chapterName],
        "userId": userId,
        "adminAdd": adminAdd,
        "isAdminAdd": isAdminAdd,
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
        "superChapterId": superChapterId,
        "fresh": fresh,
        "collect": collect,
        "shareUser": shareUser,
        "desc": desc,
    };
}

enum Author { EMPTY, AUTHOR, PURPLE }

final authorValues = EnumValues({
    "干货": Author.AUTHOR,
    "": Author.EMPTY,
    "郭霖": Author.PURPLE
});

enum ChapterName { EMPTY, CHAPTER_NAME, PURPLE, FLUFFY }

final chapterNameValues = EnumValues({
    "广场": ChapterName.CHAPTER_NAME,
    "自助": ChapterName.EMPTY,
    "郭霖": ChapterName.FLUFFY,
    "干货资源": ChapterName.PURPLE
});

enum Name { TAB, EMPTY, NAME }

final nameValues = EnumValues({
    "干货资源": Name.EMPTY,
    "公众号": Name.NAME,
    "广场Tab": Name.TAB
});

class Tag {
    Tag({
        required this.name,
        required this.url,
    });

    Name name;
    String url;

    factory Tag.fromJson(Map<dynamic, dynamic> json) => Tag(
        name: nameValues.map[json["name"]]!,
        url: json["url"],
    );

    Map<dynamic, dynamic> toJson() => {
        "name": nameValues.reverse[name],
        "url": url,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
