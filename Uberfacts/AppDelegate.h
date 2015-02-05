//
//  AppDelegate.h
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/01/27.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import <GoogleAnalytics-iOS-SDK/GAILogger.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, RESideMenuDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

