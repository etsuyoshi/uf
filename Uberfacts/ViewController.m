//
//  ViewController.m
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/01/27.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//

#import <Social/Social.h>
#import <Twitter/Twitter.h>

//admob広告
#import "GADBannerView.h"
#import "GADRequest.h"




#import "ViewController.h"
#import "UFSessionManager.h"
#import "UFCommonMethods.h"
#import "SVProgressHUD.h"
#import "UICKeyChainStore.h"
#import "UFCategoryObject.h"
#import "UFArticleObject.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LINEActivity.h"
#import "TwActivity.h"
#import "UIColor+UFColor.h"
#define HEIGHT_IMAGE 200
#define NUM_OF_CONTENTS 3
#define HEIGHT_NAV_BAR 64
#define HEIGHT_FOOTER_BAR 64
#define SIZE_LABEL_ORDINARY 26.f
#define SIZE_LABEL_SMALL 22.f
#define SIZE_LABEL_VERY_SMALL 15.f

#define STRING_LINE @"LINE"
#define STRING_TWITTER @"Twitter"
#define STRING_FACEBOOK @"Facebook"
#define STRING_INSTAGRAM @"Instagram"


static NSString *const menuCellIdentifier = @"rotationCell";

//http://blog.excite.co.jp/spdev/19907423/

//http://xoyip.hatenablog.com/entry/2014/05/26/200000
//https://github.com/OopsMouse/LINEActivity
//http://stackoverflow.com/questions/23445582/how-to-change-items-positions-in-uiacitivityviewcontroller
//https://books.google.co.jp/books?id=qJZiAwAAQBAJ&pg=PA327&lpg=PA327&dq=uiactivityviewcontroller+line+%E9%80%A3%E6%90%BA&source=bl&ots=qnWjBRUI39&sig=Pa93jJGkiv3F3FSG8kCtQTr3278&hl=ja&sa=X&ei=iWTKVN3hJ4LpmQWuyoCABQ&ved=0CEIQ6AEwBQ#v=onepage&q=uiactivityviewcontroller%20line%20%E9%80%A3%E6%90%BA&f=false
//http://zutto-megane.com/objective-c/post-367/

@interface ViewController ()

@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuIcons;


@end

@implementation ViewController{
    UIScrollView *scrollView;
    NSMutableArray *arrArticle;
    UIView *viewUnderRight;
    UIView *viewUnderMiddle;
    UIView *viewUnderLeft;
    UIImageView *imageTopLeft;
    UIImageView *imageTopMiddle;
    UIImageView *imageTopRight;
    UILabel *lblTextLeft;
    UILabel *lblTextMiddle;
    UILabel *lblTextRight;
    
    int currIndex;
    int nextIndex;
    int prevIndex;
    
    int marginImageText;
    
    CGRect rectFrame;
    
    
    NSMutableArray *arrImages;//予備で用意した画像
    UIFont *fontOrdinary;
    UIFont *fontSmall;
    UIFont *fontVerySmall;
}

-(void)initWithMenuOption{
    
    self.menuTitles = @[@"",//close
                        STRING_LINE,
                        STRING_TWITTER,
                        STRING_FACEBOOK,
                        STRING_INSTAGRAM];
                        
//                        @"Like profile",
//                        @"Add to friends",
//                        @"Add to favourites",
//                        @"Block user"];
    
    self.menuIcons = @[[UIImage imageNamed:@"Icnclose"],
                       [UIImage imageNamed:@"LINEActivityIcon"],
                       [UIImage imageNamed:@"twitter"],//twitter
                       [UIImage imageNamed:@"LikeIcn"],
                       [UIImage imageNamed:@"insta"]];
    
//    self.menuIcons = @[[UIImage imageNamed:@"Icnclose"],
//                       [UIImage imageNamed:@"SendMessageIcn"],
//                       [UIImage imageNamed:@"LikeIcn"],
//                       [UIImage imageNamed:@"AddToFriendsIcn"],
//                       [UIImage imageNamed:@"AddToFavouritesIcn"],
//                       [UIImage imageNamed:@"BlockUserIcn"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.screenName = @"first view";
    
    
    
    [SVProgressHUD showWithStatus:@"更新中.."
                         maskType:SVProgressHUDMaskTypeGradient];
    [self initWithMenuOption];
    
    arrImages = [NSMutableArray array];
    for(int i = 0;i < 13;i++){
        [arrImages addObject:[NSString stringWithFormat:@"h%d.jpg", i]];
    }
    
//    self.title = [UFCommonMethods isNullComparedToObj:self.strSlug]?@"Newest":self.strSlug;
    self.title = [UFCommonMethods isNullComparedToObj:self.title]?@"人気記事":self.title;
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"メニュー"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"シェア"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(presentMenuButtonTapped:)];
//                                    action:@selector(presentRightMenuViewController:)];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    imageView.image = [UIImage imageNamed:@"Balloon"];
//    [self.view addSubview:imageView];
    
    
    arrArticle = [NSMutableArray array];
    //テスト：実際には記事モデルオブジェクトを格納する（出力側も考慮する)
