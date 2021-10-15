#import "GrowingioSdkAutotrackerPlugin.h"
#import <GrowingAnalytics-cdp/GrowingAutotracker.h>
#import <GrowingAnalytics/GrowingEventManager.h>
#import <GrowingAnalytics/GrowingViewElementEvent.h>
#import <GrowingAnalytics/GrowingPageEvent.h>
#import <GrowingAnalytics/GrowingFlutterPlugin.h>

@implementation GrowingioSdkAutotrackerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"growingio_sdk_autotracker_plugin"
            binaryMessenger:[registrar messenger]];
  GrowingioSdkAutotrackerPlugin* instance = [[GrowingioSdkAutotrackerPlugin alloc] init];
    [GrowingFlutterPlugin sharedInstance].onNativeCircleStart = ^{
        [channel invokeMethod:@"WebCircle" arguments:@YES];
    };
    [GrowingFlutterPlugin sharedInstance].onNativeCircleStop = ^{
        [channel invokeMethod:@"WebCircle" arguments:@NO];
    };
    
    
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
        [[GrowingEventManager sharedInstance] postEventBuidler:builder];
    }else if ([methodName isEqualToString:@"flutterWebCircleEvent"]) {
        NSLog(@"flutterWebCircleEvent %@",argDic);
        if ([GrowingFlutterPlugin sharedInstance].onFlutterCircleData) {
            [GrowingFlutterPlugin sharedInstance].onFlutterCircleData(argDic);
        }else {
            NSLog(@"flutterWebCircleEvent未检测到开始圈选，数据无法传输");
        }

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
        [[GrowingEventManager sharedInstance] postEventBuidler:builder];
}

@end
