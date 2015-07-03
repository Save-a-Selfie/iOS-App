//
//  SASDeviceButton.m
//  Save a Selfie
//
//  Created by Stephen Fox on 03/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASDeviceButton.h"

@implementation SASDeviceButton

@synthesize selectedImage;
@synthesize unselectedImage;


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}


- (void)select {
    
    [self setImage:selectedImage forState:UIControlStateNormal];
}


- (void) deselect {
    [self setImage:unselectedImage forState:UIControlStateNormal];
}

@end