//    for(int i = 0;i < 100;i ++){
//        NSString *str = [NSString stringWithFormat:@"obj:%d", i];
//        [arrArticle addObject:str];
//    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    scrollView =
    [[UIScrollView alloc]
     initWithFrame:
     CGRectMake(0, 0, self.view.bounds.size.width,
                self.view.bounds.size.height
                -HEIGHT_FOOTER_BAR
                )];
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    [scrollView setBounces:NO];
    scrollView.delegate = self;

    
//    UIWebView *webView = [[UIWebView alloc]initWithFrame:
//                          CGRectMake(i*self.view.bounds.size.width,0,
//                                     self.view.bounds.size.width,
//                                     self.view.bounds.size.height)];
//    NSURL *url = [NSURL URLWithString:
//                  [NSString stringWithFormat:@"http://pocketti.zombie.jp/trivia/%d", i+1]];
//    NSURLRequest *req = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:req];
//    webView.delegate = self;
//    [scrollView addSubview:webView];
    
    
//    float goldRatio = 5.f/8.f;
    CGRect rectImage = CGRectMake(0, 0, self.view.bounds.size.width,
                                  self.view.bounds.size.width*6.f/5.f-64);
//                                  self.view.bounds.size.width * goldRatio);
    imageTopLeft = [[UIImageView alloc]initWithFrame:rectImage];
    imageTopMiddle = [[UIImageView alloc]initWithFrame:rectImage];
//    imageTopMiddle.backgroundColor = [UIColor redColor];
    imageTopRight = [[UIImageView alloc]initWithFrame:rectImage];
    
    imageTopLeft.clipsToBounds = YES;
    imageTopMiddle.clipsToBounds = YES;
    imageTopRight.clipsToBounds = YES;
    
    imageTopLeft.contentMode = UIViewContentModeScaleAspectFill;
    imageTopMiddle.contentMode = UIViewContentModeScaleAspectFill;
    imageTopRight.contentMode = UIViewContentModeScaleAspectFill;
    
    
    int margin = 10;
    marginImageText = 18;
    rectFrame = CGRectMake(margin, imageTopLeft.bounds.size.height+marginImageText,
                           self.view.bounds.size.width-2*margin,
                           self.view.bounds.size.height-imageTopLeft.bounds.size.height);
    
    float heightLabel = self.view.bounds.size.height - HEIGHT_NAV_BAR - margin;
    CGRect rectLabel = CGRectMake(0, rectImage.size.height,
                                  self.view.bounds.size.width,
                                  heightLabel);
    lblTextLeft = [[UILabel alloc] initWithFrame:rectLabel];
    lblTextMiddle = [[UILabel alloc] initWithFrame:rectLabel];
    lblTextRight = [[UILabel alloc] initWithFrame:rectLabel];
    lblTextLeft.backgroundColor = [UIColor clearColor];
    lblTextMiddle.backgroundColor = [UIColor clearColor];
    lblTextRight.backgroundColor = [UIColor clearColor];
    
    UIColor *colorLabel = [UIColor colorWithRed:68.f/255.f green:68.f/255.f blue:68.f/255.f alpha:1.f];
    lblTextLeft.textColor = colorLabel;
    lblTextMiddle.textColor = colorLabel;
    lblTextRight.textColor = colorLabel;
    
    fontOrdinary = [UIFont italicSystemFontOfSize:SIZE_LABEL_ORDINARY];
    fontSmall = [UIFont italicSystemFontOfSize:SIZE_LABEL_SMALL];
    fontVerySmall = [UIFont italicSystemFontOfSize:SIZE_LABEL_VERY_SMALL];
    
    
    lblTextLeft.font = fontOrdinary;
    lblTextMiddle.font = fontOrdinary;
    lblTextRight.font = fontOrdinary;
    
    
