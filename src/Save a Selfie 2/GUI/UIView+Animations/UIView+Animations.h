//
//  UIView+Animations.h
//  Save a Selfie
//
//  Created by Stephen Fox on 10/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SASAnimationDirection) {
    SASAnimationDirectionUp,
    SASAnimationDirectionDown,
    SASAnimationDirectionLeft,
    SASAnimationDirectionRight
};

@interface UIView (Animations)


/**
 Animates a viewe offscreen in the direction specified.
 
 @param view
        The view to animate.
 
        direction
        A SASAnimationDirection which determines the direction
        view should go offscreen.
 
        complted
        Compltetion block. Called when the animation has finished.
 */
+ (void) animateView:(UIView *) view offScreenInDirection:(SASAnimationDirection) direction completion:(void (^)(BOOL completed)) completed;


// Animates a view to a specific point in the coordinate system.
+ (void) animateView:(UIView *) view toPoint:(CGPoint) point;

@end
