
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
  GrowingAutotracker._() {}
  factory GrowingAutotracker.getInstance() => _instance;


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

  Future<void> setLoginUserAttributes(Map<String, dynamic>? variable) async {
    if (variable == null) return;
    try {
      return await _channel.invokeMethod("setLoginUserAttributes", variable);
    }
    catch(e) {
      print('error :' + e.toString());
    }
  }

  Future<void> setVisitorAttributes(Map<String, dynamic>? variable) async {
    if (variable == null) return;
    return await _channel.invokeMethod("setVisitorAttributes", variable);
  }
  Future<void> setConversionVariables(Map<String, dynamic>? variable) async {
    if (variable == null) return;
    return await _channel.invokeMethod("setConversionVariables", variable);
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

}
