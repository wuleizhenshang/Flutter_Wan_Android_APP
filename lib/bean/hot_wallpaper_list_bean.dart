/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

class HotWallpaperListBean {
  String? msg;
  Res? res;
  int? code;

  HotWallpaperListBean({this.msg, this.res, this.code});

  HotWallpaperListBean.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    res = json['res'] != null ? new Res.fromJson(json['res']) : null;
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.res != null) {
      data['res'] = this.res!.toJson();
    }
    data['code'] = this.code;
    return data;
  }
}

class Res {
  List<Vertical>? vertical;

  Res({this.vertical});

  Res.fromJson(Map<String, dynamic> json) {
    if (json['vertical'] != null) {
      vertical = <Vertical>[];
      json['vertical'].forEach((v) {
        vertical!.add(new Vertical.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vertical != null) {
      data['vertical'] = this.vertical!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vertical {
  String? preview;
  String? thumb;
  String? img;
  int? views;
  List<String>? cid;
  String? rule;
  int? ncos;
  int? rank;
  String? sourceType;
  List<String>? tag;
  List<String>? url;
  String? wp;
  bool? xr;
  bool? cr;
  int? favs;
  double? atime;
  String? id;
  String? store;
  String? desc;

  Vertical(
      {this.preview,
      this.thumb,
      this.img,
      this.views,
      this.cid,
      this.rule,
      this.ncos,
      this.rank,
      this.sourceType,
      this.tag,
      this.url,
      this.wp,
      this.xr,
      this.cr,
      this.favs,
      this.atime,
      this.id,
      this.store,
      this.desc});

  Vertical.fromJson(Map<String, dynamic> json) {
    preview = json['preview'];
    thumb = json['thumb'];
    img = json['img'];
    views = json['views'];
    cid = json['cid'].cast<String>();
    rule = json['rule'];
    ncos = json['ncos'];
    rank = json['rank'];
    sourceType = json['source_type'];
    tag = json['tag'].cast<String>();
    if (json['url'] != null) {
      url = <String>[];
      json['url'].forEach((v) {
        url!.add(v);
      });
    }
    wp = json['wp'];
    xr = json['xr'];
    cr = json['cr'];
    favs = json['favs'];
    atime = json['atime'];
    id = json['id'];
    store = json['store'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['preview'] = this.preview;
    data['thumb'] = this.thumb;
    data['img'] = this.img;
    data['views'] = this.views;
    data['cid'] = this.cid;
    data['rule'] = this.rule;
    data['ncos'] = this.ncos;
    data['rank'] = this.rank;
    data['source_type'] = this.sourceType;
    data['tag'] = this.tag;
    if (this.url != null) {
      data['url'] = this.url?.toList();
    }
    data['wp'] = this.wp;
    data['xr'] = this.xr;
    data['cr'] = this.cr;
    data['favs'] = this.favs;
    data['atime'] = this.atime;
    data['id'] = this.id;
    data['store'] = this.store;
    data['desc'] = this.desc;
    return data;
  }
}
