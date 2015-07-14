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


+ (void) animateView:(UIView *) view offScreenInDirection:(SASAnimationDirection) direction {
    
   if (direction == SASAnimationDirectionUp) {
        [self animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut | !UIViewAnimationOptionAllowUserInteraction animations:^{
            view.frame = CGRectOffset(view.frame, 0, -view.frame.size.height);
        } completion:nil];
    }
    else if(direction == SASAnimationDirectionDown) {
        [self animateWithDuration:duration delay: delay options:UIViewAnimationOptionCurveEaseInOut | !UIViewAnimationOptionAllowUserInteraction animations:^{
            view.frame = CGRectOffset(view.frame, 0, [Screen height]);
        } completion:nil];
    }
    else if (direction == SASAnimationDirectionLeft) {
        [self animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut | !UIViewAnimationOptionAllowUserInteraction animations:^{
            view.frame = CGRectOffset(view.frame, 0, -view.frame.size.width);
        } completion:nil];
    }
    else {
        [self animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut | !UIViewAnimationOptionAllowUserInteraction animations:^{
            view.frame = CGRectOffset(view.frame, [Screen width], 0);
        } completion:nil];
    }
}


@end
