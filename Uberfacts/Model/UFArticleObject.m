//
//  UFArticleObject.m
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/01/29.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//

#import "UFArticleObject.h"
#import "UFCommonMethods.h"

@implementation UFArticleObject


-(id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    
    if(self){
        NSLog(@"dict at article = %@", dict);
        NSLog(@"at at article(%@) = %@", [dict[@"attachments"] class], dict[@"attachments"]);
        self.strId = dict[@"id"];
        self.strTitle = dict[@"title"];
        if(![UFCommonMethods isNullComparedToObj:dict[@"attachments"]]){
            if(((NSArray *)dict[@"attachments"]).count > 0){
                NSLog(@"urlが存在します");
                self.strUrl = dict[@"attachments"][0][@"images"][@"full"][@"url"];
            }else{
                NSLog(@"urlが存在しません");
            }
        }else{
            NSLog(@"urlが存在しません");
        }
        self.strContent = dict[@"content"];
    }
    return self;
}

- (NSString *)entityName {
    return [NSString stringWithFormat:@"id = %@, title = %@, url=%@, content=%@",
            self.strId,
            self.strTitle,
            self.strUrl,
            self.strContent];
}
@end
