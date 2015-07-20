//
//  UIView+Animations.m
//  Save a Selfie
//
//  Created by Stephen Fox on 10/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "UIView+Animations.h"
#import "Screen.h"
#import "SASGreyView.h"


@implementation UIView (Animations)

CGFloat duration = 0.3;
CGFloat delay = 0.0;


+ (void) animateView:(UIView *) view offScreenInDirection:(SASAnimationDirection) direction completion:(void (^)(BOOL completed)) complete{
    
   if (direction == SASAnimationDirectionUp) {
        [self animateWithDuration:duration
                            delay:delay options:UIViewAnimationOptionCurveEaseInOut | !UIViewAnimationOptionAllowUserInteraction
                       animations:^{
                           view.frame = CGRectMake(view.frame.origin.x, -view.frame.size.height, view.frame.size.width, view.frame.size.height);
                       }
                       completion:^(BOOL completed) {
                           if (complete != nil) {
                               complete(completed);
                           }
                       }
         ];
    }
    else if(direction == SASAnimationDirectionDown) {
        [self animateWithDuration:duration
                            delay:delay
                          options:UIViewAnimationOptionCurveEaseInOut | !UIViewAnimationOptionAllowUserInteraction
                       animations:^{
                           view.frame = CGRectMake(view.frame.origin.x, [Screen height], view.frame.size.width, view.frame.size.height);
                       }
                       completion:^(BOOL completed) {
                           if (complete != nil) {
                               complete(completed);
                           }
                       }
         ];
    }
    else if (direction == SASAnimationDirectionLeft) {
        [self animateWithDuration:duration
                            delay:delay
                          options:UIViewAnimationOptionCurveEaseInOut | !UIViewAnimationOptionAllowUserInteraction
                       animations:^{
                           view.frame = CGRectMake(-[Screen width], view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                       }
                       completion:^(BOOL completed) {
                           if (complete != nil) {
                               complete(completed);
                           }
                       }
         ];
    }
    else if (direction == SASAnimationDirectionRight) {
        [self animateWithDuration:duration
                            delay:delay
                          options:UIViewAnimationOptionCurveEaseInOut | !UIViewAnimationOptionAllowUserInteraction
                       animations:^{
                           view.frame = CGRectMake([Screen width], view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                       }
                       completion:^(BOOL completed){
                           if (complete != nil) {
                               complete(completed);
                           }
                       }
         ];
    }
}


+ (void) animateView:(UIView *) view toPoint:(CGPoint) point {
    [self animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.frame = CGRectMake(point.x, point.y, view.frame.size.width, view.frame.size.height);
    } completion:nil];
    
}


@end
