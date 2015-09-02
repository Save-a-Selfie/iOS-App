//
//  FXPresentationController.m
//  FXAlertView
//
//  Created by Stephen Fox on 02/09/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "FXPresentationController.h"


@interface FXPresentationController()

@property (strong, nonatomic) UIView *dimmingView;

@end

@implementation FXPresentationController


- (void)presentationTransitionWillBegin {
    
    if(!self.dimmingView) {
        self.dimmingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self screenWidth], [self screenHeight])];
        self.dimmingView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    }
    
    [self.containerView addSubview:self.dimmingView];
}



- (void)presentationTransitionDidEnd:(BOOL) completed {
    // Remove the dimming view if the presentation was aborted.
    if (!completed) {
        [self.dimmingView removeFromSuperview];
    }
}


- (void) dismissalTransitionWillBegin {
    [self.dimmingView removeFromSuperview];
    self.dimmingView = nil;
}




#pragma mark Convenience Methods.
- (CGFloat) screenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}


- (CGFloat) screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}
@end
