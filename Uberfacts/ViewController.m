//
//  ViewController.m
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/01/27.
//  Copyright (c) 2015年 com.endo. All rights reserved.

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define STRING_URL_BITLY @"http://bit.ly/1Fa93V5"
#define STRING_URL_DEFAULT @"https://itunes.apple.com/us/app/dokutatoribia/id963743985?l=ja&ls=1&mt=8"

#import <Social/Social.h>
#import <Twitter/Twitter.h>



#import "ViewController.h"


#import "LINEActivity.h"
#import "TwActivity.h"
#import "UIColor+UFColor.h"
#define HEIGHT_IMAGE 200
#define NUM_OF_CONTENTS 3
#define HEIGHT_NAV_BAR 64
#define HEIGHT_FOOTER_AD 44
#define HEIGHT_FOOTER_SOCIAL 60
#define HEIGHT_LINE 37
#define SIZE_LABEL_ORDINARY 26
//#define SIZE_LABEL_SMALL 260//22.f
//#define SIZE_LABEL_MORE_SMALL 260//18.5f
//#define SIZE_LABEL_VERY_SMALL 260//15.f

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

@interface ViewController (){
    
    GADBannerView *bannerView;
}

@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuIcons;
//@property (strong, nonatomic) GADBannerView  *bannerView;

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
    UITextView *tvLeft;
    UITextView *tvMiddle;
    UITextView *tvRight;
    
    int currIndex;
    int nextIndex;
    int prevIndex;
    
    int marginImageText;
    
    CGRect rectFrame;
    
    
    NSMutableArray *arrImages;//予備で用意した画像
    UIFont *fontOrdinary;
//    UIFont *fontSmall;
//    UIFont *fontMoreSmall;
//    UIFont *fontVerySmall;
    
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
    NSLog(@"%s, frame = %@, slug = %@", __func__, NSStringFromCGRect(self.view.frame) ,self.strSlug);
    //google analytics
    self.screenName = [NSString stringWithFormat:@"firstView:%@", self.strSlug];
    
    
    [SVProgressHUD showWithStatus:@"更新中.."
                         maskType:SVProgressHUDMaskTypeGradient];
    [self initWithMenuOption];
    
    arrImages = [NSMutableArray array];
    //拡張子の種類を用意
    NSArray *arrFormat =
    [NSArray arrayWithObjects:
     @"jpg",@"jpeg",@"png",@"gif",nil];
    
    
    NSDictionary *dictSections =
    @{
      @"sex-love" : @"h",
      @"wildlife" : @"w",
      @"%e3%83%86%e3%83%ac%e3%83%93%ef%bc%86%e6%98%a0%e7%94%bb": @"c",//テレビ
      @"internet" : @"i",
      @"lifeanddeath" : @"d",
      @"history" : @"t",
      @"scienceandtech" : @"t",
      @"celebrities" : @"c",
      @"everythingelse" : @"h"
      };
    //先頭の頭文字を取得
    NSString *strHead =
    [UFCommonMethods isNullComparedToObj:self.strSlug]?
    [NSNull null]:dictSections[self.strSlug];
    NSLog(@"strHead = %@", strHead);
    
    //現状開いているセクション(self.strSulg)に相応しい画像を100枚取得してarrImagesに格納する
    NSString *strImageName = nil;
    for(int i = 0;i < 100;i++){
        
        for(int j = 0;j < arrFormat.count;j++){
            if([UFCommonMethods isNullComparedToObj:self.strSlug]){
                strHead = [[dictSections allValues] objectAtIndex:(arc4random() % dictSections.count)];
                NSLog(@"i = %d, j = %d, strHead = %@", i, j, strHead);
            }
            strImageName = [NSString stringWithFormat:@"%@%d.%@", strHead, i, arrFormat[j]];
            if(![UFCommonMethods isNullComparedToObj:[UIImage imageNamed:strImageName]]){
                NSLog(@"%@ is exists", strImageName);
                [arrImages addObject:strImageName];
                break;
            }else{
                NSLog(@"%@ is not exists", strImageName);
            }
        }
    }
    
    //万が一、一つも該当するイメージファイルが存在しない場合は以下で対応
    if(arrImages.count == 0){
        //heartなら多いので確実に一つ以上あるので存在しないではhを選択
        for(int i = 0;i < 100;i++){
            for(int j = 0;j < arrFormat.count;j++){
                strImageName = [NSString stringWithFormat:@"h%d.%@", i, arrFormat[j]];
                if(![UFCommonMethods isNullComparedToObj:[UIImage imageNamed:strImageName]]){
                    NSLog(@"%@ is exists", strImageName);
                    [arrImages addObject:strImageName];
                    break;
                }else{
                    NSLog(@"%@ is not exists", strImageName);
                }
            }
        }
    }
    
    //self.title = [UFCommonMethods isNullComparedToObj:self.title]?@"人気記事":self.title;
    if([self.title isEqualToString:@"popular"] ||
       [UFCommonMethods isNullComparedToObj:self.title]){
        self.title = @"人気記事";
    }
    
    
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
    
    
    self.view.backgroundColor = [UIColor blackColor];
    scrollView =
    [[UIScrollView alloc]
     initWithFrame:
     CGRectMake(0, 0, self.view.bounds.size.width,
                self.view.bounds.size.height - HEIGHT_FOOTER_AD)];
