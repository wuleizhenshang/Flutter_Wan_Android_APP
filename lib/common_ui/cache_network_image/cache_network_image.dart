import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../theme/color.dart';

class CustomCacheNetworkImage extends StatefulWidget {
  //图片地址
  final String imageUrl;

  //宽高
  final double width;
  final double height;

  //圆角弧度
  final double radius;

  //边框宽度
  final double strokeWidth;

  //边框颜色
  final Color strokeColor;

  //图片填充方式
  final BoxFit fit;

  const CustomCacheNetworkImage(
      {super.key,
      required this.imageUrl,
      required this.width,
      required this.height,
      this.radius = 0,
      this.strokeWidth = 0,
      this.strokeColor = Colors.white,
      this.fit = BoxFit.cover});

  @override
  State<StatefulWidget> createState() {
    return _CustomCacheNetworkImageState();
  }
}

class _CustomCacheNetworkImageState extends State<CustomCacheNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width.r,
      height: widget.height.r,
      // 外部边框
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius.r),
        border: Border.all(
          color: widget.strokeColor,
          width: widget.strokeWidth.r,
        ),
      ),
      // 使用 ClipRRect 实现圆角裁剪，确保图片和边框贴合
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius.r),
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: widget.fit,
          //进度条
          // progressIndicatorBuilder: (context, url, downloadProgress) =>
          //     CircularProgressIndicator(value: downloadProgress.progress),
          placeholder: (context, url) => CircularProgressIndicator(
            color: blue87CEFA,
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          // 图片加载完成时
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: widget.fit,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
