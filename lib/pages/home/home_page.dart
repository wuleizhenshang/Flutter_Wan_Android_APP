//flutter万物皆为widget（组件），那么一个页面也是一个组件
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android_flutter_test/bean/home_banner_bean.dart';
import 'package:wan_android_flutter_test/pages/home/home_view_model.dart';
import 'package:wan_android_flutter_test/pages/web_view_page.dart';
import 'package:wan_android_flutter_test/route/RouteUtils.dart';
import 'package:wan_android_flutter_test/route/route.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

//对应HomePage界面的状态，泛型为HomePage
//这样子就可以在HomePage中使用HomePageState的属性和方法
//_HomePageState是HomePage的私有类，只有HomePage可以访问，外部无法访问
class _HomePageState extends State<HomePage> {
  List<HomeBannerItemData> bannerList = [];

  @override
  void initState() {
    super.initState();
    initBanner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //SafeArea是一个widget，可以让其子widget避开屏幕的异形区域，比如刘海屏或者下方的Home Indicator
        //保证页面内容不会被遮挡
        body: SafeArea(
            //要一起滑动，使用SingleChildScrollView，相当于Android原生的ScrollView
            child: SingleChildScrollView(
                child: Column(
      children: [
        //轮播
        _banner(),
        //列表//用Expanded包裹，让ListView占满剩余空间
        // Expanded(child:
        ListView.builder(
          //但是SingleChildScrollView需要知道子组件的高度，但是ListView不知道，可以设置shrinkWrap: true让ListView自适应
          shrinkWrap: true,
          //同时还需要禁用ListView的滑动，避免嵌套滑动冲突
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            //回调告诉内部有多少个item，长什么样
            return _listItemView();
          },
          itemCount: 100,
        )
        // )
      ],
    ))));
  }

  //初始化Banner，需要用到异步，所以用async，才能用await等待
  void initBanner() async {
    bannerList = await HomeViewModel.getBanner();
    setState(() {});
  }

  //写好一个组建可以单独抽一个方法出来，稍微解决嵌套问题
  //轮播图
  Widget _banner() {
    return Container(
      width: double.infinity,
      height: 200.h,
      child: Swiper(
        itemCount: bannerList.length,
        itemBuilder: (context, index) {
          //margin:外边距 only可以设置上下左右的外边距，all指定所有的外边距
          //涉及上下左右用.r 高.h 宽.w
          // container是一个容器，可以设置很多属性，这里还没图片，这里先用container代替
          return ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.network(
                bannerList[index].imagePath ?? '',
                fit: BoxFit.fill
              ));
        },
        pagination: const SwiperPagination(),
        control: const SwiperControl(),
        autoplay: true,
      ),
    );
  }

  //不在上面堆太多了，这里写一个方法返回一个item布局
  Widget _listItemView() {
    //手势监听，点击事件，GestureDetector是一种,InkWell是另一种，这个有水波纹效果
    return InkWell(
        onTap: () {
          //点击事件
          //跳转到WebViewPage页面,可以通过MaterialPageRoute传递参数，也可以通过构造函数传递参数
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          //   return const WebViewPage();
          // }));
          //那么可以用隐式路由
          //Navigator.pushNamed(context, RoutePath.webViewPage);
          RouteUtils.pushForNamed(context, RoutePath.webViewPage,
              arguments: {"name": "使用路由传值"});
        },
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 1.r),
                borderRadius: BorderRadius.circular(5.r)),
            //外边距
            margin:
                EdgeInsets.only(left: 8.r, right: 8.r, top: 10.r, bottom: 10.r),
            //内边距
            padding:
                EdgeInsets.only(left: 8.r, right: 8.r, top: 10.r, bottom: 10.r),
            child: Column(children: [
              Row(children: [
                //本地就.assets，网络就.network
                // ClipRRect(
                //     borderRadius: BorderRadius.circular(20.r),
                //     child: CachedNetworkImage(
                //       width: 30.r,
                //       height: 30.r,
                //       fit: BoxFit.cover,
                //       imageUrl: "http://via.placeholder.com/350x150",
                //       placeholder: (context, url) => CircularProgressIndicator(),
                //       errorWidget: (context, url, error) => Icon(Icons.error),
                //     )),
                // Image.network没有缓存，用CachedNetworkImage第三方库
                //变为圆角
                ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Image.network(
                      "https://img.btstu.cn/api/images/5a2b8d420d355.jpg",
                      width: 40.r,
                      height: 40.r,
                      fit: BoxFit.cover,
                    )),
                //要设置间距，可以用SizedBox，也可以用Padding组件
                SizedBox(width: 10.w),
                Text("作者",
                    style: TextStyle(color: Colors.black, fontSize: 20.sp)),
                //SizedBox是一个widget，可以设置宽高，用来占位
                Expanded(child: SizedBox()),
                //设置边距也可以这样
                Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: Text("2024_11_10 00:15",
                        style:
                            TextStyle(color: Colors.black, fontSize: 18.sp))),
                Text("置顶",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp))
              ]),
              Text("简略内容，占位使用，加长一点。。。。简略内容，占位使用，加长一点。。。。简略内容，占位使用，加长一点。。。。",
                  style: TextStyle(color: Colors.black, fontSize: 20.sp)),
              Row(children: [
                Text("分类",
                    style:
                        TextStyle(color: Colors.lightGreen, fontSize: 18.sp)),
                Expanded(child: SizedBox()),
                Image.asset("assets/images/ic_unlike.png",
                    width: 30.r, height: 30.r),
              ])
            ])));
  }
}