//                self.view.bounds.size.height-HEIGHT_FOOTER_AD - HEIGHT_FOOTER_SOCIAL)];
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    [scrollView setBounces:NO];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    
    
    
//    float goldRatio = 5.f/8.f;
    CGRect rectImage = CGRectMake(0, 0, self.view.bounds.size.width,
                                  self.view.bounds.size.width-100);
    
    imageTopLeft = [[UIImageView alloc]initWithFrame:rectImage];
    imageTopMiddle = [[UIImageView alloc]initWithFrame:rectImage];
    imageTopRight = [[UIImageView alloc]initWithFrame:rectImage];
    
    imageTopLeft.clipsToBounds = YES;
    imageTopMiddle.clipsToBounds = YES;
    imageTopRight.clipsToBounds = YES;
    
    imageTopLeft.contentMode = UIViewContentModeScaleAspectFill;
    imageTopMiddle.contentMode = UIViewContentModeScaleAspectFill;
    imageTopRight.contentMode = UIViewContentModeScaleAspectFill;
    
    
    int marginTextToLeft = 10;
    marginImageText = 10;//画像とテキストの間隔
    rectFrame = CGRectMake(marginTextToLeft,
                           imageTopLeft.bounds.size.height+marginImageText,
                           self.view.bounds.size.width-2*marginTextToLeft,
//                           100);
                           self.view.bounds.size.height-imageTopLeft.bounds.size.height - marginImageText - 70);
    
    float heightLabel = self.view.bounds.size.height - HEIGHT_NAV_BAR - marginImageText;
    CGRect rectLabel = CGRectMake(0, rectImage.size.height,
                                  self.view.bounds.size.width,
                                  heightLabel);
    tvLeft = [[UITextView alloc] initWithFrame:rectLabel];
    tvMiddle = [[UITextView alloc] initWithFrame:rectLabel];
    tvRight = [[UITextView alloc] initWithFrame:rectLabel];
    tvLeft.backgroundColor = [UIColor clearColor];
    tvMiddle.backgroundColor = [UIColor clearColor];
    tvRight.backgroundColor = [UIColor clearColor];
    
    UIColor *colorLabel = [UIColor colorWithRed:68.f/255.f green:68.f/255.f blue:68.f/255.f alpha:1.f];
    tvLeft.textColor = colorLabel;
    tvMiddle.textColor = colorLabel;
    tvRight.textColor = colorLabel;
    
    tvLeft.editable = NO;
    tvMiddle.editable = NO;
    tvRight.editable = NO;
    
    fontOrdinary = [UIFont italicSystemFontOfSize:SIZE_LABEL_ORDINARY];
    
    
    tvLeft.font = fontOrdinary;
    tvMiddle.font = fontOrdinary;
    tvRight.font = fontOrdinary;
    
    
    
