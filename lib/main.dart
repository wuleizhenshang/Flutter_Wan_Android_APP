import 'package:flutter/material.dart';
import 'package:wan_android_flutter_test/pages/home/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android_flutter_test/route/RouteUtils.dart';
import 'package:wan_android_flutter_test/route/route.dart';
import 'package:wan_android_flutter_test/theme/color.dart';

import 'network/dio_instance.dart';

void main() {

  ///初始化Dio
  DioInstance.getInstance().initDio(baseUrl: "https://www.wanandroid.com/");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //屏幕适配
    return ScreenUtilInit(
        //填入设计稿中设备的屏幕尺寸
        designSize: const Size(750, 1334),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              // colorScheme: ColorScheme.fromSeed(seedColor: blue87CEFA),
              useMaterial3: true,
            ),
            //将路由封装传入，统一管理，home可以不用了，用initialRoute
            onGenerateRoute: Routes.generateRoute,
            initialRoute: RoutePath.loginPage,
            navigatorKey: RouteUtils.navigatorKey,
            //home: const HomePage(),
          );
        });
  }
}
