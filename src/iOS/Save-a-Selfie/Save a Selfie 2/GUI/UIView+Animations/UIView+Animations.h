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

// @Discussion:
//  Animates a view offscreen in the direction specified.
//  The animation for this method call uses the following parameters:
//      animateWithDuration:0.5
//      delay:0.2
//      options:UIViewAnimationOptionCurveEaseInOut
//  The animation block is the offset of the view itself.
+ (void) animateView:(UIView *) view offScreenInDirection:(SASAnimationDirection) direction;


// Animates a view to a specific point in the coordinate system.
+ (void) animateView:(UIView *) view toPoint:(CGPoint) point;
@end
