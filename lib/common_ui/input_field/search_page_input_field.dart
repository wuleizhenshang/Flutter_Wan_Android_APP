import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/color.dart';

class SearchPageInputField extends StatefulWidget {
  //输入框控制器，外部要监听输入框的值变化，可以传入控制器，监听控制器的值变化
  final TextEditingController? controller;

  //输入框的提示文字
  final String? tint;

  //删除回调
  final VoidCallback? deleteCallBack;

  //焦点
  final FocusNode? focusNode;

  const SearchPageInputField({super.key, this.controller, this.tint,this.deleteCallBack,this.focusNode});

  @override
  State<StatefulWidget> createState() {
    return _SearchPageInputFieldWidgetState();
  }
}

class _SearchPageInputFieldWidgetState extends State<SearchPageInputField> {
  //控制器
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();

  //输入框是否有内容
  final ValueNotifier<bool> _hasContent = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    //监听输入框的值变化
    _controller.addListener(() {
      _hasContent.value = _controller.text.isNotEmpty;
    });
    if(widget.controller?.text.isNotEmpty??false){
      _hasContent.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      //水平线居中
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //边距
        const SizedBox(width: 10),
        //前置图标
        Image.asset("assets/images/ic_search_999999.png",
            width: 40.w, height: 40.w),
        //边距
        const SizedBox(width: 10),
        //输入框
        Expanded(child: _inputField()),
        //后置图标
        ValueListenableBuilder<bool>(
            valueListenable: _hasContent,
            builder: (context, value2, child) {
              return value2
                  ? IconButton(
                      onPressed: () {
                        _controller.clear();
                        widget.deleteCallBack?.call();
                      },
                      icon: Image.asset("assets/images/ic_cancel.png",
                          width: 40.w, height: 40.h))
                  : const SizedBox.shrink();
            })
      ],
    );
  }

  ///输入框部分
  Widget _inputField() {
    return TextField(
      maxLines: 1,
      focusNode: widget.focusNode,
      //控制器
      controller: _controller,
      //文字样式
      style: TextStyle(
        fontSize: 30.sp,
        color: Colors.black,
      ),
      //光标颜色
      cursorColor: blue87CEFA,
      //输入的内容样式
      keyboardType: TextInputType.text,
      //输入框的样式设置的地方
      decoration: InputDecoration(
          //labelText和labelStyle是输入框的提示文字和样式
          //未获取焦点的边框样式
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.grey,width: 0.5.r),
          // ),
          enabledBorder: InputBorder.none,
          //获取焦点的边框样式
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.blue,width: 0.5.r),
          // ),
          focusedBorder: InputBorder.none,
          //提示文字
          hintText: widget.tint,
          //提示文字样式
          hintStyle: TextStyle(
            fontSize: 30.sp,
            color: grayBBCDCDCD,
          ),
          //不显示提示字数剩余
          counterText: ""),
    );
  }
}
