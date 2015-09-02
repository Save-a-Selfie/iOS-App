//
//  FXAlertViewTransitionAnimator.h
//  FXAlertView
//
//  Created by Stephen Fox on 27/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This class implements 'UIViewControllerAnimatedTransitioning' protocol
 which provides an interface for FXAlertController to animate in
 and out of a UIViewController.
 */
@interface FXAlertControllerTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>


/**
 It is advised to used the shareInstance instead of creatng your 
 own instance as specific state is captured when 
 FXAlertControllerTransitionAnimator animates an FXAlertController in the 
 view hierarchy. 
 
 When the FXAlertControllerTransitionAnimator is messaged
 to dismiss the FXAlertController this state is dealt 
 with appropriately. e.g. any views that have been altered or
 changed for the animation of the FXAlertController.
 
 Not using the sharedInstance may leave inconsistent state
 for any view in the view hierarchy who have been involoved 
 in animation.
 */
+ (instancetype) sharedInstance;



/**
 This property will return whether the animator is currently animating or not.
 
 @return YES - The animator currently animating its context.
 @return NO - The animator is not animating its context.
 */
@property (assign, nonatomic, getter=isPresenting) __block BOOL presenting;

@end
