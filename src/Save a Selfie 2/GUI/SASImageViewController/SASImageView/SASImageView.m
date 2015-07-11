//
//  SASImageView.m
//  Save a Selfie
//
//  Created by Stephen Fox on 06/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASImageView.h"
#import "SASImageInspectorView.h"


@implementation SASImageView

@synthesize selectable = _selectable;


- (instancetype)initWithCoder:(NSCoder *)coder {

    if (self = [super initWithCoder:coder]) {
        
        self.userInteractionEnabled = YES;
        _selectable = NO;
        self.contentMode = UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}




- (void) handleTap {
    
    SASImageInspectorView *sasImageInspectorView = [[SASImageInspectorView alloc] initWithImage:self.image];
    [sasImageInspectorView animateImageIntoView:[self superview]];
    
    
}





@end
