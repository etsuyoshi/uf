//
//  AppDelegate.m
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/01/27.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//


#import "AppDelegate.h"
#import "UFLeftMenuViewController.h"
#import "UFRightMenuViewController.h"
#import "ViewController.h"
#import "UIColor+UFColor.h"
#import "UFCommonMethods.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Parse/Parse.h>
#import "WatchKitManager.h"
#define MY_BANNER_UNIT_ID @"ca-app-pub-2428023138794278/9842626946";

@interface AppDelegate ()

@property (nonatomic) WatchKitManager *watchKitManager;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //crashlytics(fabric)
    [Fabric with:@[CrashlyticsKit]];
    
    
    //push notification by parse
    [Parse setApplicationId:@"QiH48eKfXQ9Ov2ETtimZh1GAZNx9YokhNsXwdRxO"
                  clientKey:@"OUCUpHlqeBixQejh3wICTuf8kx3IMjWic37OCNdg"];
    
    
    //push notification settings
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    
    
    
    //ga
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-46945838-2"];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    UINavigationController *
    navigationController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    [UFCommonMethods setNavigationBar:navigationController.navigationBar];
////    [navigationController.navigationBar setBarTintColor:[UIColor MistyRoseColor]];//背景
////    [navigationController.navigationBar setBarTintColor:[UIColor HotPinkColor]];//背景
////    [navigationController.navigationBar setBarTintColor:[UIColor LightPinkColor]];//背景
//    [navigationController.navigationBar setBarTintColor:[UIColor JinBlackColor]];
////    [navigationController.navigationBar setBarTintColor:[UIColor PinkColor]];//背景
//    [navigationController.navigationBar setTintColor:[UIColor JinDarkPinkColor]];//文字
//    [navigationController.navigationBar setTranslucent:YES];
//    navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor JinDarkPinkColor]};
    
    
//    [UICKeyChainStore removeAllItems];//テスト
    
    UFLeftMenuViewController *leftMenuViewController = [[UFLeftMenuViewController alloc] init];
    //    UFRightMenuViewController *rightMenuViewController = [[UFRightMenuViewController alloc] init];
    
    RESideMenu *
    sideMenuViewController =
    [[RESideMenu alloc] initWithContentViewController:navigationController
                               leftMenuViewController:leftMenuViewController
                              rightMenuViewController:nil
     //                              rightMenuViewController:rightMenuViewController
     ];
    
    
    
    //sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"back2.jpg"];
    
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    self.window.rootViewController = sideMenuViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
    
    
}


//If the registration is successful, the callback method: <- parse needed
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}


/*
 *https://www.parse.com/tutorials/ios-push-notifications
 *When a push notification is received while the application is not in the foreground, it is displayed in the iOS Notification Center. However, if the notification is received while the app is active, it is up to the app to handle it. To do so, we can implement the [application:didReceiveRemoteNotification] method in the app delegate. In our case, we will simply ask Parse to handle it for us. Parse will create a modal alert and display the push notification's content.
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    /**********************************************************
     * set admob
     **********************************************************/
    
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    bannerView_.rootViewController = navigationController;//self.window.rootViewController;
    [self.window addSubview:bannerView_];
    
    GADRequest *request = [GADRequest request];
    [bannerView_ loadRequest:request];
    
    [bannerView_ setFrame:CGRectMake(0, 0, screenBounds.size.width, bannerView_.bounds.size.height)];
    bannerView_.center = CGPointMake(screenBounds.size.width / 2,
                                     screenBounds.size.height - (bannerView_.bounds.size.height / 2));
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    bannerView_ = nil;
}



//watch対応:handoffなど
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    
    NSLog(@"handleActionWithIdentifier:%@", identifier);
    
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
        // "Accept"した時の処理
    }
    else if ([identifier isEqualToString:@"answerAction"]){
        // Declineした時の処理
    }
    completionHandler();
}


-(void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply{
    
    [self.watchKitManager handleWatchKitRequest:userInfo reply:reply];
    
//    written by fshin2000 in base
//    // (1) ↓runUntilDate: でメソッドの実行時間までランループの終了を遅延させる
//    //[self performSelector:@selector(selectorFromBackground1) withObject:nil afterDelay:2.f];
//    //[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.f]]; // ←これがないとダメ。
//    
//    __block UIBackgroundTaskIdentifier bgTask = 0;
//    
//    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (bgTask != UIBackgroundTaskInvalid) {
//                [application endBackgroundTask:bgTask];
//                bgTask = UIBackgroundTaskInvalid;
//            }
//        });
//        
//    }];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // Background operations
//        
//        NSString * cmd = @"" ;
//        if (userInfo != nil)
//            cmd = [userInfo valueForKey:@"cmd"];
//        
//        
////        NSDictionary * loginInfo = [BSBASEAccountManager getStoreLoginInfo];
////        if (loginInfo != nil){
////            reply(@{@"loginInfo":loginInfo});
////        }else{
//            reply(@{});
////        }
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            
//            [application endBackgroundTask:bgTask];
//            bgTask = UIBackgroundTaskInvalid;
//            
//        });
//        
//    });
    
}

- (void)selectorFromBackground1
{
    NSLog(@"(B) %@", [NSThread currentThread]);
}

- (void)selectorFromBackground2
{
    NSLog(@"(C) %@", [NSThread currentThread]);
}




- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)activityType {
    NSLog(@"application:willContinueUserActivityWithType:");
    if ([activityType isEqualToString:@"com.endo.drtrivia.handoff"])
        return YES;
    return NO;
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType
              error:(NSError *)error {
    NSLog(@"application:didFailToContinueUserActivityWithType:error:");
    NSLog(@"%@", error);
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void(^)(NSArray *restorableObjects))restorationHandler {
    NSLog(@"application:continueUserActivity:restorationHandler:");
    
    NSLog(@"%@" ,userActivity.userInfo);
    _tmpHandledItemId = [userActivity.userInfo valueForKey:@"item_id"];
    if (_tmpHandledItemId != nil){
        
//        _pushedData = @{@"category":@"viewItem" , @"itemId" : _tmpHandledItemId};
//        NSNotification* n = [NSNotification notificationWithName:@"BASEPushCall" object:self userInfo:_pushedData];
//        [[NSNotificationCenter defaultCenter] postNotification:n];
    }
    
    restorationHandler(@[]);
    return YES;
}



@end
