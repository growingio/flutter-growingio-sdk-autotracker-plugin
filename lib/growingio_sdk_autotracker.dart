import 'growingio_sdk_autotracker_platform_interface.dart';
export 'growingio_sdk_autotracker_platform_interface.dart' 
    show growingFilterEventValues, growingIgnoreFieldValues, GrowingFilterEvent, GrowingIgnoreField;

class GrowingioSdkAutotracker {
  Future<String?> getPlatformVersion() {
    return GrowingioSdkAutotrackerPlatform.instance.getPlatformVersion();
  }

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
      return GrowingioSdkAutotrackerPlatform.instance.startWithConfiguration(
        projectId: projectId, 
        dataCollectionServerHost: dataCollectionServerHost,
        dataSourceId: dataSourceId,
        urlScheme: urlScheme,
        debugEnabled: debugEnabled,
        dataCollectionEnabled: dataCollectionEnabled,
        idMappingEnabled: idMappingEnabled,
        encryptEnabled: encryptEnabled,
        cellularDataLimit: cellularDataLimit,
        dataUploadInterval: dataUploadInterval,
        sessionInterval: sessionInterval,
        excludeEvent: excludeEvent,
        ignoreField: ignoreField,
        );
  }

  Future<void> setDataCollectionEnabled(bool enabled) async {
    return GrowingioSdkAutotrackerPlatform.instance.setDataCollectionEnabled(enabled);
  }

  Future<void> setLoginUserId({
    required String userId,
    String? userKey,
  }) async {
    return GrowingioSdkAutotrackerPlatform.instance.setLoginUserId(userId: userId,userKey: userKey);
  }

  Future<void> cleanLoginUserId() async {
    return GrowingioSdkAutotrackerPlatform.instance.cleanLoginUserId();
  }

  Future<void> setLocation({
    required double latitude,
    required double longitude,
  }) async {
    return GrowingioSdkAutotrackerPlatform.instance.setLocation(latitude: latitude,longitude: longitude);
  }

  Future<void> cleanLocation() async {
    return GrowingioSdkAutotrackerPlatform.instance.cleanLocation();
  }

  Future<void> setLoginUserAttributes({
    required Map<String, String> attributes,
  }) async {
    return GrowingioSdkAutotrackerPlatform.instance.setLoginUserAttributes(attributes: attributes);
  }

  Future<String?> getDeviceId() async {
    return GrowingioSdkAutotrackerPlatform.instance.getDeviceId();
  }

  Future<void> trackCustomEvent({
    required String eventName, 
    Map<String, String>? attributes
    }) async {
      return GrowingioSdkAutotrackerPlatform.instance.trackCustomEvent(
        eventName: eventName, 
        attributes: attributes
        );
  }

  Future<String?> trackTimerStart({
    required String eventName, 
    }) async {
    return GrowingioSdkAutotrackerPlatform.instance.trackTimerStart(eventName: eventName);
  }

  Future<void> trackTimerPause({
    required String timerId, 
    }) async {
    return GrowingioSdkAutotrackerPlatform.instance.trackTimerPause(timerId: timerId);
  }

  Future<void> trackTimerResume({
    required String timerId, 
    }) async {
    return GrowingioSdkAutotrackerPlatform.instance.trackTimerResume(timerId: timerId);
  }

  Future<void> trackTimerEnd({
    required String timerId, 
    Map<String, String>? attributes,
    }) async {
    return GrowingioSdkAutotrackerPlatform.instance.trackTimerEnd(timerId: timerId, attributes: attributes);
  }

  Future<void> removeTimer({
    required String timerId, 
    }) async {
    return GrowingioSdkAutotrackerPlatform.instance.removeTimer(timerId: timerId);
  }

  Future<void> clearTrackTimer() async {
    return GrowingioSdkAutotrackerPlatform.instance.clearTrackTimer();
  }
}
