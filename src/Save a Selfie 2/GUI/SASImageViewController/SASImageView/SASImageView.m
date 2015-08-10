//
//  SASImageView.m
//  Save a Selfie
//
//  Created by Stephen Fox on 06/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASImageView.h"
#import "SASImageInspectorView.h"
#import "AppDelegate.h"



@implementation SASImageView



- (instancetype)initWithCoder:(NSCoder *)coder {

    if (self = [super initWithCoder:coder]) {
        
        self.userInteractionEnabled = YES;
        _canShowFullSizePreview = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        
        if (_canShowFullSizePreview) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
            [self addGestureRecognizer:tap];
        }
        
    }
    return self;
}




- (void) handleTap {
    
    // Only when the image property is set should
    // we present a SASImageInspectorView.
    if (self.image) {
        SASImageInspectorView *sasImageInspectorView = [[SASImageInspectorView alloc] initWithImage:self.image];
        
        __weak UIViewController *rootViewController = (UIViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        
        // It makes sense to animate it into the rootViewController as this
        // view will be clipped to this imageViews bounds and we will
        // not be able to see the whole view.
        [sasImageInspectorView animateImageIntoView:rootViewController.view];
    }
    
}





@end
