import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'growingio_sdk_autotracker_platform_interface.dart';

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
    try {
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
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }

  @override
  Future<void> setDataCollectionEnabled(bool enabled) async {
    try {
      return await methodChannel.invokeMethod("setDataCollectionEnabled", enabled);
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }

  @override
  Future<void> setLoginUserId({
    required String userId,
    String? userKey,
  }) async {
    try {
      Map<String, String> args = {"userId": userId};
      if (userKey != null) {
        args['userKey'] = userKey;
      }
      return await methodChannel.invokeMethod("setLoginUserId", args);
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }

  @override
  Future<void> cleanLoginUserId() async {
    try {
      return await methodChannel.invokeMethod("cleanLoginUserId");
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }

  @override
  Future<void> setLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      return await methodChannel.invokeMethod("setLocation", {
        "latitude": latitude,
        "longitude": longitude
      });
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }

  @override
  Future<void> cleanLocation() async {
    try {
      return await methodChannel.invokeMethod("cleanLocation");
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }

  @override
  Future<void> setLoginUserAttributes({
    required Map<String, String> attributes,
  }) async {
    try {
      return await methodChannel.invokeMethod("setLoginUserAttributes", attributes);
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }

  @override
  Future<String?> getDeviceId() async {
    try {
      final deviceId = await methodChannel.invokeMethod<String>('getDeviceId');
      return deviceId;
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }

  @override
  Future<void> trackCustomEvent({
    required String eventName, 
    Map<String, String>? attributes
    }) async {
    try {
      Map<String, Object> args = {"eventName": eventName};
      if (attributes != null) {
        args['attributes'] = attributes;
      }
      return await methodChannel.invokeMethod("trackCustomEvent", args);
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }

  @override
  Future<String?> trackTimerStart({
    required String eventName, 
    }) async {
    try {
      final timerId = await methodChannel.invokeMethod<String?>("trackTimerStart", eventName);
      return timerId;
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }

  @override
  Future<void> trackTimerPause({
    required String timerId, 
    }) async {
    try {
      return await methodChannel.invokeMethod("trackTimerPause", timerId);
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }

  @override
  Future<void> trackTimerResume({
    required String timerId, 
    }) async {
    try {
      return await methodChannel.invokeMethod("trackTimerResume", timerId);
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }

  @override
  Future<void> trackTimerEnd({
    required String timerId, 
    Map<String, String>? attributes,
    }) async {
    try {
      Map<String, Object> args = {"timerId": timerId};
      if (attributes != null) {
        args['attributes'] = attributes;
      }
      return await methodChannel.invokeMethod("trackTimerEnd", args);
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }

  @override
  Future<void> removeTimer({
    required String timerId, 
    }) async {
    try {
      return await methodChannel.invokeMethod("removeTimer", timerId);
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }

  @override
  Future<void> clearTrackTimer() async {
    try {
      return await methodChannel.invokeMethod("clearTrackTimer");
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }
}