//    NSDate *now = [NSDate date];
//    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSUInteger flags;
//    NSDateComponents *comps;
//    
//    // 年・月・日を取得
//    flags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
//    comps = [calendar components:flags fromDate:now];
//    
//    NSInteger year = comps.year;
//    NSInteger month = comps.month;
//    NSInteger day = comps.day;
//    
//    NSLog(@"%ld年 %ld月 %ld日", year, month, day);
    
    //NSDateFormatterクラスを出力する。
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    //Localeを指定。ここでは日本を設定。
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    [format setDateFormat:@"yyyyMMdd"];
    NSString *nowTime = [format stringFromDate:[NSDate date]];
    NSLog(@"nowTime = %@", nowTime);
    
    

    
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    
    
    viewUnderLeft = [[UIView alloc]initWithFrame:
                     CGRectMake(0, 0,
                                self.view.bounds.size.width,
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
    
    [viewUnderLeft addSubview:tvLeft];
    [viewUnderMiddle addSubview:tvMiddle];
    [viewUnderRight addSubview:tvRight];
    
    [scrollView addSubview:viewUnderLeft];
    [scrollView addSubview:viewUnderMiddle];
    [scrollView addSubview:viewUnderRight];
    
    
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*(NUM_OF_CONTENTS+1),
                                        self.view.bounds.size.height - HEIGHT_NAV_BAR-HEIGHT_FOOTER_AD);
    [scrollView scrollRectToVisible:CGRectMake(self.view.bounds.size.width,0,
                                               self.view.bounds.size.width,
                                               self.view.bounds.size.height-HEIGHT_NAV_BAR-HEIGHT_FOOTER_AD)
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
             
             if(arrArticle.count > 0){
                 [self reserveArticles:(NSArray *)arrArticle
                              asNameOf:(NSString *)self.strSlug];
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


- (void)loadPageWithId:(int)index onPage:(int)page {
    // load data for page
    if(index >= arrArticle.count)return;//error case
    UFArticleObject *article = arrArticle[index];
    NSLog(@"article = [%@]", [article entityName]);
    
    switch (page) {
        case 0:{
//            tvLeft.text = [self getRidOfTag:article.strContent];
            tvLeft.attributedText =
            [UFCommonMethods getAttributedString:[self getRidOfTag:article.strContent]
                                  withLineHeight:HEIGHT_LINE];
            tvLeft.font = fontOrdinary;
            tvLeft.frame = rectFrame;
            [imageTopLeft
             sd_setImageWithURL:[NSURL URLWithString:article.strUrl]
             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                 if(![UFCommonMethods isNullComparedToObj:image]){
                     [imageTopLeft setImage:image];
                 }else{
                     NSLog(@"article.strId = %@", article.strId);
                     NSLog(@"[article.strid integerValue]=%d", (int)[article.strId integerValue]);
                     NSLog(@"arrImages.count = %d", (int)arrImages.count);
                     if(arrImages.count > 0){
                         [imageTopLeft setImage:[UIImage imageNamed:arrImages[[article.strId integerValue] % arrImages.count]]];
                     }
                 }
             }];
            break;
        }
        case 1:{
//            tvMiddle.text = [self getRidOfTag:article.strContent];//[arrArticle objectAtIndex:index];
            tvMiddle.attributedText =
            [UFCommonMethods
             getAttributedString:[self getRidOfTag:article.strContent]
             withLineHeight:HEIGHT_LINE];
            tvMiddle.font = fontOrdinary;
            tvMiddle.frame = rectFrame;
            
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
            tvRight.attributedText =
            [UFCommonMethods getAttributedString:[self getRidOfTag:article.strContent]
                                  withLineHeight:HEIGHT_LINE];
            tvRight.frame = rectFrame;
            tvRight.font = fontOrdinary;
            
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
    
//    どのカテゴリで何枚フリックした状態で（飽きて？）メニューをタップするのかみたい→label?value?を送りたい！！（将来的に）
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"FirstView"
                                                          action:@"tappedMenuButton"
                                                           label:nil
                                                           value:nil] build]];

    
    // init YALContextMenuTableView tableView
    NSLog(@"%s", __func__);
    
    if(self.view.bounds.size.width > 414){//6pより大きい端末ではYALContextMenuが有効でない可能性があるので強制的にツィッターにする
        //記事データが取得できていない状態でツイートしようとするとアウト
        if(currIndex < arrArticle.count){
            UFArticleObject *article = arrArticle[currIndex];
            [self postTwitter:[self getRidOfTag:article.strContent]];
        }else{
            [SVProgressHUD showErrorWithStatus:@"記事情報が取得できません"];
        }
        return;
    }
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
    
    string = [string
              stringByAppendingString:STRING_URL_BITLY];
    
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
    
    
    //どこのカテゴリを見ているのか
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"tappedClose"
                                                          action:self.strSlug
                                                           label:nil
                                                           value:nil] build]];

}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(YALContextMenuTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s", __func__);
    
    
    //どのメニューをタップしたのか
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"FirstView"
                                                          action:self.menuTitles[indexPath.row]
                                                           label:nil
                                                           value:nil] build]];

    
    
    [tableView dismisWithIndexPath:indexPath];
    
    if(currIndex < arrArticle.count){
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
    }else{
        [SVProgressHUD showErrorWithStatus:@"記事情報が取得できません"];
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
    NSString* postContent = [NSString stringWithFormat:@"%@ #ドクトリ %@", strText,
                             STRING_URL_BITLY];
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


-(void)reserveArticles:(NSArray *)arrArticles
              asNameOf:(NSString *)strSlug{
    NSString *strKey = [UFCommonMethods isNullComparedToObj:strSlug]?@"total":strSlug;
    
    //デバイス保存について
    //指定したキーstrKeyで保存されている配列を取得
    //取得した配列の中でarrArticlesの要素と等しくないものを先頭に挿入する
    
    //表示順序
    //順序的には通信中に、先にデバイス保存の配列を表示。
    //通信結果のデータが取得できたらそれを現在表示用の配列の最後に追加→後ろに追加することになる
    
    //表示用配列の要素となる記事オブジェクトには表示済みかどうかの判断フラグが必要
    
    
}


-(void)tappedTweetLogo:(id)sender{
    
    NSLog(@"%s", __func__);
    
    
    
    if(currIndex < arrArticle.count){
        UFArticleObject *article = arrArticle[currIndex];
        NSString *strSendMessage = [self getRidOfTag:article.strContent];
        
        [self postTwitter:strSendMessage];
    }else{
        [SVProgressHUD showErrorWithStatus:@"記事情報が取得できません"];
    }
    
    
}

@end
