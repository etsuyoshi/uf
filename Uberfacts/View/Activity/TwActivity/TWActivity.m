//
//  TWActivity.m
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/01/30.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//

#import "TWActivity.h"

@interface TWActivity ()
@end
@implementation TWActivity

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryShare;
}


- (id)init
{
    NSLog(@"%s", __func__);
    if (self = [super init]) {

    }
    return self;
}

- (NSString *)activityType
{
    return NSStringFromClass([self class]);
}

- (NSString *)activityTitle
{
    return @"Twitter";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"twitter_icon.png"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]] && [[UIApplication sharedApplication] canOpenURL:activityItem]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"%s", __func__);
    for (id activityItem in activityItems) {
//        [self addItem:activityItem];
        NSLog(@"activityitem = %@", activityItem);
    }
    
    
    
}

- (void)performActivity
{
    NSLog(@"%s", __func__);
    
}

@end