//    if(self.view.bounds.size.height > 500){
        //フッター
        UIView *viewBlack =
        [[UIView alloc]initWithFrame:
         CGRectMake(0, self.view.bounds.size.height-HEIGHT_FOOTER_BAR,
                    self.view.bounds.size.width,
                    HEIGHT_FOOTER_BAR)];
        viewBlack.backgroundColor = [UIColor JinBlackColor];
        [self.view addSubview:viewBlack];
        
        
        UIImageView *imvOwl = [[UIImageView alloc]initWithImage:
                               [UIImage imageNamed:@"owl_noBack.png"]];
        imvOwl.frame = CGRectMake(0, 0, HEIGHT_FOOTER_BAR*2/3, HEIGHT_FOOTER_BAR*2/3);
        imvOwl.center = CGPointMake(self.view.bounds.size.width/2,
                                    15+HEIGHT_FOOTER_BAR/2);
        [viewBlack addSubview:imvOwl];
        
        NSLog(@"viewblack = %@", viewBlack);
//    }
    
    
    //広告表示
    int heightAd = 64;
    self.bannerView =
    [[GADBannerView alloc]
     initWithFrame:
     CGRectMake(0, self.view.bounds.size.height-heightAd,
                self.view.bounds.size.width,
                heightAd)];
    
    //self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";//defaults
    self.bannerView.adUnitID = @"ca-app-pub-2428023138794278/9842626946";
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    // Enable test ads on simulators.
    //    request.testDevices = @[ GAD_SIMULATOR_ID ];
    request.testDevices = @[@"bd4295ae361d7195eb5f5d8843ad3b741d854ac9"];//endo
    [self.bannerView loadRequest:request];
    [self.view addSubview:self.bannerView];
    
    
    
    
//    //以下行間指定
//    CGFloat customLineHeight = 32.0f;
//    
//    // パラグラフスタイルにlineHeightをセット
//    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
//    paragrahStyle.minimumLineHeight = customLineHeight;
//    paragrahStyle.maximumLineHeight = customLineHeight;
//    
//    // NSAttributedStringを生成してパラグラフスタイルをセット
//    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@""];
//    [attributedText addAttribute:NSParagraphStyleAttributeName
//                           value:paragrahStyle
//                           range:NSMakeRange(0, attributedText.length)];
//    
////    lblTextMiddle
//    lblTextLeft.attributedText = attributedText;
//    lblTextMiddle.attributedText = attributedText;
//    lblTextRight.attributedText = attributedText;
    
    

