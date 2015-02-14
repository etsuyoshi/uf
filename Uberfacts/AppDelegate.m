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


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-46945838-2"];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    [UFCommonMethods setNavigationBar:navigationController.navigationBar];
////    [navigationController.navigationBar setBarTintColor:[UIColor MistyRoseColor]];//背景
////    [navigationController.navigationBar setBarTintColor:[UIColor HotPinkColor]];//背景
////    [navigationController.navigationBar setBarTintColor:[UIColor LightPinkColor]];//背景
//    [navigationController.navigationBar setBarTintColor:[UIColor JinBlackColor]];
////    [navigationController.navigationBar setBarTintColor:[UIColor PinkColor]];//背景
//    [navigationController.navigationBar setTintColor:[UIColor JinDarkPinkColor]];//文字
//    [navigationController.navigationBar setTranslucent:YES];
//    navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor JinDarkPinkColor]};
    
    [UICKeyChainStore removeAllItems];//test
    
    [[UFSessionManager sharedClient]
     getCategoriesWithCompletion:^(NSDictionary *results,
                                   NSURLSessionDataTask *task,
                                   NSError *error){
         if([UFCommonMethods isNullComparedToObj:error]){
             NSLog(@"results = %@", results);
             
             NSLog(@"categories = %@", results[STRING_API_OUTPUT_LABEL_CATEGORIES]);
             
             //カテゴリ配列が取得できたらkeychainに格納してmenu viewcontrollerで表示できるようにする
             
             NSMutableArray *arrayMenu = [NSMutableArray array];
             for(NSDictionary *dictCategory in results[STRING_API_OUTPUT_LABEL_CATEGORIES]){
                 [arrayMenu addObject:[[UFCategoryObject alloc] initWithDictionary:dictCategory]];
             }
             
             arrayMenu = [UFCommonMethods getSortedById:arrayMenu];
             for(int i =0;i < arrayMenu.count;i++){
                 UFCategoryObject *obj = arrayMenu[i];
                 NSLog(@"1i=%d, id=%@, title=%@", i, obj.strId, obj.strTitle);
             }
             
             //            results[STRING_API_OUTPUT_LABEL_CATEGORIES];//[NSMutableArray array];
             [UFCommonMethods
              setKeyChainStoreWithObjectValue:(NSArray *)arrayMenu
              asKey:@"categories"];
             
             NSArray *returnArray =
             [UFCommonMethods
              getArrayKeyChainStore:@"categories"];
             for(int i =0;i < returnArray.count;i++){
                 NSLog(@"i = %d, obj = %@, id = %@, slug = %@", i, returnArray[i],
                       ((UFCategoryObject *)returnArray[i]).strId,
                       ((UFCategoryObject *)returnArray[i]).strSlug);
             }
             
             for(NSDictionary *dictionary in results[STRING_API_OUTPUT_LABEL_CATEGORIES]){
                 NSLog(@"dictionary = %@", dictionary);
                 
             }
             
             
         }else{//エラーの場合
             [SVProgressHUD showErrorWithStatus:@"カテゴリ情報が取得できませんでした"];
             NSLog(@"error = %@", error);
         }
     }];

    
    
    
    UFLeftMenuViewController *leftMenuViewController = [[UFLeftMenuViewController alloc] init];
//    UFRightMenuViewController *rightMenuViewController = [[UFRightMenuViewController alloc] init];
    
    RESideMenu *sideMenuViewController =
    [[RESideMenu alloc] initWithContentViewController:navigationController
                               leftMenuViewController:leftMenuViewController
                              rightMenuViewController:nil
//                              rightMenuViewController:rightMenuViewController
     ];
    
    
    
    //sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"back2.jpg"];
    
//    UIImageView *imv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"condome"]];
//    
//    UIVisualEffect *blurEffect;
//    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *visualEffectView;
//    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    visualEffectView.frame = sideMenuViewController.view.bounds;
//    [imv addSubview:visualEffectView];
    
    //[sideMenuViewController.view addSubview:visualEffectView];
//    [sideMenuViewController.view sendSubviewToBack:visualEffectView];
    
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
    
    
//    return YES;
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
