//
//  UFCategoryObject.h
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/01/31.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UFCategoryObject : NSObject<NSCoding>

@property (nonatomic, strong) NSString *strId;
@property (nonatomic, strong) NSString *strParent;
@property (nonatomic, strong) NSString *strPostCount;
@property (nonatomic, strong) NSString *strSlug;
@property (nonatomic, strong) NSString *strTitle;
@property (nonatomic, strong) NSString *strDescription;


-(id)initWithDictionary:(NSDictionary *)dict;
- (NSString *)entityName;

@end