//    lblTextLeft.backgroundColor = [UIColor redColor];
//    lblTextMiddle.backgroundColor = [UIColor greenColor];
//    lblTextRight.backgroundColor = [UIColor blueColor];
    
    lblTextLeft.numberOfLines = 0;
    lblTextMiddle.numberOfLines = 0;
    lblTextRight.numberOfLines = 0;
    
    viewUnderLeft = [[UIView alloc]initWithFrame:
                     CGRectMake(0, 0, self.view.bounds.size.width,
                                self.view.bounds.size.height)];
    viewUnderMiddle = [[UIView alloc] initWithFrame:
                       CGRectMake(self.view.bounds.size.width, 0,
                                  self.view.bounds.size.width,
                                  self.view.bounds.size.height)];
    viewUnderRight = [[UIView alloc]initWithFrame:
                      CGRectMake(self.view.bounds.size.width * 2, 0,
                                 self.view.bounds.size.width,
                                 self.view.bounds.size.height)];
    
    viewUnderLeft.backgroundColor = [UIColor whiteColor];
    viewUnderMiddle.backgroundColor = [UIColor whiteColor];
    viewUnderRight.backgroundColor = [UIColor whiteColor];
    
    [viewUnderLeft addSubview:imageTopLeft];
    [viewUnderMiddle addSubview:imageTopMiddle];
    [viewUnderRight addSubview:imageTopRight];
    
    [viewUnderLeft addSubview:lblTextLeft];
    [viewUnderMiddle addSubview:lblTextMiddle];
    [viewUnderRight addSubview:lblTextRight];
    
    [scrollView addSubview:viewUnderLeft];
    [scrollView addSubview:viewUnderMiddle];
    [scrollView addSubview:viewUnderRight];
    
    
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*(NUM_OF_CONTENTS+1),
                                        self.view.bounds.size.height - HEIGHT_NAV_BAR);
    [scrollView scrollRectToVisible:CGRectMake(self.view.bounds.size.width,0,
                                               self.view.bounds.size.width,
                                               self.view.bounds.size.height-HEIGHT_NAV_BAR)
                           animated:NO];
    
    
    [self.view addSubview:scrollView];
    
    
    [[UFSessionManager sharedClient]
     getItemsWithCategoryName:self.strSlug
     completion:^(NSDictionary *resultsGetItem,
                  NSURLSessionDataTask *taskGetItem,
                  NSError *errorGetItem){
         if([UFCommonMethods isNullComparedToObj:errorGetItem]){
             NSLog(@"results:category %@ = %@",
                   resultsGetItem[STRING_API_OUTPUT_LABEL_SLUG],
                   resultsGetItem[@"posts"]);
             
             [SVProgressHUD dismiss];
             
             for(NSDictionary *dictArticle in resultsGetItem[@"posts"]){
                 NSLog(@"dictArticle = %@", dictArticle);
                 UFArticleObject *article = [[UFArticleObject alloc]
                                             initWithDictionary:dictArticle];
                 [arrArticle addObject:article];
                 article = nil;
             }
             
             //初期ページの更新
             if(arrArticle.count > 3){
                 [self loadPageWithId:(int)arrArticle.count-1 onPage:0];
                 [self loadPageWithId:0 onPage:1];
                 [self loadPageWithId:1 onPage:2];
             }else{
                 [SVProgressHUD showErrorWithStatus:@"記事数がありません"];
             }
             
         }else{
             [SVProgressHUD showErrorWithStatus:
              [NSString stringWithFormat:@"取得できませんでした"]];
             
         }
     }];
    
    
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
            
            arrayMenu = [self getSortedById:arrayMenu];
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
    
    
}



- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //should be called after rotation animation completed
    [self.contextMenuTableView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.contextMenuTableView updateAlongsideRotation];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //should be called after rotation animation completed
        [self.contextMenuTableView reloadData];
    }];
    [self.contextMenuTableView updateAlongsideRotation];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [scrollView setContentOffset: CGPointMake(oldX, scrollView.contentOffset.y)];
}




//- (BOOL)webView:(UIWebView *)webView
//shouldStartLoadWithRequest:(NSURLRequest *)request
// navigationType:(UIWebViewNavigationType)navigationType
//{
//    //test:そのまま遷移させるテスト
//    //    return YES;
//    NSLog(@"%s : request=%@, type=%d", __func__, request, (int)navigationType);
//    
//    
//    
//    if(navigationType == UIWebViewNavigationTypeOther) {//初回起動時
//        NSLog(@"typeOther : %d", (int)navigationType);
//        return YES;
//    }else if(navigationType == UIWebViewNavigationTypeLinkClicked){//リンクをクリックしたとき
//        
//        NSString *strUrl = [[request URL] absoluteString];
//        NSRange range = [strUrl rangeOfString:@"/items/"];//この文言はすべての商品に共通に含まれる
//        NSLog(@"strUrl = %@", strUrl);
//        
//        //アイテムへのリンクではないリンクが押下された場合の処理
//        if (range.location != NSNotFound) {
//            NSLog(@"検索対象が存在した場合の処理");
//            
//            //urlを文字列判定して、該当するショップがあれば遷移させる
//            NSLog(@"typeClicked : %d", (int)navigationType);
//            
//            NSLog(@"ページ遷移");
//            //アイテムページ遷移機能
//            
//            
//            //urlからitemidのみ取得する
////            NSString *strAbstractedItemId = [self getItemIdFromUrl:strUrl];
////            
////            ETItemTable4ViewController *tvc = [[ETItemTable4ViewController alloc]init];
////            tvc.title = @"page from webview";
////            tvc.strItemId = strAbstractedItemId;//@"734633";
////            [self.navigationController pushViewController:tvc animated:YES];
//            
//            strUrl = nil;
//            //ページ遷移させない
//            return NO;
//        }else{
//            strUrl = nil;
//            //該当するショップが存在しなければそのまま遷移させる
//            return YES;
//        }
//    }else{
//        NSLog(@"unknown type : %d", (int)navigationType);
//    }
//    
//    return YES;
//}


