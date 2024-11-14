import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/color.dart';

class InputFieldWithStartIconAndCancelIconWidget extends StatefulWidget {
  //输入框控制器，外部要监听输入框的值变化，可以传入控制器，监听控制器的值变化
  final TextEditingController? controller;

  //输入框的提示文字
  final String tint;

  //是否隐藏输入内容
  final bool obscureText;

  //未选中图标
  final Widget? unSelectedIcon;

  //选中图标
  final Widget? selectedIcon;

  //后置图标
  final Widget? cancelIcon;

  //过滤器
  final List<TextInputFormatter>? inputFormatters;

  const InputFieldWithStartIconAndCancelIconWidget(
      {super.key,
      this.tint = "",
      this.cancelIcon,
      this.obscureText = false,
      this.unSelectedIcon,
      this.selectedIcon,
      this.controller,
      this.inputFormatters});

  @override
  State<StatefulWidget> createState() {
    return _InputFieldWithStartIconAndCancelIconWidgetState();
  }


  /// 只允许输入数字和字母
  static TextInputFormatter limitOnlyNumberAndLetter() {
    return FilteringTextInputFormatter.deny(
      RegExp(r'[^a-zA-Z0-9]'),
    );
  }
}

class _InputFieldWithStartIconAndCancelIconWidgetState
    extends State<InputFieldWithStartIconAndCancelIconWidget> {
  //控制器
  late final TextEditingController _controller = widget.controller ?? TextEditingController();

  //是否选中
  final ValueNotifier<bool> _isSelected = ValueNotifier(false);

  //输入框是否有内容
  final ValueNotifier<bool> _hasContent = ValueNotifier(false);

  //焦点
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    //监听焦点变化
    _focusNode.addListener(() {
      _isSelected.value = _focusNode.hasFocus;
    });
    //监听输入框的值变化
    _controller.addListener(() {
      _hasContent.value = _controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      //水平线居中
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //前置图标
        ValueListenableBuilder<bool>(
          valueListenable: _isSelected,
          builder: (context, value, child) {
            return value
                ? widget.selectedIcon ?? const SizedBox.shrink()
                : widget.unSelectedIcon ?? const SizedBox.shrink();
          },
        ),
        //边距
        widget.selectedIcon == null
            ? const SizedBox.shrink()
            : const SizedBox(width: 10),
        //输入框
        Expanded(child: _inputField()),
        //后置图标
        ValueListenableBuilder<bool>(
            valueListenable: _isSelected,
            builder: (context, value1, child) {
              return ValueListenableBuilder<bool>(
                  valueListenable: _hasContent,
                  builder: (context, value2, child) {
                    return value1 && value2
                        ? IconButton(
                            onPressed: () {
                              _controller.clear();
                            },
                            icon: widget.cancelIcon ?? const SizedBox.shrink())
                        : const SizedBox.shrink();
                  });
            })
      ],
    );
  }

  ///输入框部分
  Widget _inputField() {
    return TextField(
        maxLength: 11,
        maxLines: 1,
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
        //是否显示
        obscureText: widget.obscureText,
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
        //正则表达式校验，不符合规则的输入会重置输入框
        inputFormatters: widget.inputFormatters,
        //focus变化情况
        focusNode: _focusNode
        // onChanged: (value) {
        //   // 检查输入是否符合正则表达式
        //   if (!_regExp.hasMatch(value)) {
        //     // 如果不符合规则，则删除最后一个输入的字符
        //     String filteredValue = value.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
        //     _controller.value = TextEditingValue(
        //       text: filteredValue,
        //       selection: TextSelection.collapsed(offset: filteredValue.length),
        //     );
        //   }
        // },
        );
  }
}
