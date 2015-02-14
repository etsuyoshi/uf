//
//  UFSessionManager.m
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/01/27.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//

#import "UFSessionManager.h"
#import "UFCommonMethods.h"

#define DATA_GET_NUM_MAX @"100"

//http://pocketti.zombie.jp/trivia/api/get_category_index/
//http://pocketti.zombie.jp/trivia/api/get_category_posts/?slug=sex-love

@implementation UFSessionManager



+ (instancetype)sharedClient
{
    static UFSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
//    NSString * const kBSAPIBaseURLString = @"http://pocketti.zombie.jp/trivia/api";
    NSString *const kBSAPIBaseURLString = @"http://pocketti.zombie.jp";
    
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{
                                                @"Accept" : @"application/json",
                                                };
        
        _sharedClient = [[UFSessionManager alloc]
                         initWithBaseURL:[NSURL URLWithString:kBSAPIBaseURLString]
                         sessionConfiguration:configuration];
    });
    
    return _sharedClient;
}




//共通のpostメソッド
-(void)getMethodWithUrl:(NSString *)strUrl
               parameter:(NSDictionary *)parameters
              completion:(void (^)(NSDictionary *,
                                   NSURLSessionDataTask *,
                                   NSError *))block{
    [self GET:strUrl
    parameters:parameters
       success:^(NSURLSessionDataTask *task, id responseObject) {
           NSLog(@"success : %@ in %s", strUrl, __func__);
           if (block) block(responseObject, task, nil);
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           NSLog(@"failure : %@ in %s", strUrl, __func__);
           if (block) block(nil, task, error);
       }];
    
}




-(void)getCategoriesWithCompletion:(void (^)(NSDictionary *,
                                           NSURLSessionDataTask *,
                                           NSError *))block{
    
    NSLog(@"%s", __func__);
    
//    NSMutableDictionary *parameters =
//    [NSMutableDictionary dictionary];
    
    
    [self getMethodWithUrl:@"/trivia/api/get_category_index"
                 parameter:nil//parameters
                completion:block];
    
}

-(void)getItemsNewestWithCompletion:(void (^)(NSDictionary *,
                                              NSURLSessionDataTask *,
                                              NSError *))block{
    NSLog(@"%s",
          __func__);
    
    NSMutableDictionary *parameters =
    [NSMutableDictionary dictionary];
    
    
    parameters[STRING_API_KEY_COUNT] = DATA_GET_NUM_MAX;//@"100";
    //http://pocketti.zombie.jp/trivia/api/get_category_posts/
    [self getMethodWithUrl:@"/trivia/api/get_posts/"
                 parameter:parameters
                completion:block];
    
    
    
    
}

-(void)getItemsWithCategoryName:(NSString *)strSlug
                    completion:(void (^)(NSDictionary *,
                                         NSURLSessionDataTask *,
                                         NSError *))block{
    
    NSLog(@"%s : slug = %@",
          __func__,
          strSlug);
    
    NSMutableDictionary *parameters =
    [NSMutableDictionary dictionary];
    
    
    
    if(![UFCommonMethods
         isNullComparedToObj:strSlug] &&
       ![strSlug isEqualToString:@"popular"]){
        NSLog(@"slug指定がある場合");
        //slug指定がある場合
        parameters[STRING_API_KEY_SLUG] = strSlug;
    
        parameters[STRING_API_KEY_COUNT] = DATA_GET_NUM_MAX;//@"100";
        //http://pocketti.zombie.jp/trivia/api/get_category_posts/
        [self getMethodWithUrl:@"/trivia/api/get_category_posts/"
                     parameter:parameters
                    completion:block];
    }else{
        NSLog(@"getItemsNewestWithCompletion");
        [self getItemsNewestWithCompletion:block];
    }
    
    
}


@end
