import 'dart:async';

import 'package:flutter/services.dart';

class GrowingioSdkAutotrackerPlugin {
  String platformVersion() {
    return "1.0.0";
  }
  GrowingAutotracker tracker() {
    return GrowingAutotracker.getInstance();
  }
}

class GrowingAutotracker {
  static const MethodChannel _channel =
  const MethodChannel('growingio_sdk_autotracker_plugin');
  static final _instance = GrowingAutotracker._();
  GrowingAutotracker._() {
    _channel.setMethodCallHandler(nativeCallHandler);//设置监听
  }
  factory GrowingAutotracker.getInstance() => _instance;

  bool webCircleRunning = false;
  //实现监听
  Future<dynamic> nativeCallHandler(MethodCall call) async {
    switch (call.method) {
      case "WebCircle":
        bool isOpen = call.arguments; //获取安卓穿过来的值
        webCircleRunning = isOpen;
        print("nativeCallHandler webcircle : " + isOpen.toString());
        break;
    }
  }

  Future<void> trackCustomEvent(String? eventId,
      {double? num, Map<String, dynamic>? variable}) async {
    if (eventId == null) return;
    Map<String, dynamic> args = {"eventId": eventId};
    if (num != null) {
      args['num'] = num;
    }
    if (variable != null) {
      args['variable'] = variable;
    }
    return await _channel.invokeMethod("trackCustomEvent", args);
  }

  Future<void> trackCustomEventItemKeyId(String? eventId,String? itemKey,String? itemId,
      {Map<String, dynamic>? variable}) async {
    Map<String, dynamic> args = {"eventId": eventId};
    if (variable != null) {
      args['variable'] = variable;
    }
    if (itemKey != null) {
      args["itemKey"] = itemKey;
    }
    if (itemId != null) {
      args["itemId"] = itemId;
    }
    return await _channel.invokeMethod("trackCustomEventItemKeyId", args);
  }

  Future<void> setLoginUserAttributes(Map<String, dynamic>? variable) async {
    if (variable == null) return;
    try {
      return await _channel.invokeMethod("setLoginUserAttributes", variable);
    }
    catch(e) {
      print('error :' + e.toString());
    }
  }

  Future<void> setLoginUserId(String? userId) async {
    if (userId == null) return;
    return await _channel.invokeMethod("setLoginUserId", {"userId": userId});
  }
  Future<void> cleanLoginUserId() async {
    return await _channel.invokeMethod("cleanLoginUserId");
  }

  /// flutter and native
  Future<void> flutterClickEvent(Map<String, dynamic>? args) async {
    if (args == null) return;
    return await _channel.invokeMethod("flutterClickEvent", args);
  }

  Future<void> flutterViewChangeEvent(Map<String, dynamic>? args) async {
    if (args == null) return;
    return await _channel.invokeMethod("flutterViewChangeEvent", args);
  }

  Future<void> flutterPageEvent(Map<String, dynamic>? args) async {
    if (args == null) return;
    return await _channel.invokeMethod("flutterPageEvent", args);
  }

  Future<void> flutterWebCircleEvent(Map<String, dynamic>? args) async {
    if (args == null) return;
    return await _channel.invokeMethod("flutterWebCircleEvent", args);
  }

}
