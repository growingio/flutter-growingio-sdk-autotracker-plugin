//
//  GrowingioSdkAutotrackerPlugin.m
//  GrowingAnalytics
//
//  Created by xiangyang on 2022/12/13.
//  Copyright (C) 2023 Beijing Yishu Technology Co., Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "GrowingioSdkAutotrackerPlugin.h"
#import "GrowingAutotracker.h"
#import "GrowingEventFilter.h"
#import "GrowingFieldsIgnore.h"

@implementation GrowingioSdkAutotrackerPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"growingio_sdk_autotracker"
                                                                binaryMessenger:[registrar messenger]];
    GrowingioSdkAutotrackerPlugin* instance = [[GrowingioSdkAutotrackerPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"startWithConfiguration" isEqualToString:call.method]) {
        [self startWithConfiguration:call.arguments];
    } else if ([@"setDataCollectionEnabled" isEqualToString:call.method]) {
        [self setDataCollectionEnabled:call.arguments];
    } else if ([@"setLoginUserId" isEqualToString:call.method]) {
        [self setLoginUserId:call.arguments];
    } else if ([@"cleanLoginUserId" isEqualToString:call.method]) {
        [self cleanLoginUserId];
    } else if ([@"setLocation" isEqualToString:call.method]) {
        [self setLocation:call.arguments];
    } else if ([@"cleanLocation" isEqualToString:call.method]) {
        [self cleanLocation];
    } else if ([@"setLoginUserAttributes" isEqualToString:call.method]) {
        [self setLoginUserAttributes:call.arguments];
    }else if ([@"getDeviceId" isEqualToString:call.method]) {
        result([self getDeviceId]);
    } else if ([@"trackCustomEvent" isEqualToString:call.method]) {
        [self trackCustomEvent:call.arguments];
    } else if ([@"trackTimerStart" isEqualToString:call.method]) {
        result([self trackTimerStart:call.arguments]);
    } else if ([@"trackTimerPause" isEqualToString:call.method]) {
        [self trackTimerPause:call.arguments];
    } else if ([@"trackTimerResume" isEqualToString:call.method]) {
        [self trackTimerResume:call.arguments];
    } else if ([@"trackTimerEnd" isEqualToString:call.method]) {
        [self trackTimerEnd:call.arguments];
    } else if ([@"removeTimer" isEqualToString:call.method]) {
        [self removeTimer:call.arguments];
    } else if ([@"clearTrackTimer" isEqualToString:call.method]) {
        [self clearTrackTimer];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)startWithConfiguration:(NSDictionary *)arguments {
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
        NSUInteger result = 0;
        if (values & (1 << 0)) {
            result |= GrowingFilterEventVisit;
        }
        if (values & (1 << 1)) {
            result |= GrowingFilterEventCustom;
        }
        if (values & (1 << 2)) {
            result |= GrowingFilterEventLoginUserAttributes;
        }
        if (values & (1 << 3)) {
            result |= GrowingFilterEventPage;
        }
        if (values & (1 << 4)) {
            result |= GrowingFilterEventAppClosed;
        }
        if (values & (1 << 5)) {
            result |= GrowingFilterEventViewClick;
        }
        if (values & (1 << 6)) {
            result |= GrowingFilterEventViewChange;
        }
        if (values & (1 << 7)) {
            result |= GrowingFilterEventFormSubmit;
        }
        if (values & (1 << 8)) {
            //result |= GrowingFilterEventActivate;
        }
        if (values & (1 << 9)) {
            result |= GrowingFilterEventReengage;
        }
        configuration.excludeEvent = result;
    }

    NSNumber *ignoreField = arguments[@"ignoreField"];
    if (ignoreField) {
        NSUInteger values = ignoreField.intValue;
        NSUInteger result = 0;
        if (values & (1 << 0)) {
            result |= GrowingIgnoreFieldsNetworkState;
        }
        if (values & (1 << 1)) {
            result |= GrowingIgnoreFieldsScreenWidth;
        }
        if (values & (1 << 2)) {
            result |= GrowingIgnoreFieldsScreenHeight;
        }
        if (values & (1 << 3)) {
            result |= GrowingIgnoreFieldsDeviceBrand;
        }
        if (values & (1 << 4)) {
            result |= GrowingIgnoreFieldsDeviceModel;
        }
        if (values & (1 << 5)) {
            result |= GrowingIgnoreFieldsDeviceType;
        }
        configuration.ignoreField = result;
    }
    
    [GrowingAutotracker startWithConfiguration:configuration launchOptions:@{}];
}

- (void)setDataCollectionEnabled:(NSNumber *)argument {
    BOOL enabled = argument.boolValue;
    [[GrowingAutotracker sharedInstance] setDataCollectionEnabled:enabled];
}

- (void)setLoginUserId:(NSDictionary *)arguments {
    NSString *userId = arguments[@"userId"];
    NSString *userKey = arguments[@"userKey"];
    if (userKey && userKey.length > 0) {
        [[GrowingAutotracker sharedInstance] setLoginUserId:userId userKey:userKey];
    } else {
        [[GrowingAutotracker sharedInstance] setLoginUserId:userId];
    }
}

- (void)cleanLoginUserId {
    [[GrowingAutotracker sharedInstance] cleanLoginUserId];
}

- (void)setLocation:(NSDictionary *)arguments {
    NSNumber *latitude = arguments[@"latitude"];
    NSNumber *longitude = arguments[@"longitude"];
    [[GrowingAutotracker sharedInstance] setLocation:latitude.doubleValue longitude:longitude.doubleValue];
}

- (void)cleanLocation {
    [[GrowingAutotracker sharedInstance] cleanLocation];
}

- (void)setLoginUserAttributes:(NSDictionary *)arguments {
    [[GrowingAutotracker sharedInstance] setLoginUserAttributes:arguments];
}

- (NSString *)getDeviceId {
    return [[GrowingAutotracker sharedInstance] getDeviceId];
}

- (void)trackCustomEvent:(NSDictionary *)arguments {
    NSString *eventName = arguments[@"eventName"];
    NSDictionary *attributes = arguments[@"attributes"];
    if (eventName && attributes) {
        [[GrowingAutotracker sharedInstance] trackCustomEvent:eventName withAttributes:attributes];
    } else if (eventName) {
        [[GrowingAutotracker sharedInstance] trackCustomEvent:eventName];
    }
}

- (NSString *)trackTimerStart:(NSString *)eventName {
    NSString *timerId = [[GrowingAutotracker sharedInstance] trackTimerStart:eventName];
    return timerId;
}

- (void)trackTimerPause:(NSString *)timerId {
    [[GrowingAutotracker sharedInstance] trackTimerPause:timerId];
}

- (void)trackTimerResume:(NSString *)timerId {
    [[GrowingAutotracker sharedInstance] trackTimerResume:timerId];
}

- (void)trackTimerEnd:(NSDictionary *)arguments {
    NSString *timerId = arguments[@"timerId"];
    NSDictionary *attributes = arguments[@"attributes"];
    if (timerId && attributes) {
        [[GrowingAutotracker sharedInstance] trackTimerEnd:timerId withAttributes:attributes];
    } else if (timerId) {
        [[GrowingAutotracker sharedInstance] trackTimerEnd:timerId];
    }
}

- (void)removeTimer:(NSString *)timerId {
    [[GrowingAutotracker sharedInstance] removeTimer:timerId];
}

- (void)clearTrackTimer {
    [[GrowingAutotracker sharedInstance] clearTrackTimer];
}

@end