//行間詰める場合：http://qiita.com/Jacminik/items/21f87aadc3a4363b9802
- (void)loadPageWithId:(int)index onPage:(int)page {
    // load data for page
    UFArticleObject *article = arrArticle[index];
    NSLog(@"article = [%@]", [article entityName]);
    
    switch (page) {
        case 0:{
//            lblTextLeft.text = [arrArticle objectAtIndex:index];
            lblTextLeft.text = [self getRidOfTag:article.strContent];
            lblTextLeft.frame = rectFrame;
            [lblTextLeft sizeToFit];
            
            if([self is4SDevice]){
                lblTextLeft.font = fontVerySmall;
                [lblTextLeft sizeToFit];
            }else if(50+64+marginImageText + lblTextLeft.bounds.size.height + imageTopLeft.bounds.size.height > self.view.bounds.size.height){
                lblTextLeft.font = fontSmall;//[UIFont systemFontOfSize:SIZE_LABEL_SMALL];
                [lblTextLeft sizeToFit];
            }else{
                lblTextLeft.font = fontOrdinary;//[UIFont systemFontOfSize:SIZE_LABEL_ORDINARY];
                [lblTextLeft sizeToFit];
            }
            lblTextLeft.frame = CGRectMake(rectFrame.origin.x,
                                           rectFrame.origin.y,
                                           lblTextLeft.bounds.size.width,
                                           lblTextLeft.bounds.size.height);
            lblTextLeft.center = CGPointMake(self.view.bounds.size.width/2,
                                             lblTextLeft.center.y);
//            lblTextLeft.text = [NSString stringWithFormat:@"(%d)%@",
//                                (int)(64+marginImageText + lblTextLeft.bounds.size.height + imageTopLeft.bounds.size.height),
//                                lblTextLeft.text];
            [imageTopLeft
             sd_setImageWithURL:[NSURL URLWithString:article.strUrl]
             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                 if(![UFCommonMethods isNullComparedToObj:image]){
                     [imageTopLeft setImage:image];
                 }else{
                     [imageTopLeft setImage:[UIImage imageNamed:arrImages[[article.strId integerValue] % arrImages.count]]];
                 }
             }];
            break;
        }
        case 1:{
            lblTextMiddle.text = [self getRidOfTag:article.strContent];//[arrArticle objectAtIndex:index];
            lblTextMiddle.frame = rectFrame;
            [lblTextMiddle sizeToFit];
            
            if([self is4SDevice]){
                lblTextMiddle.font = fontVerySmall;
                [lblTextMiddle sizeToFit];
            }else if(50+64+marginImageText + lblTextMiddle.bounds.size.height + imageTopMiddle.bounds.size.height > self.view.bounds.size.height){
                lblTextMiddle.font = fontSmall;//[UIFont systemFontOfSize:SIZE_LABEL_SMALL];
                [lblTextMiddle sizeToFit];
            }else{
                lblTextMiddle.font = fontOrdinary;//[UIFont systemFontOfSize:SIZE_LABEL_ORDINARY];
                [lblTextMiddle sizeToFit];
            }
            
//            lblTextMiddle.text = [NSString stringWithFormat:@"(%d)%@",
//                                (int)(64+marginImageText + lblTextMiddle.bounds.size.height + imageTopMiddle.bounds.size.height),
//                                lblTextMiddle.text];
            
            lblTextMiddle.frame = CGRectMake(rectFrame.origin.x,
                                           rectFrame.origin.y,
                                           lblTextMiddle.bounds.size.width,
                                             lblTextMiddle.bounds.size.height);
            lblTextMiddle.center = CGPointMake(self.view.bounds.size.width/2,
                                             lblTextMiddle.center.y);
            [imageTopMiddle
             sd_setImageWithURL:[NSURL URLWithString:article.strUrl]
             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                 if(![UFCommonMethods isNullComparedToObj:image]){
                     [imageTopMiddle setImage:image];
                 }else{
                     [imageTopMiddle setImage:[UIImage imageNamed:arrImages[[article.strId integerValue] % arrImages.count]]];
                 }
             }];
            break;
        }
        case 2:{
            lblTextRight.text = [self getRidOfTag:article.strContent];//[arrArticle objectAtIndex:index];
            lblTextRight.frame = rectFrame;
            [lblTextRight sizeToFit];
            
            if([self is4SDevice]){
                lblTextRight.font = fontVerySmall;
                [lblTextRight sizeToFit];
            }else if(50 + 64+marginImageText + lblTextRight.bounds.size.height + imageTopRight.bounds.size.height > self.view.bounds.size.height){
                lblTextRight.font = fontSmall;//[UIFont systemFontOfSize:SIZE_LABEL_SMALL];
                [lblTextRight sizeToFit];
            }else{
                lblTextRight.font = fontOrdinary;//[UIFont systemFontOfSize:SIZE_LABEL_ORDINARY];
                [lblTextRight sizeToFit];
            }
            
//            lblTextRight.text = [NSString stringWithFormat:@"(%d)%@",
//                                (int)(64+marginImageText + lblTextRight.bounds.size.height + imageTopRight.bounds.size.height),
//                                lblTextRight.text];
            
            lblTextRight.frame = CGRectMake(rectFrame.origin.x,
                                           rectFrame.origin.y,
                                           lblTextRight.bounds.size.width,
                                           lblTextRight.bounds.size.height);
            lblTextRight.center = CGPointMake(self.view.bounds.size.width/2,
                                             lblTextRight.center.y);
            [imageTopRight
             sd_setImageWithURL:[NSURL URLWithString:article.strUrl]
             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                 if(![UFCommonMethods isNullComparedToObj:image]){
                     [imageTopRight setImage:image];
                 }else{
                     [imageTopRight setImage:[UIImage imageNamed:arrImages[[article.strId integerValue] % arrImages.count]]];
                 }
             }];
            break;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    // All data for the documents are stored in an array (arrArticle).
    // We keep track of the index that we are scrolling to so that we
    // know what data to load for each page.
    if(scrollView.contentOffset.x > scrollView.frame.size.width) {
        // We are moving forward. Load the current doc data on the first page.
        [self loadPageWithId:currIndex onPage:0];
        // Add one to the currentIndex or reset to 0 if we have reached the end.
        currIndex = (currIndex >= (int)[arrArticle count]-1) ? 0 : currIndex + 1;
        [self loadPageWithId:currIndex onPage:1];
        // Load content on the last page. This is either from the next item in the array
        // or the first if we have reached the end.
        nextIndex = (currIndex >= (int)[arrArticle count]-1) ? 0 : currIndex + 1;
        [self loadPageWithId:nextIndex onPage:2];
    }
    if(scrollView.contentOffset.x < scrollView.frame.size.width) {
        // We are moving backward. Load the current doc data on the last page.
        [self loadPageWithId:currIndex onPage:2];
        // Subtract one from the currentIndex or go to the end if we have reached the beginning.
        currIndex = (currIndex == 0) ? (int)[arrArticle count]-1 : currIndex - 1;
        [self loadPageWithId:currIndex onPage:1];
        // Load content on the first page. This is either from the prev item in the array
        // or the last if we have reached the beginning.
        prevIndex = (currIndex == 0) ? (int)[arrArticle count]-1 : currIndex - 1;
        [self loadPageWithId:prevIndex onPage:0];     
    }     
    
    // Reset offset back to middle page     
    [scrollView scrollRectToVisible:CGRectMake(self.view.bounds.size.width,0,
                                               self.view.bounds.size.width,
                                               self.view.bounds.size.height-HEIGHT_NAV_BAR)
                           animated:NO];
}


