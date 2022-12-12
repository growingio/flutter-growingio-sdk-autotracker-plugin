import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'growingio_sdk_autotracker_method_channel.dart';

abstract class GrowingioSdkAutotrackerPlatform extends PlatformInterface {
  /// Constructs a GrowingioSdkAutotrackerPlatform.
  GrowingioSdkAutotrackerPlatform() : super(token: _token);

  static final Object _token = Object();

  static GrowingioSdkAutotrackerPlatform _instance = MethodChannelGrowingioSdkAutotracker();

  /// The default instance of [GrowingioSdkAutotrackerPlatform] to use.
  ///
  /// Defaults to [MethodChannelGrowingioSdkAutotracker].
  static GrowingioSdkAutotrackerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GrowingioSdkAutotrackerPlatform] when
  /// they register themselves.
  static set instance(GrowingioSdkAutotrackerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
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
      throw UnimplementedError('startWithConfiguration() has not been implemented.');
  }

  Future<void> setDataCollectionEnabled(bool enabled) async {
    throw UnimplementedError('setDataCollectionEnabled() has not been implemented.');
  }

  Future<void> setLoginUserId({
    required String userId,
    String? userKey,
  }) async {
    throw UnimplementedError('setLoginUserId() has not been implemented.');
  }

  Future<void> cleanLoginUserId() async {
    throw UnimplementedError('cleanLoginUserId() has not been implemented.');
  }

  Future<void> setLocation({
    required double latitude,
    required double longitude,
  }) async {
    throw UnimplementedError('setLocation() has not been implemented.');
  }

  Future<void> cleanLocation() async {
    throw UnimplementedError('cleanLocation() has not been implemented.');
  }

  Future<void> setLoginUserAttributes({
    required Map<String, String> attributes,
  }) async {
    throw UnimplementedError('setLoginUserAttributes() has not been implemented.');
  }

  Future<String?> get deviceId {
    throw UnimplementedError('get {deviceId} has not been implemented.');
  }

  Future<void> trackCustomEvent({
    required String eventName, 
    Map<String, String>? attributes
    }) async {
      throw UnimplementedError('trackCustomEvent() has not been implemented.');
  }

  Future<String> trackTimerStart({
    required String eventName, 
    }) {
      throw UnimplementedError('trackTimerStart() has not been implemented.');
  }

  Future<void> trackTimerPause({
    required String timerId, 
    }) async {
      throw UnimplementedError('trackTimerPause() has not been implemented.');
  }

  Future<void> trackTimerResume({
    required String timerId, 
    }) async {
      throw UnimplementedError('trackTimerResume() has not been implemented.');
  }

  Future<void> trackTimerEnd({
    required String timerId, 
    Map<String, String>? attributes,
    }) async {
      throw UnimplementedError('trackTimerEnd() has not been implemented.');
  }

  Future<void> removeTimer({
    required String timerId, 
    }) async {
      throw UnimplementedError('removeTimer() has not been implemented.');
  }

  Future<void> clearTrackTimer() async {
      throw UnimplementedError('clearTrackTimer() has not been implemented.');
  }
}
