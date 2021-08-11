GrowingIO Autotracker
======

![GrowingIO](https://www.growingio.com/vassets/images/home_v3/gio-logo-primary.svg)
[![GitHub](https://img.shields.io/github/license/growingio/flutter-growingio-sdk-autotracker-plugin)](https://github.com/growingio/growingio-sdk-ios-autotracker/blob/master/LICENSE)
[![Platform Flutter](https://img.shields.io/badge/platform-Flutter-brightgreen)]()
[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)

## GrowingIO简介

[**GrowingIO**](https://www.growingio.com/)（北京易数科技有限公司）是基于用户行为数据的增长平台，国内领先的数据运营解决方案供应商。为产品、运营、市场、数据团队及管理者等，提供客户数据平台、获客分析、产品分析、智能运营等产品和咨询服务，帮助企业在数据化升级的路上，提升数据驱动能力，实现更好的增长。  
[**GrowingIO**](https://www.growingio.com/) 专注于零售、电商、金融、酒旅航司、教育、内容社区、B2B等行业，成立以来，服务上千家企业级客户，获得迪奥、安踏、喜茶、招商仁和人寿、上汽集团、东航、春航、首旅如家、陌陌、滴滴、爱奇艺、新东方等客户的青睐。

## SDK 简介

**growingio_sdk_autotracker_plugin** 为GrowingIO 无埋点SDK的 Flutter plugin支持部分，同时基于 [growingio/aspectd](https://github.com/growingio/aspectd) 

## 如何使用

基于环境：

```
sdk: ">=2.12.0 <3.0.0"
flutter: ">=1.20.0"
```

### 1.添加依赖

以工程`flutter_app`为例，在`pubspec.yaml`文件中添加依赖

```c
dependencies:
  growingio_sdk_autotracker_plugin:
    git:
      ref: master
      url: https://github.com/growingio/flutter-growingio-sdk-autotracker-plugin.git
```

然后执行 `flutter pub get` 指令

> 注意：部分用户无法访问github.com，从而无法下拉插件库的情况，可以修改域名为hub.fastgit.org，即可解决

### 2.iOS 工程配置

sdk需要初始化操作，否则会`异常退出`

在`AppDelegate`文件中添加初始化sdk代码，例如如下所示：

```c
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <GrowingAnalytics/GrowingAutotracker.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    GrowingAutotrackConfiguration *configuration = [GrowingTrackConfiguration configurationWithProjectId:@"0a1b4118dd954ec3bcc69da5138bdb96"];
    configuration.debugEnabled = YES;
    //configuration.dataCollectionServerHost = @"https://run.mocky.io/v3/08999138-a180-431d-a136-051f3c6bd306";
    [GrowingAutotracker startWithConfiguration:configuration launchOptions:launchOptions];
    [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

```

使用Xcode，选择`Targets->Info->URL Types`配置好相关的`url scheme`

### 3.Android工程配置

- 新建一个`MyApplication`继承自`FlutterApplication`

```
package com.example.flutter_app;

import com.growingio.android.sdk.autotrack.AutotrackConfiguration;
import com.growingio.android.sdk.autotrack.GrowingAutotracker;
import io.flutter.app.FlutterApplication;

public class MyApplication extends FlutterApplication {
    private static AutotrackConfiguration sConfiguration;
    @Override
    public void onCreate() {
        super.onCreate();


        if (sConfiguration == null) {
            sConfiguration = new AutotrackConfiguration("bfc5d6a3693a110d", "growing.d80871b41ef40518")
                    .setUploadExceptionEnabled(false)
                    .setDebugEnabled(true)
                    .setOaidEnabled(false);
        }
        GrowingAutotracker.startWithConfiguration(this, sConfiguration);
    }
}


```

- 并修改` AndroidManifest.xml`文件中`android:name`字段

```
<application
        android:name="com.example.growingio_sdk_tracker_plugin_example.MyApplication" //修改这里
        ...
```

- 在`app`下的`build.gradle`添加配置参数

```c
android {
    compileSdkVersion 29

    lintOptions {
        disable 'InvalidPackage'
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId "com.example.flutter_app"
        minSdkVersion 17   //提示：这里可能版本小于17，修改为17可以避免报错
        targetSdkVersion 29
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
	resValue("string", "growingio_project_id", "9926fc6c1189e2fb") //这里是你的工程id
	resValue("string", "growingio_url_scheme", "growing.da7e6c2879469314") //这里是你的url scheme
```

- 在`app`下的`build.gradle`中添加 `GrowingIO Tracker SDK`

```c
dependencies {
    implementation 'com.growingio.android:tracker:latest.release' //可以指定你需要的版本 >3.0.0
}
```

之后，运行你的app，即可进行正常埋点。

### 4. 集成 aspectd

参考 [growingio/aspectd](https://github.com/growingio/aspectd) 的 README.md 进行集成 aspectd，其让 flutter aop 实现提供了可能。

