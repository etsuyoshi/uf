//
//  UFCommonMethods.m
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/01/27.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//

#import "UFCommonMethods.h"
#import "UIColor+UFColor.h"

@implementation UFCommonMethods


+(BOOL)isNullComparedToObj:(id)obj{
    if([obj isEqual:[NSNull null]] ||
       obj == nil){
        return YES;
    }
    return NO;
}

+(NSString *)getBundleId{
    NSString *strBundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSLog(@"bundle = %@", strBundleId);
    return strBundleId;
}

+(NSString *)getStringKeyChainStore:(NSString *)strKey{
    
    NSString *strBundleId = [self getBundleId];
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:strBundleId];
    return (NSString *)[store stringForKey:strKey];
    
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
//    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+(id)getObjectKeyChainStore:(NSString *)strKey{
    NSString *strBundleId = [self getBundleId];
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:strBundleId];
    return [store dataForKey:strKey];
}

+(NSArray *)getArrayKeyChainStore:(NSString *)strKey{
    id returnData = [self getObjectKeyChainStore:strKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:returnData];
}
+(NSDictionary *)getDictionayKeyChainStore:(NSString *)strKey{
    id returnData = [self getObjectKeyChainStore:strKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:returnData];
}

+(BOOL)setKeyChainStoreWithStringValue:(NSString *)strValue
                           asKey:(NSString *)strKey{
    [UICKeyChainStore setString:strValue forKey:strKey];
    return YES;
}


+(BOOL)setKeyChainStoreWithObjectValue:(id)objValue
                                 asKey:(NSString *)strKey{
    
    NSLog(@"%s, objvalue = %@, strkeys = %@", __func__, objValue, strKey);
    if([objValue isKindOfClass:[NSArray class]] ||
       [objValue isKindOfClass:[NSDictionary class]]){
        //辞書、配列の場合は
        [UICKeyChainStore
         setData:[NSKeyedArchiver archivedDataWithRootObject:objValue]
         forKey:strKey];
    }else{
        //カスタムクラスの場合はそのまま保存
        [UICKeyChainStore
         setData:objValue forKey:strKey];
    }
    
    return YES;
}


+(void)setNavigationBar:(UINavigationBar *)navigationBar{
//    navBar.barTintColor = [UIColor grayColor];
//    UIColor *backgroundLayerColor = [[UIColor grayColor] colorWithAlphaComponent:0.8f];
//    static CGFloat kStatusBarHeight = 20;
//    
//    CALayer *navBackgroundLayer = [CALayer layer];
//    navBackgroundLayer.backgroundColor = [backgroundLayerColor CGColor];
//    navBackgroundLayer.frame = CGRectMake(0, -kStatusBarHeight, navBar.frame.size.width,
//                                          kStatusBarHeight + navBar.frame.size.height);
//    [navBar.layer addSublayer:navBackgroundLayer];
//    // move the layer behind the navBar
//    navBackgroundLayer.zPosition = -1;

    //    [navigationController.navigationBar setBarTintColor:[UIColor MistyRoseColor]];//背景
    //    [navigationController.navigationBar setBarTintColor:[UIColor HotPinkColor]];//背景
    //    [navigationController.navigationBar setBarTintColor:[UIColor LightPinkColor]];//背景
    //    [navigationController.navigationBar setBarTintColor:[UIColor PinkColor]];//背景
    
    UIColor *backGroundColor = [UIColor JinDarkPinkColor];
    UIColor *textColor = [UIColor JinWhiteColor];
    [navigationBar setBarTintColor:backGroundColor];
    [navigationBar setTintColor:textColor];//文字
    [navigationBar setTranslucent:YES];
    navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: textColor};
    
    //ステータスバーの文字色を白くする
    navigationBar.barStyle = UIBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
}

//bubble sort by id in UFCategoryObject
+(NSMutableArray *)getSortedById:(NSMutableArray *)arrayArg{
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

@end