-(NSString *)getRidOfTag:(NSString *)strArg{
    
    NSRange r;
    NSString *s = strArg;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
    
    
}

- (void)presentMenuButtonTapped:(UIBarButtonItem *)sender {
    // init YALContextMenuTableView tableView
    NSLog(@"%s", __func__);
    if ([UFCommonMethods isNullComparedToObj:self.contextMenuTableView]) {
        NSLog(@"self.contextMenuTableView is not null(%@)", self.contextMenuTableView);
        self.contextMenuTableView = [[YALContextMenuTableView alloc]initWithTableViewDelegateDataSource:self];
        //アニメーションスピード
        self.contextMenuTableView.animationDuration = 0.1f;
        //optional - implement custom YALContextMenuTableView custom protocol
        self.contextMenuTableView.yalDelegate = self;
        
        //register nib
        UINib *cellNib = [UINib nibWithNibName:@"ContextMenuCell" bundle:nil];
        [self.contextMenuTableView registerNib:cellNib forCellReuseIdentifier:menuCellIdentifier];//@"contextMenuCellReuseId"];
    }
    
    // it is better to use this method only for proper animation
    [self.contextMenuTableView showInView:self.navigationController.view withEdgeInsets:UIEdgeInsetsZero animated:YES];
}

-(void)presentRightMenuViewController:(id)sender{
    NSLog(@"%s", __func__);
    
//    [self lineText];
//    
//    return;
    
    
    
    NSArray *activityItems =
    @[@"DrTriviaからテストだよ@line",
      @"開発環境dt twitterテスト"
      ];
    //  @[item];
    NSArray *applicationActivities = @[[[LINEActivity alloc] init],
                                       [[TWActivity alloc] init]
                                       ];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
    [self presentViewController:activityViewController animated:YES completion:NULL];
    return;
    
    
    //保存したいイメージ
    UIImage *saveImage = [UIImage imageNamed:@"Stars"];
//    camera_image;
    
    // UIActivityViewController
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[saveImage] applicationActivities:@[]];
    
    // 表示
    [self presentViewController:activityView animated:YES completion:nil];

    
}


