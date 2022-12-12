
import 'growingio_sdk_autotracker_platform_interface.dart';

class GrowingioSdkAutotracker {
  Future<String?> getPlatformVersion() {
    return GrowingioSdkAutotrackerPlatform.instance.getPlatformVersion();
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
}
