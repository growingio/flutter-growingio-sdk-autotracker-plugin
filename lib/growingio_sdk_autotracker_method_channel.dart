import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'growingio_sdk_autotracker_platform_interface.dart';

enum GrowingFilterEvent {
  visit,
  custom,
  loginUserAttributes,

  // autotrack
  page,
  appClosed,
  viewClick,
  viewChange,
  formSubmit,
  clickChangeSubmit,

  // advert
  activate,
  reengage,
}

enum GrowingIgnoreField {
  networkState,
  screenWidth,
  screenHeight,
  deviceBrand,
  deviceModel,
  deviceType,
  all,
}

const growingFilterEventValues = {
  GrowingFilterEvent.visit: (1 << 0),
  GrowingFilterEvent.custom: (1 << 1),
  GrowingFilterEvent.loginUserAttributes: (1 << 2),
  GrowingFilterEvent.page: (1 << 3),
  GrowingFilterEvent.appClosed: (1 << 4),
  GrowingFilterEvent.viewClick: (1 << 5),
  GrowingFilterEvent.viewChange: (1 << 6),
  GrowingFilterEvent.formSubmit: (1 << 7),
  GrowingFilterEvent.clickChangeSubmit: ((1 << 5) + (1 << 6) + (1 << 7)),
  GrowingFilterEvent.activate: (1 << 8),
  GrowingFilterEvent.reengage: (1 << 9),
};

const growingIgnoreFieldValues = {
  GrowingIgnoreField.networkState: (1 << 0),
  GrowingIgnoreField.screenWidth: (1 << 1),
  GrowingIgnoreField.screenHeight: (1 << 2),
  GrowingIgnoreField.deviceBrand: (1 << 3),
  GrowingIgnoreField.deviceModel: (1 << 4),
  GrowingIgnoreField.deviceType: (1 << 5),
  GrowingIgnoreField.all: ((1 << 0) + (1 << 1) + (1 << 2) + (1 << 3) + (1 << 4) + (1 << 5)),
};

/// An implementation of [GrowingioSdkAutotrackerPlatform] that uses method channels.
class MethodChannelGrowingioSdkAutotracker extends GrowingioSdkAutotrackerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('growingio_sdk_autotracker');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> startWithConfiguration({
    required String projectId, 
    required String dataCollectionServerHost,
    String? dataSourceId,
    String? urlScheme,
    bool? debugEnabled,
    bool? dataCollectionEnabled,
    bool? idMappingEnabled,
    bool? encryptEnabled,
    int? cellularDataLimit,
    int? dataUploadInterval,
    int? sessionInterval,
    int? excludeEvent, // growingFilterEventValues
    int? ignoreField, // growingIgnoreFieldValues
    }) async {
      Map<String, Object> args = {
        "projectId": projectId,
        "dataCollectionServerHost": dataCollectionServerHost,
      };
      if (dataSourceId != null) {
        args['dataSourceId'] = dataSourceId;
      }
      if (debugEnabled != null) {
        args['debugEnabled'] = debugEnabled;
      }
      if (dataCollectionEnabled != null) {
        args['dataCollectionEnabled'] = dataCollectionEnabled;
      }
      if (idMappingEnabled != null) {
        args['idMappingEnabled'] = idMappingEnabled;
      }
      if (encryptEnabled != null) {
        args['encryptEnabled'] = encryptEnabled;
      }
      if (urlScheme != null) {
        args['urlScheme'] = urlScheme;
      }
      if (cellularDataLimit != null) {
        args['cellularDataLimit'] = cellularDataLimit;
      }
      if (dataUploadInterval != null) {
        args['dataUploadInterval'] = dataUploadInterval;
      }
      if (sessionInterval != null) {
        args['sessionInterval'] = sessionInterval;
      }
      if (excludeEvent != null) {
        args['excludeEvent'] = excludeEvent;
      }
      if (ignoreField != null) {
        args['ignoreField'] = ignoreField;
      }
      return await methodChannel.invokeMethod("startWithConfiguration", args);
  }

  @override
  Future<void> setDataCollectionEnabled(bool enabled) async {
    return await methodChannel.invokeMethod("setDataCollectionEnabled", enabled);
  }

  @override
  Future<void> setLoginUserId({
    required String userId,
    String? userKey,
  }) async {
    Map<String, String> args = {"userId": userId};
      if (userKey != null) {
        args['userKey'] = userKey;
      }
    return await methodChannel.invokeMethod("setLoginUserId", args);
  }

  @override
  Future<void> cleanLoginUserId() async {
    return await methodChannel.invokeMethod("cleanLoginUserId");
  }

  @override
  Future<void> setLocation({
    required double latitude,
    required double longitude,
  }) async {
    return await methodChannel.invokeMethod("setLocation", {
      "latitude": latitude,
      "longitude": longitude
      });
  }

  @override
  Future<void> cleanLocation() async {
    return await methodChannel.invokeMethod("cleanLocation");
  }

  @override
  Future<void> setLoginUserAttributes({
    required Map<String, String> attributes,
  }) async {
    return await methodChannel.invokeMethod("setLoginUserAttributes", attributes);
  }

  @override
  Future<String?> get deviceId {
    try {
      return methodChannel.invokeMethod<String?>('getDeviceId');
    } catch (e, s) {
      
    }
  }

  @override
  Future<void> trackCustomEvent({
    required String eventName, 
    Map<String, String>? attributes
    }) async {
      Map<String, Object> args = {"eventName": eventName};
      if (attributes != null) {
        args['attributes'] = attributes;
      }
      return await methodChannel.invokeMethod("trackCustomEvent", args);
  }

  @override
  Future<String> trackTimerStart({
    required String eventName, 
    }) {
      return methodChannel.invokeMethod<String>("trackTimerStart", eventName);
  }

  @override
  Future<void> trackTimerPause({
    required String timerId, 
    }) async {
      return await methodChannel.invokeMethod("trackTimerPause", timerId);
  }

  @override
  Future<void> trackTimerResume({
    required String timerId, 
    }) async {
      return await methodChannel.invokeMethod("trackTimerResume", timerId);
  }

  @override
  Future<void> trackTimerEnd({
    required String timerId, 
    Map<String, String>? attributes,
    }) async {
      Map<String, Object> args = {"timerId": timerId};
      if (attributes != null) {
        args['attributes'] = attributes;
      }
      return await methodChannel.invokeMethod("trackTimerEnd", args);
  }

  @override
  Future<void> removeTimer({
    required String timerId, 
    }) async {
      return await methodChannel.invokeMethod("removeTimer", timerId);
  }

  @override
  Future<void> clearTrackTimer() async {
      return await methodChannel.invokeMethod("clearTrackTimer");
  }
}
