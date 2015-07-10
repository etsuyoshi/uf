//
//  UFCommonMethods.h
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/01/27.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UICKeyChainStore.h"

@interface UFCommonMethods : NSObject

+(BOOL)isNullComparedToObj:(id)obj;
+(NSString *)getBundleId;
+(NSString *)getStringKeyChainStore:(NSString *)strKey;
+(id)getObjectKeyChainStore:(NSString *)strKey;
+(NSArray *)getArrayKeyChainStore:(NSString *)strKey;
+(NSDictionary *)getDictionayKeyChainStore:(NSString *)strKey;


+(BOOL)setKeyChainStoreWithStringValue:(NSString *)strValue
                                 asKey:(NSString *)strKey;


+(BOOL)setKeyChainStoreWithObjectValue:(id)objValue
                                 asKey:(NSString *)strKey;

+(void)setNavigationBar:(UINavigationBar*)navBar;

+(NSMutableArray *)getSortedById:(NSMutableArray *)arrayArg;
+(NSMutableAttributedString *)getAttributedString:(NSString *)text
                                   withLineHeight:(float)customLineHeight;
@end
