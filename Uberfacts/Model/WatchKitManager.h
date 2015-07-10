//
//  WatchKitManager.h
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/07/10.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface WatchKitManager : NSObject

- (void)handleWatchKitRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply;

@end