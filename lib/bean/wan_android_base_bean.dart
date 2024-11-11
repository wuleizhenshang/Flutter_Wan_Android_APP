class WanAndroidBaseBean<T> {
  T? data;
  int? errorCode;
  String? errorMsg;

  WanAndroidBaseBean.fromJson(dynamic json) {
    data = json['data'];
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }
}
