import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../memory/sp/sp_key_constant.dart';
import '../../memory/sp/sp_utils.dart';

///cookie拦截器
class CookieInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //获取cookie并给请求头赋值
    SpUtils.getList(SpKey.cookie).then((value) {
      options.headers[HttpHeaders.cookieHeader] = value;
      handler.next(options);
    });
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    //是请求登录接口才做处理
    if (response.requestOptions.path.contains("user/login")) {
      //获取cookie
      dynamic cookieList = response.headers[HttpHeaders.setCookieHeader];
      List<String> cookies = [];
      if (cookieList is List) {
        for (String? s in cookieList) {
          if (s != null) {
            cookies.add(s);
          }
        }
      }
      //保存cookie
      SpUtils.saveList(SpKey.cookie, cookies);
    }
    super.onResponse(response, handler);
  }
}
