//
//  InterfaceController.m
//  Dr.Trivia WatchKit Extension
//
//  Created by EndoTsuyoshi on 2015/07/03.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//  http://iscene.jimdo.com/2015/04/08/apple-watch-table-view-テーブル一覧-の作成/

#import "FirstInterfaceController.h"
#import "FirstTableRowController.h"
#import "SecondInterfaceController.h"

@interface FirstInterfaceController()

@property (nonatomic, weak) IBOutlet WKInterfaceTable *firstTable;

@property (nonatomic, strong) NSArray *arrImageNames;
@property (nonatomic, strong) NSArray *arrStrLabels;


@end


@implementation FirstInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    
    NSLog(@"%s", __func__);
    [self loadTableData];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    
    NSLog(@"%s", __func__);
    NSDictionary *userInfo = @{@"command": @"hello"};
    
    // iPhoneにリクエストを投げる
    [WKInterfaceController
     openParentApplication:userInfo
     reply:^(NSDictionary *replyInfo, NSError *error) {
        // 結果が返ってきたとき
        NSLog(@"結果が返ってきたとき:%@", replyInfo);
        if (replyInfo) {
            
            NSString *result = replyInfo[@"result"];
            // エラー時
            if ([result isEqualToString:@"error"]) {
                NSLog(@"エラー時の対応");
                // エラー理由の表示
                NSString *message = replyInfo[@"message"];
                if (message) {
                    NSLog(@"error: %@", message);
                    
                }
                return;
            }
            
            // 成功時
            if ([result isEqualToString:@"success"]) {
                // 応答文の表示
                NSLog(@"応答時の対応");
                NSString *message = replyInfo[@"message"];
                if (message) {
                    NSLog(@"success: %@", message);
                }
                return;
            }
        }
    }];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


- (void)loadTableData{
    //images.xcassets
    self.arrImageNames = @[@"loadingImage", @"loadingImage", @"loadingImage"];
    self.arrStrLabels = @[@"トリビア1", @"トリビア2", @"トリビア3"];
    
    //テーブル行数設定
    [self.firstTable setNumberOfRows:self.arrImageNames.count withRowType:@"default"];
    
    //テーブルの要素設定
    [self.arrStrLabels enumerateObjectsUsingBlock:^(NSString *strLabel, NSUInteger idx, BOOL *stop){
//        @autoreleasepool {
        
            //テーブル行の設定
            FirstTableRowController *row =
            [self.firstTable rowControllerAtIndex:idx];
            
            
            [row.imageWatch setImageNamed:self.arrImageNames[idx]];
            [row.labelWatch setText:strLabel];
            
//        }
    }];
}


//tapされた時の挙動:入力されたidentifierに対応するviewcontrollerにcontextを渡す
-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex{
    [self presentControllerWithName:@"secondInterfaceController"
                            context:self.arrImageNames[rowIndex]];
}

@end



