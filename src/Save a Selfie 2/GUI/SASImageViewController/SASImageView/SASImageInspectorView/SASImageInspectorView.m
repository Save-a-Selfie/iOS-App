//
//  SASImageInspectorView.m
//  Save a Selfie
//
//  Created by Stephen Fox on 06/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASImageInspectorView.h"
#import "Screen.h"

@interface SASImageInspectorView()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) BOOL shouldFinishInspectingImage;
@end

@implementation SASImageInspectorView

@synthesize imageView = _imageView;
@synthesize shouldFinishInspectingImage = _shouldFinishInspectingImage;



#pragma Object Life Cycle.
- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, [Screen width], [Screen height]);
        self.backgroundColor = [UIColor blackColor];
        
        _imageView = [[UIImageView alloc]initWithImage:image];
        _imageView.frame = self.frame;
        _shouldFinishInspectingImage = YES;
        _imageView.center = self.center;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:_imageView];
        
        [self addTapGesture];
        
    }
    return self;
}


- (void) addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:tap];
    
}



- (void) handleTap {
    if (self.shouldFinishInspectingImage == YES) {
        [self removeFromSuperview];
    }
}

#pragma Animations.
- (void)animateImageIntoView:(UIView *)view {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [view addSubview:self];
    [view bringSubviewToFront:self];
}
@end
