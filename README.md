# wan_android_flutter_test
## 简要说明
这个app是借助鸿洋大大的玩安卓开放的api，使用flutter开发的一个app，主要是为了练习flutter的开发，以及熟悉flutter的一些基本组件和功能。<br>
**这里主要是保存自己的学习经历，同时也供大家参考，代码是按照下面视频up的思路写的，另外加上了自己的一些ui想法和一些自己想学习的idea，可能很杂！另外就是只测试了Android平台的运行，编译环境使用的Android Studio！**<br>
api地址：https://www.wanandroid.com/blog/show/2 <br>
另外跟随学习视频地址为：https://www.bilibili.com/video/BV1Qb421Y7SV <br>
学习博客地址为：https://book.willh.cn/ <br>

## 编译环境说明
**下面是`flutter doctor -v`打印的环境信息，as版本是最新的2024.2.2Nightly,并指定了编译的jdk版本为17**<br>
PS C:\project\android_project\wan_android_flutter_test> flutter doctor -v
Flutter assets will be downloaded from https://storage.flutter-io.cn. Make sure you trust this source!
[✓] Flutter (Channel stable, 3.24.4, on Microsoft Windows [版本 10.0.22621.3007], locale zh-CN)
• Flutter version 3.24.4 on channel stable at C:\ApplicationData\FlutterSDK\flutter_windows_3.24.4-stable\flutter
• Upstream repository https://github.com/flutter/flutter.git
• Framework revision 603104015d (3 weeks ago), 2024-10-24 08:01:25 -0700
• Engine revision db49896cf2
• Dart version 3.5.4
• DevTools version 2.37.3
• Pub download mirror https://pub.flutter-io.cn
• Flutter download mirror https://storage.flutter-io.cn

[✓] Windows Version (Installed version of Windows is version 10 or higher)

[✓] Android toolchain - develop for Android devices (Android SDK version 35.0.0)
• Android SDK at C:\Users\jianting\AppData\Local\Android\sdk
• Platform android-35, build-tools 35.0.0
• Java binary at: C:\Users\jianting\AppData\Local\Programs\Android Studio 2\jbr\bin\java
• Java version OpenJDK Runtime Environment (build 21.0.4+-12508038-b607.1)
• All Android licenses accepted.

[✓] Android Studio (version 2022.3)
• Android Studio at C:\Users\jianting\AppData\Local\Programs\Android Studio
• Flutter plugin can be installed from:
🔨 https://plugins.jetbrains.com/plugin/9212-flutter
• Dart plugin can be installed from:
🔨 https://plugins.jetbrains.com/plugin/6351-dart
• Java version OpenJDK Runtime Environment (build 17.0.6+0-b2043.56-10027231)

[✓] Android Studio (version 2024.2)
• Android Studio at C:\Users\jianting\AppData\Local\Programs\Android Studio 2
• Flutter plugin can be installed from:
🔨 https://plugins.jetbrains.com/plugin/9212-flutter
• Dart plugin can be installed from:
🔨 https://plugins.jetbrains.com/plugin/6351-dart
• Java version OpenJDK Runtime Environment (build 21.0.4+-12508038-b607.1)

[✓] IntelliJ IDEA Ultimate Edition (version 2023.3)
• IntelliJ at C:\Users\jianting\AppData\Local\Programs\IntelliJ IDEA Ultimate
• Flutter plugin can be installed from:
🔨 https://plugins.jetbrains.com/plugin/9212-flutter
• Dart plugin can be installed from:
🔨 https://plugins.jetbrains.com/plugin/6351-dart

[✓] Connected device (1 available)
• MI 8 SE (mobile) • 4f56c284 • android-arm64 • Android 10 (API 29)

[✓] Network resources
• All expected network resources are available.

**指定了jdk版本**<br>
PS C:\project\android_project\wan_android_flutter_test> flutter config --jdk-dir="C:\Users\jianting\.jdks\corretto-17.0.13"
Setting "jdk-dir" value to "C:\Users\jianting\.jdks\corretto-17.0.13".

## 使用的插件

