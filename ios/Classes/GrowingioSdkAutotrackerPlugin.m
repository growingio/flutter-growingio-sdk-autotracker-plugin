#import "GrowingioSdkAutotrackerPlugin.h"
#import <GrowingAnalytics/GrowingAutotracker.h>
#import <GrowingAnalytics/GrowingEventManager.h>
#import <GrowingAnalytics/GrowingViewElementEvent.h>
#import <GrowingAnalytics/GrowingPageEvent.h>

@implementation GrowingioSdkAutotrackerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"growingio_sdk_autotracker_plugin"
            binaryMessenger:[registrar messenger]];
  GrowingioSdkAutotrackerPlugin* instance = [[GrowingioSdkAutotrackerPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  [self methodName:call.method andArguments:call.arguments];
}

//打点事件方法
- (BOOL)methodName:(NSString *)methodName andArguments:(id)arguments{
    NSDictionary *argDic = arguments ;
    if ([methodName isEqualToString:@"trackCustomEvent"]) {
        NSString *eventID = argDic[@"eventId"];
        NSDictionary *variable = argDic[@"variable"];
        NSNumber *num = (NSNumber *)argDic[@"num"];
        if (eventID && variable){
            [[GrowingAutotracker sharedInstance] trackCustomEvent:eventID withAttributes:variable];
        }else if (eventID){
            [[GrowingAutotracker sharedInstance] trackCustomEvent:eventID];
        }
    }else if ([methodName isEqualToString:@"setLoginUserAttributes"]) {
        NSLog(@"Handler setLoginUserAttributes");
        [[GrowingAutotracker sharedInstance] setLoginUserAttributes:argDic];
    }else if ([methodName isEqualToString:@"setVisitorAttributes"]) {
        [[GrowingAutotracker sharedInstance] setVisitorAttributes:argDic];
    }else if ([methodName isEqualToString:@"setConversionVariables"]) {
        [[GrowingAutotracker sharedInstance] setVisitorAttributes:argDic];
    }else if ([methodName isEqualToString:@"setLoginUserId"]) {
        NSString *userId = argDic[@"userId"];
        [[GrowingAutotracker sharedInstance] setLoginUserId:userId];
    }else if ([methodName isEqualToString:@"cleanLoginUserId"]) {
        [[GrowingAutotracker sharedInstance] cleanLoginUserId];
    }else if ([methodName isEqualToString:@"flutterClickEvent"]) {
        [self handleViewElementEvent:GrowingEventTypeViewClick arguments:argDic];
    }else if ([methodName isEqualToString:@"flutterViewChangeEvent"]) {
             [self handleViewElementEvent:GrowingEventTypeViewChange arguments:argDic];
    }else if ([methodName isEqualToString:@"flutterPageEvent"]) {
        long long ts = ((NSNumber *)argDic[@"timestamp"]).longLongValue;
        GrowingBaseBuilder *builder =
            GrowingPageEvent.builder.setTitle(argDic[@"title"]).setPath(argDic[@"path"]).setTimestamp(ts);
        [[GrowingEventManager shareInstance] postEventBuidler:builder];
    }else {
        return NO;
    }
    return YES;
}

- (void)handleViewElementEvent:(NSString *)eventType arguments:(NSDictionary *)argDic {
        int index = ((NSNumber *)argDic[@"index"]).intValue;
        long long ts = ((NSNumber *)argDic[@"pageShowTimestamp"]).longLongValue;
        GrowingBaseBuilder *builder = GrowingViewElementEvent.builder.setEventType(GrowingEventTypeViewClick)
         .setPath(argDic[@"path"])
         .setPageShowTimestamp(ts)
         .setXpath(argDic[@"xpath"])
         .setIndex(index)
        .setTextValue(argDic[@"textValue"]);
        [[GrowingEventManager shareInstance] postEventBuidler:builder];
}

@end
