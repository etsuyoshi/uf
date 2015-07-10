//
//  WatchKitManager.m
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/07/10.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//
#import "WatchKitManager.h"

@interface WatchKitManager ()

// WatchKitManagerがどのタイミングでも応答できるようにblockをプロパティで保持する
@property (nonatomic, copy) void (^reply)(NSDictionary *);

@end

@implementation WatchKitManager

- (void)handleWatchKitRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply {
    
    // エラーハンドリング
    if (!userInfo) {
        NSDictionary *replyInfo = @{@"result": @"error",
                                    @"message": @"userInfo is nil"};
        reply(replyInfo);
        return;
    }
    
    // WatchKitへの応答を自由なタイミングで実行するためにプロパティに保持する
    self.reply = reply;
    
    if (userInfo[@"command"]) {
        if ([userInfo[@"command"] isEqualToString:@"hello"]) {
            
            // 通信や遅延処理をする
            // ...
            // 実行した後にプロパティに保持した応答用のblock文replyを使用する
            NSDictionary *replyInfo = @{@"result": @"success",
                                        @"message": @"hello!!"};
            self.reply(replyInfo);
        }
    }
}

@end