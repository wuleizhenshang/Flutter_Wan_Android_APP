import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:wan_android/common_ui/cache_network_image/cache_network_image.dart';
import 'package:wan_android/pages/hot_wallpaper/hot_wallpaper_viewmodel.dart';
import 'package:wan_android/theme/color.dart';

///热门壁纸页面
class HotWallpaperPage extends StatefulWidget {
  const HotWallpaperPage({super.key});

  @override
  _HotWallpaperPageState createState() => _HotWallpaperPageState();
}

class _HotWallpaperPageState extends State<HotWallpaperPage> {
  //EasyRefresh控制器
  final EasyRefreshController _easyRefreshController = EasyRefreshController();

  //初始化viewModel，getx为全局单例，不会自动销毁
  ///Obx管理需要Put进去，GetX管理不需要
  final HotWallpaperViewModel viewModel = Get.put(HotWallpaperViewModel());

  //销毁，手动回收getx
  @override
  void dispose() {
    Get.delete<HotWallpaperViewModel>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    viewModel.getHotWallpaper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: blue87CEFA,
        title: const Text("热门壁纸"),
      ),
      body: SafeArea(
        child: Obx(() {
          return viewModel.isFirstLoading.value
              ? Center(child: CircularProgressIndicator(color: blue87CEFA))
              : EasyRefresh(
                  controller: _easyRefreshController,
                  onRefresh: () async {
                    await viewModel.getHotWallpaper();
                    _easyRefreshController.finishRefresh();
                  },
                  child: ListView.builder(
                    itemCount: viewModel.hotWallpaperList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            CustomCacheNetworkImage(
                                width: double.infinity,
                                height: 500,
                                radius: 20,
                                imageUrl:
                                    viewModel.hotWallpaperList[index].thumb ??
                                        ""),
                          ],
                        ),
                      );
                    },
                  ),
                );
        }),
      ),
    );
  }
}
