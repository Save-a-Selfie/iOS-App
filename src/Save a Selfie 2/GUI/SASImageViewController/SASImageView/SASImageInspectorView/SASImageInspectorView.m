//
//  SASImageInspectorView.m
//  Save a Selfie
//
//  Created by Stephen Fox on 06/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASImageInspectorView.h"
#import "Screen.h"
#import "UIView+Animations.h"

@interface SASImageInspectorView() {
    CGPoint lastPosition;
    CGPoint position;
}

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

        
    }
    return self;
}


#pragma Touch updates.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    lastPosition = [[touches anyObject] locationInView:self.superview];
    
    [UIView animateWithDuration:0.2 animations:^{self.backgroundColor = [UIColor clearColor];}];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    position = [[touches anyObject] locationInView:self.superview];
    
    CGFloat xDisplacement = position.x - lastPosition.x;
    CGFloat yDisplacement = position.y - lastPosition.y;
    
    CGRect frame = self.frame;
    frame.origin.x += xDisplacement;
    frame.origin.y += yDisplacement;
    self.frame = frame;
    lastPosition = position;
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    float distanceFromCenter = self.superview.center.y - self.center.y;
    

    if (self.center.y < self.superview.center.y && distanceFromCenter > 50) {
        
        [UIView animateView:self
       offScreenInDirection:SASAnimationDirectionUp
                 completion:^(BOOL completed) {
                     [self removeFromSuperview];
                     self.imageView = nil;
                 }
         ];
        
    }
    else if(self.center.y > self.superview.center.y && distanceFromCenter < -50) {
        
        [UIView animateView:self
       offScreenInDirection:SASAnimationDirectionDown
                 completion:^(BOOL completed) {
                     [self removeFromSuperview];
                     self.imageView = nil;
                 }
         ];
        
    }
    else {
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.center = self.superview.center;
                             self.backgroundColor = [UIColor blackColor];
                         }
         ];
    }
    

}






#pragma Animations.
- (void)animateImageIntoView:(UIView *)view {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [view addSubview:self];
    [view bringSubviewToFront:self];
}
@end
