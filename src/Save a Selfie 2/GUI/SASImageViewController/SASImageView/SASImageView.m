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

@interface SASImageView() <SASImageInspectorDelegate>

@end


@implementation SASImageView

- (instancetype)initWithCoder:(NSCoder *)coder {

    if (self = [super initWithCoder:coder]) {
        
        self.userInteractionEnabled = YES;
        _canShowFullSizePreview = NO;
        _hideOriginalInPreview = NO;
        self.contentMode = UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tap];

        
    }
    return self;
}




- (void) handleTap {
    
    
    if (_canShowFullSizePreview && self.image) {
        
        SASImageInspectorView *sasImageInspectorView = [[SASImageInspectorView alloc] initWithImage:self.image];
        sasImageInspectorView.delegate = self;
        
        UIViewController *rootViewController = (UIViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        
        [sasImageInspectorView animateImageIntoView:rootViewController.view];
    }
    

    if (self.hideOriginalInPreview)
        self.hidden = YES;
    
}



#pragma mark <SASImageInspectorView>
- (void) sasImageInspectorView:(SASImageInspectorView *) inspector didDismiss:(BOOL) dismissed {

    if (dismissed && self.hideOriginalInPreview) {
        self.hidden = NO;
    }
}



@end