//文章を投稿
-(void)lineText:(NSString *)strText {
    NSString *string = [NSString
                        stringWithFormat:@"知ってた？"];
    string = [string
              stringByAppendingString:strText];
    
    //エンコード
    string = [string
              stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *LINEUrlString = [NSString
                               stringWithFormat:@"line://msg/text/%@", string];
    
    //LINEがインストールされているか確認。されていなければアラート→AppStoreを開く
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:LINEUrlString]]) {
        [[UIApplication sharedApplication]
         openURL:[NSURL URLWithString:LINEUrlString]];
    } else {
        [self cannotOpenAlert];
    }
}

//画像を投稿
-(void)lineImage {
    UIImage *image = [UIImage imageNamed:@"test.png"];
    
    UIPasteboard *pasteboard;
    
    //iOS7.0以降では共有のクリップボードしか使えない。その際クリップボードが上書きされてしまうので注意。
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        pasteboard = [UIPasteboard generalPasteboard];
    } else {
        pasteboard = [UIPasteboard pasteboardWithUniqueName];
    }
    
    [pasteboard setData:UIImagePNGRepresentation(image)
      forPasteboardType:@"public.png"];
    
    NSString *LINEUrlString = [NSString stringWithFormat:@"line://msg/image/%@", pasteboard.name];
    
    //LINEがインストールされているか確認。されていなければアラート→AppStoreを開く
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:LINEUrlString]]) {
        [[UIApplication sharedApplication]
         openURL:[NSURL URLWithString:LINEUrlString]];
    } else {
        [self cannotOpenAlert];
    }
}

//アラート
-(void)cannotOpenAlert{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"LINEがインストールされていません"
                          message:@"AppStoreを開いてLINEをインストールします。"
                          delegate:self
                          cancelButtonTitle:@"いいえ"
                          otherButtonTitles:@"はい", nil
                          ];
    [alert show];
}

-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://いいえのとき
            break;
        case 1://はいのとき
            [[UIApplication sharedApplication]
             openURL:[NSURL
                      URLWithString:@"https://itunes.apple.com/jp/app/line/id443904275?mt=8"]];
            break;
    }
}



#pragma mark - YALContextMenuTableViewDelegate

