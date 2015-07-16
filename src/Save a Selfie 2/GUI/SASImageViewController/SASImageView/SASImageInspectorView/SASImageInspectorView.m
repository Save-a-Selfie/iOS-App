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

@end

@implementation SASImageInspectorView

@synthesize imageView = _imageView;

- (instancetype)initWithImage:(UIImage *)image {
    if(self = [super init]) {
        
        self.frame = CGRectMake(0, 0, [Screen width], [Screen height]);
        self.backgroundColor = [UIColor orangeColor];

        _imageView.frame = CGRectMake(0, 0, [Screen width], [Screen height]);
        _imageView.image = [image copy];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.center = self.center;
        [self addSubview:_imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}


- (void) handleTap {
    // TODO: Forward to delegate
}

- (void)animateImageIntoView:(UIView *)view {

    [UIView animateWithDuration:1.0
                     animations:^{[view addSubview:self];}
                     completion:nil];
}
@end
