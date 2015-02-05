//
//  UFSessionManager.h
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/01/27.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#define STRING_API_KEY_SLUG @"slug"
#define STRING_API_KEY_COUNT @"count"
#define STRING_API_OUTPUT_LABEL_CATEGORIES @"categories"
#define STRING_API_OUTPUT_LABEL_SLUG @"slug"


@interface UFSessionManager : AFHTTPSessionManager
+ (instancetype)sharedClient;


//共通のgetメソッドは外だしする必要ない
//-(void)getMethodWithUrl:(NSString *)strUrl
//              parameter:(NSDictionary *)parameters
//             completion:(void (^)(NSDictionary *,
//                                  NSURLSessionDataTask *,
//                                  NSError *))block;
-(void)getCategoriesWithCompletion:(void (^)(NSDictionary *,
                                             NSURLSessionDataTask *,
                                             NSError *))block;
-(void)getItemsNewestWithCompletion:(void (^)(NSDictionary *,
                                              NSURLSessionDataTask *,
                                              NSError *))block;

-(void)getItemsWithCategoryName:(NSString *)strSlug
                    completion:(void (^)(NSDictionary *,
                                         NSURLSessionDataTask *,
                                         NSError *))block;
@end
