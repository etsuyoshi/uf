//
//  SecondInterfaceController.m
//  Uberfacts
//
//  Created by EndoTsuyoshi on 2015/07/08.
//  Copyright (c) 2015年 com.endo. All rights reserved.
//

#import "SecondInterfaceController.h"

@interface SecondInterfaceController ()

@property (nonatomic, weak) IBOutlet WKInterfaceImage *image;

@end

@implementation SecondInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    
    [self.image setImageNamed:context];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



