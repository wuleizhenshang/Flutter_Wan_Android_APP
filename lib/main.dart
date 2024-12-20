import 'package:flutter/material.dart';
import 'package:wan_android/memory/drift/db/setup.dart';
import 'package:wan_android/network/constant.dart';
import 'package:wan_android/network/request/wan_android/dio_instance.dart';
import '/pages/home/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/route/route_utils.dart';
import '/route/route.dart';
import '/theme/color.dart';

Future<void> main() async{
  ///初始化Dio
  DioInstance.getInstance().initDio(baseUrl: wanAndroidBaseUrl);
  ///覆盖数据库打开方法
  setupDatabases();

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
            title: 'wan android',
            theme: ThemeData(
                // colorScheme: ColorScheme.fromSeed(seedColor: blue87CEFA),
                useMaterial3: true,

                ///设置appbar主题
                ///默认情况下，AppBar 会根据主题自动调整它的背景颜色。
                ///surfaceTintColor 是用来修改这种默认背景色的。
                ///如果设置为 Colors.transparent，它会让 AppBar 的背景颜色变得透明，
                ///同时不会有任何默认的表面颜色覆盖
                appBarTheme: AppBarTheme(surfaceTintColor: Colors.transparent)),
            //将路由封装传入，统一管理，home可以不用了，用initialRoute
            onGenerateRoute: Routes.generateRoute,
            initialRoute: RoutePath.mainTab,
            navigatorKey: RouteUtils.navigatorKey,
            //home: const HomePage(),
          );
        });
  }
}
