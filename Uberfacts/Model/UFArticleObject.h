//
//  UFArticleObject.h
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/01/29.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UFArticleObject : NSObject

@property (nonatomic, strong) NSString *strId;
@property (nonatomic, strong) NSString *strTitle;
@property (nonatomic, strong) NSString *strUrl;
@property (nonatomic, strong) NSString *strContent;

-(id)initWithDictionary:(NSDictionary *)dict;
- (NSString *)entityName;
@end
