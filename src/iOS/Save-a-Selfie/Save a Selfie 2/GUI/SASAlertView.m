//
//  SASAlertView.m
//  Save a Selfie
//
//  Created by Stephen Fox on 02/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASAlertView.h"
#import "Screen.h"
#import "UIFont+SASFont.h"

@interface SASAlertView()

@property(strong, nonatomic) UIView* greyView;
@property(assign, nonatomic) SEL alertAction;
@end

@implementation SASAlertView

@synthesize alertTitle;
@synthesize alertMessage;
@synthesize alertButton;
@synthesize greyView;

@synthesize alertAction;



- initWithTitle:(NSString*) title message:(NSString*) message andButtonTitle:(NSString*) buttonTitle Withtarget:(id) target action:(SEL) action {
    if(self = [super init]) {
        
        self = [[[NSBundle mainBundle]
                         loadNibNamed:@"SASAlertView"
                         owner:self
                         options:nil]
                        firstObject];
        
        
        self.alertTitle.text = title;
        [UIFont increaseCharacterSpacingForLabel:self.alertTitle byAmount:2.0];
        
        self.alertMessage.text = message;
        self.alertMessage.font = [UIFont sasFontWithSize:18.0];
        
        [self.alertButton setTitle:buttonTitle forState:UIControlStateNormal];
        [self.alertButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        self.alertButton.layer.cornerRadius = 5.0;
        
        self.alertAction = action;
        
        self.layer.cornerRadius = 8.0;
    }
    return self;
}



// TODO: Fix animation
#pragma mark Animations
- (void)animateIntoView:(UIView *)view {
    
    if(self.greyView == nil) {
        self.greyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [Screen width], [Screen height])];
        
    }
    self.greyView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    
    [view addSubview:greyView];
    [view addSubview:self];
    
    self.frame = CGRectOffset(self.frame, 0, -50);
    
    
    [UIView animateWithDuration:1.0
                          delay:0.2
         usingSpringWithDamping:0.4
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{self.center = view.center;}
                     completion:nil];
}



// TODO: Add animation for this.
- (void)animateOutOfView:(UIView *)view {
    [self removeFromSuperview];
}


- (IBAction)doneButtonPress:(id)sender {
    if(self.alertAction == nil) {
        [self removeFromSuperview];
        [self.greyView removeFromSuperview];
    } else {
        // TODO: Call custom target.
    }
    
}


@end