- (void)contextMenuTableView:(YALContextMenuTableView *)contextMenuTableView didDismissWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Menu dismissed with indexpath = %@", indexPath);
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(YALContextMenuTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s", __func__);
    [tableView dismisWithIndexPath:indexPath];
    
    UFArticleObject *article = arrArticle[currIndex];
    NSString *strSendMessage = [self getRidOfTag:article.strContent];
    if([self.menuTitles[indexPath.row] isEqualToString:STRING_LINE]){
        [self lineText:strSendMessage];
    }else if([self.menuTitles[indexPath.row] isEqualToString:STRING_TWITTER]){
        [self postTwitter:strSendMessage];
    }else if([self.menuTitles[indexPath.row] isEqualToString:STRING_FACEBOOK]){
        [self postFacebook:strSendMessage];
    }else if([self.menuTitles[indexPath.row] isEqualToString:STRING_INSTAGRAM]){
        [self postInstagram:strSendMessage];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(YALContextMenuTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];
    
    if (cell) {
        cell.menuTitleLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
//        cell.menuImageView.image = [self.menuIcons objectAtIndex:indexPath.row];
        cell.menuImageView.image = [self.menuIcons[indexPath.row] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        [cell.menuImageView setTintColor:[UIColor LightPinkColor]];
        [cell.menuImageView setTintColor:[UIColor whiteColor]];
//        cell.menuImageView.backgroundColor = [UIColor LightPinkColor];
        cell.menuImageView.backgroundColor = [UIColor JinDarkPinkColor];
//        cell.contentView.backgroundColor = [UIColor LightPinkColor];
    }
    
    return cell;
}


//bubble sort by id in UFCategoryObject
-(NSMutableArray *)getSortedById:(NSMutableArray *)arrayArg{
    NSMutableArray *arrayRet = [arrayArg mutableCopy];
    // 最後の要素を除いて、すべての要素を並べ替えます
    for(int i=0;i<arrayRet.count-1;i++){
        NSLog(@"i = %d", i);
        // 下から上に順番に比較します
        for(int j=(int)arrayRet.count-1;j>i;j--){
            NSLog(@"j = %d", j);
            
            int idj = (int)[((UFCategoryObject *)arrayRet[j]).strId integerValue];
            int idj_1 = (int)[((UFCategoryObject *)arrayRet[j-1]).strId integerValue];
            NSLog(@"idj = %d, idj_1 = %d", idj, idj_1);
            // 上の方が大きいときは互いに入れ替えます
            if(idj<idj_1){
                id t=arrayRet[j];
                arrayRet[j]=arrayRet[j-1];
                arrayRet[j-1]=t;
            }
        }
    }
    
    for(int i =0;i < arrayRet.count;i++){
        UFCategoryObject *obj = arrayRet[i];
        NSLog(@"i=%d, id=%@, title=%@", i, obj.strId, obj.strTitle);
    }
    
    return arrayRet;
}

//https://github.com/mglagola/MGInstagram
-(void)postInstagram:(NSString *)strSendMessage{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://location?id=1"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }
}

- (void)postFacebook:(NSString *)strSendMessage {
    SLComposeViewController *facebookPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    NSString* postContent = strSendMessage;//[NSString stringWithFormat:@"投稿内容"];
    [facebookPostVC setInitialText:postContent];
    [facebookPostVC addURL:[NSURL URLWithString:@"url"]]; // URL文字列
    [facebookPostVC addImage:[UIImage imageNamed:@"image_name_string"]]; // 画像名（文字列）
    [self presentViewController:facebookPostVC animated:YES completion:nil];
}
// Twitter
- (void)postTwitter:(NSString *)strText {
    NSLog(@"%s", __func__);
    NSString* postContent = [NSString stringWithFormat:@"知ってた？「%@」", strText];
//    NSURL* appURL = [NSURL URLWithString:_entry.link];
    // =========== iOSバージョンで、処理を分岐 ============
    // iOS Version
    NSString *iosVersion =
    [[[UIDevice currentDevice]
      systemVersion]
     stringByTrimmingCharactersInSet:
     [NSCharacterSet whitespaceCharacterSet]];
    // Social.frameworkを使う
    if ([iosVersion floatValue] >= 6.0) {
        SLComposeViewController *twitterPostVC =
        [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitterPostVC setInitialText:postContent];
//        [twitterPostVC addURL:appURL]; // アプリURL
        [self presentViewController:twitterPostVC animated:YES completion:nil];
    }
//     Twitter.frameworkを使う
//    else if ([iosVersion floatValue] >= 5.0) {
//        // Twitter画面を保持するViewControllerを作成する。
//        TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
//        // 初期表示する文字列を指定する。
//        [twitter setInitialText:postContent];
//        // TweetにURLを追加することが出来ます。
//        [twitter addURL:appURL];
//        // Tweet後のコールバック処理を記述します。
//        // ブロックでの記載となり、引数にTweet結果が渡されます。
//        twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
//            if (res == TWTweetComposeViewControllerResultDone)
//                NSLog(@"tweet done.");
//            else if (res == TWTweetComposeViewControllerResultCancelled)
//                NSLog(@"tweet canceled.");
//        };
//        // Tweet画面を表示します。
//        [self presentModalViewController:twitter animated:YES];
//    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
               
               -(BOOL)is4SDevice{
                   return (self.view.bounds.size.height < 500);
               }
@end
