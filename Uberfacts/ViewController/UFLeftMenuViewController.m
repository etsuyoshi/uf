//
//  UFLeftMenuViewController.m
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/01/27.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//

#import "UFLeftMenuViewController.h"
#import "ViewController.h"
#import "UFSecondViewController.h"
#import "UFCategoryObject.h"
#import "UIColor+UFColor.h"


#define HEIGHT_CATEGORY_ROW 54

@interface UFLeftMenuViewController ()
@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation UFLeftMenuViewController{
    NSArray *arrCategories;
    NSMutableArray *arrTableLabels;
    
    int tableHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //google analytics
    self.screenName = @"menuView";
    
    
    
    // Do any additional setup after loading the view.
    arrTableLabels = [NSMutableArray arrayWithObjects:@"人気", nil];
    
    
    
    
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame =
    CGRectMake(0, 0, self.view.bounds.size.width*100,
               self.view.bounds.size.height*100);
    visualEffectView.center = self.view.center;
    [self.view addSubview:visualEffectView];

    
    self.tableView = ({
        UITableView *tableView =
        [[UITableView alloc]
         initWithFrame:
         CGRectMake(0, (self.view.frame.size.height - HEIGHT_CATEGORY_ROW * arrTableLabels.count) / 2.0f,
                    self.view.frame.size.width, HEIGHT_CATEGORY_ROW * arrTableLabels.count)
         style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    
    arrCategories = [NSArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    arrCategories = [UFCommonMethods getArrayKeyChainStore:@"categories"];
    
    
    //このビューが呼ばれた時点でデバイスに保存されていない場合はリアルタイムで読み込む
    if(arrCategories.count == 1){
        
        
        
    }else{
        [self setTableviewReload];
    }
    
}

-(void)setTableviewReload{
    
    NSLog(@"arrCategories = %@", arrCategories);
    for(UFCategoryObject *category in arrCategories){
        if([category isKindOfClass:[UFCategoryObject class]]){
            NSLog(@"category = %@(%@:%@)", category.strTitle,category.strId,category.strSlug);
            [arrTableLabels addObject:category.strTitle];
        }
    }
    
    
    int heightTable = MIN(HEIGHT_CATEGORY_ROW*(arrTableLabels.count),
                          self.view.bounds.size.height);
    
    self.tableView.frame =
    CGRectMake(0, (self.view.bounds.size.height-heightTable)/2.0f,
               self.view.bounds.size.width,
               heightTable);
    
    [self.tableView reloadData];
    [self.view addSubview:self.tableView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *strTopArticle = @"人気記事";
    NSString *strSendMessage =
    (indexPath.row == 0)?strTopArticle:arrCategories[indexPath.row-1];
    //どこのカテゴリを見ているのか
    id<GAITracker> tracker =
    [[GAI sharedInstance] defaultTracker];
    [tracker send:
     [[GAIDictionaryBuilder
       createEventWithCategory:@"MenuView"
       action:[NSString stringWithFormat:@"tapped:%@", strSendMessage]
       label:nil
       value:nil] build]];
    
    if(indexPath.row < arrCategories.count+1){//最上段が最新,それ以外は各カテゴリ
        ViewController *vc = [[ViewController alloc]init];
        
        if(indexPath.row == 0){
            vc.strSlug = @"popular";//人気記事はgoogle analytics対応のため
            vc.title = strTopArticle;
        }else if(indexPath.row-1 < arrCategories.count){
            int categoryNo = (int)indexPath.row-1;
            UFCategoryObject *obj = arrCategories[categoryNo];
            vc.strSlug = obj.strSlug;
            vc.title = obj.strTitle;
        }
        
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        [UFCommonMethods setNavigationBar:navigationController.navigationBar];        
        
        [self.sideMenuViewController
         setContentViewController:
         navigationController
//         [[UINavigationController alloc]
//          initWithRootViewController:vc]
         animated:YES];
        [self.sideMenuViewController
         hideMenuViewController];
        
    }
    
//    
//    switch (indexPath.row) {
//        case 0:{
//            UFCategoryObject *obj = arrCategories[indexPath.row];
//            ViewController *vc = [[ViewController alloc]init];
////            vc.strSlug = obj.strSlug;//newest
//            [self.sideMenuViewController
//             setContentViewController:
//             [[UINavigationController alloc]
//              initWithRootViewController:vc]
//             animated:YES];
//            [self.sideMenuViewController
//             hideMenuViewController];
//            break;
//        }
//        case 1:
//            [self.sideMenuViewController
//             setContentViewController:
//             [[UINavigationController alloc]
//              initWithRootViewController:
//              [[UFSecondViewController alloc] init]]
//             animated:YES];
//            [self.sideMenuViewController
//             hideMenuViewController];
//            break;
//        default:
//            break;
//    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_CATEGORY_ROW;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    NSLog(@"return category count = %d", (int)arrTableLabels.count);
    //人気（最新記事)とカテゴリ
//    return arrCategories.count+1;
    return arrTableLabels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
//    NSArray *titles = @[@"Home", @"Calendar", @"Profile", @"Settings", @"Log Out"];
    NSArray *images = @[@"IconHome", @"IconCalendar", @"IconProfile", @"IconSettings", @"IconEmpty"];
    if(indexPath.row == 0){
        cell.textLabel.text = @"人気";
    }else if(indexPath.row-1 < arrCategories.count){
        
//        cell.textLabel.text = ((UFCategoryObject *)arrCategories[indexPath.row-1]).strTitle;//titles[indexPath.row];
        cell.textLabel.text = arrTableLabels[indexPath.row];
        
        cell.imageView.image = [UIImage imageNamed:images[(indexPath.row-1) % images.count]];
    }
    
    return cell;
}


@end
