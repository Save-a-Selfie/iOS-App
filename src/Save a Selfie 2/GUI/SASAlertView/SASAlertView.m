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
#import "SASGreyView.h"
#import "UIView+NibInitializer.h"

@interface SASAlertView()


@property(assign, nonatomic) SEL alertAction;

@property (weak, nonatomic) IBOutlet UIButton *alertButton;
@property (weak, nonatomic) IBOutlet UILabel *alertTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *alertMessageTextView;

@property (strong, nonatomic) SASGreyView *greyView;

@property (strong, nonatomic) id alertTarget;
@end

@implementation SASAlertView


// IBOutlets
@synthesize alertTitleLabel;
@synthesize alertMessageTextView = _alertMessageTextView;
@synthesize alertButton = _alertButton;

// NSStrings.
@synthesize title;
@synthesize message;
@synthesize buttonTitle;

// Action
@synthesize alertAction = _alertAction;
@synthesize alertTarget = _alertTarget;


// Grey view background
@synthesize greyView;


- (instancetype)initWithTarget:(id)target andAction:(SEL)action {
    
    if(self = [super init]) {
        
        self = [self initWithNibNamed:@"SASAlertView"];
        
        self.layer.cornerRadius = 8.0;
        
        _alertButton.layer.cornerRadius = 5.0;
        
        _alertAction = action;
        _alertTarget = target;
        
        [_alertButton addTarget:target
                             action:action
                   forControlEvents:UIControlEventTouchUpInside];
        
        
        //[UIFont increaseCharacterSpacingForLabel:self.alertTitleLabel byAmount:5];
        _alertMessageTextView.font = [UIFont sasFontWithSize:18.0];
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
    

    self.greyView = [[SASGreyView alloc]initWithFrame:CGRectMake(0, 0, [Screen width], [Screen height])];

    
    [view addSubview:greyView];
    [view addSubview:self];
    
    self.center = view.center;
    self.alpha = 0.0;
    
    [UIView animateWithDuration:0.5
                          delay:0.1
         usingSpringWithDamping:0.4
          initialSpringVelocity:0.4
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{self.alpha = 1.0;}
                     completion:nil];
}



// TODO: Add animation for this.
- (void)animateOutOfView:(UIView *)view {
    [self removeFromSuperview];
}



- (IBAction)doneButtonPress:(id)sender {
    printf("Called");
    if(self.alertAction == nil) {
        
        [self removeFromSuperview];
        [self.greyView removeFromSuperview];
        
    } else {
        
        [self.alertTarget performSelector:self.alertAction withObject:nil afterDelay:0.0];
        
        [self removeFromSuperview];
        [self.greyView removeFromSuperview];
    }
}


@end
