#import "GrowingioSdkAutotrackerPlugin.h"
#import "GrowingAutotracker.h"
#import "GrowingEventFilter.h"
#import "GrowingFieldsIgnore.h"

@implementation GrowingioSdkAutotrackerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"growingio_sdk_autotracker"
            binaryMessenger:[registrar messenger]];
  GrowingioSdkAutotrackerPlugin* instance = [[GrowingioSdkAutotrackerPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"startWithConfiguration" isEqualToString:call.method]) {
      NSDictionary *arguments = call.arguments;
      NSString *projectId = arguments[@"projectId"];
      GrowingAutotrackConfiguration *configuration = [GrowingAutotrackConfiguration configurationWithProjectId:projectId];
      NSString *dataCollectionServerHost = arguments[@"dataCollectionServerHost"];
      configuration.dataCollectionServerHost = dataCollectionServerHost;

      NSString *dataSourceId = arguments[@"dataSourceId"];
      if (dataSourceId && dataSourceId.length > 0) {
          configuration.dataSourceId = dataSourceId;
      }

      NSString *urlScheme = arguments[@"urlScheme"];
      if (urlScheme && urlScheme.length > 0) {
          configuration.urlScheme = urlScheme;
      }

      NSNumber *debugEnabled = arguments[@"debugEnabled"];
      if (debugEnabled) {
          configuration.debugEnabled = debugEnabled.boolValue;
      }

      NSNumber *dataCollectionEnabled = arguments[@"dataCollectionEnabled"];
      if (dataCollectionEnabled) {
          configuration.dataCollectionEnabled = dataCollectionEnabled.boolValue;
      }

      NSNumber *idMappingEnabled = arguments[@"idMappingEnabled"];
      if (idMappingEnabled) {
          configuration.idMappingEnabled = idMappingEnabled.boolValue;
      }

      NSNumber *encryptEnabled = arguments[@"encryptEnabled"];
      if (encryptEnabled) {
          configuration.encryptEnabled = encryptEnabled.boolValue;
      }

      NSNumber *cellularDataLimit = arguments[@"cellularDataLimit"];
      if (cellularDataLimit) {
          configuration.cellularDataLimit = cellularDataLimit.intValue;
      }

      NSNumber *dataUploadInterval = arguments[@"dataUploadInterval"];
      if (dataUploadInterval) {
          configuration.dataUploadInterval = dataUploadInterval.doubleValue;
      }

      NSNumber *sessionInterval = arguments[@"sessionInterval"];
      if (sessionInterval) {
          configuration.sessionInterval = sessionInterval.doubleValue;
      }

      NSNumber *excludeEvent = arguments[@"excludeEvent"];
      if (excludeEvent) {
          NSUInteger values = excludeEvent.intValue;
          if (values & (1 << 0)) {
            values |= GrowingFilterEventVisit;
          }
          if (values & (1 << 1)) {
            values |= GrowingFilterEventCustom;
          }
          if (values & (1 << 2)) {
            values |= GrowingFilterEventLoginUserAttributes;
          }
          if (values & (1 << 3)) {
            values |= GrowingFilterEventPage;
          }
          if (values & (1 << 4)) {
            values |= GrowingFilterEventAppClosed;
          }
          if (values & (1 << 5)) {
            values |= GrowingFilterEventViewClick;
          }
          if (values & (1 << 6)) {
            values |= GrowingFilterEventViewChange;
          }
          if (values & (1 << 7)) {
            values |= GrowingFilterEventFormSubmit;
          }
          if (values & (1 << 8)) {
            // values |= GrowingFilterEventActivate;
          }
          if (values & (1 << 9)) {
            values |= GrowingFilterEventReengage;
          }
          configuration.excludeEvent = values;
      }

      NSNumber *ignoreField = arguments[@"ignoreField"];
      if (ignoreField) {
          NSUInteger values = ignoreField.intValue;
          if (values & (1 << 0)) {
            values |= GrowingIgnoreFieldsNetworkState;
          }
          if (values & (1 << 1)) {
            values |= GrowingIgnoreFieldsScreenWidth;
          }
          if (values & (1 << 2)) {
            values |= GrowingIgnoreFieldsScreenHeight;
          }
          if (values & (1 << 3)) {
            values |= GrowingIgnoreFieldsDeviceBrand;
          }
          if (values & (1 << 4)) {
            values |= GrowingIgnoreFieldsDeviceModel;
          }
          if (values & (1 << 5)) {
            values |= GrowingIgnoreFieldsDeviceType;
          }
          configuration.ignoreField = values;
      }
      
      [GrowingAutotracker startWithConfiguration:configuration launchOptions:@{}];
  } else if ([@"trackCustomEvent" isEqualToString:call.method]) {
      NSDictionary *arguments = call.arguments;
      NSString *eventName = arguments[@"eventName"];
      NSDictionary *attributes = arguments[@"attributes"];
      if (eventName && attributes) {
          [[GrowingAutotracker sharedInstance] trackCustomEvent:eventName withAttributes:attributes];
      } else if (eventName) {
          [[GrowingAutotracker sharedInstance] trackCustomEvent:eventName];
      }
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
