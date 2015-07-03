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

@property (weak, nonatomic) IBOutlet UIButton *alertButton;
@property (weak, nonatomic) IBOutlet UILabel *alertTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *alertMessageTextView;

@end

@implementation SASAlertView


// IBOutlets
@synthesize alertTitleLabel;
@synthesize alertMessageTextView;
@synthesize alertButton;

// NSStrings.
@synthesize title;
@synthesize message;
@synthesize buttonTitle;

// Action
@synthesize alertAction;


// Grey view background
@synthesize greyView;


- (instancetype)initWithTarget:(id)target andAction:(SEL)action {
    if(self = [super init]) {
        
        self = [[[NSBundle mainBundle]
                 loadNibNamed:@"SASAlertView"
                 owner:self
                 options:nil]
                firstObject];
        
        self.layer.cornerRadius = 8.0;
        self.alertButton.layer.cornerRadius = 5.0;
        
        
        self.alertAction = action;
        
        [self.alertButton addTarget:target
                             action:action
                   forControlEvents:UIControlEventTouchUpInside];
        
        
        [UIFont increaseCharacterSpacingForLabel:self.alertTitleLabel byAmount:2.0];
        self.alertMessageTextView.font = [UIFont sasFontWithSize:18.0];
    }
    return self;
}




#pragma mark Mutator Methods.
- (void)setTitle:(NSString *)aTitle {
    [self.alertTitleLabel setText:aTitle];
}

- (void)setMessage:(NSString *)aMessage {
    [self.alertMessageTextView setText:aMessage];
}

- (void)setButtonTitle:(NSString *)aTitle {
    [self.alertButton setTitle:aTitle forState:UIControlStateNormal];
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
