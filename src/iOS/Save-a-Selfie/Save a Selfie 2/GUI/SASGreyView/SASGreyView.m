//
//  SASGreyView.m
//  Save a Selfie
//
//  Created by Stephen Fox on 05/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASGreyView.h"

@implementation SASGreyView


- (instancetype)init {
    if(self = [super init]) {
        [self setupGreyView];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupGreyView];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setupGreyView];
    }
    return self;
}


- (void) setupGreyView {
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
}


#pragma Animatations
- (void) animateIntoView:(UIView*) view {
    
    self.alpha = 0.0;
    
    [view addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{self.alpha = 1.0;}];
}


- (void) animateOutOfParentView {
    [UIView animateWithDuration:0.2
                     animations:^{self.alpha = 0.0;}
                     completion:^(BOOL f){[self removeFromSuperview];}];
    
}


@end
