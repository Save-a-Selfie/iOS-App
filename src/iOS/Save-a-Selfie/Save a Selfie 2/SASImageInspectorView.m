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

@synthesize imageView;


- (instancetype)initWithImage:(UIImage*)image {
    if(self = [super initWithFrame: CGRectMake(0, 0, [Screen width], [Screen height])]) {
        self.backgroundColor = [UIColor blackColor];
        self.imageView.userInteractionEnabled = YES;
        
        // Set up the imageView property.
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [Screen width], [Screen height])];
        self.imageView.image = [image copy];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        
        UIGestureRecognizer *oneTap = [[UIGestureRecognizer alloc] initWithTarget:self.imageView action:@selector(handleGesture)];
        [self.imageView addGestureRecognizer:oneTap];
    }
    return self;
}


- (void) handleGesture {
    [self removeFromSuperview];
    printf("Tapped");
    self.imageView = nil;
}

@end
