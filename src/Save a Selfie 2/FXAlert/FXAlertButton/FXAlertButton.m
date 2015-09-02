//
//  FXAlertButton.m
//  FXAlertView
//
//  Created by Stephen Fox on 25/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "FXAlertButton.h"


@implementation FXAlertButton


#pragma mark Object Life Cycle.
- (instancetype) initWithType:(FXAlertButtonType) type {
    if (self = [super init]) {
        
        _type = type;
        
        if (_type == FXAlertButtonTypeStandard) {
            self.backgroundColor = [FXAlertButton standardColour];
        }
        else if (_type == FXAlertButtonTypeCancel) {
            self.backgroundColor = [FXAlertButton cancelColour];
        }
        self.titleLabel.minimumScaleFactor = 0.5;
        
    }
    return self;
}



// @Discussion
// Override this method so we can forward button taps to the delegate.
// As this class is a UIButton, -addTarget:action:forControlEvents: will be called
// when an instance is tapped. Therefore we can't really manipulate that method and swap
// out the selectors, to message the FXAlertView that a button has been tapped so
// it can remove itself from its parent view.
// This way is the alternative, make FXAlertView a delegate and forward button
// taps through overriding this method.
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    
    if (self.isTouchInside) {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(fxAlertButton:wasPressed:)]) {
            [self.delegate fxAlertButton:self wasPressed:YES];
        }
    } else {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(fxAlertButton:wasPressed:)]) {
            [self.delegate fxAlertButton:self wasPressed:NO];
        }
    }
}



#pragma Accessors for buttons colours.
+ (UIColor *)standardColour {

    return [UIColor colorWithRed:0.125 green:0.784 blue:0.392 alpha:1.0];
}

+ (UIColor *)cancelColour {
    return [UIColor colorWithWhite:0.8 alpha:1.0];
}

@end
