import 'dart:math';

/// category : "源码"
/// icon : ""
/// id : 22
/// link : "https://www.androidos.net.cn/sourcecode"
/// name : "androidos"
/// order : 11
/// visible : 1

class UsuallyUseWebsite {
  UsuallyUseWebsite({
      this.category, 
      this.icon, 
      this.id, 
      this.link, 
      this.name, 
      this.order, 
      this.visible,});

  UsuallyUseWebsite.fromJson(dynamic json) {
    category = json['category'];
    icon = json['icon'];
    id = json['id'];
    link = json['link'];
    name = json['name'];
    order = json['order'];
    visible = json['visible'];
  }
  String? category;
  String? icon;
  num? id;
  String? link;
  String? name;
  num? order;
  num? visible;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['category'] = category;
    map['icon'] = icon;
    map['id'] = id;
    map['link'] = link;
    map['name'] = name;
    map['order'] = order;
    map['visible'] = visible;
    return map;
  }

}

class UsuallyUseWebsiteBean{
  List<UsuallyUseWebsite>list = [];

  UsuallyUseWebsiteBean.fromJson(dynamic json) {
    if(json is List){
      for(var item in json){
        list.add(UsuallyUseWebsite.fromJson(item));
      }
    }else{
      list = [];
    }
  }
}