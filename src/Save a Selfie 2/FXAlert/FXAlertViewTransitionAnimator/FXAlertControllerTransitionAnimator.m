//
//  FXAlertViewTransitionAnimator.m
//  FXAlertView
//
//  Created by Stephen Fox on 27/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "FXAlertControllerTransitionAnimator.h"
#import "FXAlertController.h"
#import <objc/runtime.h>

@implementation FXAlertControllerTransitionAnimator


#pragma Object Life Cycle.
+ (instancetype)sharedInstance {
    
    static FXAlertControllerTransitionAnimator *sharedInstance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^(){
        sharedInstance = [[FXAlertControllerTransitionAnimator alloc] init];
    });
    return sharedInstance;
}



#pragma mark <UIViewControllerAnimatedTransitioning>
- (void) animateTransition:(id<UIViewControllerContextTransitioning>) transitionContext {
    
    if (self.isPresenting) {
        [self presentationAnimation:transitionContext];
    } else {
        [self dismissAnimation:transitionContext];
    }
    
}


- (void) presentationAnimation:(id<UIViewControllerContextTransitioning>) transitionContext {
    
    UIViewController *destinationViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [transitionContext.containerView addSubview:destinationViewController.view];
    destinationViewController.view.frame = CGRectOffset(destinationViewController.view.frame, 0, -300);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.4
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         destinationViewController.view.center = transitionContext.containerView.center;
                         
                     }
                     completion:^(BOOL completed){
                         
                         if (completed) {
                             self.presenting = NO;
                             [transitionContext completeTransition:YES];
                             
                         }
                     }
     ];
}


- (void) dismissAnimation:(id<UIViewControllerContextTransitioning>) transitionContext {
    
    UIViewController *sourceViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.4
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         // Animate way off the screen.
                         sourceViewController.view.frame = CGRectOffset(sourceViewController.view.frame, 0, 1000);
                         
                     }
                     completion:^(BOOL completed){
                         if (completed) {
                             [transitionContext completeTransition:YES];
                         }
                     }
     ];
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}


@end
