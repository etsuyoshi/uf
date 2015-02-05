//
//  UIColor+UFColor.m
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/01/31.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//

#import "UIColor+UFColor.h"
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@implementation UIColor (ETColor)
+ (UIColor*)MistyRoseColor {//255, 228, 225
    return [UIColor colorWithRed:255.0/255.0 green:228.0/255.0 blue:225.0/255.0 alpha:1];
}


+ (UIColor*)HotPinkColor {//255, 105, 180
    return [UIColor colorWithRed:255.0/255.0 green:105.0/255.0 blue:180.0/255.0 alpha:1];
}




+ (UIColor*)PinkColor {//pink(255, 192, 203)
    return [UIColor colorWithRed:255.0/255.0 green:192.0/255.0 blue:203.0/255.0 alpha:1];
}



+ (UIColor*)LightPinkColor {//LightPink	(255, 182, 193)
    return [UIColor colorWithRed:255.0/255.0 green:182.0/255.0 blue:193.0/255.0 alpha:1];
}


+ (UIColor*)JinDarkPinkColor {//R: 240 G: 123 B: 149
//    return RGBA(240, 123, 149, .5f);
    return RGB(240, 123, 149);
}
+ (UIColor*)JinLightPinkColor {//R: 250 G: 179 B: 195
    return RGB(250, 179, 195);
}
+ (UIColor*)JinWhiteColor {//R: 255 G: 255 B: 255
    return RGB(255, 255, 255);
}

+ (UIColor*)JinRedColor {//R: 218 G: 78 B: 89
    return RGB(218, 78, 89);
}

+ (UIColor*)JinBlackColor {//R: 64 G: 65 B: 70
    return RGB(64, 65, 70);
}






@end
