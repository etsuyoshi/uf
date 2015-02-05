//
//  ViewController.h
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/01/27.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "ContextMenuCell.h"
#import "YALContextMenuTableView.h"
//#import "YALNavigationBar.h"

//ga計測
#import "GAITrackedViewController.h"


@class GADBannerView;

//@interface ViewController : UIViewController
@interface ViewController : GAITrackedViewController
<
UIScrollViewDelegate
,UITableViewDelegate
,UITableViewDataSource
//,UIWebViewDelegate
,YALContextMenuTableViewDelegate
>

@property (strong, nonatomic) GADBannerView  *bannerView;

@property (nonatomic, strong) YALContextMenuTableView* contextMenuTableView;
@property (nonatomic, strong) NSString *strSlug;

@end

