//
//  UFCategoryObject.m
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/01/31.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//

#import "UFCategoryObject.h"

@implementation UFCategoryObject


-(id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    
    if(self){
        NSLog(@"dict at category = %@", dict);
        self.strId = dict[@"id"];
        self.strTitle = dict[@"parent"];
        self.strPostCount = dict[@"post_count"];
        self.strSlug = dict[@"slug"];
        self.strTitle = dict[@"title"];
        self.strDescription = dict[@"description"];
    }
    return self;
}

- (NSString *)entityName {
    return [NSString stringWithFormat:@"id = %@:%@:%@:%@:%@:%@",
            self.strId,
            self.strParent,
            self.strPostCount,
            self.strSlug,
            self.strTitle,
            self.strDescription];
}



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self )
    {
        self.strId = [aDecoder decodeObjectForKey:@"id"];
        self.strParent= [aDecoder decodeObjectForKey:@"parent"];
        self.strPostCount = [aDecoder decodeObjectForKey:@"post_count"];
        self.strSlug = [aDecoder decodeObjectForKey:@"slug"];
        self.strTitle = [aDecoder decodeObjectForKey:@"title"];
        self.strDescription = [aDecoder decodeObjectForKey:@"description"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.strId forKey:@"id"];
    [encoder encodeObject:self.strParent forKey:@"parent"];
    [encoder encodeObject:self.strPostCount forKey:@"post_count"];
    [encoder encodeObject:self.strSlug forKey:@"slug"];
    [encoder encodeObject:self.strTitle forKey:@"title"];
    [encoder encodeObject:self.strDescription forKey:@"description"];
}


@end
